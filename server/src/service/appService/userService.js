//src/service/userService.js
import db from "../../models";
import { Op } from "sequelize"; 


const getAllUser = async (eventId) => {
  try {

    const userEvents = await db.UserEvent.findAll({
      where: { eventId: eventId },
      attributes: ['userId']
    });


    const userIds = userEvents.map(userEvent => userEvent.userId);

    
    const users = await db.User.findAll({
      where: { id: { [Op.notIn]: userIds },
                activated: true
    }, 
      attributes: ['id', 'name', 'role', 'email', 'phone', 'avatarUrl']
    });

    if (users) {
      return {
        EM: "Lấy danh sách người dùng không thuộc sự kiện thành công",
        EC: 0,
        DT: users,
      };
    } 
  } catch (e) {
    console.log(e);
    return {
      EM: "Lấy danh sách người dùng không thuộc sự kiện thất bại",
      EC: 1,
      DT: [],
    };
  }
};




  const getOneUser = async (userId) => {
    try {
      let user = await db.User.findOne({
        attributes: ['id', 'name', 'role', 'email', 'phone', 'avatarUrl', 'activated'],
        where: { id: userId },
      });
  
      if (user) {
        return {
          EM: "Lấy thông tin người dùng thành công",
          EC: 0,
          DT: user,
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

  const changeAvatar = async (userId, avatarUrl) => {
    try {
        let user = await db.User.findOne({
            where: { id: userId },
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
                    avatarUrl: avatarUrl,
                },
                { where: { id: userId } }
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
      // console.log("data", data);
       
      let updatedUser = await db.User.update(
          {
              name: data.name,
              phone: data.phoneNumber
             
          },
          { where: { id: data.userId } }
      );


      return {
          EM: 'Cập nhật thông tin người dùng thành công',
          EC: 0,
          DT: updatedUser
      };
  } catch (error) {
      console.log(error);
      return {
          EM: 'Cập nhật thông tin người dùng thất bại',
          EC: 1,
          DT: []
      };
  }
};
module.exports={ 
  getAllUser,
  getOneUser,
  changeAvatar,
  updateUser
};
