function toUserResponse(userInstance) {
  if (!userInstance) return null;
  // Convierte instancia de Sequelize a objeto plano si es necesario
  const user = userInstance.toJSON ? userInstance.toJSON() : userInstance;

  return {
    id: user.id,
    name: user.name,
    email: user.email,
    password: user.password,
    phone: user.phone,
    role: user.role,
    created_at: user.created_at
  };
}

function toUsersResponse(users) {
  if (!users) return [];
  return users.map(toUserResponse);
}

module.exports = {
  toUserResponse,
  toUsersResponse
};