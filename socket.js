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
const { v4 : uuid4 } = require('uuid');

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

//socketio jwt 토큰 인증
io.use((socket, next) => {
    const token = socket.handshake.auth.token;
    if (!token) {
        return next(new Error('Authentication error'));
    }
    try {
        const decoded = jwt.verify(token, AccessKey);
        socket.user = decoded;
        console.log("jwt인증완료")
        //인증 완료시 다음으로 이동
        next();
    } catch (err) {
        return next(new Error('Authentication error'));
    }
});

//연결
io.on('connection', (socket) => {
    //socket.user에 사용자의 정보가 저장되있을거니까 이걸로 db에 방 정보 저장
    const key=uuid4();
    
    console.log('A user connected');
    socket.on('joinChannel', (data) => {
        //입력받은 data에서 채널 추출해서 참가 -> 채널번호는 _id로
        const channel=socket.handshake.query.channel;
        socket.join(channel);
        nickname = socket.user.NickName;
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

httpsServer.listen(443, () => {
    console.log("HTTPS Server running on port 443");
});