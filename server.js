const express = require('express');
const { MongoClient } = require('mongodb');
const bcrypt = require('bcrypt');
require("dotenv").config();
const cors = require('cors');
const fs=require('fs');
const https=require('https');
const path = require('path');
var moment = require('moment');
require('moment-timezone');
moment.tz.setDefault("Asia/Seoul");
const jwt = require('jsonwebtoken');
const AccessKey=process.env.JwtAccessSecretKey;
const RefreshKey=process.env.JwtRefreshSecretKey;
let currentTime=moment().format('YYYY-MM-DD HH:mm:ss');
const { v4 : uuid4 } = require('uuid');
const socketio = require('socket.io');

const app = express();
app.use(cors({origin: '*',}));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const mongoUrl = process.env.db_uri;
const client = new MongoClient(mongoUrl);

const options = {
  cert: fs.readFileSync(path.join(process.env.ssl_key_loc, process.env.key_f)),
  key: fs.readFileSync(path.join(process.env.ssl_key_loc, process.env.key_p))
};

const server = https.createServer(options, app);
const io = socketio(server,{
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
    credentials: true
}
});

//jwt 키 생성
const CreateJwtToken = async function(Email){  
  let accessToken=null;
  let refreshToken=null;
  try{
      await client.connect(); // MongoDB 클라이언트 연결
      const database = client.db('YATA');
      const Usercollection = database.collection('User');
      const result = await Usercollection.findOne({ "Email" : Email });
      let nickname=null;
      if (result!==null) {
        // 닉네임이 있다면 응답
        nickname=result.NickName;
      } else {
        // 닉네임이 없다면 응답
        throw new Error('No nickname found');
      }

      const payloadA = { Email: Email, NickName : nickname, iss:"YATA", roles:"user", keyName:"access" };
      const payloadR = { Email: Email, NickName : nickname, iss:"YATA", roles:"user", keyName:"refresh" };
      accessToken = jwt.sign(payloadA, AccessKey, { expiresIn: '1d' });
      currentTime=moment().format('YYYY-MM-DD HH:mm:ss');
      refreshToken = jwt.sign(payloadR, RefreshKey, { expiresIn: '7d' }, currentTime);
      const RefreshCollection = database.collection('RefreshToken');
      const hashedToken = bcrypt.hashSync(refreshToken, 10,(err,hash)=>{});
      await RefreshCollection.updateOne(
          { Email : Email },
          { $set: { hashedToken , LastLogin:currentTime} },
          { upsert: true }
        );
      console.log("success key save");
  }catch(error) {
      console.error(error);
  }finally{
    await client.close();
  }

  if(accessToken===null||refreshToken===null){
    console.log('둘중 하나 널임');
  }
  return({ accessToken, refreshToken });
};

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
      // res.json({ message: 'Protected route accessed!', decoded });
  } catch (err) {
      // 만료된 토큰 처리
      if (err.name === 'TokenExpiredError') {
          return res.status(401).send('Token Expired');
      }
      // 다른 모든 인증 오류 처리
      res.status(400).send('Invalid Token');
  }
}


//로그인
app.post('/Login', async (req, res) => {
  try{
    await client.connect();
    const database = client.db('YATA');
    const users = database.collection('User');
    //사용자 입력에서 Email과 Password 파싱
    const { Email, Password } = req.body;
    console.log(Email+"의 로그인 요청");
    //이메일로 LoginUser에 사용자 정보 저장
    const LoginUser= await users.findOne({ Email: Email });
    //LoginUser가 존재하고, 입력한 비밀번호(Password)와 서버에 저장된 비밀번호(HashedPassword)가 일치하는지 확인
    if (LoginUser&&await bcrypt.compare(Password,LoginUser.HashedPassword)) {
      const { accessToken, refreshToken } = await CreateJwtToken(Email)
      res.status(200).json({ success: true, accessToken: accessToken, refreshToken: refreshToken });
    } else {
      res.status(401).send({ success : false });
    }
  } catch (error) {
    console.error(error);
    res.status(500).send('서버 에러');
  } finally {
      await client.close();
  }
  
});

