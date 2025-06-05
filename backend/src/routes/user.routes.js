const express = require('express');
const router = express.Router();
const userController = require('../controllers/user.controller');
const { validarLogin, validate } = require('../middleware/validaciones/login');

router.get('/', userController.getAllUsers);
router.get('/:id', userController.getUserById);
router.post('/', userController.createUser);
router.put('/:id', userController.updateUser);
router.delete('/:id', userController.deleteUser);

router.put('/:id/password', userController.updateUserPassword);

router.post('/login', validarLogin(), validate, userController.loginUser);

module.exports = router;