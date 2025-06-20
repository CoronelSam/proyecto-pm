const orderRepository = require('../repositories/order.repository');
const { toOrderResponse, toOrdersResponse } = require('../adapters/order.adapter');
const { Order, OrderItem, Product, User } = require('../models');

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
    // 1. Extrae los items y los datos de la orden del body
    const { items, ...orderData } = req.body;

    // 2. Crea la orden
    const order = await Order.create(orderData);

    // 3. Crea los items de la orden
    if (items && Array.isArray(items)) {
      for (const item of items) {
        await OrderItem.create({
          order_id: order.id,
          product_id: item.product_id,
          quantity: item.quantity,
          subtotal: item.subtotal,
          size: item.size || null
        });
      }
    }

    res.status(201).json(order); // Puedes adaptar la respuesta si lo deseas
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

// Actualizar solo el estado de la orden
const updateOrderStatus = async (req, res) => {
  try {
    const { status } = req.body;
    const orderId = req.params.id;
    if (!status) {
      return res.status(400).json({ error: 'El estado es requerido' });
    }
    const order = await orderRepository.update(orderId, { status });
    if (!order) return res.status(404).json({ error: 'Orden no encontrada' });
    res.json({ message: 'Estado actualizado', order });
  } catch (error) {
    res.status(500).json({ error: 'Error al actualizar el estado de la orden' });
  }
};

const getOrderStatus = async (req, res) => {
  try {
    const order = await orderRepository.findById(req.params.id);
    if (!order) return res.status(404).json({ error: 'Orden no encontrada' });
    res.json({ id: order.id, status: order.status, created_at: order.created_at });
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener el estado de la orden' });
  }
};

const getOrderWithItems = async (req, res) => {
  try {
    const order = await Order.findByPk(req.params.id, {
      include: [
        {
          model: OrderItem,
          include: [Product]
        },
        {
          model: User,
          attributes: ['id', 'name', 'email']
        }
      ]
    });
    if (!order) return res.status(404).json({ error: 'Orden no encontrada' });
    res.json(order);
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener la orden con items' });
  }
};

const getAllOrdersWithItems = async (req, res) => {
  try {
    const orders = await Order.findAll({
      include: [
        {
          model: OrderItem,
          include: [Product]
        },
        {
          model: User,
          attributes: ['id', 'name', 'email']
        }
      ],
      order: [['created_at', 'DESC']]
    });
    res.json(orders);
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener las órdenes con items' });
  }
};

module.exports = {
  getAllOrders,
  getOrderById,
  createOrder,
  updateOrder,
  deleteOrder,
  updateOrderStatus,
  getOrderStatus,
  getOrderWithItems,
  getAllOrdersWithItems
};