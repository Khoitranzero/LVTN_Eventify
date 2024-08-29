//src/service/webAdminService/adminUserService
import moment from "moment";
import db from "../../models";
import bcrypt from "bcryptjs";
import { Op, where } from "sequelize";
const salt = bcrypt.genSaltSync(10);

const checkEmailExist = async (userEmail) => {
  let user = await db.User.findOne({
    where: { email: userEmail },
  });
  return user;
};
const getAllUser = async () => {
  try {
    const users = await db.User.findAll({
      attributes: [
        "id",
        "name",
        "role",
        "email",
        "phone",
        "avatarUrl",
        "activated",
      ],
    });

    console.log("check", users);
    if (users) {
      return {
        EM: "get data success",
        EC: 0,
        DT: users,
      };
    } else {
      return {
        EM: "get data success",
        EC: 0,
        DT: [],
      };
    }
  } catch (e) {
    console.log(e);
    return {
      EM: "error from server",
      EC: 1,
      DT: [],
    };
  }
};

const getUserWithPagination = async (page, limit) => {
  try {
    let offset = (page - 1) * limit;
    const { count, rows } = await db.User.findAndCountAll({
      offset: offset,
      limit: limit,
      attributes: [
        "id",
        "name",
        "role",
        "email",
        "phone",
        "avatarUrl",
        "activated",
      ],
    });

    let totalPages = Math.ceil(count / limit);
    let data = {
      totalRows: count,
      totalPages: totalPages,
      users: rows,
    };

    return {
      EM: "fetch ok",
      EC: 0,
      DT: data,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "error from server",
      EC: 1,
      DT: [],
    };
  }
};

// const createNewUser=async(data)=>{
//     try {
// let isUserIdExist = await checkUserIdExist(data.userId);
// if(isUserIdExist===true) {
//     return{
//         EM : 'MSSV already exist',
//         EC : 1,
//         DT :'userId'
//     }
// }
// let isPhoneExist = await checkPhoneExist(data.phone);
// if(isPhoneExist===true) {
//     return{
//         EM : 'The phone number already exist',
//         EC : 1,
//         DT :'phone'
//     }

// }
// //hash user password
// let hashPassword = hashUserPassword(data.password);
//     //create new user
//         await db.User.create({...data, password: hashPassword});
//         return {
//             EM : 'create ok',
//             EC: 0,
//             DT:[]

//         }
//     } catch (error) {
//         console.log(error)
//         return {
//             EM : 'something wrong with service',
//             EC: 1,
//             DT:[]

//         }
//     }
// }

