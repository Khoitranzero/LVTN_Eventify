//src/controller/webAdminController/adminUserController
import adminUserService from "../../service/webAdminService/adminUserService";
import admin from "firebase-admin";
import upload from "../../Cloudinary/upload";

const getAllUserFunc = async (req, res) => {
  try {
    if (req.query.page && req.query.limit) {
      let page = req.query.page;
      let limit = req.query.limit;

      let data = await adminUserService.getUserWithPagination(+page, +limit);
      return res.status(200).json({
        EM: data.EM,
        EC: data.EC,
        DT: data.DT,
      });
    } else {
      let data = await adminUserService.getAllUser();
      return res.status(200).json({
        EM: data.EM,
        EC: data.EC,
        DT: data.DT,
      });
    }
  } catch (error) {
    return res.status(500).json({
      EM: "error from server",
      EC: "-1",
      DT: "",
    });
  }
};

const getUserAccountFunc = async (req, res) => {
  try {
    const user = req.user;
    let data = await adminUserService.getUserAccount(user, req.token);
    console.log("userAccountDetails", data);
    return res.status(200).json({
      EM: data.EM,
      EC: 0,
      DT: data.DT,
    });
  } catch (error) {
    console.error("Error in getUserAccount: ", error);
    return res.status(500).json({
      EM: "Internal Server Error",
      EC: 1,
      DT: {},
    });
  }
};
const updateUserFunc = async (req, res) => {
  try {
    upload.single("avatar")(req, res, async (err) => {
      if (err) {
        return res.status(500).json({
          EM: "Lỗi tải tập tin lên",
          EC: "-1",
          DT: "",
        });
      }

      const { email, phone, name, role } = req.body;
      const avatarUrl = req.file ? req.file.path : null;

      console.log("updateUserFunc", req.body, "avatarUrl", avatarUrl);
      let data = await adminUserService.updateUser({
        email,
        phone,
        name,
        role,
        avatarUrl,
      });
      console.log("data updateUserFunc return", data);
      return res.status(200).json({
        EM: data.EM,
        EC: data.EC,
        DT: data.DT,
      });
    });
  } catch (error) {
    console.error("Error during user update:", error);
    return res.status(500).json({
      EM: "Lỗi từ máy chủ",
      EC: "-1",
      DT: "",
    });
  }
};

const clockUserFunc = async (req, res) => {
  try {
    const { email } = req.body;
    let data = await adminUserService.clockUser(email);
    console.log("data clockUserFunc return", data);
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
const unBlockUserFunc = async (req, res) => {
  try {
    const { email } = req.body;
    let data = await adminUserService.unBlockUser(email);
    console.log("data unblockUserFunc return", data);
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
const filterUserInTimeFunc = async (req, res) => {
  try {
    const time = req.query.time;
    const timeType = req.query.timeType;
    // console.log("eventId,", eventId,"userId,",userId);
    const input = {
      time,
      timeType,
    };
    console.log("Thời gian controller: ", input);
    let data = await adminUserService.filterUserByTime(input);
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
const getUserWithAdditionInfoFunc = async (req, res) => {
  try {
    const userId = req.query.userId;
    let data = await adminUserService.getUserWithAdditionInfo(userId);
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
const getTaskByUserFunc = async (req, res) => {
  try {
    const userId = req.query.userId;
    let data = await adminUserService.getTaskByUser(userId);
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
const updateUserPermissionFunc = async (req, res) => {
  try {
    const userId = req.query.userId;
    let data = await adminUserService.updateUserPermission(userId);
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
  getAllUserFunc,
  getUserAccountFunc,
  updateUserFunc,
  clockUserFunc,
  unBlockUserFunc,
  filterUserInTimeFunc,
  getUserWithAdditionInfoFunc,
  getTaskByUserFunc,
  updateUserPermissionFunc
};
