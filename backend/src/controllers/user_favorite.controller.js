const userFavoriteRepo = require('../repositories/user_favorite.repository');

const addFavorite = async (req, res) => {
  const { userId, productId } = req.body;
  await userFavoriteRepo.addFavorite(userId, productId);
  res.json({ message: 'Producto agregado a favoritos' });
};

const removeFavorite = async (req, res) => {
  const { userId, productId } = req.body;
  await userFavoriteRepo.removeFavorite(userId, productId);
  res.json({ message: 'Producto eliminado de favoritos' });
};

const getFavorites = async (req, res) => {
  const { userId } = req.params;
  const favorites = await userFavoriteRepo.getFavorites(userId);
  res.json(favorites.map(fav => fav.Product));
};

module.exports = { addFavorite, removeFavorite, getFavorites };