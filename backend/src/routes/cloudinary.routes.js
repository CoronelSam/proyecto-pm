const express = require('express');
const router = express.Router();
const multer = require('multer');
const upload = multer({ dest: 'uploads/' });
const { getImagesFromFolder, uploadImage, deleteImage } = require('../controllers/cloudinary.controller');

router.get('/images', getImagesFromFolder);
router.post('/upload', upload.single('image'), uploadImage);
router.post('/delete', deleteImage);

module.exports = router;