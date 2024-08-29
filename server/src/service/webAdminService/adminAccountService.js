//src/service/webAdminService/adminAccountService'
import db from "../../models/index";
require('dotenv').config();
import { Op } from "sequelize";
// import firebase from "firebase/app";
import { auth } from "../../firebase/firebase";
import { authAdmin } from '../../firebase/firebaseAdmin';
import {
  AuthErrorCodes,
  createUserWithEmailAndPassword,
  signInWithEmailAndPassword,
  signOut,
  updatePassword as updateUserPassword,
  EmailAuthProvider,
  reauthenticateWithCredential,
  sendEmailVerification as sendVerificationEmail,
  sendPasswordResetEmail
} from "firebase/auth";
import crypto from 'crypto';
import nodemailer from 'nodemailer';

const verificationCodes = new Map();
//  const checkPhoneExist = async(userPhone) => {
//     let user = await db.User.findOne({
//         where : {phone : userPhone}
//     });
    
//     if(user) {
//         return true;
//     }
//     return false;
//      }
const checkEmailExist = async (userEmail) => {
  let user = await db.User.findOne({
    where: { email: userEmail },
  });
  return user;
};
const registerNewUser = async (rawUserData) => {
  try {
  
    const { email, password, username, phone } = rawUserData;
    let checkEmail = await checkEmailExist(email);
    if (checkEmail) {
      return {
        EM: "Tài khoản này đã được sử dụng, vui lòng sử dụng email khác",
        EC: 1,
        DT: "",
      };
    }
    const userCredential = await createUserWithEmailAndPassword(
      auth,
      email,
      password
    ).then((userCredential) => {
      const user = userCredential.user;
      db.User.create({
        id: user.uid,
        email: email,
        name: username,
        phone: phone,
      });
    });
    return {
      EM: "Tạo tài khoản thành công",
      EC: 0,
      DT: userCredential,
    };
  } catch (e) {
    if (error.code === "auth/email-already-in-use") {
      // console.log("Invalid credentials:", error.message);
      return {
        EM: "Tài khoản này đã được sử dụng , vui lòng sử dụng email khác",
        EC: 1,
        DT: "",
      };
    }
    console.error(e);
    return {
      EM: "Tạo tài khoản thất bại",
      EC: 1,
      DT: "",
    };
  }
};
    
const handleAdminLogin = async(rawData)=> {
    try {
        const { valueLogin, password } = rawData;
        const email=valueLogin;
        let userRole = await db.User.findOne({
            where : {email : email},
            attributes: ['role']
        });
        // console.log("userRole",userRole)
        if(userRole.role=='Admin'){
        const userCredential = await signInWithEmailAndPassword(
          auth,
          email,
          password
        );
        const user = userCredential.user;
        const token = await user.getIdToken();
    
        let userFromDB = await db.User.findOne({
          where: {
            [Op.or]: [{ email: email }],
          },
        });
          // console.log("userFromDB",userFromDB)
        if (userFromDB) {
          return {
            EM: "Đăng nhập thành công",
            EC: 0,
            DT: {
              id:userFromDB.id,
              email: userFromDB.email,
              fullName: userFromDB.name,
              phone: userFromDB.phone,
              role:userFromDB.role,
              token,
            },
          };
        } else {
          console.log("User not found with email: ", email);
          return {
            EM: "Email hoặc mật khẩu của bạn không đúng",
            EC: 1,
            DT: "",
          };
        }
    } else {
        return {
            EM: "Bạn không phải admin",
            EC: 1,
            DT: "",
          };
    }
      } catch (error) {
        if (error.code === "auth/invalid-credential"|| error.code === AuthErrorCodes.INVALID_CREDENTIAL) {
          console.log("Invalid credentials:", error.message);
          return {
            EM: "Tài khoản hoặc mật khẩu không hợp lệ, vui lòng nhập lại",
            EC: 1,
          };
        }
        console.error(error);
        return {
          EM: "Lỗi từ máy chủ",
          EC: -2,
        };
      }
};
const deleteUser = async (email) => {
  const transaction = await db.sequelize.transaction();
  try {
    if (!email) {
      return {
        EM: "Email này không tồn tại",
        EC: 1,
        DT: ""
      };
    }


    const userRecord = await authAdmin.getUserByEmail(email);
    const userId = userRecord.uid;


    await authAdmin.deleteUser(userId);

 
    await Promise.all([
      db.UserTask.destroy({ where: { userId }, transaction }),
      db.Chat.destroy({ where: { userId }, transaction }),
      db.Notification.destroy({ where: { userId }, transaction }),
      db.UserEvent.destroy({ where: { userId }, transaction })
    ]);


    await db.User.destroy({ where: { email: email }, transaction });

    await transaction.commit();

    return {
      EM: "Xóa tài khoản thành công",
      EC: 0,
      DT: ""
    };
  } catch (e) {
    if (transaction.finished !== 'commit') {
      await transaction.rollback();
    }
    console.error(e);
    return {
      EM: "Xóa tài khoản thất bại",
      EC: -2,
      DT: ''
    };
  }
};

