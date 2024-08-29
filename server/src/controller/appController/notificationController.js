import notificationService from "../../service/appService/notificationService";
import { broadcast } from "../../server";

const getAllUserNotificationFunc = async (req, res) => {
  try {
    const userId = req.query.userId; 
      // console.log("userId",userId)
      const data = await notificationService.getAllUserNotification(userId);
      // console.log("getAllUserNotificationFunc",data.DT)
      return res.status(200).json({
        EM: data.EM,
        EC: data.EC,
        DT: data.DT,
      });
      
  } catch (error) {
      console.log(error);
      return res.status(500).json({
          EM: "Lỗi từ máy chủ",
          EC: "-1",
          DT: "",
      });
  }
};
const createNotifyFunc = async (req, res) => {
    try {
      // console.log("req.body",req.body)
      const {type, data, eventId} = req.body;
      let dataNotify = await notificationService.createNotification(type, data, eventId);
      broadcast(dataNotify);  // Gửi thông báo tới tất cả các client kết nối
      return res.status(200).json(dataNotify);
    } catch (error) {
      return res.status(500).json({
        EM: "Lỗi từ máy chủ",
        EC: "-1",
        DT: "",
      });
    }
  };
  const readAllNotifyFunc = async (req, res) => {
    try {
      const userId = req.body.userId; 
      // console.log("userId",userId)
      let data = await notificationService.readAllNotification(userId);
      // console.log("readAllNotifyFunc",data)
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

  const readOneNotifyFunc = async (req, res) => {
    try {
      let data = await notificationService.readOneNotification(req.body);
      // console.log("readOneNotifyFunc",data)
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
  const deleteNotifyFunc = async (req, res) => {
    try {
      const userId = req.body.userId; 
      // console.log("userId",userId)
      let data = await notificationService.deleteNotify(req.body);
      // console.log("readAllNotifyFunc",data)
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
module.exports = {
    getAllUserNotificationFunc,
    createNotifyFunc,
    readAllNotifyFunc,
    readOneNotifyFunc,
    deleteNotifyFunc
  };