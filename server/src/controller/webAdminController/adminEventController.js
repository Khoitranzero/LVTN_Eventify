//src/controller/eventController.js
import adminEventService from "../../service/webAdminService/adminEventService";
const getUserRoleInEventFunc = async (req, res) => {
  try {
    const userId = req.query.userId;
    const eventId = req.query.eventId;
    // console.log("userid",userId)
    const data = await adminEventService.getUserRoleInEvent(eventId, userId);
    // console.log("userEvents",data)
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
const getAllEventFunc = async (req, res) => {
  try {
    let data = await adminEventService.getAllEvent();

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

const getUserEventsFunc = async (req, res) => {
  try {
    const userId = req.query.userId;
    // console.log("userid",userId)
    const data = await adminEventService.getUserEvents(userId);
    // console.log("userEvents",data)
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
const getMemberInEventsFunc = async (req, res) => {
  try {
    const eventId = req.query.eventId;
    // console.log("eventId",eventId)
    const data = await adminEventService.getMemberInEvents(eventId);
    // console.log("getMemberInEventsFunc",data)
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

const getMemberAssignFunc = async (req, res) => {
  try {
    const eventId = req.query.eventId;
    // console.log("eventId",eventId)
    const taskId = req.query.taskId;
    // console.log("taskId",taskId)
    const data = await adminEventService.getMemberAssign(eventId, taskId);
    // console.log("getMemberAsignFunc",data)
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

const getOneEventFunc = async (req, res) => {
  try {
    const eventId = req.query.eventId;
    // console.log("eventId",eventId)
    let data = await adminEventService.getOneEvent(eventId);

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
const createEventFunc = async (req, res) => {
  try {
    // console.log("req.body",req.body)
    // const { eventId, userId } = req.body;
    let data = await adminEventService.createEvent(req.body);
    // console.log("data.DT.id,",data.DT.id)
    await adminEventService.addUserToEvent(
      req.body.eventId,
      req.body.userId,
      "Master"
    );
    // console.log("first",data.DT)
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

const addUserToEventFunc = async (req, res) => {
  try {
    const { eventId, userId, role } = req.body;
    // console.log("req.body",req.body)
    let data = await adminEventService.addUserToEvent(eventId, userId, role);
    //  console.log("first",data.DT)
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
const updateEventFunc = async (req, res) => {
  try {
    console.log("update event: ", data);
    let data = await adminEventService.updateEvent(req.body);
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
const deleteEventFunc = async (req, res) => {
  try {
    const eventId = req.query.eventId;
    console.log("first,", eventId);

    let data = await adminEventService.deleteEvent(eventId);
    console.log("data,", data);
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

const updateUserRoleFunc = async (req, res) => {
  try {
    const { eventId, userId, role } = req.body;
    // console.log("updateUserRoleFunc,",req.body);
    let data = await adminEventService.updateUserRole(eventId, userId, role);
    // console.log("data,", data);
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
const deleteUserInEventFunc = async (req, res) => {
  try {
    const eventId = req.query.eventId;
    const userId = req.query.userId;
    // console.log("eventId,", eventId,"userId,",userId);

    let data = await adminEventService.deleteUserInEvent(eventId, userId);
    // console.log("data,", data);
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
const filterEventInTimeFunc = async (req, res) => {
  try {
    const time = req.query.time;
    const timeType = req.query.timeType;
    // console.log("eventId,", eventId,"userId,",userId);
    const input = {
      time,
      timeType,
    };
    console.log("Thời gian controller: ", input);
    let data = await adminEventService.filterEventByTime(input);
    // console.log("data,", data);
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
const filterEventInFutureTimeFunc = async (req, res) => {
  try {
    const startAt = req.query.startAt;
    const endAt = req.query.endAt;
    const timeType = req.query.timeType;
    const input = {
      startAt,
      endAt,
      timeType,
    };
    let data = await adminEventService.filterEventInFuture(input);
    // console.log("data,", data);
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
const allEventFinishFunc = async (req, res) => {
  try {
    let data = await adminEventService.countEventFinished();
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
  getUserRoleInEventFunc,
  getAllEventFunc,
  getUserEventsFunc,
  getMemberInEventsFunc,
  getMemberAssignFunc,
  getOneEventFunc,
  createEventFunc,
  addUserToEventFunc,
  updateEventFunc,
  deleteEventFunc,
  updateUserRoleFunc,
  deleteUserInEventFunc,
  filterEventInTimeFunc,
  filterEventInFutureTimeFunc,
  allEventFinishFunc,
};
