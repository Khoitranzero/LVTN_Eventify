// src/models/index.js
import { sequelize } from "../config/connectDB";
import EventCategory from "./eventCategory";
import Chat from "./chat";
import ChatRoom from "./chatRoom";
import Event from "./event";
import EventStatus from "./eventStatus";
import Notification from "./notification";
import Role from "./role";
import Task from "./task";
import TaskStatus from "./taskStatus";
import User from "./user";
import UserEvent from "./userEvent";
import UserTask from "./userTask";
import CostCategory from "./costCategory";
import EventCost from "./eventCost";
import TaskCost from "./taskCost";

// Define associations
Chat.belongsTo(ChatRoom, { foreignKey: "chatRoomId" });
Chat.belongsTo(User, { foreignKey: "userId" });

ChatRoom.belongsTo(Event, { foreignKey: "eventId" });
ChatRoom.hasMany(Chat, { foreignKey: "chatRoomId" });

EventStatus.belongsTo(Event, { foreignKey: "eventId" });

Notification.belongsTo(Event, { foreignKey: "eventId" });
Notification.belongsTo(User, { foreignKey: "userId" });

Task.belongsTo(Event, { foreignKey: "eventId" });
//Na
Task.belongsTo(TaskStatus, { foreignKey: "id" });
Task.belongsTo(Task, { as: "ParentTask", foreignKey: "parentTaskId" });
Task.hasMany(Task, { as: "SubTasks", foreignKey: "parentTaskId" });
Task.hasMany(UserTask, { foreignKey: "taskId" });

TaskStatus.belongsTo(Task, { foreignKey: "taskId" });

UserEvent.belongsTo(Event, { foreignKey: "eventId" });
UserEvent.belongsTo(User, { foreignKey: "userId" });
UserEvent.belongsTo(Role, { foreignKey: "roleId" });

UserTask.belongsTo(Task, { foreignKey: "taskId" });
UserTask.belongsTo(User, { foreignKey: "userId" });

Event.belongsTo(EventCategory, { foreignKey: "categoryId" });
Event.hasMany(UserEvent, { foreignKey: "eventId" });
Event.hasMany(ChatRoom, { foreignKey: "eventId" });
Event.hasMany(EventStatus, { foreignKey: "eventId" });
Event.hasMany(Notification, { foreignKey: "eventId" });
Event.hasMany(Task, { foreignKey: "eventId" });
Event.hasMany(EventCost, { foreignKey: "eventId" });

EventCategory.hasMany(Event, {
  foreignKey: "categoryId",
});

User.hasMany(Chat, { foreignKey: "userId" });
User.hasMany(Notification, { foreignKey: "userId" });
User.hasMany(UserEvent, { foreignKey: "userId" });
User.hasMany(UserTask, { foreignKey: "userId" });

Role.hasMany(UserEvent, { foreignKey: "roleId" });

CostCategory.hasMany(EventCost, { foreignKey: "categoryId" });
CostCategory.hasMany(TaskCost, { foreignKey: "categoryId" });

EventCost.belongsTo(Event, { foreignKey: "eventId" });
EventCost.belongsTo(CostCategory, { foreignKey: "categoryId" });

TaskCost.belongsTo(Task, { foreignKey: "taskId" });
TaskCost.belongsTo(CostCategory, { foreignKey: "categoryId" });

const db = {
  sequelize,
  Chat,
  ChatRoom,
  Event,
  EventCategory,
  EventStatus,
  Notification,
  Role,
  Task,
  TaskStatus,
  User,
  UserEvent,
  UserTask,
  CostCategory,
  EventCost,
  TaskCost,
};

export default db;
