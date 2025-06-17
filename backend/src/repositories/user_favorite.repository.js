const { UserFavorite, Product } = require('../models');

const addFavorite = async (userId, productId) => {
  return await UserFavorite.create({ user_id: userId, product_id: productId });
};

const removeFavorite = async (userId, productId) => {
  return await UserFavorite.destroy({ where: { user_id: userId, product_id: productId } });
};

const getFavorites = async (userId) => {
  return await UserFavorite.findAll({
    where: { user_id: userId },
    include: [{ model: Product }]
  });
};

module.exports = { 
    addFavorite, 
    removeFavorite, 
    getFavorites 
};