import { sequelize } from '../config/connectDB';
const {  DataTypes } = require('sequelize');

const EventStatus = sequelize.define('EventStatus', {
  id: {
    type: DataTypes.CHAR(36),
    primaryKey: true,
  },
  eventId: {
    type: DataTypes.CHAR(36),
    allowNull: false,
    references: {
      model: Event,
      key: 'id',
    },
  },
  status: {
    type: DataTypes.STRING(50),
    allowNull: false,
  },
},
{
  tableName: 'eventstatus',
  timestamps: false 
}
);

export default EventStatus;
