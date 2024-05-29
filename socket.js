const { Server } = require("socket.io");
const express = require('express');
// const https=require('https');
const http=require('http');
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
const { channel } = require("diagnostics_channel");

const AccessKey=process.env.JwtAccessSecretKey;
const app = express();

const mongoUrl = process.env.db_uri;
const client = new MongoClient(mongoUrl);


app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors({origin: '*',}));

// const options = {
//     cert: fs.readFileSync(path.join(process.env.ssl_key_loc, process.env.key_f)),
//     key: fs.readFileSync(path.join(process.env.ssl_key_loc, process.env.key_p))
// };

//const httpsServer=https.createServer(options,app);
const httpServer = http.createServer(app);
const io = new Server(httpServer,{
    cors: {
        origin: "*", // 필요한 경우 특정 도메인으로 변경합니다.
        methods: ["GET", "POST"],
        credentials: true // 필요한 경우 사용합니다.
    }
});

const deleteChannelFromDB=async function (channel){
  try{
    await client.connect();
    const database = client.db('YATA');
    const RecruitingsCollection = database.collection('Recruiting');
    
    const result = await RecruitingsCollection.deleteOne({ _id: channel });
    if (result.deletedCount === 1) {
      console.log(`Successfully deleted channel with id: ${channel}`);
    } else {
      console.log(`No channel found with id: ${channel}`);
    }
  } catch (error) {
    console.error(error);
  } finally {
      await client.close();
  }
}


// socketio jwt 토큰 인증
io.use((socket, next) => {
    const token = socket.handshake.auth.token;
    if (!token) {
        return next(new Error('Authentication error'));
    }
    try {
        const decoded = jwt.verify(token, AccessKey);
        socket.user = decoded;
        console.log("jwt인증완료");
        //인증 완료시 다음으로 이동
        next();
    } catch (err) {
        return next(new Error('Authentication error'));
    }
  });

const channels={};

//소켓 연결
io.on('connection', (socket) => {
  console.log('A user socket connected');
  //let channel;
  let currentChannel;
  let headCount;
  let nickname=socket.user.NickName;
  function addChannel(channel, MaxCount) {
    if (!channels[channel]) {
    channels[channel] = { MaxCount: MaxCount, clients: 1 };
    };
  }

  //최대인원, jwt, id 
  socket.on('creation',(data)=>{
    const { MaxCount, channel } = data;
    console.log("방 생성 입니다 / 최대 인원 : "+ MaxCount+" / 채널"+channel);
    addChannel(channel, MaxCount);
    currentTime=moment().format('YYYY-MM-DD HH:mm:ss');
    socket.emit('channelCreated', { message: `Channel ${channel} created : `+ currentTime });
    currentChannel=channel;
    headCount=1;
    socket.join(channel);
    console.log("현재 인원 : "+channels[channel].clients);
    io.emit('channel-info',{channel,headCount,MaxCount})
  });

  //참석할때 필요한 정보 jwt, 채널 아이디
  socket.on('joinChannel', (data) => {
    //입력받은 data에서 채널 추출해서 참가 -> 채널번호는 _id로
    currentTime=moment().format('YYYY-MM-DD HH:mm:ss');
    channel=data.channel;
    currentChannel=channel;
    //입력한 채널이 존재하지 않을 경우 추가해야함.
    if (!channels[channel]) {
      socket.emit('error', { message: 'Channel does not exist' });
      console.log('Channel does not exist')
      return;
    }

    //채널의 최대인원 확인
    if (channels[channel].clients >= channels[channel].MaxCount) {
        socket.emit('error', { message: 'Channel is full' });
        console.log('Channel is full');
        return;
    }
    socket.join(channel);
    channels[channel].clients+=1;
    headCount+=1;
  
    nickname = socket.user.NickName;
    console.log(`${nickname} joined channel: ${channel}`);
    console.log("현재 인원 : " +channels[channel].clients);
    io.to(channel).emit('message', { nickname: 'System', message: `${nickname} has joined the channel`,currentTime: `${currentTime}` });
    io.emit('channel-info',{channel,headCount,MaxCount})
  });

  socket.on('message', (data) => {
    currentTime=moment().format('YYYY-MM-DD HH:mm:ss');
    const { channel, message } = data;
    console.log(nickname +'Message send: ' + message);
    io.to(channel).emit('message', { nickname, message, currentTime });
  });

  socket.on('disconnect', async() => {
      //채널이 존재하는지 확인        
      if (channels[currentChannel]) {
          channels[currentChannel].clients-=1;
          headCount-=1;
          console.log('A user disconnected');
          socket.leave(currentChannel);
          //채널에 0명일때
          if (channels[currentChannel].clients === 0) {
            delete channels[currentChannel];
            deleteChannelFromDB(currentChannel);
            console.log(`Channel ${currentChannel} deleted`);
          }else{
            io.to(channel).emit('message', { nickname: 'System', message: `${nickname} has lefted the channel`,currentTime: `${currentTime}` });
            console.log("현재 인원 : " +channels[currentChannel].clients);
          }
      }
      io.emit('channel-info',{channel,headCount,MaxCount})
  })
  
});


//소켓 에러 처리
io.engine.on("connection_error", (err) => {
  console.log(err.req);      // the request object
  console.log(err.code);     // the error code, for example 1
  console.log(err.message);  // the error message, for example "Session ID unknown"
  console.log(err.context);  // some additional error context
});

io.on('channel-info', (socketData) => {
  console.log('Channel ID:', socketData.channel);
  console.log('Current users:', socketData.headCount);
  console.log('Max users:', socketData.MaxCount);
  
  // 받은 채널 정보를 활용하여 필요한 작업 수행
});

httpServer.listen(80, () => {
    console.log("HTTPS Server running on port 443");
});