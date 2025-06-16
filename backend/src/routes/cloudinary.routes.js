const express = require('express');
const router = express.Router();
const multer = require('multer');
const upload = multer({ dest: 'uploads/' });
const { getImagesFromFolder, uploadImage } = require('../controllers/cloudinary.controller');

router.get('/images', getImagesFromFolder);
router.post('/upload', upload.single('image'), uploadImage);

module.exports = router;