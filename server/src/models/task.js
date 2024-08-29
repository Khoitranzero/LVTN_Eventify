import { sequelize } from "../config/connectDB";
const { DataTypes } = require("sequelize");

const Task = sequelize.define(
  "Task",
  {
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
    eventId: {
      type: DataTypes.CHAR(36),
      allowNull: true,
      references: {
        model: "Event",
        key: "id",
      },
    },
    parentTaskId: {
      type: DataTypes.CHAR(36),
      allowNull: true,
      references: {
        model: "Task",
        key: "id",
      },
    },
    isShow: {
      type: DataTypes.BOOLEAN,
      defaultValue: true,
    },
    // priority: {
    //   type: DataTypes.INTEGER,
    //   default: 0,
    // },
  },
  {
  tableName: 'task',
  timestamps: false,
});

export default Task;
