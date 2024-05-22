const express = require("express");
const { MongoClient } = require("mongodb");
const { createServer } = require("http");
const { Server } = require("socket.io");
const cors = require("cors");
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

const client = new MongoClient(process.env.DB, { useNewUrlParser: true, useUnifiedTopology: true });

async function main() {
    try {
        if (!process.env.DB) {
            throw new Error("DB connection string is not defined in the environment variables.");
        }

        await client.connect();
        console.log('MongoDB에 연결되었습니다.');

        const db = client.db();
        const recruitingCollection = db.collection('Recruiting');
        const messageCollection = db.collection('Messages');

        app.post('/Recruiting', async (req, res) => {
            try {
                const { roomTitle, partyCount, destination, startTime } = req.body;
                const newRecruitment = { roomTitle, partyCount, destination, startTime: parseInt(startTime, 10) };

                await recruitingCollection.insertOne(newRecruitment);
                res.status(200).json({ message: 'Recruitment data saved successfully' });
            } catch (error) {
                console.error('Error saving recruitment data:', error);
                res.status(500).json({ message: 'Error saving recruitment data' });
            }
        });

        app.get('/Select_Recruiting', async (req, res) => {
            try {
                const recruitments = await recruitingCollection.find({}).toArray();
                const recruitmentsWithIntStartTime = recruitments.map(recruitment => ({
                    ...recruitment,
                    startTime: parseInt(recruitment.startTime, 10)
                }));
                res.json(recruitmentsWithIntStartTime);
                console.log("리스트 요청 성공");
            } catch (error) {
                console.error('Error fetching recruitment list:', error);
                res.status(500).json({ message: 'Server error' });
            }
        });

        app.get('/MessagesInfo/:room', async (req, res) => {
            try {
                const room = req.params.room;
                const messages = await messageCollection.find({ room }).toArray();
                res.json(messages);
            } catch (error) {
                console.error('Error fetching messages:', error);
                res.status(500).json({ message: 'Server error' });
            }
        });

        const httpServer = createServer(app);
        const io = new Server(httpServer, {
            cors: {
                origin: "*",
            }
        });

        const roomCounts = {};  // 방별 클라이언트 수를 추적하는 객체 생성 슛
        const roomLimits = {};  // 방별 최대 참여 인원 수를 저장하는 객체 생성 슛

        io.on("connection", (socket) => {
            console.log('유저 연결 :', socket.id);

            socket.on("join_room", (data) => {
                const { room, maxParticipants } = data;
                if (roomCounts[room] && roomCounts[room] >= maxParticipants) {
                    //플러터 코드 中 socket.on ('join_error') 에게 다이렉트 전달
                    socket.emit('join_error', '방이 가득 찼습니다. 다른 방에 입장 하세요');
                    return;
                }

                socket.join(room);
                console.log(`유저가 들어온 방 : ${room}`);
                roomCounts[room] = (roomCounts[room] || 0) + 1; // 1씩 증가 ㄱㄱ
                roomLimits[room] = maxParticipants;

                //플러터 코드 中 socket.on ('update_participant_count') 에게 다이렉트 전달
                io.to(room).emit('update_participant_count', roomCounts[room]);

                // 소켓 ID를 클라이언트에게 전달
                socket.emit('socket_id', socket.id);
            });

            socket.on("send_message", async (data) => {
                try {
                    const { room, message } = data;
                    const sender = socket.id;
                    console.log(`Message received in room ${room}: ${message} from ${sender}`);

                    // (socket.)이 아니라 (io.) 인 이유는 전체 방송이라 생각 하면됌
                    //방에 있는 모든 클라이언트에게 메시지 전송
                    io.to(room).emit("receive_message", { message, sender });

                    //데이터베이스에 메시지 저장
                    await messageCollection.insertOne({ room, message, sender, timestamp: new Date() });
                    console.log(`메시지 데베에 저장 완료  ${room}: ${message} from ${sender}`);
                } catch (error) {
                    console.error('Error handling message:', error);
                }
            });

            socket.on("disconnecting", () => {
                for (const room of socket.rooms) {
                    if (room !== socket.id) {
                        roomCounts[room] = (roomCounts[room] || 1) - 1; //채팅방에 접속이 끊기면 - 1
                        io.to(room).emit('update_participant_count', roomCounts[room]);
                    }
                }
            });

            socket.on("disconnect", () => {
                console.log('User disconnected:', socket.id);
            });
        });

        const PORT = process.env.PORT || 3000;
        httpServer.listen(PORT, () => {
            console.log(`서버가 포트 ${PORT}에서 응답 중`);
        }).on('error', (err) => {
            console.error('서버 시작 에러:', err);
        });
    } catch (err) {
        console.error("MongoDB 연결 실패:", err);
    }
}

main().catch(console.error);
