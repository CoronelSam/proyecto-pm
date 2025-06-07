const { OrderItem } = require('../models');

const findAll = async () => await OrderItem.findAll();

const findById = async (id) => await OrderItem.findByPk(id);

const create = async (data) => await OrderItem.create(data);

const update = async (id, data) => {
  await OrderItem.update(data, { where: { id } });
  return await OrderItem.findByPk(id);
};

const deleteOrderItem = async (id) => await OrderItem.destroy({ where: { id } });

module.exports = {
  findAll,
  findById,
  create,
  update,
  delete: deleteOrderItem
};