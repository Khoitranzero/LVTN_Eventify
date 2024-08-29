import eventCategory from "../../service/webAdminService/adminCategoryService";
const getAllEventCategoryFunc = async (req, res) => {
  try {
    let data = await eventCategory.getAllEventCategory();

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
const createEventCategoryFunc = async (req, res) => {
  try {
    let data = await eventCategory.createEventCategory(req.body);
    console.log("create event category: ", data);
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
const deleteEventCategoryFunc = async (req, res) => {
  try {
    let data = await eventCategory.deleteEventCategory(req.body);
    console.log("delete event category: ", data);
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
const updateEventCategoryFunc = async (req, res) => {
  try {
    console.log("update event category: ", req.body);
    let data = await eventCategory.updateEventCategory(req.body);
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
  getAllEventCategoryFunc,
  createEventCategoryFunc,
  deleteEventCategoryFunc,
  updateEventCategoryFunc,
};
