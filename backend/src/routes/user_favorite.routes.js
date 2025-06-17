const express = require('express');
const router = express.Router();
const userFavoriteController = require('../controllers/user_favorite.controller');

router.get('/:userId', userFavoriteController.getFavorites);

router.post('/', userFavoriteController.addFavorite);

router.delete('/', userFavoriteController.removeFavorite);

module.exports = router;