// src/middleware/authenticate.js
import { verifyIdToken } from 'firebase-admin';
import admin from 'firebase-admin';
const nonSecurePaths = [
  "/login",
  "/register",
  "/logout"
];
const appAuthenticate = async (req, res, next) => {
    if (nonSecurePaths.includes(req.path)) return next();
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) {
        return res.status(401).json({
            EM: 'Không được phép truy cập',
            EC: 1,
            DT: ''
        });
    }

    try {
        const decodedToken = await admin.auth().verifyIdToken(token);
        req.user = decodedToken;
        next();
    } catch (error) {
        console.error('Lỗi xác minh token:', error);
        return res.status(401).json({
            EM: 'Không được phép truy cập',
            EC: 1,
            DT: ''
        });
    }
};

export { appAuthenticate };

