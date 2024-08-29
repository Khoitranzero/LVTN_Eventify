//src/controller/userController.js
import userService from "../../service/appService/userService";
import upload from "../../Cloudinary/upload";
const getAllUserFunc = async (req, res) => {
    try {
        const eventId = req.query.eventId; 
        let data = await userService.getAllUser(eventId);
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
const getOneUserFunc = async (req, res) => {
    try {
        const userId = req.query.userId; 
        let data = await userService.getOneUser(userId);
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
const changeAvatarFunc = async (req, res) => {
    try {
        upload.single('avatar')(req, res, async (err) => {
            if (err) {
                return res.status(500).json({
                    EM: 'Lỗi tải tập tin lên',
                    EC: '-1',
                    DT: ''
                });
            }
            
            const userId = req.body.userId;
            const avatarUrl = req.file.path; 
            // console.log("userId",userId)
            // console.log("avatarUrl",avatarUrl)
            let data = await userService.changeAvatar(userId, avatarUrl);
            return res.status(200).json({
                EM: data.EM,
                EC: data.EC,
                DT: data.DT
            });
        });
    } catch (e) {
        return res.status(500).json({
            EM: 'Lỗi từ máy chủ',
            EC: '-1',
            DT: ''
        });
    }
};
const updateUserFunc = async (req, res) => {
    try {
      let data = await userService.updateUser(req.body);
    //   console.log("data return",data)
      return res.status(200).json({
        EM: data.EM,
        EC: data.EC,
        DT: data.DT,
      });
    } catch (error) {
      return res.status(500).json({
        EM: "Lỗi từ máy chủ",
        EC: "-1",
        DT: "",
      });
    }
  };
module.exports= { 
    getAllUserFunc,
    getOneUserFunc,
    changeAvatarFunc,
    updateUserFunc
 }; 

