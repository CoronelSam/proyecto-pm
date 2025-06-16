const cloudinary = require('cloudinary').v2;
const fs = require('fs');
const path = require('path');

const uploadImage = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'No se envió ninguna imagen' });
    }
    if (
      !req.file.mimetype.startsWith('image/') &&
      !(
        req.file.mimetype === 'application/octet-stream' &&
        ['.jpg', '.jpeg', '.png', '.gif', '.webp'].includes(path.extname(req.file.originalname).toLowerCase())
      )
    ) {
      fs.unlinkSync(req.file.path);
      return res.status(400).json({ error: 'Solo se permiten imágenes' });
    }
    const folder = req.body.folder || 'sabores_de_mi_casa';
    const result = await cloudinary.uploader.upload(req.file.path, {
      folder: folder,
    });
    fs.unlinkSync(req.file.path);
    res.json({ url: result.secure_url, public_id: result.public_id });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al subir la imagen a Cloudinary' });
  }
};

const getImagesFromFolder = async (req, res) => {
  const folder = req.query.folder;
  if (!folder) {
    return res.status(400).json({ error: 'El parámetro folder es requerido' });
  }
  try {
    const result = await cloudinary.api.resources({
      type: 'upload',
      prefix: `${folder}/`,
      max_results: 100,
    });

    const images = result.resources.map(img => ({
      url: img.secure_url,
      public_id: img.public_id
    }));

    res.json({ images });
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener imágenes de Cloudinary' });
  }
};

const deleteImage = async (req, res) => {
  try {
    const { public_id } = req.body;
    if (!public_id) return res.status(400).json({ error: 'public_id requerido' });
    await cloudinary.uploader.destroy(public_id);
    res.json({ message: 'Imagen eliminada' });
  } catch (error) {
    res.status(500).json({ error: 'Error al eliminar la imagen de Cloudinary' });
  }
};

module.exports = {
  getImagesFromFolder,
  uploadImage,
  deleteImage
};