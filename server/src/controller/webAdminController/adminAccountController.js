//src/controller/webAdminController/adminAccountController
import adminAccountService from '../../service/webAdminService/adminAccountService';
const handleRegister = async(req, res) => {
    try {
        // if (!req.body.password || req.body.password.length < 4) {
        //     return res.status(200).json({
        //         EM: 'Missing required parameters',
        //         EC: '1',
        //         DT: ''
        //     });
        // }
        // if (!req.body.email || !req.body.phone || !req.body.password) {
        //     return res.status(200).json({
        //         EM: 'Your password must have more than 3 letters',
        //         EC: '1',
        //         DT: ''
        //     });
        // }
  
        const data = await adminAccountService.registerNewUser(req.body);
        console.log("data ",data);
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
    const handleLogin = async(req,res)=> {
        try {
            const data = await adminAccountService.handleAdminLogin(req.body);
            console.log("message login", data)
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
    }
    const handleLogout=async (req,res)=>{
        try {
            res.clearCookie("firebaseToken");
             return res.status(200).json({
                 EM : 'clear cookie',
                 EC: 0,
                 DT: ''
         
             })
 
     }catch(e){
         return res.status(500).json({
             EM : 'error from server',
             EC: '-1',
             DT:''
         
         })
     }
    };
    const handleDeleteUser = async (req, res) => {
        try {
            const  email  = req.query.email; 
            console.log("handleDeleteUser",email)
            const data = await adminAccountService.deleteUser(email);
            console.log("data", data)
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
    const handleChangePassword = async (req, res) => {
        try {
            console.log("req.body return",req.body)
            let data =  await adminAccountService.updatePassword(req.body);
            console.log("data return",data)
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
            const data = await adminAccountService.sendVerificationCode(req.body);
            console.log("data",data)
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
            const data = await adminAccountService.verifyCodeAndResetPassword(email, code, newPassword);
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
module.exports = {
    handleRegister,
    handleLogin,
    handleLogout,
    handleDeleteUser,
    handleChangePassword,
    handleSendVerificationCode,
    handleVerifyCodeAndChangePassword
}
