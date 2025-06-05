const { Product } = require('../models');

const findAll = async () => await Product.findAll();

const findById = async (id) => await Product.findByPk(id);

const create = async (data) => await Product.create(data);

const update = async (id, data) => {
  await Product.update(data, { where: { id } });
  return await Product.findByPk(id);
};

const deleteProduct = async (id) => await Product.destroy({ where: { id } });

module.exports = {
  findAll,
  findById,
  create,
  update,
  delete: deleteProduct
};