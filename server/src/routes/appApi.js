//src/routes/appApi.js
import express from "express";
import accountController from "../controller/appController/accountController";
import userController from "../controller/appController/userController";
import eventController from "../controller/appController/eventController";
import taskController from "../controller/appController/taskController";
import chatController from "../controller/appController/chatController";
import notificationController from "../controller/appController/notificationController";
import costController from "../controller/appController/costController";
import { appAuthenticate } from "../middleware/appAuthenticate";

const router = express.Router();

const initAppApiRoutes = (app) => {
  // Rest API
  //App Flutter API
  //account
  router.post("/register", accountController.handleRegister);
  router.post("/login", accountController.handleLogin);
  router.post(
    "/sendVerificationCode",
    accountController.handleSendVerificationCode
  );
  router.post(
    "/verifyCodeAndChangePassword",
    accountController.handleVerifyCodeAndChangePassword
  );
  // router.use(appAuthenticate);
  router.post("/changePassword", accountController.handleChangePassword);
  router.post("/logout", accountController.handleLogout);
  router.delete("/deleteUser", accountController.handleDeleteUser);

  //user
  router.get("/user/getAllUser", userController.getAllUserFunc);
  router.get("/user/getOneUser", userController.getOneUserFunc);
  router.post("/user/changeAvatar", userController.changeAvatarFunc);
  router.put("/user/updateUser", userController.updateUserFunc);

  //event
  router.get(
    "/event/getUserRoleInEvent",
    eventController.getUserRoleInEventFunc
  );
  // event_detail
  router.get("/event/getAllEvent", eventController.getAllEventFunc);
  router.get("/event/getAllEventStatus", eventController.getAllEventStatusFunc);
  router.get(
    "/event/getAllEventCategory",
    eventController.getAllEventCategoryFunc
  );
  router.get("/event/getUserEvents", eventController.getUserEventsFunc);
  router.get("/event/getOneEvent", eventController.getOneEventFunc);
  router.post("/event/createEvent", eventController.createEventFunc);
  router.put("/event/updateEvent", eventController.updateEventFunc);
  router.delete("/event/deleteEvent", eventController.deleteEventFunc);
  //event_member
  router.get("/event/getMemberInEvents", eventController.getMemberInEventsFunc);
  router.get("/event/getMemberAssign", eventController.getMemberAssignFunc);
  router.post("/event/addUserToEvent", eventController.addUserToEventFunc);
  router.put("/event/updateUserRole", eventController.updateUserRoleFunc);
  router.delete(
    "/event/deleteUserInEvent",
    eventController.deleteUserInEventFunc
  );

  //budget category
  router.get("/cost/getAllCategory", costController.getAllCategoryFunc);
  router.post("/cost/createCategory", costController.createCategoryFunc);
  router.delete("/cost/category", costController.deleteCategoryFunc);
  router.put("/cost/category", costController.updateCostCategoryFunc);
  //cost

  router.get("/cost/getAllEventCost", costController.getAllEventCostFunc);
  router.post("/cost/createBudgetCost", costController.createBudgetCostFunc);
  router.get("/cost/getOneBudgetCost", costController.getOneBudgetCostFunc);
  router.put("/cost/updateEventCost", costController.updateEventCostFunc);
  router.delete("/cost/deleteEventCost", costController.deleteEventCostFunc);

  router.get("/cost/getTotalCost", costController.getTotalCostFunc);
  
  router.put("/cost/updateEventBudgetCost", costController.updateEventBudgetCostFunc);

  router.get("/cost/getAllTaskCost", costController.getAllTaskCostFunc);
  router.get("/cost/getOneTaskCost", costController.getOneTaskCostFunc);
  router.post("/cost/createTaskCost", costController.createTaskCostFunc);
  router.put("/cost/updateTaskCost", costController.updateTaskCostFunc);
  router.delete("/cost/deleteTaskCost", costController.deleteTaskCostFunc);

  //task
  router.get("/task/getAllTaskInEvents", taskController.getAllTaskInEventsFunc);
  router.get("/task/getAllTaskStatus", taskController.getAllTaskStatusFunc);
  router.get("/task/getOneTask", taskController.getOneTaskFunc);
  router.post("/task/createTask", taskController.createTaskFunc);
  router.put("/task/updateTask", taskController.updateTaskFunc);
  router.delete("/task/deleteTask", taskController.deleteTaskFunc);
  //subtask
  router.get("/task/getSubTaskInEvents", taskController.getSubTaskInEventsFunc);
  router.get("/task/getOneSubTask", taskController.getOneSubTaskFunc);

  //task_member
  router.get("/task/getMemberInTask", taskController.getMemberInTaskFunc);
  router.post("/task/addMemberToTask", taskController.addMemberToTaskFunc);
  router.delete(
    "/task/deleteMemberInTask",
    taskController.deleteMemberInTaskFunc
  );

  //sub_task_member
  router.get("/task/getMemberInSubTask", taskController.getMemberInSubTaskFunc);
  router.get(
    "/task/getMemberAssignSubTask",
    taskController.getMemberAssignSubTaskFunc
  );
  router.post(
    "/task/addMemberToSubTask",
    taskController.addMemberToSubTaskFunc
  );

  //chat
  router.get("/chat/getUserRoomChat", chatController.getUserRoomChatFunc);
  router.get(
    "/chat/getAllMessagesInChatRoom",
    chatController.getAllMessagesInChatRoomFunc
  );
  router.post("/chat/sendMessage", chatController.sendMessageFunc);
  router.post("/chat/sendImage", chatController.sendImageFunc);

  //notification
  router.get(
    "/notification/getAllUserNotification",
    notificationController.getAllUserNotificationFunc
  );
  router.post(
    "/notification/createNotify",
    notificationController.createNotifyFunc
  );
  router.put(
    "/notification/readAllNotify",
    notificationController.readAllNotifyFunc
  );
  router.put(
    "/notification/readOneNotify",
    notificationController.readOneNotifyFunc
  );
  router.put(
    "/notification/deleteNotify",
    notificationController.deleteNotifyFunc
  );

  return app.use("/api/v1/", router);
};

export default initAppApiRoutes;
