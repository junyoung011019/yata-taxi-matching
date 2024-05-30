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
const { channel } = require("diagnostics_channel");

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
//const httpServer = http.createServer(app);
const io = new Server(httpsServer,{
    cors: {
        origin: "*", // 필요한 경우 특정 도메인으로 변경합니다.
        methods: ["GET", "POST"],
        credentials: true // 필요한 경우 사용합니다.
    }
});

//jwt 액세스키 검증
const VerifyJwtAccessToken = async function(req, res, next){
    const authHeader = req.headers['authorization'];
    const token = authHeader.split(' ')[1]
    if (!token) {
        return res.status(401).send('Access Denied: No Token Provided!');
    }
  
    try {
        const decoded = jwt.verify(token, AccessKey);
        req.user=decoded;
        next();
    } catch (err) {
        // 만료된 토큰 처리
        if (err.name === 'TokenExpiredError') {
            return res.status(401).send('Token Expired');
        }
        // 다른 모든 인증 오류 처리
        res.status(400).send('Invalid Token');
    }
  }

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

let channels={};

//소켓 연결
io.on('connection', (socket) => {
  console.log('A user socket connected');
  //let channel;
  let currentChannel;
  let headCount;
  let nickname=socket.user.NickName;
  function addChannel(channel, MaxCount) {
    if (!channels[channel]) {
        channels[channel] = { channel, MaxCount, clients: 1 };
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
    console.log(data);
    const channel=data.channel;
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
    headCount=channels[channel].clients;
  
    nickname = socket.user.NickName;
    console.log(`${nickname} joined channel: ${channel}`);
    console.log("현재 인원 : " +channels[channel].clients);
    io.to(channel).emit('message', { nickname: 'System', message: `${nickname} has joined the channel`,currentTime: `${currentTime}` });
    io.emit('channel-info',{channel,headCount})
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
      io.emit('channel-info',{channel,headCount})
  })
  
});

//소켓 에러 처리
io.engine.on("connection_error", (err) => {
  console.log(err.req);      // the request object
  console.log(err.code);     // the error code, for example 1
  console.log(err.message);  // the error message, for example "Session ID unknown"
  console.log(err.context);  // some additional error context
});


const ShowDBList = async function(){
    try{
        await client.connect(); // MongoDB 클라이언트 연결
        const database = client.db('YATA');
        const RecruitingsCollection = database.collection('Recruiting');
        const recruitments=await RecruitingsCollection.find({}).toArray();
        return recruitments;
    }catch (error) {
        console.error("Error saving data:", error);
        throw error;
    } finally {
        await client.close(); // MongoDB 클라이언트 연결 해제
    }
}

function mergeData(rooms, socket) {
    return rooms.map(room => ({
      "_id": room._id,
      "roomTitle": room.roomTitle,
      "destination": room.destination,
      "startTime": room.startTime,
      "CreationTime": room.CreationTime,
      "RoomManager": room.RoomManager,
      "MaxCount": socket[room._id].MaxCount,
      "clients": socket[room._id].clients
    }));
  }

//방향 확인 db에 불러오기
app.post('/Matching', VerifyJwtAccessToken, async function (req, res) {
    currentTime=moment().format('YYYY-MM-DD HH:mm:ss');
    //db에서 정보 받아오기
    const showList=await ShowDBList();
    const DBlist = showList.map(({ _id, destination, CreationTime, startTime }) => ({
        id: _id,
        destination,
        CreationTime,
        startTime
      }));
    //소켓의 정보
    //channels
    const LiveRoomData=mergeData(DBlist,channels);
    res.status(200).json(LiveRoomData);
  })
//시간 순 매칭

//인원 순 매칭


//매칭해서 리턴 해줄때 모든 정보를 넘겨줘야함

//방 목록 보기
app.get('/ShowRecruiting', VerifyJwtAccessToken, async function (req, res) {
    try {    
        const DBlist=await ShowDBList();
        const LiveRoomData=mergeData(DBlist,channels);
        res.status(200).json(LiveRoomData);
        console.log("리스트 반환 성공");
    } catch (error) {
        console.error('Error fetching recruitment list:', error);
        res.status(500).json(error);
    }
});


app.get('/', function (req, res) {
    console.log(channels);
    res.status(200).json(channels);
});


httpsServer.listen(443, () => {
    console.log("HTTPS Server running on port 443");
});