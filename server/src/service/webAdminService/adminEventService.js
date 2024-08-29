//src/service/eventService.js
import db from "../../models";
// import chatService from "../appService/chatService";
import moment from "moment";
import { Op, where } from "sequelize";
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
        "status",
        "description",
        "startAt",
        "endAt",
        "experience",
        "categoryId",
      ],
      include: [
        {
          model: db.EventCategory,
          as: "EventCategory",
          attributes: ["name"],
        },
        {
          model: db.UserEvent,
          as: "UserEvents",
          where: { roleId: "leader" },
          attributes: ["roleId"],
          include: [
            {
              model: db.User,
              as: "User",
              attributes: ["id", "name", "email", "avatarUrl"],
            },
          ],
          required: false, // Make it optional in case some events don't have a leader
        },
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

const getUserEvents = async (userId) => {
  try {
    const userEvents = await db.UserEvent.findAll({
      where: {
        userId: userId,
      },
      include: [
        {
          model: db.Event,
          as: "Event",
        },
      ],
    });
    // console.log("userEvents", userEvents);

    const events = userEvents.map((userEvent) => userEvent.Event);

    // console.log("events", events);

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
      attributes: [
        "name",
        "status",
        "description",
        "startAt",
        "endAt",
        "location",
      ],
      where: {
        [Op.or]: [{ id: eventId }],
      },
      include: [
        {
          model: db.EventCategory,
          attributes: ["name"],
        },
      ],
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
    // console.log("data create event", data);

    // let isEventIdExist = await checkEventIdExist(data);
    // if (isEventIdExist === true) {
    //     return {
    //         EM: 'EventId is Exist',
    //         EC: 2,
    //         DT: []
    //     };
    // }

    let newEvent = await db.Event.create({
      id: data.eventId,
      name: data.name,
      status: "Pending",
      description: data.description,
      startAt: data.startAt,
      endAt: data.endAt,
    });

    await db.EventStatus.create({
      id: uuidv4(),
      eventId: newEvent.id,
      status: "Pending",
    });
    if (newEvent) {
      //   await chatService.createChatRoom(newEvent.id);
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

const updateEvent = async (data) => {
  try {
    // console.log("data", data);
    let updatedEvent = await db.Event.update(
      {
        name: data?.name,
        status: data?.status,
        description: data?.description,
        startAt: data?.startAt,
        endAt: data?.endAt,
        // experience: data.experience, // Nếu cần thiết
      },
      { where: { id: data.eventId } }
    );

    if (data.status) {
      await db.EventStatus.create({
        id: uuidv4(),
        eventId: data?.eventId,
        status: data?.status,
      });
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
    await Promise.all([
      db.Task.destroy({ where: { eventId: eventId } }),
      db.ChatRoom.destroy({ where: { eventId: eventId } }),
      db.Notification.destroy({ where: { eventId: eventId } }),
      db.EventStatus.destroy({ where: { eventId: eventId } }),
      db.UserEvent.destroy({ where: { eventId: eventId } }),
    ]);

    let deletedEvent = await db.Event.destroy({
      where: { id: eventId },
    });

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
        id: `${eventId}-${userId}`,
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
//Filter event by time
const filterEventByTime = async (data) => {
  try {
    console.log("service", data);
    let startDate;
    let endDate;

    switch (data.timeType) {
      case "date":
        startDate = moment(data.time, "YYYY-MM-DD").startOf("day").toDate();
        endDate = moment(data.time, "YYYY-MM-DD").endOf("day").toDate();
        break;
      case "month":
        startDate = moment(data.time, "YYYY-MM").startOf("month").toDate();
        endDate = moment(data.time, "YYYY-MM").endOf("month").toDate();
        break;
      case "quarter":
        startDate = moment(data.time, "YYYY-[Q]Q").startOf("quarter").toDate();
        endDate = moment(data.time, "YYYY-[Q]Q").endOf("quarter").toDate();
        break;
      case "year":
        startDate = moment(data.time, "YYYY").startOf("year").toDate();
        endDate = moment(data.time, "YYYY").endOf("year").toDate();
        break;
      default:
        throw new Error("Invalid timeType");
    }

    const filteredEvent = await db.Event.findAll({
      where: {
        createdAt: {
          [Op.gte]: startDate,
          [Op.lte]: endDate,
        },
      },
      include: [
        {
          model: db.EventStatus,
          attributes: ["status"],
        },
      ],
    });

    return {
      EM: `Số lượng thông tin sự kiện được tạo ra trong ${data.time}`,
      EC: 0,
      DT: filteredEvent,
    };
  } catch (error) {
    console.error(error);
    return {
      EM: "Lấy thông tin sự kiện theo thời gian thất bại",
      EC: 1,
      DT: [],
    };
  }
};
//Filter event in future
const filterEventInFuture = async (data) => {
  try {
    let startDate;
    let endDate;

    switch (data.timeType) {
      case "date":
        startDate = moment(data.startAt, "YYYY-MM-DD").startOf("day").toDate();
        endDate = moment(data.endAt, "YYYY-MM-DD").endOf("day").toDate();
        break;
      case "month":
        startDate = moment(data.startAt, "YYYY-MM-DD")
          .startOf("month")
          .toDate();
        endDate = moment(data.endAt, "YYYY-MM").endOf("month").toDate();
        break;
      case "quarter":
        startDate = moment(data.startAt, "YYYY-MM-DD")
          .startOf("quarter")
          .toDate();
        endDate = moment(data.endAt, "YYYY-[Q]Q").endOf("quarter").toDate();
        break;
      case "year":
        startDate = moment(data.startAt, "YYYY-MM-DD").startOf("year").toDate();
        endDate = moment(data.endAt, "YYYY").endOf("year").toDate();
        break;
      default:
        throw new Error("Invalid timeType");
    }

    const filteredEvent = await db.Event.findAll({
      where: {
        startAt: {
          [Op.between]: [startDate, endDate],
        },
      },
      include: [
        {
          model: db.UserEvent,
          where: {
            roleId: "Leader",
          },
          include: [
            {
              model: db.User,
            },
          ],
        },
      ],
    });

    return {
      EM: `Số lượng thông tin sự kiện diễn ra từ ${data.startAt} đến ${data.endAt}`,
      EC: 0,
      DT: filteredEvent,
    };
  } catch (error) {
    console.error(error);
    return {
      EM: "Lấy thông tin sự kiện theo thời gian thất bại",
      EC: 1,
      DT: [],
    };
  }
};
//count event that finished
const countEventFinished = async () => {
  try {
    let allEventFinish = await db.Event.findAll({
      where: {
        status: "Completed",
      },
    });
    return {
      EM: "Sự kiện đã hoàn thành",
      EC: 0,
      DT: allEventFinish,
    };
  } catch (error) {
    console.log("Sự kiện đã hoàn thành lỗi");
    return {
      EM: "Lấy sự kiện đã hoàn thành lỗi",
      EC: 1,
      DT: [],
    };
  }
};
module.exports = {
  getUserRoleInEvent,
  getAllEvent,
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
  filterEventByTime,
  filterEventInFuture,
  countEventFinished,
};
