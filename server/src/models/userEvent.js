import { sequelize } from "../config/connectDB";
const { DataTypes } = require("sequelize");

const UserEvent = sequelize.define(
  "UserEvent",
  {
    id: {
      type: DataTypes.CHAR(36),
      primaryKey: true,
    },
    eventId: {
      type: DataTypes.CHAR(36),
      references: {
        model: "Event",
        key: "id",
      },
    },
    userId: {
      type: DataTypes.CHAR(36),
      references: {
        model: "User",
        key: "id",
      },
    },
    roleId: {
      type: DataTypes.CHAR(36),
      references: {
        model: "Role",
        key: "id",
      },
    },
  },
  {
    tableName: "userevent",
    timestamps: true,
  }
);

export default UserEvent;
