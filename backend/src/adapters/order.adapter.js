function toOrderResponse(orderInstance) {
  if (!orderInstance) return null;
  const order = orderInstance.toJSON ? orderInstance.toJSON() : orderInstance;
  return {
    id: order.id,
    user_id: order.user_id,
    order_type: order.order_type,
    total: order.total,
    status: order.status,
    created_at: order.created_at
  };
}

function toOrdersResponse(orders) {
  if (!orders) return [];
  return orders.map(toOrderResponse);
}

module.exports = {
  toOrderResponse,
  toOrdersResponse
};