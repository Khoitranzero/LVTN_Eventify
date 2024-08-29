import moment from "moment";
import db from "../../models";
import bcrypt from "bcryptjs";
import { Op, where } from "sequelize";
const salt = bcrypt.genSaltSync(10);
const getAllCategory = async () => {
  try {
    let categories = await db.CostCategory.findAll({
      include: [
        {
          model: db.TaskCost,
          attributes: ["actualAmount"],
        },
      ],
    });

    if (categories) {
      categories = categories.map((category) => {
        const taskCount = category.TaskCosts.length;
        const totalActualAmount = category.TaskCosts.reduce(
          (total, taskCost) => total + taskCost.actualAmount,
          0
        );
        return {
          ...category.toJSON(),
          totalActualAmount,
          taskCount,
        };
      });
      return {
        EM: "Lấy danh sách danh mục thành công",
        EC: 0,
        DT: categories,
      };
    }
  } catch (e) {
    console.log(e);
    return {
      EM: "Lấy danh sách danh mục thất bại",
      EC: 1,
      DT: [],
    };
  }
};

module.exports = {
  getAllCategory,
};
