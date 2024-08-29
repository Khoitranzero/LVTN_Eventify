//src/service/eventService.js
import db from "../../models";
import { Op, Sequelize } from "sequelize";
const { v4: uuidv4 } = require("uuid");

const checkCategoryExist = async (name) => {
  let category = await db.CostCategory.findOne({
    where: { name: name },
  });
  return category;
};
const checkBudgetCostExist = async (data) => {
  let budgetCost = await db.EventCost.findOne({
    where: { eventId: data.eventId, categoryId: data.categoryId },
  });
  return budgetCost;
};
const checkActualCostExist = async (data) => {
  let actualCost = await db.TaskCost.findOne({
    where: { taskId: data.taskId, categoryId: data.categoryId },
  });
  return actualCost;
};
const checkCategoryHasEventCosts = async (categoryId) => {
  try {
    const eventCostCount = await db.EventCost.count({
      where: {
        categoryId: categoryId,
      },
    });

    if (eventCostCount > 0) {
      return false;
    } else {
      return true;
    }
  } catch (error) {
    console.error("Error checking category event costs:", error);
    throw error;
  }
};

const createCategory = async (data) => {
  try {
    // console.log("data createCategory", data);

    let isCategoryExist = await checkCategoryExist(data.name);
    if (isCategoryExist) {
      return {
        EM: "Danh mục này đã tồn tại",
        EC: 1,
        DT: [],
      };
    }

    let newCategory = await db.CostCategory.create({
      id: uuidv4(),
      name: data.name,
    });

    return {
      EM: "Tạo danh mục thành công",
      EC: 0,
      DT: newCategory,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Tạo danh mục thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const deleteBudgetCategory = async (data) => {
  try {
    if (await checkCategoryHasEventCosts(data.id)) {
      let deleteBudgetCategory = await db.CostCategory.destroy({
        where: { id: data.id },
      });
      return {
        EM: "Xóa danh mục chi phí thành công !!",
        EC: 0,
        DT: deleteBudgetCategory,
      };
    } else {
      return {
        EM: "Không thể xóa danh mục này vì danh mục đang được sử dụng !!",
        EC: 0,
        DT: deleteBudgetCategory,
      };
    }
  } catch (error) {
    console.log(error);
    return {
      EM: "Xóa danh mục chi phí thất bại !!",
      EC: 1,
      DT: [],
    };
  }
};
const getAllEventCost = async (eventId) => {
  try {
    let eventCosts = await db.EventCost.findAll({
      where: {
        eventId: eventId,
      },
      include: [
        {
          model: db.CostCategory,
          attributes: ["name"],
        },
      ],
    });
    // console.log("eventCost", eventCosts);
    if (eventCosts) {
      return {
        EM: "Lấy danh sách danh mục của sự kiện thành công",
        EC: 0,
        DT: eventCosts,
      };
    }
  } catch (e) {
    console.log(e);
    return {
      EM: "Lấy danh sách danh mục của sự kiện thất bại",
      EC: 1,
      DT: [],
    };
  }
};
//get all budget category
// const getAllCategory = async () => {
//   try {
//     let categorys = await db.CostCategory.findAll({});

//     if (categorys) {
//       return {
//         EM: "Lấy danh sách danh mục thành công",
//         EC: 0,
//         DT: categorys,
//       };
//     }
//   } catch (e) {
//     console.log(e);
//     return {
//       EM: "Lấy danh sách danh mục thất bại",
//       EC: 1,
//       DT: [],
//     };
//   }
// };
const getAllCategory = async () => {
  try {
    let categorys = await db.CostCategory.findAll({});

    if (categorys) {
      return {
        EM: "Lấy danh sách danh mục thành công",
        EC: 0,
        DT: categorys,
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

const updateBudgetCategory = async (data) => {
  try {
    let updateBudgetCategory = await db.CostCategory.update(
      {
        name: data.name,
      },
      { where: { id: data.id } }
    );

    return {
      EM: "Cập nhật danh mục chi phí thành công",
      EC: 0,
      DT: updateBudgetCategory,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Cập nhật danh mục chi phí thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const createBudgetCost = async (data) => {
  try {
    // console.log("data createCategory", data);
    let isBudgetCostExist = await checkBudgetCostExist(data);
    if (isBudgetCostExist) {
      return {
        EM: "Đã tồn tại danh mục này trong sự kiện ",
        EC: 1,
        DT: [],
      };
    }
    let newBudgetCost = await db.EventCost.create({
      id: uuidv4(),
      eventId: data.eventId,
      categoryId: data.categoryId,
      budgetAmount: data.budgetAmount,
      actualAmount: 0,
      description: data.description,
    });

    return {
      EM: "Thêm chi phí dự kiến thành công",
      EC: 0,
      DT: newBudgetCost,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Thêm chi phí dự kiến thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const getOneBudgetCost = async (costId) => {
  try {
    let cost = await db.EventCost.findOne({
      where: {
        [Op.or]: [{ id: costId }],
      },
    });

    if (cost) {
      return {
        EM: "Lấy thông tin chi phí sự kiện thành công",
        EC: 0,
        DT: cost,
      };
    }
  } catch (e) {
    console.log(e);
    return {
      EM: "Lấy thông tin chi phí sự kiện thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const updateEventCost = async (data) => {
  try {
    // console.log("data", data);
    let isCategory = await db.EventCost.findOne({
      where: { id: data.costId },
      attributes: ["categoryId"],
    });
    // console.log("isCategory", isCategory.categoryId);
    if (isCategory.categoryId != data.categoryId) {
      let isBudgetCostExist = await checkBudgetCostExist(data);
      if (isBudgetCostExist) {
        return {
          EM: "Đã tồn tại danh mục này trong sự kiện ",
          EC: 1,
          DT: [],
        };
      }
    }

    let updateEventCost = await db.EventCost.update(
      {
        categoryId: data.categoryId,
        budgetAmount: data.budget,
        description: data.description,
      },
      { where: { id: data.costId } }
    );

    return {
      EM: "Cập nhật chi phí sự kiện thành công",
      EC: 0,
      DT: updateEventCost,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Cập nhật chi phí sự kiện thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const deleteEventCost = async (costId) => {
  try {
    let deleteEventCost = await db.EventCost.destroy({
      where: { id: costId },
    });

    return {
      EM: "Xóa chi phí sự kiện thành công !!",
      EC: 0,
      DT: deleteEventCost,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Xóa chi phí sự kiện thất bại !!",
      EC: 1,
      DT: [],
    };
  }
};

const getTotalCost = async (eventId) => {
  // console.log("data getTotalCost", eventId);
  try {
    // Tính tổng actualAmount từ bảng TaskCost theo từng categoryId
    const taskCostTotals = await db.TaskCost.findAll({
      include: [
        {
          model: db.Task,
          where: { eventId: eventId },
        },
      ],
      attributes: [
        "categoryId",
        [
          Sequelize.fn("sum", Sequelize.col("actualAmount")),
          "totalActualAmount",
        ],
      ],
      group: ["categoryId"],
    });

    // Đặt lại tất cả actualAmount về 0 cho eventId trong bảng EventCost
    await db.EventCost.update(
      { actualAmount: 0 },
      { where: { eventId: eventId } }
    );

    // Cập nhật actualAmount trong bảng EventCost dựa trên tổng từ TaskCost
    for (const taskCostTotal of taskCostTotals) {
      await db.EventCost.update(
        {
          actualAmount: taskCostTotal.dataValues.totalActualAmount,
        },
        {
          where: {
            eventId: eventId,
            categoryId: taskCostTotal.dataValues.categoryId,
          },
        }
      );
    }

    // Tính tổng budgetAmount và actualAmount từ bảng EventCost
    const eventCosts = await db.EventCost.findAll({
      where: { eventId: eventId },
      attributes: [
        [
          Sequelize.fn("sum", Sequelize.col("budgetAmount")),
          "totalBudgetAmount",
        ],
        [
          Sequelize.fn("sum", Sequelize.col("actualAmount")),
          "totalEventActualAmount",
        ],
      ],
    });

    const totalBudgetAmount = eventCosts[0]?.dataValues.totalBudgetAmount || 0;
    const totalEventActualAmount = eventCosts[0]?.dataValues.totalEventActualAmount || 0;

    // Cập nhật bảng Event với tổng chi phí dự kiến và thực tế đã tính toán
    await db.Event.update(
      {
        // totalBudget: totalBudgetAmount,
        totalActualCost: totalEventActualAmount,
      },
      {
        where: { id: eventId },
      }
    );

    // Lấy thông tin tổng chi phí đã cập nhật
    let totalCost = await db.Event.findOne({
      where: {
        id: eventId,
      },
      attributes: ["totalBudget", "totalActualCost"],
     
    });

    // console.log("data getTotalCost", totalCost);
    if (totalCost) {
      return {
        EM: "Lấy thông tin chi phí sự kiện thành công",
        EC: 0,
        DT: {totalCost,totalBudgetAmount},
         // totalCost.totalBudget: vốn sự kiện
        // totalCost.totalActualCost: tổng chi phí thực tế
        // totalBudgetAmount: tổng chi phí dự kiến
      };
    }
  } catch (e) {
    console.log(e);
    return {
      EM: "Lấy thông tin chi phí sự kiện thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const updateEventBudgetCost = async (data) => {
  try {
    // console.log("data", data);
    

    let updateEventBudgetCost = await db.Event.update(
      {
        totalBudget: data.budgetCost,
      },
      { where: { id: data.eventId } }
    );

    return {
      EM: "Cập nhật vốn sự kiện thành công",
      EC: 0,
      DT: updateEventBudgetCost,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Cập nhật vốn sự kiện thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const getAllTaskCost = async (taskId) => {
  try {
    let taskCosts = await db.TaskCost.findAll({
      where: {
        taskId: taskId,
      },
      include: [
        {
          model: db.CostCategory,
          attributes: ["name"],
        },
      ],
    });
    // console.log("taskCosts",taskCosts)
    if (taskCosts) {
      return {
        EM: "Lấy danh sách chi phí của công việc thành công",
        EC: 0,
        DT: taskCosts,
      };
    }
  } catch (e) {
    console.log(e);
    return {
      EM: "Lấy danh sách chi phí của công việc thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const createTaskCost = async (data) => {
  try {
   
    let isBudgetCostExist = await checkBudgetCostExist(data);

    if (isBudgetCostExist) {
      // console.log("data createTaskCost", data);

   
      let isActualCostExist = await checkActualCostExist(data);

      if (isActualCostExist) {
        return {
          EM: "Đã tồn tại danh mục này trong công việc",
          EC: 1,
          DT: [],
        };
      }


      let newTaskCost = await db.TaskCost.create({
        id: uuidv4(),
        taskId: data.taskId,
        categoryId: data.categoryId,
        actualAmount: data.actual,
        description: data.description,
      });
      if (newTaskCost) {
        await getTotalCost(data.eventId);
      }
      return {
        EM: "Thêm chi phí công việc thành công",
        EC: 0,
        DT: newTaskCost,
      };
    } else {
  
      let newBudgetCost = await db.EventCost.create({
        id: uuidv4(),
        eventId: data.eventId,
        categoryId: data.categoryId,
        budgetAmount: 0,
        actualAmount: 0,
        description: data.description,
      });

      let newTaskCost = await db.TaskCost.create({
        id: uuidv4(),
        taskId: data.taskId,
        categoryId: data.categoryId,
        actualAmount: data.actual,
        description: data.description,
      });
      if (newTaskCost) {
        await getTotalCost(data.eventId);
      }
      return {
        EM: "Thêm chi phí công việc thành công",
        EC: 0,
        DT: newTaskCost,
      };
    }
  } catch (error) {
    console.log(error);
    return {
      EM: "Thêm chi phí công việc thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const getOneTaskCost = async (costId) => {
  // console.log("data getOneTaskCost", costId);
  try {
    let taskCost = await db.TaskCost.findOne({
      where: {
        [Op.or]: [{ id: costId }],
      },
    });
    // console.log("data getOneTaskCost", taskCost);
    if (taskCost) {
      return {
        EM: "Lấy thông tin chi phí công việc thành công",
        EC: 0,
        DT: taskCost,
      };
    }
  } catch (e) {
    console.log(e);
    return {
      EM: "Lấy thông tin chi phí công việc thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const updateTaskCost = async (data) => {
  try {
    // console.log("data", data);
    let isCategory = await db.TaskCost.findOne({
      where: { id: data.costId },
      attributes: ["categoryId"],
    });
    // console.log("isCategory", isCategory.categoryId);
    if (isCategory.categoryId != data.categoryId) {
      let isActualCostExist = await checkActualCostExist(data);
      if (isActualCostExist) {
        return {
          EM: "Đã tồn tại danh mục này trong công việc ",
          EC: 1,
          DT: [],
        };
      }
    }

    let updateTaskCost = await db.TaskCost.update(
      {
        categoryId: data.categoryId,
        actualAmount: data.actual,
        description: data.description,
      },
      { where: { id: data.costId } }
    );
    if (updateTaskCost) {
      await getTotalCost(data.eventId);
    }
    return {
      EM: "Cập nhật chi phí công việc thành công",
      EC: 0,
      DT: updateTaskCost,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Cập nhật chi phí công việc thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const deleteTaskCost = async (costId, eventId) => {
  try {
    let deleteTaskCost = await db.TaskCost.destroy({
      where: { id: costId },
    });

    if (deleteTaskCost) {
    
      await getTotalCost(eventId);
    }

    return {
      EM: "Xóa chi phí công việc thành công !!",
      EC: 0,
      DT: deleteTaskCost,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Xóa chi phí công việc thất bại !!",
      EC: 1,
      DT: [],
    };
  }
};

module.exports = {
  createCategory,
  getAllEventCost,
  getAllCategory,
  createBudgetCost,
  getOneBudgetCost,
  updateEventCost,
  deleteEventCost,
  getTotalCost,
  updateEventBudgetCost,
  getAllTaskCost,
  createTaskCost,
  getOneTaskCost,
  updateTaskCost,
  deleteTaskCost,
  deleteBudgetCategory,
  updateBudgetCategory,
};
