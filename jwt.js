const express = require('express');
const { MongoClient } = require('mongodb');
const jwt = require('jsonwebtoken');
require("dotenv").config();
var moment = require('moment');
require('moment-timezone');
moment.tz.setDefault("Asia/Seoul");
const bcrypt = require('bcrypt');

const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
const port = 3000;

const AccessKey=process.env.JwtAccessSecretKey;
const RefreshKey=process.env.JwtRefreshSecretKey;

const mongoUrl = process.env.db_uri;
const client = new MongoClient(mongoUrl);

var currentTime=moment().format('YYYY-MM-DD HH:mm:ss');

app.post('/login', async (req, res) => {
    console.log(req.body)
    const payloadA = { Email: req.body.Email, iss:"YATA", roles:"user", keyName:"access" };
    const payloadR = { Email: req.body.Email, iss:"YATA", roles:"user", keyName:"refresh" };
    const accessToken = jwt.sign(payloadA, AccessKey, { expiresIn: '1m' });
    const refreshToken = jwt.sign(payloadR, RefreshKey, { expiresIn: '2m' }, currentTime);
    
    try{
        await client.connect(); // MongoDB 클라이언트 연결
        const database = client.db('YATA');
        const RefreshCollection = database.collection('RefreshToken');
        const hashedToken = bcrypt.hashSync(refreshToken, 10,(err,hash)=>{});
        await RefreshCollection.updateOne(
            { Email : req.body.Email },
            { $set: { hashedToken , LastLogin:currentTime} },
            { upsert: true }
          );
        console.log("success key save");
    }catch(error) {
        console.error(error);
        return res.status(500).send("Internal Server Error");
    }
    
    res.json({ accessToken, refreshToken });
});

app.get('/protected', (req, res) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader.split(' ')[1]

    if (!token) {
        return res.status(401).send('Access Denied: No Token Provided!');
    }

    try {
        const decoded = jwt.verify(token, AccessKey);
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

app.post('/refresh', async(req,res)=>{
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

app.listen(3000, () => {
    console.log(`Server running on port ${port}`);
});