import { sequelize } from '../config/connectDB';
const {  DataTypes } = require('sequelize');

const Role = sequelize.define('Role', {
  id: {
    type: DataTypes.CHAR(36),
    primaryKey: true,
  },
  role: {
    type: DataTypes.STRING(50),
    allowNull: false,
  },
},
{
  tableName: 'role',
  timestamps: false 
}
);

export default Role;
