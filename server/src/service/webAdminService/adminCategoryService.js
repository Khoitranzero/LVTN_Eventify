import { Sequelize } from "sequelize";
import db from "../../models/index";
const { v4: uuidv4 } = require("uuid");
const checkCategoryExist = async (name) => {
  let category = await db.EventCategory.findOne({
    where: { name: name },
  });
  return category;
};
const checkIfCategoryHasEvent = async (categoryId) => {
  let categoryHasEvent = await db.Event.findOne({
    where: { categoryId: categoryId },
  });
  return categoryHasEvent;
};
const createEventCategory = async (data) => {
  try {
    let isCategoryExist = await checkCategoryExist(data.name);
    if (isCategoryExist) {
      return {
        EM: "Danh mục của sự kiện này đã tồn tại",
        EC: 1,
        DT: [],
      };
    }

    let newCategory = await db.EventCategory.create({
      id: uuidv4(),
      name: data.name,
    });

    return {
      EM: "Tạo danh mục sự kiện thành công",
      EC: 0,
      DT: newCategory,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Tạo danh mục sự kiện thất bại",
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
      include: [
        {
          model: db.Event,
          attributes: ["id", "name", "description", "startAt", "endAt"],
          where: {
            categoryId: Sequelize.col("EventCategory.id"),
          },
          required: false, // Đảm bảo rằng các danh mục không có sự kiện vẫn được lấy
        },
      ],
      group: ["EventCategory.id", "Events.id"], // Nhóm theo id của EventCategory và Event
    });

    return {
      EM: "Lấy thông tin toàn bộ danh mục sự kiện thành công",
      EC: 0,
      DT: eventCategories,
    };
  } catch (e) {
    console.log(e);
    return {
      EM: "Lấy thông tin toàn bộ danh mục sự kiện thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const deleteEventCategory = async (data) => {
  try {
    let isCategoryExist = await checkIfCategoryHasEvent(data.categoryId);
    if (isCategoryExist) {
      return {
        EM: "Danh mục này đã có sự kiện, không thể xóa !!!",
        EC: 1,
        DT: [],
      };
    }

    let deletedCategory = await db.EventCategory.destroy({
      where: { id: data.categoryId },
    });

    return {
      EM: "Xóa danh mục sự kiện thành công",
      EC: 0,
      DT: deletedCategory,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Xóa danh mục sự kiện thất bại",
      EC: 1,
      DT: "",
    };
  }
};
const updateEventCategory = async (data) => {
  try {
    let updatedEvent = await db.EventCategory.update(
      {
        name: data.name,
      },
      { where: { id: data.categoryId } }
    );
    return {
      EM: "Cập nhật danh mục sự kiện thành công",
      EC: 0,
      DT: updatedEvent,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Cập nhật danh mục sự kiện thất bại",
      EC: 1,
      DT: [],
    };
  }
};
module.exports = {
  getAllEventCategory,
  createEventCategory,
  deleteEventCategory,
  updateEventCategory,
};
