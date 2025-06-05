const orderRepository = require('../repositories/order.repository');
const { toOrderResponse, toOrdersResponse } = require('../adapters/order.adapter');

const getAllOrders = async (req, res) => {
  try {
    const orders = await orderRepository.findAll();
    res.json(toOrdersResponse(orders));
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener las órdenes' });
  }
};

const getOrderById = async (req, res) => {
  try {
    const order = await orderRepository.findById(req.params.id);
    if (!order) return res.status(404).json({ error: 'Orden no encontrada' });
    res.json(toOrderResponse(order));
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener la orden' });
  }
};

const createOrder = async (req, res) => {
  try {
    const order = await orderRepository.create(req.body);
    res.status(201).json(toOrderResponse(order));
  } catch (error) {
    res.status(500).json({ error: 'Error al crear la orden' });
  }
};

const updateOrder = async (req, res) => {
  try {
    const order = await orderRepository.update(req.params.id, req.body);
    if (!order) return res.status(404).json({ error: 'Orden no encontrada' });
    res.json(toOrderResponse(order));
  } catch (error) {
    res.status(500).json({ error: 'Error al actualizar la orden' });
  }
};

const deleteOrder = async (req, res) => {
  try {
    const deleted = await orderRepository.delete(req.params.id);
    if (!deleted) return res.status(404).json({ error: 'Orden no encontrada' });
    res.json({ message: 'Orden eliminada correctamente' });
  } catch (error) {
    res.status(500).json({ error: 'Error al eliminar la orden' });
  }
};

module.exports = {
  getAllOrders,
  getOrderById,
  createOrder,
  updateOrder,
  deleteOrder
};