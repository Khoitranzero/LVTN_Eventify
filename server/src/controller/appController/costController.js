//src/controller/eventController.js
import costService from "../../service/appService/costService";

const createCategoryFunc = async (req, res) => {
  try {
    let data = await costService.createCategory(req.body);
    // console.log("createCategoryFunc", data);
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
//Delete budget category
const deleteCategoryFunc = async (req, res) => {
  try {
    const id = req.body;
    let data = await costService.deleteBudgetCategory(id);
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
const getAllEventCostFunc = async (req, res) => {
  try {
    const eventId = req.query.eventId;
    let data = await costService.getAllEventCost(eventId);
    // console.log("getAllEventCostFunc", data);
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
//get all budget category
const getAllCategoryFunc = async (req, res) => {
  try {
    let data = await costService.getAllCategory();
    // console.log("getAllCategoryFunc", data);
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
//update budget category
const updateCostCategoryFunc = async (req, res) => {
  try {
    let data = await costService.updateBudgetCategory(req.body);
    // console.log("data return", data);
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

const createBudgetCostFunc = async (req, res) => {
  try {
    let data = await costService.createBudgetCost(req.body);
    // console.log("createBudgetCostFunc", data);
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

const getOneBudgetCostFunc = async (req, res) => {
  try {
    const costId = req.query.costId;
    // console.log("costId", costId);
    let data = await costService.getOneBudgetCost(costId);
    // console.log("getOneBudgetCostFunc", data);
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

const updateEventCostFunc = async (req, res) => {
  try {
    let data = await costService.updateEventCost(req.body);
    // console.log("data return", data);
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
const deleteEventCostFunc = async (req, res) => {
  try {
    const costId = req.query.costId;
    // console.log("costId,", costId);

    let data = await costService.deleteEventCost(costId);
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

const getAllTaskCostFunc = async (req, res) => {
  try {
    const taskId = req.query.taskId;
    let data = await costService.getAllTaskCost(taskId);
    // console.log("getAllTaskCostFunc",data)
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

const getTotalCostFunc = async (req, res) => {
  try {
    const eventId = req.query.eventId;
    let data = await costService.getTotalCost(eventId);
    // console.log("getTotalCostFunc", data);
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


const updateEventBudgetCostFunc = async (req, res) => {
  try {
    let data = await costService.updateEventBudgetCost(req.body);
    // console.log("data return", data);
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

const createTaskCostFunc = async (req, res) => {
  try {
    let data = await costService.createTaskCost(req.body);
    // console.log("createTaskCostFunc", data);
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

const getOneTaskCostFunc = async (req, res) => {
  try {
    const costId = req.query.costId;
    let data = await costService.getOneTaskCost(costId);
    // console.log("getOneTaskCostFunc", data);
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

const updateTaskCostFunc = async (req, res) => {
  try {
    let data = await costService.updateTaskCost(req.body);
    // console.log("data return", data);
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
const deleteTaskCostFunc = async (req, res) => {
  try {
    const costId = req.query.costId;
    const eventId = req.query.eventId;
    // console.log("costId,", costId);

    let data = await costService.deleteTaskCost(costId, eventId);
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
  createCategoryFunc,
  getAllEventCostFunc,
  getAllCategoryFunc,
  createBudgetCostFunc,
  getOneBudgetCostFunc,
  updateEventCostFunc,
  deleteEventCostFunc,
  getTotalCostFunc,
  updateEventBudgetCostFunc,
  getAllTaskCostFunc,
  createTaskCostFunc,
  getOneTaskCostFunc,
  updateTaskCostFunc,
  deleteTaskCostFunc,
  deleteCategoryFunc,
  updateCostCategoryFunc,
};
