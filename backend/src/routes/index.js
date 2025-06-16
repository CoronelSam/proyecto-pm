const { Router } = require('express');

const router = Router();

const userRoutes = require('./user.routes');
const productRoutes = require('./product.routes');
const orderRoutes = require('./order.routes');
const orderItemRoutes = require('./order_items.routes');
const cloudinaryRoutes = require('./cloudinary.routes');

router.use('/api/v1/users', userRoutes);
router.use('/api/v1/products', productRoutes);
router.use('/api/v1/orders', orderRoutes);
router.use('/api/v1/order-items', orderItemRoutes);
router.use('/api/v1/cloudinary', cloudinaryRoutes);

module.exports = router;