const checkPassword = async (email, oldPassword) => {
  try {
    if (!auth.currentUser) {
      throw new Error("Người dùng chưa được xác thực.");
    }

    const credential = EmailAuthProvider.credential(email, oldPassword);
    await reauthenticateWithCredential(auth.currentUser, credential);
    return true;
  } catch (error) {
    console.error(error);
    if (error.code === 'auth/invalid-credential') {
      return false; 
    } else {
      throw error; 
    }
  }
};
const updatePassword = async (dataChange) => {
  try {
    const { email, oldPassword, newPassword } = dataChange;

    const isPasswordCorrect = await checkPassword(email, oldPassword);
    if (isPasswordCorrect) {
      await updateUserPassword(auth.currentUser, newPassword);
      return {
        EM: 'Đổi mật khẩu thành công',
        EC: 0,
        DT: ''
      };
    } else {
      return {
        EM: 'Mật khẩu cũ không đúng',
        EC: 1,
        DT: ''
      };
    }
  } catch (error) {
    console.error(error);
    return {
      EM: 'Lỗi từ máy chủ',
      EC: -1,
      DT: ''
    };
  }
};
const sendVerificationCode = async (data) => {
  try {
 
      // const user = await User.findOne({ where: { email } });
      // if (!user) {
      //     return { EM: "Email not found", EC: 1, DT: '' };
      // }

    
      const code = crypto.randomBytes(3).toString('hex');

 
      verificationCodes.set(data.email, code);

      // Send the code via email
      const transporter = nodemailer.createTransport({
          service: 'Gmail',
          auth: {
              user: 'trandinhkhoitvtp@gmail.com', 
              pass: 'rrfl qfyf srwh aitw' 
          }
      });

      const mailOptions = {
          from: 'trandinhkhoitvtp@gmail.com', 
          to: data.email,
          subject: 'Mã đặt lại mật khẩu',
          text: `Mã xác minh của bạn là: ${code}`
      };

      await transporter.sendMail(mailOptions);

      return { EM: `Đã gửi mã xác thực đến gmail : ${data.email}`, EC: 0, DT: '' };
  } catch (e) {
      console.error(e);
      return { EM: `Lỗi gửi mã xác thực đến gmail : ${data.email} !` , EC: -2, DT: '' };
  }
};

const verifyCodeAndResetPassword = async (email, code, newPassword) => {
  try {
    const storedCode = verificationCodes.get(email);
    if (!storedCode || storedCode !== code) {
      return { EM: "Mã không hợp lệ hoặc đã hết hạn", EC: 1, DT: '' };
    }

    const user = await db.User.findOne({ where: { email } });
    if (!user) {
      return { EM: "Không tìm thấy email", EC: 1, DT: '' };
    }
     await authAdmin.updateUser(user.id, { password: newPassword });
 
    // await sendPasswordResetEmail(auth, email);

    verificationCodes.delete(email);

    return { EM: "Đặt lại mật khẩu thành công", EC: 0, DT: '' };
  } catch (e) {
    console.error(e);
    return { EM: "Lỗi khi đặt lại mật khẩu", EC: -2, DT: '' };
  }
};
module.exports = {
  registerNewUser,
  handleAdminLogin,
  deleteUser,
  checkPassword,
  updatePassword,
  sendVerificationCode,
  verifyCodeAndResetPassword
}