const changeAvatar = async (data) => {
  try {
    let user = await db.User.findOne({
      where: { id: data.userId },
    });

    if (!user) {
      return {
        EM: "Không tồn tại người dùng này",
        EC: 1,
        DT: [],
      };
    } else {
      await db.User.update(
        {
          avatarUrl: data.avatarUrl,
        },
        { where: { id: data.userId } }
      );

      return {
        EM: "Đổi ảnh đại diện thành công",
        EC: 0,
        DT: user,
      };
    }
  } catch (e) {
    console.log(e);
    return {
      EM: "Đổi ảnh đại diện thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const updateUser = async (data) => {
  try {
    console.log("data", data);
    let updatedUser;
    if (data.avatarUrl == null) {
      updatedUser = await db.User.update(
        {
          name: data.name,
          phone: data.phoneNumber,
          role: data.role,
          // == 'null'?null:data.role
        },
        { where: { email: data.email } }
      );
    } else {
      updatedUser = await db.User.update(
        {
          name: data.name,
          phone: data.phoneNumber,
          role: data.role,
          // ?data.role:null,
          avatarUrl: data.avatarUrl,
        },
        { where: { email: data.email } }
      );
    }

    return {
      EM: "Cập nhật thông tin người dùng thành công",
      EC: 0,
      DT: updatedUser,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Cập nhật thông tin người dùng thất bại",
      EC: 1,
      DT: [],
    };
  }
};
const updateUserPermission = async (userId) => {
  try {
    const checkUserPermission = await db.User.findOne({
      where: { id: userId },
    });
    if (!checkUserPermission) {
      return {
        EM: "Người dùng không tồn tại",
        EC: 1,
        DT: [],
      };
    }
    let newRole = checkUserPermission.role === "Admin" ? "" : "Admin";
    let updatedUser = await db.User.update(
      {
        role: newRole,
      },
      { where: { id: userId } }
    );

    return {
      EM: "Cập nhật quyền truy cập người dùng thành công",
      EC: 0,
      DT: updatedUser,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Cập nhật quyền truy cập người dùng thất bại",
      EC: 1,
      DT: [],
    };
  }
};
// const deleteUser=async(userId)=>{
//     try {
//         let user = await db.User.findOne({
//             where : {userId : userId }
//         })
//         if(user){
//             await user.destroy();
//             return {
//                 EM : 'delete student success',
//                 EC: 0,
//                 DT: []

//             }
//         }
//         else{
//             return {
//                 EM : ' student not exist',
//                 EC: 2,
//                 DT: []

//             }
//         }
//     } catch (error) {
//         console.log(e)
//         return {
//             EM : 'get data success',
//             EC: 1,
//             DT:[]

//         }
//     }
// }
const getUserAccount = async (user, token) => {
  try {
    let userAccount = await db.User.findOne({
      attributes: [
        "id",
        "name",
        "role",
        "email",
        "phone",
        "avatarUrl",
        "activated",
      ],
      where: { email: user.email },
    });

    if (userAccount) {
      let account = {
        token: token,
        phone: userAccount.phone,
        email: userAccount.email,
        id: userAccount.id,
        fullName: userAccount.name,
      };
      return {
        EM: "Lấy thông tin người dùng thành công",
        EC: 0,
        DT: account,
      };
    }
  } catch (e) {
    console.log(e);
    return {
      EM: "Lấy thông tin người dùng thất bại",
      EC: 1,
      DT: [],
    };
  }
};

const clockUser = async (email) => {
  try {
    console.log("email là", email);

    let checkEmail = await checkEmailExist(email);
    if (!checkEmail) {
      return {
        EM: "Email này không tồn tại",
        EC: 1,
      };
    }

    let clockUser = await db.User.update(
      {
        activated: false,
      },
      { where: { email: email } }
    );
    return {
      EM: "Khóa tài khoản người dùng thành công",
      EC: 0,
      DT: clockUser,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Khóa tài khoản người dùng thất bại",
      EC: 1,
      DT: [],
    };
  }
};
const unBlockUser = async (email) => {
  try {
    console.log("email là", email);

    let checkEmail = await checkEmailExist(email);
    if (!checkEmail) {
      return {
        EM: "Email này không tồn tại",
        EC: 1,
      };
    }

    let unBlockUser = await db.User.update(
      {
        activated: true,
      },
      { where: { email: email } }
    );
    return {
      EM: "Mở khóa tài khoản người dùng thành công",
      EC: 0,
      DT: unBlockUser,
    };
  } catch (error) {
    console.log(error);
    return {
      EM: "Mở khóa tài khoản người dùng thất bại",
      EC: 1,
      DT: [],
    };
  }
};
//filter user
const filterUserByTime = async (data) => {
  try {
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

    const filteredUser = await db.User.findAll({
      where: {
        createdAt: {
          [Op.gte]: startDate,
          [Op.lte]: endDate,
        },
      },
    });

    return {
      EM: `Số lượng thông tin người dùng được tạo ra trong ${data.time}`,
      EC: 0,
      DT: filteredUser,
    };
  } catch (error) {
    console.error(error);
    return {
      EM: "Lấy thông tin người dùng theo thời gian thất bại",
      EC: 1,
      DT: [],
    };
  }
};
//getUserInfo with addition info
const getUserWithAdditionInfo = async (userId) => {
  try {
    let userAccount = await db.User.findOne({
      attributes: [
        "id",
        "name",
        "role",
        "email",
        "phone",
        "avatarUrl",
        "activated",
      ],
      where: { id: userId },
      include: [
        {
          model: db.UserEvent,
          attributes: ["eventId", "roleId", "createdAt"],
          include: [
            {
              model: db.Event,
              attributes: ["name", "description"],
            },
          ],
        },
        {
          model: db.UserTask,
          include: [
            {
              model: db.Task,
              attributes: ["name", "status"],
            },
          ],
        },
      ],
    });
    return {
      EM: "Lấy thông tin người dùng thành công",
      EC: 0,
      DT: userAccount,
    };
  } catch (e) {
    console.log(e);
    return {
      EM: "Lấy thông tin người dùng thất bại",
      EC: 1,
      DT: [],
    };
  }
};
const getTaskByUser = async (userId) => {
  try {
    let userAccount = await db.User.findOne({
      where: { id: userId },
      include: [
        {
          model: db.UserTask,
          include: [
            {
              model: db.Task,
              attributes: ["name", "status"],
            },
          ],
        },
      ],
    });
    return {
      EM: "Lấy thông tin người dùng thành công",
      EC: 0,
      DT: userAccount,
    };
  } catch (e) {
    console.log(e);
    return {
      EM: "Lấy thông tin người dùng thất bại",
      EC: 1,
      DT: [],
    };
  }
};
module.exports = {
  getAllUser,
  getUserWithPagination,
  getUserAccount,
  updateUser,
  updateUserPermission,
  changeAvatar,
  clockUser,
  unBlockUser,
  filterUserByTime,
  getUserWithAdditionInfo,
  getTaskByUser,
};
