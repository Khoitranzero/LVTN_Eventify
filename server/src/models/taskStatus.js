import { sequelize } from '../config/connectDB';
const {  DataTypes } = require('sequelize');

const TaskStatus = sequelize.define('TaskStatus', {
  id: {
    type: DataTypes.CHAR(36),
    primaryKey: true,
  },
  taskId: {
    type: DataTypes.CHAR(36),
    allowNull: false,
    references: {
      model: 'Task',
      key: 'id',
    },
  },
  status: {
    type: DataTypes.STRING(50),
    allowNull: false,
  },
},
{
  tableName: 'taskstatus',
  timestamps: false 
}
);

export default TaskStatus;
