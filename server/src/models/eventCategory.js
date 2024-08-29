import { sequelize } from '../config/connectDB';
const { DataTypes } = require('sequelize');

const EventCategory = sequelize.define('EventCategory', {
  id: {
    type: DataTypes.CHAR(36),
    primaryKey: true,
  },
  name: {
    type: DataTypes.STRING(100),
    allowNull: false,
  },
}, {
  tableName: 'eventcategory',
  timestamps: false,
});

export default EventCategory;
