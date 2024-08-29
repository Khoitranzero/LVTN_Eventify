//src/service/eventService.js
import db from "../../models";
// import chatService from "../appService/chatService";
import moment from "moment";
import { Op } from "sequelize";
const { v4: uuidv4 } = require("uuid");
//get task in event
const getAllTaskInEvents = async (eventId) => {
  try {
    let tasks = await db.Task.findAll({
      where: { eventId: eventId, parentTaskId: null },
    });

    if (!tasks || tasks.length === 0) {
      return {
        EM: "Sự kiện không tồn tại",
        EC: 1,
        DT: [],
      };
    }
    const taskIds = tasks.map((task) => task.id);
    const userTasks = await db.UserTask.findAll({
      where: { taskId: taskIds },
      include: [
        {
          model: db.User,
          attributes: ["id", "name", "email", "role", "phone", "avatarUrl"],
        },
      ],
    });

    const userTaskMap = {};
    userTasks.forEach((userTask) => {
      if (!userTaskMap[userTask.taskId]) {
        userTaskMap[userTask.taskId] = [];
      }
      userTaskMap[userTask.taskId].push(userTask.User);
    });

    const tasksWithUsers = tasks.map((task) => ({
      ...task.toJSON(),
      users: userTaskMap[task.id] || [],
    }));

    return {
      EM: "Lấy danh sách công việc của sự kiện thành công",
      EC: 0,
      DT: tasksWithUsers,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Lấy danh sách công việc của sự kiện thất bại",
      EC: 1,
      DT: [],
    };
  }
};
const updateTask = async (data) => {
  try {
    // console.log("data", data);
    let updatedTask = await db.Task.update(
      {
        startAt: data?.startAt,
        endAt: data?.endAt,
      },
      { where: { id: data.id } }
    );
    return {
      EM: "Cập nhật công việc thành công",
      EC: 0,
      DT: updatedTask,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Cập nhật công việc thất bại",
      EC: 1,
      DT: [],
    };
  }
};
module.exports = {
  getAllTaskInEvents,
  updateTask
};
