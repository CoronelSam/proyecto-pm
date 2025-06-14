const orderItemRepository = require('../repositories/order_items.repository');
const { toOrderItemResponse, toOrderItemsResponse } = require('../adapters/order_items.adapter');

const getAllOrderItems = async (req, res) => {
  try {
    const items = await orderItemRepository.findAll();
    res.json(toOrderItemsResponse(items));
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener los items de la orden' });
  }
};

const getOrderItemById = async (req, res) => {
  try {
    const item = await orderItemRepository.findById(req.params.id);
    if (!item) return res.status(404).json({ error: 'Item no encontrado' });
    res.json(toOrderItemResponse(item));
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener el item' });
  }
};

const createOrderItem = async (req, res) => {
  try {
    const item = await orderItemRepository.create(req.body);
    res.status(201).json(toOrderItemResponse(item));
  } catch (error) {
    res.status(500).json({ error: 'Error al crear el item' });
  }
};

const updateOrderItem = async (req, res) => {
  try {
    const item = await orderItemRepository.update(req.params.id, req.body);
    if (!item) return res.status(404).json({ error: 'Item no encontrado' });
    res.json(toOrderItemResponse(item));
  } catch (error) {
    res.status(500).json({ error: 'Error al actualizar el item' });
  }
};

const deleteOrderItem = async (req, res) => {
  try {
    const deleted = await orderItemRepository.delete(req.params.id);
    if (!deleted) return res.status(404).json({ error: 'Item no encontrado' });
    res.json({ message: 'Item eliminado correctamente' });
  } catch (error) {
    res.status(500).json({ error: 'Error al eliminar el item' });
  }
};

module.exports = {
  getAllOrderItems,
  getOrderItemById,
  createOrderItem,
  updateOrderItem,
  deleteOrderItem
};