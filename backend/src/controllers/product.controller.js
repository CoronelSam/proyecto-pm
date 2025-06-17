const productRepository = require('../repositories/product.repository');
const { toProductResponse, toProductsResponse } = require('../adapters/product.adapter');

const getAllProducts = async (req, res) => {
  try {
    const products = await productRepository.findAll();
    res.json(toProductsResponse(products));
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener los productos' });
  }
};

const getProductById = async (req, res) => {
  try {
    const product = await productRepository.findById(req.params.id);
    if (!product) return res.status(404).json({ error: 'Producto no encontrado' });
    res.json(toProductResponse(product));
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener el producto' });
  }
};

const createProduct = async (req, res) => {
  try {
    const product = await productRepository.create(req.body);
    res.status(201).json(toProductResponse(product));
  } catch (error) {
    console.error('Error creating product:', error);
    res.status(500).json({ error: 'Error al crear el producto' });
  }
};

const updateProduct = async (req, res) => {
  try {
    const product = await productRepository.update(req.params.id, req.body);
    if (!product) return res.status(404).json({ error: 'Producto no encontrado' });
    res.json(toProductResponse(product));
  } catch (error) {
    res.status(500).json({ error: 'Error al actualizar el producto' });
  }
};

const deleteProduct = async (req, res) => {
  try {
    const deleted = await productRepository.delete(req.params.id);
    if (!deleted) return res.status(404).json({ error: 'Producto no encontrado' });
    res.json({ message: 'Producto eliminado correctamente' });
  } catch (error) {
    res.status(500).json({ error: 'Error al eliminar el producto' });
  }
};

module.exports = {
  getAllProducts,
  getProductById,
  createProduct,
  updateProduct,
  deleteProduct
};