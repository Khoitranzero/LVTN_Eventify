//src/config/conectDB.js
import  Sequelize  from 'sequelize';
const dbConfig = require('./database.js');

const sequelize = new Sequelize(
  dbConfig.DB,
  dbConfig.USER,
  dbConfig.PASSWORD,
  {
    host: dbConfig.HOST,
    port: 3307,
    dialect: dbConfig.dialect,
    logging: false, 
    dialectOptions: {
      charset: 'utf8mb4',
    },
    pool: {
      max: 5,
      min: 0,
      acquire: 30000,
      idle: 10000
    }
  }
);

const connection = async() => {
  try {
    await sequelize.authenticate();
    console.log('Kết nối đã được thiết lập thành công');
  } catch (error) {
    console.error('Không thể kết nối với cơ sở dữ liệu:', error);
  }
}

export { sequelize, connection };
