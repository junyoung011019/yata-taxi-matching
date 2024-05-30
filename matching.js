const express = require('express');
const https=require('https');
require("dotenv").config();
const cors = require('cors');
const fs=require('fs');
const path = require('path');
var moment = require('moment');
require('moment-timezone');
var currentTime=moment().format('YYYY-MM-DD HH:mm:ss');
const jwt = require('jsonwebtoken');
const { MongoClient } = require('mongodb');
const AccessKey=process.env.JwtAccessSecretKey;

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

const ShowDBList = async function(){
    try{
        await client.connect(); // MongoDB 클라이언트 연결
        const database = client.db('YATA');
        const RecruitingsCollection = database.collection('Recruiting');
        const recruitments=await RecruitingsCollection.find({}).toArray();
        console.log(recruitments);
        return recruitments;
    }catch (error) {
        console.error("Error saving data:", error);
        throw error;
    } finally {
        await client.close(); // MongoDB 클라이언트 연결 해제
    }
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
    console.log(DBlist);
    //소켓에서 정보 받아오기
    


    
  })
//시간 순 매칭

//인원 순 매칭


//매칭해서 리턴 해줄때 모든 정보를 넘겨줘야함

//방 목록 보기
app.get('/ShowRecruiting', VerifyJwtAccessToken, async function (req, res) {
    try {    
        const list=await ShowList();
        res.status(200).json(list);
        console.log("리스트 반환 성공");
    } catch (error) {
        console.error('Error fetching recruitment list:', error);
        res.status(500).json(error);
    }
});

server.listen(443, () => {
    console.log("HTTPS Server running on port 443")
  });