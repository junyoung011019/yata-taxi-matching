const { Server } = require("socket.io");
const express = require('express');
const https=require('https');
const jwt = require('jsonwebtoken');
require("dotenv").config();
const fs=require('fs');
const path = require('path');
const cors = require('cors');
var moment = require('moment');
require('moment-timezone');
moment.tz.setDefault("Asia/Seoul");
var currentTime=moment().format('YYYY-MM-DD HH:mm:ss');
const { MongoClient } = require('mongodb');

const AccessKey=process.env.JwtAccessSecretKey;
const app = express();

const mongoUrl = process.env.db_uri;
const client = new MongoClient(mongoUrl);


app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors({origin: '*',}));

const options = {
    cert: fs.readFileSync(path.join(process.env.ssl_key_loc, process.env.key_f)),
    key: fs.readFileSync(path.join(process.env.ssl_key_loc, process.env.key_p))
};

const httpsServer=https.createServer(options,app);
const io = new Server(httpsServer,{
    cors: {
        origin: "*", // 필요한 경우 특정 도메인으로 변경합니다.
        methods: ["GET", "POST"],
        credentials: true // 필요한 경우 사용합니다.
    }
});

io.use((socket, next) => {
    const token = socket.handshake.auth.token;
    if (!token) {
        return next(new Error('Authentication error'));
    }
    try {
        const decoded = jwt.verify(token, AccessKey);
        socket.user = decoded;
        console.log("jwt인증완료")
        next();
    } catch (err) {
        return next(new Error('Authentication error'));
    }
});

io.on('connection', (socket) => {
    console.log('A user connected');
    socket.on('joinChannel', async({ channel }) => {
        const nickname=socket.user.NickName
        socket.join(channel);
        socket.nickname = nickname;
        console.log(`${nickname} joined channel: ${channel}`);
        io.to(channel).emit('message', { nickname: 'System', message: `${nickname} has joined the channel`,currentTime: `${currentTime}` });
    });

    socket.on('message', (data) => {
        const { channel, message } = data;
        console.log('Message received: ' + message);
        console.log(socket.nickname)
        io.to(channel).emit('message', { nickname:socket.nickname, message, currentTime });
    });

    socket.on('disconnect', () => {
        console.log('A user disconnected');
        // io.socketsLeave("room1");
    });
});

io.engine.on("connection_error", (err) => {
    console.log(err.req);      // the request object
    console.log(err.code);     // the error code, for example 1
    console.log(err.message);  // the error message, for example "Session ID unknown"
    console.log(err.context);  // some additional error context
});

app.get('/ShowRecruiting', async (req, res) => {
    await client.connect(); // MongoDB 클라이언트 연결
    const database = client.db('YATA');
    try {
        const RecruitingsCollection = database.collection('Recruiting');
        // Recruiting 컬렉션에서 모든 방 정보 조회
        const recruitments = await RecruitingsCollection.find({}).toArray();
        
        // 조회한 모집 정보의 startTime 필드를 정수로 변환합니다.
        const recruitmentsWithIntStartTime = recruitments.map(recruitment => ({
            ...recruitment, // 기존 모집 정보의 모든 필드를 복사합니다.
             //startTime 인트로 강제 변환
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

app.post('/RoomEnter', async (req, res) => {
    RoomNo=req.body.roomNo;
});

httpsServer.listen(443, () => {
    console.log("HTTPS Server running on port 443")
});