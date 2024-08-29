// src/service/eventService.js
import db from "../../models";
import { Op } from "sequelize";
import { v4 as uuidv4 } from 'uuid'; 

const getAllUserNotification = async (userId) => {
    try {
      let notifys = await db.Notification.findAll({
        where: { userId: userId,deleted :false },
      });
      if (!notifys) {
        return {
          EM: 'Thông báo không tồn tại',
          EC: 1,
          DT: []
        };
      }
      return {
        EM: "Lấy danh sách Thông báo của người dùng thành công",
        EC: 0,
        DT: notifys
      };
    } catch (error) {
      console.log(error);
      return {
        EM: "Lấy danh sách Thông báo của người dùng thất bại",
        EC: 1,
        DT: []
      };
    }
  };


  const createNotification = async (type, data, eventId) => {
    try {
        const event = await db.Event.findOne({
            where: { id: eventId }
        });

        if (!event) {
            return {
                EM: 'Sự kiện không tồn tại',
                EC: 1,
                DT: []
            };
        }

        const users = await db.UserEvent.findAll({
            where: { eventId: eventId },
            include: [{
                model: db.User,
                as: 'User'
            }]
        });
// console.log("user đây",users)
        if (!users || users.length === 0) {
            return {
                EM: 'Không có người dùng nào trong sự kiện này',
                EC: 1,
                DT: []
            };
        }

        let notifications = [];

        for (const userEvent of users) {
            const newNotification = await db.Notification.create({
                id: uuidv4(),
                type: type,
                isRead: false,
                data: data,
                createAt: new Date().toISOString(),
                deleted: false,
                eventId: eventId,
                userId: userEvent.userId
            });
            notifications.push(newNotification);

        
        }

        return {
            EM: 'Tạo thông báo thành công',
            EC: 0,
            DT: notifications
        };
    } catch (error) {
        console.log(error);
        return {
            EM: 'Tạo thông báo thất bại',
            EC: 1,
            DT: []
        };
    }
};


const readOneNotification = async (data) => {

    try {
        // console.log("data read one notify",data)
        let readNotification = await db.Notification.update(
            {
                isRead: true,
            },
            { where: { id: data.notifyId ,userId: data.userId} }
        );

        return {
            EM: 'Đọc thông báo thành công',
            EC: 0,
            DT: readNotification
        };
    } catch (error) {
        console.log(error);
        return {
            EM: 'Lỗi đọc thông báo',
            EC: 1,
            DT: []
        };
    }
};
const deleteNotification = async (notifiId) => {
    try {
    
        // await Promise.all([
        // ]);

     
        let deletedNotification = await db.Notification.destroy({
            where: { id: notifiId }
        });

        return {
            EM: 'Xóa thông báo thành công!',
            EC: 0,
            DT: deletedNotification
        };
    } catch (error) {
        console.log(error);
        return {
            EM: 'Lỗi khi xóa thông báo',
            EC: 1,
            DT: []
        };
    }
};

const readAllNotification = async (userId) => {
    try {

        let readAllNotification = await db.Notification.update(
            {
                isRead: true,
            },
            { where: { userId: userId } }
        );

        return {
            EM: 'Đọc thông báo thành công',
            EC: 0,
            DT: readAllNotification
        };
    } catch (error) {
        console.log(error);
        return {
            EM: 'Đọc thông báo thất bại',
            EC: 1,
            DT: []
        };
    }
};
const deleteNotify = async (data) => {
    try {
     
        let deleteNotify = await db.Notification.update(
            {
                deleted: true,
            },
            { where: { userId: data.userId ,id : data.notifyId} }
        );

        return {
            EM: 'Xóa thông báo thành công!',
            EC: 0,
            DT: deleteNotify
        };
    } catch (error) {
        console.log(error);
        return {
            EM: 'Lỗi khi xóa thông báo',
            EC: 1,
            DT: []
        };
    }
};
module.exports = { 
    getAllUserNotification,
    createNotification,
    readOneNotification,
    deleteNotification,
    readAllNotification,
    deleteNotify
};
