import accountService from "../../service/appService/accountService";
import firebaseAdmin from 'firebase-admin';
import { getAuth, signOut } from "firebase/auth";
import {auth} from '../../firebase/firebase';
// import { auth } from "../../firebase/firebase";
const handleRegister = async (req, res) => {
    try {
        // console.log("data",req.body);
        const data = await accountService.registerNewUser(req.body);
        return res.status(200).json({
            EM: data.EM,
            EC: data.EC,
            DT: ''
        });
    } catch (e) {
        return res.status(500).json({
            EM: 'Lỗi từ máy chủ',
            EC: '-1',
            DT: ''
        });
    }
};

const handleLogin = async (req, res) => {
    try {
        const data = await accountService.handleUserLogin(req.body);
        console.log("handleLogin",data)
        return res.status(200).json({
            EM: data.EM,
            EC: data.EC,
            DT: data.DT
        });
    } catch (e) {
        return res.status(500).json({
            EM: 'Lỗi từ máy chủ',
            EC: '-1',
            DT: ''
        });
    }
};
const handleLogout = async (req, res) => {
    try {
        const data = await accountService.handleUserLogout();
        console.log("handleLogout",data)
        return res.status(200).json({
            EM: data.EM,
            EC: data.EC,
            DT: data.DT
        });
    } catch (e) {
        return res.status(500).json({
            EM: 'Lỗi từ máy chủ',
            EC: '-1',
            DT: ''
        });
    }
};

const handleChangePassword = async (req, res) => {
    try {
        let data =  await accountService.updatePassword(req.body);
        // console.log("data return",data)
        return res.status(200).json({
            EM: data.EM,
            EC: data.EC,
            DT: data.DT
        });
    } catch (error) {
        console.error(error);
        return res.status(500).json({
            EM: 'Lỗi từ máy chủ',
            EC: '-1',
            DT: ''
        });
    }
};

const handleSendVerificationCode = async (req, res) => {
    try {
        const data = await accountService.sendVerificationCode(req.body);
        // console.log("data",data)
        return res.status(200).json({
            EM: data.EM,
            EC: data.EC,
            DT: data.DT,
        });
    } catch (e) {
        console.error(e);
        return res.status(500).json({
            EM: 'Lỗi từ máy chủ',
            EC: '-1',
            DT: '',
        });
    }
};

const handleVerifyCodeAndChangePassword = async (req, res) => {
    try {
        const { email, code, newPassword } = req.body;
        // console.log("handleVerifyCodeAndChangePassword controller", req.body)
        const data = await accountService.verifyCodeAndResetPassword(email, code, newPassword);
        // console.log("data", data)
        return res.status(200).json({
            EM: data.EM,
            EC: data.EC,
            DT: data.DT,
        });
    } catch (e) {
        console.error(e);
        return res.status(500).json({
            EM: 'Lỗi từ máy chủ',
            EC: '-1',
            DT: '',
        });
    }
};
const handleDeleteUser = async (req, res) => {
    try {
        const  email  = req.query.email; 
        // console.log("handleDeleteUser",email)
        const data = await accountService.deleteUser(email);
        // console.log("data", data)
        return res.status(200).json({
            EM: data.EM,
            EC: data.EC,
            DT: data.DT,
        });
    } catch (e) {
        console.error(e);
        return res.status(500).json({
            EM: "Server error",
            EC: -1,
            DT: ""
        });
    }
};
module.exports= { 
    handleRegister, 
    handleLogin,
    handleLogout,
    handleChangePassword,
    handleVerifyCodeAndChangePassword,
    handleSendVerificationCode,
    handleDeleteUser
};
