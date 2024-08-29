import { sequelize } from '../config/connectDB';
const { DataTypes } = require('sequelize');

const Chat = sequelize.define('Chat', {
  id: {
    type: DataTypes.CHAR(36),
    primaryKey: true,
  },
  text: {
    type: DataTypes.TEXT,
    allowNull: false,
  },
  time: {
    type: DataTypes.DATE,
    allowNull: false,
  },
  chatRoomId: {
    type: DataTypes.CHAR(36),
    references: {
      model: 'ChatRoom',
      key: 'id',
    },
  },
  userId: {
    type: DataTypes.CHAR(36),
    references: {
      model: 'User',
      key: 'id',
    },
  },
}, {
  tableName: 'chat',
  timestamps: false,
});

export default Chat;
