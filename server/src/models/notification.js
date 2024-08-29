import { sequelize } from '../config/connectDB';
const { DataTypes } = require('sequelize');

const Notification = sequelize.define('Notification', {
  id: {
    type: DataTypes.CHAR(36),
    primaryKey: true,
  },
  type: {
    type: DataTypes.STRING(50),
    allowNull: false,
  },
  isRead: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
  data: {
    type: DataTypes.TEXT,
    allowNull: false,
  },
  createAt: {
    type: DataTypes.DATE,
    allowNull: false,
  },
  deleted: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
  eventId: {
    type: DataTypes.CHAR(36),
    references: {
      model: 'Event',
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
  tableName: 'notification',
  timestamps: false,
});

export default Notification;
