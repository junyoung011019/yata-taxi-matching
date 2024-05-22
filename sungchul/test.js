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
                // Recruiting 컬렉션에서 모든 방 정보 조회
                const recruitments = await recruitingCollection.find({}).toArray();
                
                // 조회한 모집 정보의 startTime 필드를 정수로 변환합니다.
                const recruitmentsWithIntStartTime = recruitments.map(recruitment => ({
                    ...recruitment, // 기존 모집 정보의 모든 필드를 복사합니다.
                     // startTime이 어떤건 인트고 어떤건 String이라 아싸리 startTime 인트로 강제 변환
                    startTime: parseInt(recruitment.startTime, 10) // startTime 필드를 정수로 변환.
                }));
                
                // 변환된 모집 정보를 응답으로 전송.
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
                origin: "*", // 필요한 경우 특정 도메인만 허용하도록 수정
            }
        });
        let ID = ""  // 소캣 id 받을거임
        /// 소캣 
        io.on("connection", (socket) => {
            console.log('User connected:', socket.id);
            

            socket.on("join_room", (room) => {
                socket.join(room);
                console.log(`User joined room: ${room}`);

                //소캣 ID를 클라이언트 (플러터) 에게 넘겨줌
                socket.emit('socket_id', socket.id);


                io.to(room).emit("receive_message", { message, sender });
                
            });
        
            socket.on("send_message", async (data) => {
                try {
                    const { room, message } = data;
                    const sender = socket.id; // 이거
                    console.log(`Message received in room ${room}: ${message} from ${sender}`);
                    console.log (sender);

                    io.to(room).emit("receive_message", { message, sender });
                    

                    // 데이터베이스에 저장
                    await messageCollection.insertOne({ room, message, sender, timestamp: new Date() });
                    console.log(`Message saved to DB in room ${room}: ${message} from ${sender}`);
                } catch (error) {
                    console.error('Error handling message:', error);
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
