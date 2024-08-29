// src/service/chatService.js
import db from "../../models";
import { v4 as uuidv4 } from 'uuid'; 
import { broadcast } from '../../server'
import cloudinary from 'cloudinary';

const getUserRoomChat = async (userId) => {
    try {
        const user = await db.User.findOne({
            where: { id: userId }
        });

        if (!user) {
            return {
                EM: 'Người dùng không tồn tại',
                EC: 1,
                DT: []
            };
        }

        const userRooms = await db.UserEvent.findAll({
            where: { userId: userId },
            include: [
                {
                    model: db.Event,
                    attributes: ['id', 'name'],
                    include: [
                        {
                            model: db.ChatRoom,
                            attributes: ['id', 'eventId']
                        },
                        {
                            model: db.UserEvent,
                            attributes: ['userId'], 
                            duplicating: false
                        }
                    ]
                }
            ]
        });

        const formattedUserRooms = userRooms.map(userEvent => {
            const event = userEvent.Event;
            const chatRooms = event && event.ChatRooms ? event.ChatRooms : [];
            const userCount = event && Array.isArray(event.UserEvents) ? event.UserEvents.length : 0;
            return chatRooms.map(chatRoom => ({
                eventId: event.id,
                eventName: event.name,
                userCount: userCount,
                chatRoomId: chatRoom.id
            }));
        }).flat();

        return {
            EM: 'Lấy các phòng chat của người dùng thành công',
            EC: 0,
            DT: formattedUserRooms
        };
    } catch (error) {
        console.log(error);
        return {
            EM: 'Lấy các phòng chat của người dùng thất bại',
            EC: 1,
            DT: []
        };
    }
};







const createChatRoom = async (eventId) => {
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

      
        const existingChatRoom = await db.ChatRoom.findOne({
            where: { eventId: eventId }
        });

        if (existingChatRoom) {
            return {
                EM: 'Phòng chat đã tồn tại',
                EC: 0,
                DT: existingChatRoom
            };
        }

       
        let newChatRoom = await db.ChatRoom.create({
            id: uuidv4(), 
            eventId: eventId
        });

        return {
            EM: 'Tạo phòng chat thành công',
            EC: 0,
            DT: newChatRoom
        };
    } catch (error) {
        console.log(error);
        return {
            EM: 'Tạo phòng chat thất bại',
            EC: 1,
            DT: []
        };
    }
};

const sendMessage = async (eventId, userId, messageText) => {
    try {
        const event = await db.Event.findOne({ where: { id: eventId } });
        if (!event) {
            return { EM: 'Sự kiện không tồn tại', EC: 1, DT: [] };
        }

        const userEvent = await db.UserEvent.findOne({ where: { eventId: eventId, userId: userId } });
        if (!userEvent) {
            return { EM: 'Người dùng không tham gia sự kiện này', EC: 1, DT: [] };
        }

        const chatRoom = await db.ChatRoom.findOne({ where: { eventId: eventId } });
        if (!chatRoom) {
            return { EM: 'Phòng chat không tồn tại', EC: 1, DT: [] };
        }

        let newMessage = await db.Chat.create({
            id: uuidv4(), 
            text: messageText,
            time: new Date(), 
            chatRoomId: chatRoom.id,
            userId: userId,
        });

        broadcast({
            eventId: eventId,
            message: newMessage
        });

        return { EM: 'Gửi tin nhắn thành công', EC: 0, DT: newMessage };
    } catch (error) {
        console.log(error);
        return { EM: 'Gửi tin nhắn thất bại', EC: 1, DT: [] };
    }
};
const sendImage = async (eventId, userId, imageUrl) => {
    try {
        const event = await db.Event.findOne({ where: { id: eventId } });
        if (!event) {
            return { EM: 'Sự kiện không tồn tại', EC: 1, DT: [] };
        }

        const userEvent = await db.UserEvent.findOne({ where: { eventId: eventId, userId: userId } });
        if (!userEvent) {
            return { EM: 'Người dùng không tham gia sự kiện này', EC: 1, DT: [] };
        }

        const chatRoom = await db.ChatRoom.findOne({ where: { eventId: eventId } });
        if (!chatRoom) {
            return { EM: 'Phòng chat không tồn tại', EC: 1, DT: [] };
        }

        let newMessage;
        if (imageUrl) {
            // // Upload image to Cloudinary
            // const uploadResponse = await cloudinary.uploader.upload(imageUrl);
            newMessage = await db.Chat.create({
                id: uuidv4(), 
                text: imageUrl,
                time: new Date(), 
                chatRoomId: chatRoom.id,
                userId: userId,
            });

            broadcast({
                eventId: eventId,
                message: newMessage
            });

            return { EM: 'Gửi tin nhắn thành công', EC: 0, DT: newMessage };
        }

        
    } catch (error) {
        console.log(error);
        return { EM: 'Gửi tin nhắn thất bại', EC: 1, DT: [] };
    }
};
const getAllMessagesInChatRoom = async (eventId) => {
    try {
    //    console.log("lấy tin nhắn phòng ",eventId)
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

        const chatRoom = await db.ChatRoom.findOne({
            where: { eventId: eventId }
        });

        if (!chatRoom) {
            return {
                EM: 'Phòng chat không tồn tại',
                EC: 1,
                DT: []
            };
        }

     
        const messages = await db.Chat.findAll({
            where: { chatRoomId: chatRoom.id },
            order: [['time', 'ASC']],
            include: [
                {
                    model: db.User,
                    attributes: ['avatarUrl','name']
                }
            ]
        });
// console.log("messages",messages)
        return {
            EM: 'Lấy tin nhắn thành công',
            EC: 0,
            DT: messages
        };
    } catch (error) {
        console.log(error);
        return {
            EM: 'Lấy tin nhắn thất bại',
            EC: 1,
            DT: []
        };
    }
};

module.exports = { 
    getUserRoomChat,
    createChatRoom,
    sendMessage,
    sendImage,
    getAllMessagesInChatRoom
};