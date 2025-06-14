const userRepository = require('../repositories/user.repository');
const { toUserResponse, toUsersResponse } = require('../adapters/user.adapter');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const getAllUsers = async (req, res) => {
  try {
    const users = await userRepository.findAll();
    res.json(toUsersResponse(users));
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener los usuarios' });
  }
};

const getUserById = async (req, res) => {
  try {
    const user = await userRepository.findById(req.params.id);
    if (!user) return res.status(404).json({ error: 'Usuario no encontrado' });
    res.json(toUserResponse(user));
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener el usuario' });
  }
};

const createUser = async (req, res) => {
  try {
    const { name, email, password, phone } = req.body;
    const userData = { name, email, password, phone, role: 'user' };
    const user = await userRepository.create(userData);
    res.status(201).json(toUserResponse(user));
  } catch (error) {
    res.status(500).json({ error: 'Error al crear el usuario' });
  }
};

const updateUser = async (req, res) => {
  try {
    const { name, email, phone } = req.body;
    const updateData = { name, email, phone };
    const user = await userRepository.update(req.params.id, updateData);
    if (!user) return res.status(404).json({ error: 'Usuario no encontrado' });
    res.json(toUserResponse(user));
  } catch (error) {
    res.status(500).json({ error: 'Error al actualizar el usuario' });
  }
};

const deleteUser = async (req, res) => {
  try {
    const deleted = await userRepository.delete(req.params.id);
    if (!deleted) return res.status(404).json({ error: 'Usuario no encontrado' });
    res.json({ message: 'Usuario eliminado correctamente' });
  } catch (error) {
    res.status(500).json({ error: 'Error al eliminar el usuario' });
  }
};

const updateUserPassword = async (req, res) => {
  try {
    const { password } = req.body;
    if (!password) {
      return res.status(400).json({ error: 'La contraseña es requerida' });
    }
    const user = await userRepository.updatePassword(req.params.id, password);
    if (!user) return res.status(404).json({ error: 'Usuario no encontrado' });
    res.json({ message: 'Contraseña actualizada correctamente' });
  } catch (error) {
    res.status(500).json({ error: 'Error al actualizar la contraseña' });
  }
};

const loginUser = async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ error: 'Email y contraseña son requeridos' });
    }

    const user = await userRepository.findByEmail(email);
    if (!user) {
      return res.status(401).json({ error: 'Credenciales inválidas' });
    }

    const passwordMatch = await bcrypt.compare(password, user.password);
    if (!passwordMatch) {
      return res.status(401).json({ error: 'Credenciales inválidas' });
    }

    // const token = jwt.sign(
    //   {
    //     id: user.id,
    //     email: user.email,
    //     role: user.role
    //   },
    //   process.env.JWT_SECRET,
    //   { expiresIn: '2h' }
    // );

    res.json({
      user: toUserResponse(user),
      //token
    });
  } catch (error) {
    res.status(500).json({ error: 'Error al iniciar sesión' });
  }
};

module.exports = {
  getAllUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser,
  updateUserPassword,
  loginUser
};