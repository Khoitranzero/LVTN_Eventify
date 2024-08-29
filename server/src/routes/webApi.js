//src/routes/api.js
import express from "express";
import adminAccountController from "../controller/webAdminController/adminAccountController";
import adminUserController from "../controller/webAdminController/adminUserController";
import adminEventController from "../controller/webAdminController/adminEventController";
import adminCategoryController from "../controller/webAdminController/adminCategoryController";
import adminTaskController from "../controller/webAdminController/adminTaskController";
import adminCostController from "../controller/webAdminController/adminCostController";
import { webAuthenticate } from "../middleware/webAuthenticate";

const router = express.Router();

const initWebApiRoutes = (app) => {
  // Rest API
  //Web_Admin API
  //account
  router.post("/admin/register", adminAccountController.handleRegister);
  router.post("/admin/login", adminAccountController.handleLogin);
  router.post("/admin/logout", adminAccountController.handleLogout);
  router.delete("/admin/deleteUser", adminAccountController.handleDeleteUser);
  router.post(
    "/admin/sendVerificationCode",
    adminAccountController.handleSendVerificationCode
  );
  router.post(
    "/admin/verifyCodeAndChangePassword",
    adminAccountController.handleVerifyCodeAndChangePassword
  );

  // router.use(webAuthenticate);
  router.post(
    "/admin/changePassword",
    adminAccountController.handleChangePassword
  );

  //user
  router.get("/admin/user/getAllUser", adminUserController.getAllUserFunc);
  router.get("/admin/account", adminUserController.getUserAccountFunc);
  router.put("/admin/user/updateUser", adminUserController.updateUserFunc);
  router.put("/admin/user/blockUser", adminUserController.clockUserFunc);
  router.put("/admin/user/unBlockUser", adminUserController.unBlockUserFunc);
  router.put(
    "/admin/user/updatePermission",
    adminUserController.updateUserPermissionFunc
  );
  //event
  router.get("/admin/filterEvent", adminEventController.filterEventInTimeFunc);
  router.get("/admin/event/detail", adminEventController.getOneEventFunc);
  router.get(
    "/admin/event/filterInFuture",
    adminEventController.filterEventInFutureTimeFunc
  );
  router.get(
    "/admin/event/finishedEvent",
    adminEventController.allEventFinishFunc
  );
  router.put("/admin/event/update", adminEventController.updateEventFunc);
  //task
  router.get(
    "/admin/task/getAllTaskInEvents",
    adminTaskController.getAllTaskInEventsFunc
  );
  //event category
  router.get(
    "/admin/eventCategory",
    adminCategoryController.getAllEventCategoryFunc
  );
  router.post(
    "/admin/eventCategory",
    adminCategoryController.createEventCategoryFunc
  );
  router.delete(
    "/admin/eventCategory",
    adminCategoryController.deleteEventCategoryFunc
  );
  router.put(
    "/admin/eventCategory",
    adminCategoryController.updateEventCategoryFunc
  );
  //cost category
  router.get(
    "/admin/cost/getAllCategory",
    adminCostController.getAllCategoryFunc
  );
  // event_detail
  router.get("/admin/event/getAllEvent", adminEventController.getAllEventFunc);
  router.delete(
    "/admin/event/deleteEvent",
    adminEventController.deleteEventFunc
  );
  //user
  router.get(
    "/admin/user/filterUser",
    adminUserController.filterUserInTimeFunc
  );
  router.get(
    "/admin/user/getUserInfo",
    adminUserController.getUserWithAdditionInfoFunc
  );
  router.get("/admin/user/getUserTask", adminUserController.getTaskByUserFunc);
  //task
  router.put("/admin/task/update", adminTaskController.updateTaskFunc);
  return app.use("/api/v2/", router);
};

export default initWebApiRoutes;
