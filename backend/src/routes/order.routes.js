const express = require('express');
const router = express.Router();
const orderController = require('../controllers/order.controller');

router.get('/', orderController.getAllOrders);
router.get('/admin', orderController.getAllOrdersWithItems);
router.get('/:id', orderController.getOrderById);
router.post('/', orderController.createOrder);
router.put('/:id', orderController.updateOrder);
router.delete('/:id', orderController.deleteOrder);
router.patch('/:id/status', orderController.updateOrderStatus);
router.get('/:id/status', orderController.getOrderStatus);
router.get('/:id/items', orderController.getOrderWithItems);
router.get('/user/:userId', orderController.getOrdersByUser);

module.exports = router;