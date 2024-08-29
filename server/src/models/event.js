import { sequelize } from '../config/connectDB';
const { DataTypes } = require('sequelize');

const Event = sequelize.define('Event', {
  id: {
    type: DataTypes.CHAR(36),
    primaryKey: true,
  },
  name: {
    type: DataTypes.STRING(100),
    allowNull: false,
  },
  status: {
    type: DataTypes.STRING(50),
    allowNull: false,
  },
  description: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  startAt: {
    type: DataTypes.DATE,
    allowNull: false,
  },
  endAt: {
    type: DataTypes.DATE,
    allowNull: false,
  },
  location: {
    type: DataTypes.STRING(100),
    allowNull: true,
  },
  experience: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  totalBudget: {
    type: DataTypes.DECIMAL(15, 2),
    defaultValue: 0,
  },
  totalActualCost: {
    type: DataTypes.DECIMAL(15, 2),
    defaultValue: 0,
  },
  categoryId: {
    type: DataTypes.CHAR(36),
    references: {
      model: 'EventCategory',
      key: 'id',
    },
  },
}, {
  tableName: 'event',
  timestamps: true,
});

export default Event;
