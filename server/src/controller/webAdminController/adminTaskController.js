import adminTaskService from "../../service/webAdminService/adminTaskService";
const getAllTaskInEventsFunc = async (req, res) => {
  try {
    const eventId = req.query.eventId;
    const data = await adminTaskService.getAllTaskInEvents(eventId);
    console.log("getAllTaskInEvents", data);
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
const updateTaskFunc = async (req, res) => {
  try {
    let data = await adminTaskService.updateTask(req.body);
    // console.log("data return",data)
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
  getAllTaskInEventsFunc,
  updateTaskFunc
};
