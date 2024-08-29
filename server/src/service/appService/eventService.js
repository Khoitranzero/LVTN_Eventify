//src/service/eventService.js
import db from "../../models";
import chatService from "../appService/chatService";
import notificationService from "../appService/notificationService";
import { Op, Sequelize, where } from "sequelize";
const { v4: uuidv4 } = require("uuid");

const checkEventIdExist = async (data) => {
  let event = await db.Event.findOne({
    where: {
      id: data.id,
    },
  });

  if (event) {
    return true;
  }
  return false;
};

const getUserRoleInEvent = async (eventId, userId) => {
  try {
    const userRole = await db.UserEvent.findOne({
      where: {
        userId: userId,
        eventId: eventId,
      },
      include: [
        {
          model: db.Role,
          as: "Role",
          attributes: ["role"],
        },
      ],
      attributes: [],
    });

    // console.log("userRole", userRole.Role);

    return {
      EM: "Nhận quyền của người dùng trong sự kiện thành công",
      EC: 0,
      DT: userRole.Role,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Nhận quyền của người dùng trong sự kiện thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const getAllEvent = async () => {
  try {
    let events = await db.Event.findAll({
      attributes: [
        "id",
        "name",
        "location",
        "status",
        "description",
        "startAt",
        "endAt",
        "experience",
      ],
    });

    if (events) {
      return {
        EM: "Lấy thông tin toàn bộ sự kiện thành công",
        EC: 0,
        DT: events,
      };
    }
  } catch (e) {
    console.log(e);
    return {
      EM: "Lấy thông tin toàn bộ sự kiện thất bại",
      EC: 1,
      DT: [],
    };
  }
};
const getAllEventStatus = async () => {
  try {
    let events = await db.EventStatus.findAll({
    });

    if (events) {
      return {
        EM: "Lấy danh sách trạng thái sự kiện thành công",
        EC: 0,
        DT: events,
      };
    }
  } catch (e) {
    console.log(e);
    return {
      EM: "Lấy danh sách trạng thái sự kiện thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const getAllEventCategory = async () => {
  try {
    let eventCategories = await db.EventCategory.findAll({
      attributes: [
        "id",
        "name",
        [
          Sequelize.literal(
            "(SELECT COUNT(*) FROM `event` WHERE `event`.`categoryId` = `EventCategory`.`id`)"
          ),
          "eventCount",
        ],
      ],
    });

    if (eventCategories) {
      return {
        EM: "Lấy thông tin toàn bộ danh mục sự kiện thành công",
        EC: 0,
        DT: eventCategories,
      };
    }
  } catch (e) {
    console.log(e);
    return {
      EM: "Lấy thông tin toàn bộ danh mục sự kiện thất bại",
      EC: 1,
      DT: [],
    };
  }
};

// const getUserEvents = async (userId) => {
//   try {
//     const userEvents = await db.UserEvent.findAll({
//       where: {
//         userId: userId,
//       },
//       include: [
//         {
//           model: db.Event,
//           attributes: [
//             "id",
//             "name",
//             "status",
//             "startAt",
//             "endAt",
//             "createdAt",
//             "updatedAt",
//           ],
//         },
//         {
//           model: db.Role,
//           attributes: ["role"],
//           as: "Role",
//         },
//       ],
//     });
//     // Chuyển đổi kết quả thành danh sách các sự kiện kèm vai trò
//     const events = userEvents?.map((userEvent) => {
//       const event = userEvent.Event.toJSON();// Chuyển đổi thành đối tượng JSON
//       event.role = userEvent.Role ? userEvent.Role.role : null; // Thêm thuộc tính 'role' từ Role
//       return event;
//     });
//     return {
//       EM: "Lấy danh sách các sự kiện của người dùng thành công",
//       EC: 0,
//       DT: events,
//     };
//   } catch (error) {
//     console.log(error);
//     return {
//       EM: "Lấy danh sách các sự kiện của người dùng thất bại",
//       EC: 1,
//       DT: [],
//     };
//   }
// };
const getUserEvents = async (userId) => {
  try {
    const userEvents = await db.UserEvent.findAll({
      where: {
        userId: userId,
      },
      include: [
        {
          model: db.Event,
          attributes: [
            "id",
            "name",
            "status",
            "startAt",
            "endAt",
            "createdAt",
            "updatedAt",
          ],
        },
        {
          model: db.Role,
          attributes: ["role"],
          as: "Role",
        },
      ],
    });

    const events = userEvents
      ?.map((userEvent) => {
        if (userEvent.Event) {
          const event = userEvent.Event.toJSON();
          event.role = userEvent.Role ? userEvent.Role.role : null; 
          return event;
        }
        return null;
      })
      .filter((event) => event !== null); 

    return {
      EM: "Lấy danh sách các sự kiện của người dùng thành công",
      EC: 0,
      DT: events,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Lấy danh sách các sự kiện của người dùng thất bại",
      EC: 1,
      DT: [],
    };
  }
};
// const getUserEvents = async (userId) => {
//   try {
//     const userEvents = await db.UserEvent.findAll({
//       where: {
//         userId: userId,
//       },
//       include: [
//         {
//           model: db.Event,
//           attributes: [
//             'id',
//             'name',
//             'startAt',
//             'endAt',
//             // 'createdAt',
//             // 'updatedAt',
//           ],
//           include: [
//             {
//               model: db.EventStatus,
//               attributes: ['status'],
//             },
//           ],
//         },
//         {
//           model: db.Role,
//           attributes: ['role'],
//           as: 'Role',
//         },
//       ],
//     });

//     const events = userEvents.map((userEvent) => {
//       const event = userEvent.Event.toJSON();
//       event.role = userEvent.Role ? userEvent.Role.role : null;
//       event.status = event.EventStatus ? event.EventStatus.status : null;
//       delete event.EventStatus; // Remove redundant EventStatus field
//       return event;
//     });

//     return {
//       EM: 'Lấy danh sách các sự kiện của người dùng thành công',
//       EC: 0,
//       DT: events,
//     };
//   } catch (error) {
//     console.log(error);
//     return {
//       EM: 'Lấy danh sách các sự kiện của người dùng thất bại',
//       EC: 1,
//       DT: [],
//     };
//   }
// };

const getMemberInEvents = async (eventId) => {
  try {
    const usersInEvent = await db.UserEvent.findAll({
      where: {
        eventId: eventId,
      },
      include: [
        {
          model: db.User,
          as: "User",
          attributes: [
            "id",
            "name",
            "role",
            "email",
            "phone",
            "avatarUrl",
            "activated",
          ],
        },
        {
          model: db.Role,
          as: "Role",
          attributes: ["role"],
        },
      ],
    });

    const users = usersInEvent.map((userEvent) => ({
      id: userEvent.User.id,
      name: userEvent.User.name,
      role: userEvent.Role.role,
      email: userEvent.User.email,
      phone: userEvent.User.phone,
      avatarUrl: userEvent.User.avatarUrl,
      activated: userEvent.User.activated,
    }));

    return {
      EM: "Lấy danh sách thành viên trong sự kiện thành công",
      EC: 0,
      DT: users,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Lấy danh sách thành viên trong sự kiện thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const getMemberAssign = async (eventId, taskId) => {
  try {
    const usersAssignedToTask = await db.UserTask.findAll({
      where: {
        taskId: taskId,
      },
      attributes: ["userId"],
    });

    const userIdsAssignedToTask = usersAssignedToTask.map(
      (userTask) => userTask.userId
    );

    const usersInEvent = await db.UserEvent.findAll({
      where: {
        eventId: eventId,
        userId: {
          [Op.notIn]: userIdsAssignedToTask,
        },
      },
      include: [
        {
          model: db.User,
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

    const users = usersInEvent.map((userEvent) => ({
      id: userEvent.User.id,
      name: userEvent.User.name,
      email: userEvent.User.email,
      phone: userEvent.User.phone,
      avatarUrl: userEvent.User.avatarUrl,
      activated: userEvent.User.activated,
    }));

    return {
      EM: "Lấy danh sách thành viên để giao việc thành công",
      EC: 0,
      DT: users,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Lấy danh sách thành viên để giao việc thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const getOneEvent = async (eventId) => {
  try {
    let event = await db.Event.findOne({
      where: {
        [Op.or]: [{ id: eventId }],
      },
      // include: [
      //   {
      //     model: db.EventStatus,
      //     attributes: ['id','status'],
      //   },
      // ],
    });
    // console.log("event",event)
    if (event) {
      return {
        EM: "Lấy thông tin sự kiện thành công",
        EC: 0,
        DT: event,
      };
    }
    //  else {
    //   return {
    //     EM: "Không tìm thấy sự kiện",
    //     EC: 2,
    //     DT: [],
    //   };
    // }
  } catch (e) {
    console.log(e);
    return {
      EM: "Lấy thông tin sự kiện thất bại",
      EC: 1,
      DT: [],
    };
  }
};
const createEvent = async (data) => {
  try {
    let newEvent = await db.Event.create({
      id: data.eventId,
      name: data.name,
      location: data.location,
      status: "Pending",
      description: data.description,
      startAt: data.startAt,
      endAt: data.endAt,
      categoryId: data.categoryId,
    });

    await db.EventStatus.create({
      id: uuidv4(),
      eventId: newEvent.id,
      status: "Pending",
    });
    if (newEvent) {
      await chatService.createChatRoom(newEvent.id);
      await db.EventStatus.create({
        id: uuidv4(),
        eventId: newEvent.id,
        status: "Pending",
      });
    }
    return {
      EM: "Tạo sự kiện thành công",
      EC: 0,
      DT: newEvent,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Tạo sự kiện thất bại",
      EC: 1,
      DT: [],
    };
  }
};
// const createEvent = async (data) => {
//   try {
//     let newEvent = await db.Event.create({
//       id: data.eventId,
//       name: data.name,
//       location: data.location,
//       statusId: 1,
//       description: data.description,
//       startAt: data.startAt,
//       endAt: data.endAt,
//       categoryId: data.categoryId,
//     });
//     if (newEvent) {
//       await chatService.createChatRoom(newEvent.id);
//     }
//     return {
//       EM: "Tạo sự kiện thành công",
//       EC: 0,
//       DT: newEvent,
//     };
//   } catch (error) {
//     console.log(error);
//     return {
//       EM: "Tạo sự kiện thất bại",
//       EC: 1,
//       DT: [],
//     };
//   }
// };

const updateEvent = async (data) => {
  try {
    // console.log("updateEvent", data);
    let updatedEvent = await db.Event.update(
      {
        name: data.name,
        location: data.location,
        status: data.status,
        description: data.description,
        startAt: data.startAt,
        endAt: data.endAt,
        categoryId: data.categoryId,
      },
      { where: { id: data.eventId } }
    );

    if (data.status) {
      await db.EventStatus.update({
        status: data.status,
      },
      { where: { eventId: data.eventId } }
    );
    }

    return {
      EM: "Cập nhật sự kiện thành công",
      EC: 0,
      DT: updatedEvent,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Cập nhật sự kiện thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const deleteEvent = async (eventId) => {
  try {
   
    const tasks = await db.Task.findAll({ where: { eventId: eventId } });

    for (const task of tasks) {
     
      const subtasks = await db.Task.findAll({
        where: { parentTaskId: task.id },
      });

      for (const subtask of subtasks) {
        
        await Promise.all([
          db.UserTask.destroy({ where: { taskId: subtask.id } }),
          db.TaskStatus.destroy({ where: { taskId: subtask.id } }),
          db.TaskCost.destroy({ where: { taskId: subtask.id } }),
        ]);
      
        await db.Task.destroy({ where: { id: subtask.id } });
      }

     
      await Promise.all([
        db.UserTask.destroy({ where: { taskId: task.id } }),
        db.TaskStatus.destroy({ where: { taskId: task.id } }),
        db.TaskCost.destroy({ where: { taskId: task.id } }),
      ]);
    }

   
    await db.Task.destroy({ where: { eventId: eventId } });

    
    const chatRooms = await db.ChatRoom.findAll({
      where: { eventId: eventId },
    });

    for (const chatRoom of chatRooms) {
      await db.Chat.destroy({ where: { chatRoomId: chatRoom.id } });
    }

   
    await db.ChatRoom.destroy({ where: { eventId: eventId } });

    
    await Promise.all([
      db.Notification.destroy({ where: { eventId: eventId } }),
      db.EventStatus.destroy({ where: { eventId: eventId } }),
      db.UserEvent.destroy({ where: { eventId: eventId } }),
      db.EventCost.destroy({ where: { eventId: eventId } }),
    ]);

   
    const deletedEvent = await db.Event.destroy({ where: { id: eventId } });

    return {
      EM: "Xóa sự kiện thành công !!",
      EC: 0,
      DT: deletedEvent,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Xóa sự kiện thất bại !!",
      EC: 1,
      DT: [],
    };
  }
};

const updateUserRole = async (eventId, userId, role) => {
  try {
    const roleRecord = await db.Role.findOne({
      where: { role: role },
    });

    if (!roleRecord) {
      return {
        EM: "Không tìm thấy quyền này",
        EC: 1,
        DT: [],
      };
    }

    let updatedUserRole = await db.UserEvent.update(
      { roleId: roleRecord.id },
      {
        where: {
          eventId: eventId,
          userId: userId,
        },
      }
    );

    return {
      EM: "Cập nhật quyền của người dùng thành công",
      EC: 0,
      DT: updatedUserRole,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Cập nhật quyền của người dùng thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const addUserToEvent = async (eventId, userId, roleName) => {
  try {
    let role = await db.Role.findOne({ where: { role: roleName } });

    if (!role) {
      role = await db.Role.create({ id: `${roleName}`, role: roleName });
    }

    const user = await db.User.findOne({ where: { id: userId } });
    if (!user) {
      return {
        EM: "Người dùng không tồn tại",
        EC: 1,
        DT: [],
      };
    }

    let userEvent = await db.UserEvent.findOne({
      where: {
        eventId: eventId,
        userId: userId,
      },
    });

    if (userEvent) {
      userEvent.roleId = role.id;
      await userEvent.save();
    } else {
      await db.UserEvent.create({
        id: uuidv4(),
        eventId: eventId,
        userId: userId,
        roleId: role.id,
      });
    }

    return {
      EM: "Thêm người dùng vào sự kiện thành công",
      EC: 0,
      DT: [],
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Thêm người dùng vào sự kiện thất bại",
      EC: 1,
      DT: [],
    };
  }
};
const deleteUserInEvent = async (eventId, userId) => {
  try {
    await db.UserEvent.destroy({
      where: {
        eventId: eventId,
        userId: userId,
      },
    });

    return {
      EM: "Xóa người dùng khỏi sự kiện thành công",
      EC: 0,
      DT: [],
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Xóa người dùng khỏi sự kiện thất bại",
      EC: 1,
      DT: [],
    };
  }
};

module.exports = {
  getUserRoleInEvent,
  getAllEvent,
  getAllEventStatus,
  getAllEventCategory,
  getUserEvents,
  getMemberInEvents,
  getMemberAssign,
  getOneEvent,
  createEvent,
  updateEvent,
  deleteEvent,
  updateUserRole,
  addUserToEvent,
  deleteUserInEvent,
};
