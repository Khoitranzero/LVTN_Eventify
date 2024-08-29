import { sequelize } from '../config/connectDB';
const { DataTypes } = require('sequelize');

const EventCost = sequelize.define('EventCost', {
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
  categoryId: {
    type: DataTypes.CHAR(36),
    references: {
      model: 'CostCategory',
      key: 'id',
    },
  },
  budgetAmount: {
    type: DataTypes.DECIMAL,
    allowNull: true,
  },
  actualAmount: {
    type: DataTypes.DECIMAL,
    defaultValue: 0,
  },
  description: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
}, {
  tableName: 'eventcost',
  timestamps: false,
});

export default EventCost;
