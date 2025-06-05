const { Order } = require('../models');

const findAll = async () => await Order.findAll();

const findById = async (id) => await Order.findByPk(id);

const create = async (data) => await Order.create(data);

const update = async (id, data) => {
  await Order.update(data, { where: { id } });
  return await Order.findByPk(id);
};

const deleteOrder = async (id) => await Order.destroy({ where: { id } });

module.exports = {
  findAll,
  findById,
  create,
  update,
  delete: deleteOrder
};