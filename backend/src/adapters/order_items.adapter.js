function toOrderItemResponse(orderItemInstance) {
  if (!orderItemInstance) return null;
  const item = orderItemInstance.toJSON ? orderItemInstance.toJSON() : orderItemInstance;
  return {
    id: item.id,
    order_id: item.order_id,
    product_id: item.product_id,
    quantity: item.quantity,
    subtotal: item.subtotal
  };
}

function toOrderItemsResponse(orderItems) {
  if (!orderItems) return [];
  return orderItems.map(toOrderItemResponse);
}

module.exports = {
  toOrderItemResponse,
  toOrderItemsResponse
};