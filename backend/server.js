const express = require('express');
const app = express();
require('dotenv').config();
const cookieParser = require('cookie-parser');
const { query } = require('express-validator');
app.use(express.json());
app.use(cookieParser());
app.use(express.urlencoded({ extended: true }));
const PORT = process.env.PORT || 3001;

// --- SOCKET.IO ---
const http = require('http').createServer(app);
const io = require('socket.io')(http, {
  cors: {
    origin: '*'
  }
});
app.set('io', io);

io.on('connection', (socket) => {
  console.log('Usuario conectado al socket:', socket.id);

  socket.on('joinOrderRoom', (orderId) => {
    socket.join(`order_${orderId}`);
  });

  socket.on('disconnect', () => {
    console.log('Usuario desconectado:', socket.id);
  });
});


app.get('/', (req, res) => {
  res.send('Hello, World!');
})

app.get('/about', (req, res) => {
    res.send('About Us');
})

const db = require('./src/models');
db.sequelize.sync()
  .then(() => {
    console.log('Database synchronized successfully.');
  })
  .catch((error) => {
    console.error('Error synchronizing database: ', error);
  });

const indexRoutes = require('./src/routes/index');
app.use(indexRoutes);

// Cambia app.listen por http.listen
http.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
})