const express = require('express');
const router = express.Router();
const { getImagesFromFolder } = require('../controllers/cloudinary.controller');

router.get('/images', getImagesFromFolder);

module.exports = router;