const { Router } = require('express')

const router = Router();

const authRoutes = require('./auth.routes')

router.use('/api/v1/auth', authRoutes);

module.exports = router;