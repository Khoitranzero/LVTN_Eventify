import { sequelize } from '../config/connectDB';
const { DataTypes } = require('sequelize');

const ChatRoom = sequelize.define('ChatRoom', {
  id: {
    type: DataTypes.CHAR(36),
    primaryKey: true,
  },
  eventId: {
    type: DataTypes.CHAR(36),
    references: {
      model: 'Event',
      key: 'id',
    },
  },
}, {
  tableName: 'chatroom',
  timestamps: false,
});

export default ChatRoom;
