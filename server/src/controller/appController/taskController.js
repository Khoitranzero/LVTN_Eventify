//src/controller/taskController.js
import taskService from "../../service/appService/taskService";
import notificationService from "../../service/appService/notificationService";

const getAllTaskInEventsFunc = async (req, res) => {
  try {
    const eventId = req.query.eventId; 
      const data = await taskService.getAllTaskInEvents(eventId);
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
const getSubTaskInEventsFunc = async (req, res) => {
  try {
    const eventId = req.query.eventId;
    const parentTaskId = req.query.parentTaskId;  
      // console.log("eventId",eventId)
      const data = await taskService.getSubTaskInEvents(eventId,parentTaskId);
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

const getAllTaskStatusFunc = async (req, res) => {
  try {
    let data = await taskService.getAllTaskStatus();
//  console.log("getAllTaskStatusFunc",data)
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

const getOneTaskFunc = async (req, res) => {
  try {
    const taskId = req.query.taskId; 
    // console.log("taskId",taskId)
    const userId = req.query.userId; 
    let data = await taskService.getOneTask(taskId,userId);
    // console.log("getOneTaskFunc",data)
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

const getOneSubTaskFunc = async (req, res) => {
  try {
    const taskId = req.query.taskId; 
    const parentTaskId = req.query.parentTaskId; 
    const userId = req.query.userId; 
    // console.log("taskId",taskId)
    // console.log("parentTaskId",parentTaskId)
    let data = await taskService.getOneSubTask(taskId,parentTaskId,userId);
    // console.log("data",data)
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

const createTaskFunc = async (req, res) => {
  try {
    // console.log("req.body",req.body)
    let data = await taskService.createTask(req.body);

    // console.log("first",data)
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



const updateTaskFunc = async (req, res) => {
  try {
    let data = await taskService.updateTask(req.body);
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
const deleteTaskFunc = async (req, res) => {
  try {
    const taskId = req.query.taskId; 
    // console.log("taskId,", taskId);

    let data = await taskService.deleteTask(taskId);
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

const getMemberInTaskFunc = async (req, res) => {
  try {
      const taskId = req.query.taskId; 
      // console.log("taskId",taskId)
      const data = await taskService.getMemberInTask(taskId);
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

const getMemberInSubTaskFunc = async (req, res) => {
  try {
      const taskId = req.query.taskId; 
      const parentTaskId = req.query.parentTaskId; 
      // console.log("taskId",taskId)
      // console.log("parentTaskId",parentTaskId)
      const data = await taskService.getMemberInSubTask(taskId, parentTaskId);
      // console.log("getMemberInSubTaskFunc",data)
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
const addMemberToTaskFunc = async (req, res) => {
  try {
      const { taskId, userId } = req.body;
      // console.log("req.body",req.body)
      let data = await taskService.addMemberToTask(taskId, userId);
      //  console.log("first",data)
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

const addMemberToSubTaskFunc = async (req, res) => {
  try {
      const { taskId, userId } = req.body;
      // console.log("req.body",req.body)
      let data = await taskService.addMemberToSubTask(taskId, userId);
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

const deleteMemberInTaskFunc = async (req, res) => {
  try {
    const taskId = req.query.taskId; 
    const userId = req.query.userId; 
    // console.log("taskId,", taskId,"userId,",userId);

    let data = await taskService.deleteMemberInTask(taskId,userId);
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

const getMemberAssignSubTaskFunc = async (req, res) => {
  try {
      // const eventId = req.query.eventId; 
      // console.log("eventId",eventId)
      const taskId = req.query.taskId; 
      // console.log("taskId",taskId)
      const data = await taskService.getMemberAssignSubTask(taskId);
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
module.exports = {
  getAllTaskInEventsFunc,
  getSubTaskInEventsFunc,
  getAllTaskStatusFunc,
  getOneTaskFunc,
  getOneSubTaskFunc,
  createTaskFunc,
  updateTaskFunc,
  deleteTaskFunc,
  getMemberInTaskFunc,
  getMemberInSubTaskFunc,
  addMemberToTaskFunc,
  addMemberToSubTaskFunc,
  deleteMemberInTaskFunc,
  getMemberAssignSubTaskFunc
};