//회원가입
app.post('/SignUp', async (req, res) => {
  try {
      await client.connect();
      const database = client.db('YATA');
      const UserCollection = database.collection('User');
      // 비밀번호 해싱
      const hashedPassword = bcrypt.hashSync(req.body.Password, 10,(err,hash)=>{});
      // 사용자 정보 저장
      const user = {
          Email: req.body.Email,
          HashedPassword: hashedPassword,
          UserName: req.body.UserName,
          NickName: req.body.NickName,
          Phone: req.body.Phone,
          AccountNumber: req.body.AccountNumber,
      };
      console.log(req.body.Email+"의 회원가입 요청");
      await UserCollection.insertOne(user);
      const { accessToken, refreshToken } = await CreateJwtToken(req.body.Email);
      console.log(accessToken)
      console.log(refreshToken)
      res.status(201).json({ message: '사용자 등록 성공', accessToken: accessToken, refreshToken: refreshToken });
  } catch (error) {
      console.error(error);
      res.status(500).send('서버 에러');
  } finally {
      await client.close();
  }
});

//닉네임 중복 체크
app.post('/NickCheck', async function (req, res) {
  try {
    await client.connect(); // MongoDB 클라이언트 연결
    const database = client.db('YATA');
    const collection = database.collection('User');

    const { NickName }=req.body;
    console.log(NickName+" 중복체크 요청")
    const result = await collection.findOne({ "NickName" : NickName });

    if (result) {
      // 닉네임이 있다면 응답
      res.status(409).send({ Available : false });
    } else {
      // 닉네임이 없다면 응답
      res.status(201).send({ Available : true });
    }

  } catch (error) {
    console.error("Error saving data:", error);
    res.status(500).send("Error saving data");
  } finally {
    await client.close(); // MongoDB 클라이언트 연결 해제
  }
})

//모집
app.post('/Recruiting', VerifyJwtAccessToken, async function (req, res) {
  try {
    currentTime=moment().format('YYYY-MM-DD HH:mm:ss');
    await client.connect(); // MongoDB 클라이언트 연결
    const database = client.db('YATA');
    const UserCollection = database.collection('User');
    const NickName = (await UserCollection.findOne({ "Email" : req.user.Email })).NickName;
    console.log(NickName+"의 방만들기 요청");

    const RecruitingsCollection = database.collection('Recruiting');
    const key=uuid4();
    req.body._id=key;
    req.body.HeadCount=1;
    req.body.CreationTime=currentTime;
    req.body.RoomManager=NickName;
    
    await RecruitingsCollection.insertOne(req.body);
    res.status(200).send({msg : '방 생성 완료', roomId : req.body._id});
  }catch (error) {
    console.error("Error saving data:", error);
    res.status(500).send("Error saving data");
  } finally {
    await client.close(); // MongoDB 클라이언트 연결 해제
  }
})

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

const roomCounts = {};
const roomLimits = {};

