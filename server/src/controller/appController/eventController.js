//src/controller/eventController.js
import eventService from "../../service/appService/eventService";
const getUserRoleInEventFunc = async (req, res) => {
  try {
    const userId = req.query.userId; 
    const eventId = req.query.eventId; 
      // console.log("userid",userId)
      const data = await eventService.getUserRoleInEvent(eventId,userId);
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
    let data = await eventService.getAllEvent();

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

const getAllEventStatusFunc = async (req, res) => {
  try {
    let data = await eventService.getAllEventStatus();

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

const getAllEventCategoryFunc = async (req, res) => {
  try {
    let data = await eventService.getAllEventCategory();

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
      const data = await eventService.getUserEvents(userId);
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
      const data = await eventService.getMemberInEvents(eventId);
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
      const data = await eventService.getMemberAssign(eventId,taskId);
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
    let data = await eventService.getOneEvent(eventId);
  // console.log("getOneEventFunc",data)
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
    // console.log("createEventFunc",req.body)
    // const { eventId, userId } = req.body;
    let data = await eventService.createEvent(req.body);
// console.log("data.DT.id,",data.DT.id)
    await eventService.addUserToEvent(req.body.eventId, req.body.userId, 'Leader');
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
      let data = await eventService.addUserToEvent(eventId, userId, role);
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
    // console.log("updateEventFunc",req.body)
    let data = await eventService.updateEvent(req.body);
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
    // console.log("first,", eventId);

    let data = await eventService.deleteEvent(eventId);
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

const updateUserRoleFunc = async (req, res) => {
  try {
    const {eventId ,userId , role}= req.body;
    // console.log("updateUserRoleFunc,",req.body);
    let data = await eventService.updateUserRole(eventId,userId,role);
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

    let data = await eventService.deleteUserInEvent(eventId,userId);
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
module.exports = {
  getUserRoleInEventFunc,
  getAllEventFunc,
  getAllEventStatusFunc,
  getAllEventCategoryFunc,
  getUserEventsFunc,
  getMemberInEventsFunc,
  getMemberAssignFunc,
  getOneEventFunc,
  createEventFunc,
  addUserToEventFunc,
  updateEventFunc,
  deleteEventFunc,
  updateUserRoleFunc,
  deleteUserInEventFunc
};
