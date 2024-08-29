//src/models/user.js
//const { sequelize } = require('../config/connectDB');
import { sequelize } from "../config/connectDB";
const { DataTypes } = require("sequelize");
const User = sequelize.define(
  "User",
  {
    id: {
      type: DataTypes.CHAR(36),
      primaryKey: true,
    },
    name: {
      type: DataTypes.STRING(100),
      allowNull: false,
    },
    role: {
      type: DataTypes.STRING(50),
      allowNull: true,
    },
    email: {
      type: DataTypes.STRING(100),
      allowNull: false,
    },
    phone: {
      type: DataTypes.STRING(15),
      allowNull: false,
    },
    avatarUrl: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    activated: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: false,
    },
  },
  {
    tableName: "user",
    timestamps: true,
  }
);

export default User;
