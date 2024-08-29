// src/service/eventService.js
import db from "../../models";
import { Op } from "sequelize";
import { v4 as uuidv4 } from "uuid";

const getAllTaskInEvents = async (eventId) => {
  try {
    console.log(eventId);
    let event = await db.Task.findAll({
      where: { eventId: eventId, parentTaskId: null },
      // include: [
      //   {
      //     model: db.UserTask,
      //     include: [
      //       {
      //         model: db.User,
      //         attributes: ['id', 'name']
      //       }
      //     ]
      //   }
      // ]
      include: [
        {
          model: db.UserTask,
          attributes: ["userId"],
        },
      ],
    });
    if (!event) {
      return {
        EM: "Sự kiện không tồn tại",
        EC: 1,
        DT: [],
      };
    }
    return {
      EM: "Lấy danh sách công việc của sự kiện thành công",
      EC: 0,
      DT: event,
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

// const getAllTaskInEvents = async (eventId) => {
//   try {

//     let tasks = await db.Task.findAll({
//       where: { eventId: eventId, parentTaskId: null },
//       include: [
//         {
//           model: db.TaskStatus,
//           attributes: ['status'],
//         },
//       ],
//     });

//     if (!tasks || tasks.length === 0) {
//       return {
//         EM: "Sự kiện không tồn tại",
//         EC: 1,
//         DT: [],
//       };
//     }
//     const taskIds = tasks.map((task) => task.id);
//     const userTasks = await db.UserTask.findAll({
//       where: { taskId: taskIds },
//       include: [
//         {
//           model: db.User,
//           attributes: ["id", "name", "email", "role", "phone", "avatarUrl"],
//         },
//       ],
//     });

//     const userTaskMap = {};
//     userTasks.forEach((userTask) => {
//       if (!userTaskMap[userTask.taskId]) {
//         userTaskMap[userTask.taskId] = [];
//       }
//       userTaskMap[userTask.taskId].push(userTask.User);
//     });

//     const tasksWithUsers = tasks.map((task) => ({
//       ...task.toJSON(),
//       status: task.TaskStatus ? task.TaskStatus.status : null,
//       users: userTaskMap[task.id] || [],
//     }));

//     return {
//       EM: "Lấy danh sách công việc của sự kiện thành công",
//       EC: 0,
//       DT: tasksWithUsers,
//     };
//   } catch (error) {
//     console.log(error);
//     return {
//       EM: "Lấy danh sách công việc của sự kiện thất bại",
//       EC: 1,
//       DT: [],
//     };
//   }
// };

const getSubTaskInEvents = async (eventId, parentTaskId) => {
  try {
    let event = await db.Task.findAll({
      where: {
        eventId: eventId,
        parentTaskId: parentTaskId,
      },
      // include: [
      //   {
      //     model: db.TaskStatus,
      //     attributes: ["id", "status"],
      //   },
      // ],
    });
    if (!event) {
      return {
        EM: "Sự kiện không tồn tại",
        EC: 1,
        DT: [],
      };
    }
    return {
      EM: "Lấy danh sách công việc phụ của sự kiện thành công",
      EC: 0,
      DT: event,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Lấy danh sách công việc phụ của sự kiện thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const getAllTaskStatus = async () => {
  try {
    let taskStatus = await db.TaskStatus.findAll({});

    if (taskStatus) {
      return {
        EM: "Lấy danh sách trạng thái công việc thành công",
        EC: 0,
        DT: taskStatus,
      };
    }
  } catch (e) {
    console.log(e);
    return {
      EM: "Lấy danh sách trạng thái công việc thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const getOneTask = async (taskId, userId) => {
  try {
    let task = await db.Task.findOne({
      where: {
        [Op.or]: [{ id: taskId }],
      },
      // include: [
      //   {
      //     model: db.TaskStatus,
      //     attributes: ["id", "status"],
      //   },
      // ],
    });

    if (task) {
      let isMember = await db.UserTask.findOne({
        where: {
          taskId: taskId,
          userId: userId,
        },
      });

      return {
        EM: "Lấy thông tin công việc thành công",
        EC: 0,
        DT: {
          ...task.toJSON(),
          isMember: isMember ? true : false,
        },
      };
    } else {
      return {
        EM: "Công việc không tồn tại",
        EC: 1,
        DT: [],
      };
    }
  } catch (e) {
    console.log(e);
    return {
      EM: "Lấy thông tin công việc thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const getOneSubTask = async (taskId, parentTaskId, userId) => {
  try {
    let subtask = await db.Task.findOne({
      where: {
        [Op.or]: [{ id: taskId, parentTaskId: parentTaskId }],
      },
      // include: [
      //   {
      //     model: db.TaskStatus,
      //     attributes: ["id", "status"],
      //   },
      // ],
    });
    // console.log("subtask",subtask)
    if (subtask) {
      let isMember = await db.UserTask.findOne({
        where: {
          taskId: taskId,
          userId: userId,
        },
      });
      return {
        EM: "Lấy thông tin công việc phụ thành công",
        EC: 0,
        DT: {
          ...subtask.toJSON(),
          isMember: isMember ? true : false,
        },
      };
    } else {
      return {
        EM: "Công việc phụ không tồn tại",
        EC: 1,
        DT: [],
      };
    }
  } catch (e) {
    console.log(e);
    return {
      EM: "Lấy thông tin công việc phụ thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const createTask = async (data) => {
  try {
    // console.log("data create task", data);
    const { eventId, name, description, startAt, endAt, parentTaskId } = data;

    const event = await db.Event.findOne({
      where: { id: eventId },
    });

    if (!event) {
      return {
        EM: "Sự kiện không tồn tại",
        EC: 1,
        DT: [],
      };
    }

    let newTask;
    if (parentTaskId) {
      newTask = await db.Task.create({
        id: uuidv4(),
        name: name,
        description: description,
        startAt: startAt,
        endAt: endAt,
        // statusId: 1,
        status: "Pending",
        eventId: eventId,
        parentTaskId: parentTaskId,
        isShow: false,
      });
    } else {
      newTask = await db.Task.create({
        id: uuidv4(),
        name: name,
        description: description,
        startAt: startAt,
        endAt: endAt,
        // statusId: 1,
        status: "Pending",
        eventId: eventId,
      });
    }
    await db.TaskStatus.create({
      id: uuidv4(),
      taskId: newTask.id,
      status: "Pending",
    });
    return {
      EM: "Tạo công việc thành công",
      EC: 0,
      DT: newTask,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Tạo công việc thất bại",
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
        name: data.name,
        description: data.description,
        startAt: data.startAt,
        endAt: data.endAt,
        status: data.status,
        isShow: data.isShow,
      },
      { where: { id: data.taskId } }
    );
    await db.TaskStatus.update(
      {
        status: data.status,
      },
      { where: { taskId: data.taskId } }
    );
    return {
      EM: "Cập nhật công việc thành công",
      EC: 0,
      DT: updatedTask,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Lỗi cập nhật công việc",
      EC: 1,
      DT: [],
    };
  }
};
const deleteTask = async (taskId) => {
  try {
    const subTasks = await db.Task.findAll({
      where: { parentTaskId: taskId },
    });

    await Promise.all(
      subTasks.map(async (subTask) => {
        await Promise.all([
          db.UserTask.destroy({ where: { taskId: subTask.id } }),
          db.TaskStatus.destroy({ where: { taskId: subTask.id } }),
          db.TaskCost.destroy({ where: { taskId: subTask.id } }),
        ]);

        await db.Task.destroy({
          where: { id: subTask.id },
        });
      })
    );

    await Promise.all([
      db.UserTask.destroy({ where: { taskId: taskId } }),
      db.TaskStatus.destroy({ where: { taskId: taskId } }),
      db.TaskCost.destroy({ where: { taskId: taskId } }),
    ]);

    let deletedTask = await db.Task.destroy({
      where: { id: taskId },
    });

    return {
      EM: "Xóa công việc thành công!",
      EC: 0,
      DT: deletedTask,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Lỗi khi xóa công việc",
      EC: 1,
      DT: [],
    };
  }
};

const getMemberInTask = async (taskId) => {
  try {
    const usersInTask = await db.UserTask.findAll({
      where: {
        taskId: taskId,
      },
      include: [
        {
          model: db.User,
          as: "User",
          attributes: [
            "id",
            "name",
            "email",
            "phone",
            "avatarUrl",
            "activated",
          ],
        },
      ],
    });

    const users = usersInTask.map((userTask) => ({
      id: userTask.User.id,
      name: userTask.User.name,
      email: userTask.User.email,
      phone: userTask.User.phone,
      avatarUrl: userTask.User.avatarUrl,
      activated: userTask.User.activated,
    }));

    return {
      EM: "Lấy thông tin công việc thành công",
      EC: 0,
      DT: users,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Lấy thông tin công việc thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const getMemberInSubTask = async (taskId, parentTaskId) => {
  try {
    const usersInSubTask = await db.UserTask.findAll({
      include: [
        {
          model: db.Task,
          as: "Task",
          where: {
            id: taskId,
            parentTaskId: parentTaskId,
          },
        },
        {
          model: db.User,
          as: "User",
          attributes: [
            "id",
            "name",
            "email",
            "phone",
            "avatarUrl",
            "activated",
          ],
        },
      ],
    });

    const users = usersInSubTask.map((userTask) => ({
      id: userTask.User.id,
      name: userTask.User.name,
      email: userTask.User.email,
      phone: userTask.User.phone,
      avatarUrl: userTask.User.avatarUrl,
      activated: userTask.User.activated,
    }));

    return {
      EM: "Lấy danh sách thành viên công việc phụ thành công",
      EC: 0,
      DT: users,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Lấy danh sách thành viên công việc phụ thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const addMemberToTask = async (taskId, userId) => {
  try {
    const user = await db.User.findOne({ where: { id: userId } });
    if (!user) {
      return {
        EM: "Người dùng không tồn tại",
        EC: 1,
        DT: [],
      };
    }

    let userTask = await db.UserTask.findOne({
      where: {
        taskId: taskId,
        userId: userId,
      },
    });

    if (!userTask) {
      await db.UserTask.create({
        id: uuidv4(),
        taskId: taskId,
        userId: userId,
      });
    }

    return {
      EM: "Giao việc cho thành viên thành công",
      EC: 0,
      DT: [],
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Giao việc cho thành viên thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const addMemberToSubTask = async (taskId, userId) => {
  try {
    const user = await db.User.findOne({ where: { id: userId } });
    if (!user) {
      return {
        EM: "Người dùng không tồn tại",
        EC: 1,
        DT: [],
      };
    }

    let userTask = await db.UserTask.findOne({
      where: {
        taskId: taskId,
        userId: userId,
      },
    });

    if (!userTask) {
      await db.UserTask.create({
        id: uuidv4(),
        taskId: taskId,
        userId: userId,
      });
    }

    return {
      EM: "Giao việc cho thành viên thành công",
      EC: 0,
      DT: [],
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Giao việc cho thành viên thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const deleteMemberInTask = async (taskId, userId) => {
  try {
    await db.UserTask.destroy({
      where: {
        taskId: taskId,
        userId: userId,
      },
    });

    return {
      EM: "Hủy việc cho thành viên thành công",
      EC: 0,
      DT: [],
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Hủy việc cho thành viên thất bại",
      EC: 1,
      DT: [],
    };
  }
};
const getMemberAssignSubTask = async (taskId) => {
  try {
    const usersInMainTask = await db.UserTask.findAll({
      where: {
        taskId: taskId,
      },
      include: [
        {
          model: db.Task,
          as: "Task",
          where: {
            parentTaskId: null,
          },
        },
        {
          model: db.User,
          as: "User",
          attributes: [
            "id",
            "name",
            "email",
            "phone",
            "avatarUrl",
            "activated",
          ],
        },
      ],
    });

    const users = usersInMainTask.map((userTask) => ({
      id: userTask.User.id,
      name: userTask.User.name,
      email: userTask.User.email,
      phone: userTask.User.phone,
      avatarUrl: userTask.User.avatarUrl,
      activated: userTask.User.activated,
    }));

    return {
      EM: "Lấy danh sách thành viên công việc thành công",
      EC: 0,
      DT: users,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Lấy danh sách thành viên công việc thất bại",
      EC: 1,
      DT: [],
    };
  }
};

module.exports = {
  getAllTaskInEvents,
  getSubTaskInEvents,
  getAllTaskStatus,
  getOneTask,
  getOneSubTask,
  createTask,
  updateTask,
  deleteTask,
  getMemberInTask,
  getMemberInSubTask,
  addMemberToTask,
  addMemberToSubTask,
  deleteMemberInTask,
  getMemberAssignSubTask,
};
