import { sequelize } from '../config/connectDB';
const { DataTypes } = require('sequelize');

const CostCategory = sequelize.define('CostCategory', {
  id: {
    type: DataTypes.CHAR(36),
    primaryKey: true,
  },
  name: {
    type: DataTypes.STRING(100),
    allowNull: false,
  },
}, {
  tableName: 'costcategory',
  timestamps: false,
});

export default CostCategory;
