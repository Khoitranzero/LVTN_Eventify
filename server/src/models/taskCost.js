import { sequelize } from '../config/connectDB';
const { DataTypes } = require('sequelize');

const TaskCost = sequelize.define('TaskCost', {
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
  categoryId: {
    type: DataTypes.CHAR(36),
    references: {
      model: 'CostCategory',
      key: 'id',
    },
  },
  actualAmount: {
    type: DataTypes.DECIMAL,
    allowNull: true,
  },
  description: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
}, {
  tableName: 'taskcost',
  timestamps: false,
});

export default TaskCost;
