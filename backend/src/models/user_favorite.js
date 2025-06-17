'use strict';
module.exports = (sequelize, DataTypes) => {
  const UserFavorite = sequelize.define('UserFavorite', {
    user_id: DataTypes.INTEGER,
    product_id: DataTypes.INTEGER
  }, {
    tableName: 'user_favorites',
    timestamps: false
  });

  UserFavorite.associate = function(models) {
    UserFavorite.belongsTo(models.User, { foreignKey: 'user_id' });
    UserFavorite.belongsTo(models.Product, { foreignKey: 'product_id' });
  };

  return UserFavorite;
};