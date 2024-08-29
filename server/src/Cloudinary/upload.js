//upload.js
import {v2 as cloudinary} from 'cloudinary';
const multer = require('multer');
const { CloudinaryStorage } = require('multer-storage-cloudinary');

          
cloudinary.config({ 

});
// cloudinary.config({
//   cloud_name: 'your-cloud-name',
//   api_key: 'your-api-key',
//   api_secret: 'your-api-secret'
// });

const storage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: 'uploads',
    format: async (req, file) => 'jpg', 
    public_id: (req, file) => file.originalname
  },
});


const upload = multer({ storage: storage });

module.exports = upload;
