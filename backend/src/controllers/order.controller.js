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
    const { items, ...orderData } = req.body;

    const order = await Order.create(orderData);

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

    res.status(201).json(order);
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

const updateOrderStatus = async (req, res) => {
  try {
    const { status } = req.body;
    const orderId = req.params.id;
    if (!status) {
      return res.status(400).json({ error: 'El estado es requerido' });
    }
    const order = await orderRepository.update(orderId, { status });
    if (!order) return res.status(404).json({ error: 'Orden no encontrada' });
    const io = req.app.get('io');
    if (io) {
      io.to(`order_${orderId}`).emit('orderStatusChanged', {
        orderId,
        status,
        updated_at: new Date()
      });
    }
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

const getOrdersByUser = async (req, res) => {
  try {
    const userId = req.params.userId;
    const orders = await Order.findAll({
      where: { user_id: userId },
      include: [
        {
          model: OrderItem,
          include: [Product]
        }
      ],
      order: [['created_at', 'DESC']]
    });
    res.json(orders);
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener las órdenes del usuario' });
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
  getAllOrdersWithItems,
  getOrdersByUser,
};