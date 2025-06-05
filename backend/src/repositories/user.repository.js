const { User } = require('../models');
const { Op } = require('sequelize');
const bcrypt = require('bcrypt');

const findAll = async () => {
  return await User.findAll();
};

const findById = async (id) => {
  return await User.findByPk(id);
};

const create = async (userData) => {
  // Hashear la contraseña antes de guardar el usuario
  if (userData.password) {
    const salt = await bcrypt.genSalt(10);
    userData.password = await bcrypt.hash(userData.password, salt);
  }
  return await User.create(userData);
};

const update = async (id, userData) => {
  // Si se actualiza la contraseña, hashearla
  if (userData.password) {
    const salt = await bcrypt.genSalt(10);
    userData.password = await bcrypt.hash(userData.password, salt);
  }
  await User.update(userData, { where: { id } });
  return await User.findByPk(id);
};

const deleteUser = async (id) => {
  return await User.destroy({ where: { id } });
};

const findByEmail = async (email) => {
  return await User.findOne({ where: { email } });
};

const updatePassword = async (id, password) => {
  // Hashear la nueva contraseña antes de actualizar
  const salt = await bcrypt.genSalt(10);
  const hashedPassword = await bcrypt.hash(password, salt);
  await User.update({ password: hashedPassword }, { where: { id } });
  return await User.findByPk(id);
};

const login = async (email, password) => {
  const user = await User.findOne({ where: { email } });
  if (!user) return null;

  const passwordMatch = await bcrypt.compare(password, user.password);
  if (!passwordMatch) return null;

  return user;
};

module.exports = {
  findAll,
  findById,
  create,
  update,
  delete: deleteUser,
  findByEmail,
  updatePassword,
  login
};