//소켓 연결
io.on('connection', (socket) => {
  console.log('A user connected');
  let channel;
  let nickname;

  //최대인원, jwt, id 
  socket.on('createion',(data)=>{
    const { MaxCount, channel } = data;
    channels[channel]={ MaxCount: MaxCount, clients: 1 };
    currentTime=moment().format('YYYY-MM-DD HH:mm:ss');
    socket.emit('channelCreated', { message: `Channel ${channel} created : `+ currentTime });
    console.log("현재 인원 : " +channels[channel].clients);
  });

  //참석할때 필요한 정보 jwt, 채널 아이디
  socket.on('joinChannel', (data) => {
    //입력받은 data에서 채널 추출해서 참가 -> 채널번호는 _id로
    currentTime=moment().format('YYYY-MM-DD HH:mm:ss');
    channel=data.channel;
    //연결된 채널이 있을 경우
    if(channel){
      socket.leave(channel);
    }
    //입력한 채널이 없을 경우
    if (!channel) {
      socket.emit('error', { message: 'Channel does not exist' });
      return;
    }
    //채널의 최대인원 확인
    if (channel.clients.length >= channel.maxCount) {
        socket.emit('error', { message: 'Channel is full' });
        return;
    }
    socket.join(channel);
    channels[channel].clients+=1;
    nickname = socket.user.NickName;
    console.log(`${nickname} joined channel: ${channel}`);
    console.log("현재 인원 : " +channels[channel].clients);
    io.to(channel).emit('message', { nickname: 'System', message: `${nickname} has joined the channel`,currentTime: `${currentTime}` });
  });

  socket.on('message', (data) => {
      currentTime=moment().format('YYYY-MM-DD HH:mm:ss');
      const { channel, message } = data;
      console.log(nickname +'Message send: ' + message);
      io.to(channel).emit('message', { nickname, message, currentTime });
  });

  socket.on('disconnect', () => {
    channels[channel].clients-=1;
    console.log('A user disconnected');
    io.to(channel).emit('message', { nickname: 'System', message: `${nickname} has lefted the channel`,currentTime: `${currentTime}` });
    socket.leave(channel);
    console.log("현재 인원 : " +channels[channel].clients);
  });
});

//소켓 에러 처리
io.engine.on("connection_error", (err) => {
  console.log(err.req);      // the request object
  console.log(err.code);     // the error code, for example 1
  console.log(err.message);  // the error message, for example "Session ID unknown"
  console.log(err.context);  // some additional error context
});

//방 목록 보기
app.get('/ShowRecruiting', VerifyJwtAccessToken, async function (req, res) {
  await client.connect(); // MongoDB 클라이언트 연결
  const database = client.db('YATA');
  try {
      const RecruitingsCollection = database.collection('Recruiting');
      // Recruiting 컬렉션에서 모든 방 정보 조회
      const recruitments = await RecruitingsCollection.find({}).toArray();
      
      //id랑 현재인원은 소켓에서 


      // 변환된 모집 정보를 응답으로 전송.
      res.status(200).json(recruitments);
      console.log("리스트 반환 성공");
  } catch (error) {
      console.error('Error fetching recruitment list:', error);
      res.status(500).json({ message: 'Server error' });
  }
});

//리프레시 토큰
app.post('/Refresh', async(req,res)=>{
  const {refreshToken} = req.body;

  if (!refreshToken){
      return res.sendStatus(401).send('Access Denied: No Token Provided!');
  } 

  await client.connect(); // MongoDB 클라이언트 연결
  const database = client.db('YATA');
  const RefreshCollection = database.collection('RefreshToken');
  try{
      const decoded = jwt.verify(refreshToken, RefreshKey);

      const { Email } = decoded
      //DB에서 Email의 (해쉬된) Refresh 토큰 값을 찾고, 입력 받은 Refresh 토큰과 해쉬값 일치하는지 여부 확인
      const HashedKey = await RefreshCollection.findOne({ Email: Email });
      
      if(!HashedKey){
          res.status(400).send('Invalid Token');
          console.log('저장된 키가 없음');
      }else{
          if (await bcrypt.compare(refreshToken,HashedKey.hashedToken)) {
              const accessToken = jwt.sign({ Email: Email, iss:"YATA", roles:"user", keyName:"refresh" }, AccessKey, { expiresIn: '2m' });
              res.json({ accessToken });
          }
      }

  }catch (err) {
      // 만료된 토큰 처리
      if (err.name === 'TokenExpiredError') {
          return res.status(401).send('Token Expired');
      }
      // 다른 모든 인증 오류 처리
      res.status(400).send('Invalid Token');
      console.log('키 불일치');
  }
});

server.listen(443, () => {
  console.log("HTTPS Server running on port 443")
});
