import { sequelize } from '../config/connectDB';
const { DataTypes } = require('sequelize');

const UserTask = sequelize.define('UserTask', {
  id: {
    type: DataTypes.CHAR(36),
    primaryKey: true,
  },
  taskId: {
    type: DataTypes.CHAR(36),
    references: {
      model: 'Task',
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
  tableName: 'usertask',
  timestamps: false,
});

export default UserTask;
