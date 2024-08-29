import adminCostService from "../../service/webAdminService/adminCostService";
const getAllCategoryFunc = async (req, res) => {
  try {
    const data = await adminCostService.getAllCategory();
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
module.exports = {
  getAllCategoryFunc,
};