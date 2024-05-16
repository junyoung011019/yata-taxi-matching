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
const secretKey = process.env.JwtSecretKey;

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

//로그인
app.post('/Login', async (req, res) => {
  try{
    await client.connect();
    const database = client.db('YATA');
    const users = database.collection('user');
    //사용자 입력에서 Email과 Password 파싱
    const { Email, Password } = req.body;
    console.log(Email+"의 로그인 요청");
    //이메일로 LoginUser에 사용자 정보 저장
    const LoginUser= await users.findOne({ Email: Email });
    //LoginUser가 존재하고, 입력한 비밀번호(Password)와 서버에 저장된 비밀번호(HashedPassword)가 일치하는지 확인
    if (LoginUser&&await bcrypt.compare(Password,LoginUser.HashedPassword)) {
      //jwt 액세스 키 전달
      const payload = { Email: req.body.Email };
      const options = { expiresIn: '5m' };
      const token = jwt.sign(payload, secretKey, options);
      res.status(200).json({ success: true, token: token });
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
      const users = database.collection('user');
      // 비밀번호 해싱
      const hashedPassword = bcrypt.hashSync(req.body.PassWord, 10,(err,hash)=>{});
      // 사용자 정보 저장
      const user = {
          Email: req.body.Email,
          HashedPassword: hashedPassword,
          UserName: req.body.UserName,
          NickName: req.body.NickName,
          Phone: req.body.Phone,
          AccountNumber: req.body.AccountNumber,
      };
      console.log(Email+"의 회원가입 요청");
      await users.insertOne(user);

      res.status(201).send('사용자 등록 성공');
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
    const users = database.collection('user');

    const { NickName }=req.body;
    console.log(NickName+" 중복체크 요청")
    const result = await users.findOne({ "NickName" : NickName });

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
app.post('/Recruiting', async function (req, res) {
  try {
    await client.connect(); // MongoDB 클라이언트 연결
    const database = client.db('YATA');
    const recruitings = database.collection('recruiting');
    var currentTime=moment().format('YYYY-MM-DD HH:mm:ss');
    const RecuitInfo = {
      roomTitle: req.body.roomTitle,
      partyCount: req.body.partyCount,
      destination: req.body.destination,
      startTime: req.body.startTime,
      CreationTime: currentTime
    }




  } catch (error) {
    console.error("Error saving data:", error);
    res.status(500).send("Error saving data");
  } finally {
    await client.close(); // MongoDB 클라이언트 연결 해제
  }
})


app.post('/Protected', (req, res) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader.split(' ')[1]

  if (!token) {
      return res.status(401).send('Access Denied: No Token Provided!');
  }

  try {
      const decoded = jwt.verify(token, secretKey);
      res.json({ message: 'Protected route accessed!', decoded });
  } catch (err) {
      // 만료된 토큰 처리
      if (err.name === 'TokenExpiredError') {
          return res.status(401).send('Token Expired');
      }
      // 다른 모든 인증 오류 처리
      res.status(400).send('Invalid Token');
  }
});


https.createServer(options,app).listen(443, () => {
  console.log("HTTPS Server running on port 443")
});