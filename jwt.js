const express = require('express');
const jwt = require('jsonwebtoken');
require("dotenv").config();

const app = express();
const port = 3000;

const secretKey=process.env.JwtSecretKey;

app.use(express.json());

app.post('/login', (req, res) => {
    const payload = { id: req.body.id };
    const options = { expiresIn: '1m' };
    const token = jwt.sign(payload, secretKey, options);
    const refreshToken = jwt.sign(payload, secretKey, { expiresIn: '7d' });
    refreshTokens.push(refreshToken);
    res.json({ token });
});

app.post('/protected', (req, res) => {
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

app.listen(3000, () => {
    console.log(`Server running on port ${port}`);
});