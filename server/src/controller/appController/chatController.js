import chatService from "../../service/appService/chatService";
import upload from "../../Cloudinary/upload";
const getUserRoomChatFunc = async (req, res) => {
  try {
    const userId = req.query.userId; 
      // console.log("userId",userId)
      const data = await chatService.getUserRoomChat(userId);
      // console.log("getUserRoomChatFunc",data)
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
const sendMessageFunc = async (req, res) => {
  try {
          const { eventId, userId, messageText } = req.body;

          const data = await chatService.sendMessage(eventId, userId, messageText);
          return res.status(200).json({ EM: data.EM, EC: data.EC, DT: data.DT });
  } catch (error) {
      console.log(error);
      return res.status(500).json({ EM: 'Lỗi từ máy chủ', EC: '-1', DT: '' });
  }
};
const sendImageFunc = async (req, res) => {
  try {
      upload.single('image')(req, res, async (err) => {
          if (err) {
              return res.status(500).json({ EM: 'Lỗi tải tập tin lên', EC: '-1', DT: '' });
          }

          const imageUrl = req.file ? req.file.path : null; 
          const { eventId, userId } = req.body;

          const data = await chatService.sendImage(eventId, userId, imageUrl);
          return res.status(200).json({ EM: data.EM, EC: data.EC, DT: data.DT });
      });
  } catch (error) {
      console.log(error);
      return res.status(500).json({ EM: 'Lỗi từ máy chủ', EC: '-1', DT: '' });
  }
};

  const getAllMessagesInChatRoomFunc = async (req, res) => {
    try {
      const eventId = req.query.eventId; 
        // console.log("eventId",eventId)
        const data = await chatService.getAllMessagesInChatRoom(eventId);
        // console.log("getAllTaskInEvents",data)
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
 
module.exports = {
    getUserRoomChatFunc,
    sendMessageFunc,
    sendImageFunc,
    getAllMessagesInChatRoomFunc
    
  };