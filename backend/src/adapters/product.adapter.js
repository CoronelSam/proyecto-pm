function toProductResponse(productInstance) {
  if (!productInstance) return null;
  const product = productInstance.toJSON ? productInstance.toJSON() : productInstance;
  return {
    id: product.id,
    name: product.name,
    description: product.description,
    price: product.price,
    image_url: product.image_url,
    category: product.category,
    sizes: product.sizes,
    available: product.available,
    created_at: product.created_at
  };
}

function toProductsResponse(products) {
  if (!products) return [];
  return products.map(toProductResponse);
}

module.exports = {
  toProductResponse,
  toProductsResponse
};