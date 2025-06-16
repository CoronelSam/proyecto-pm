const cloudinary = require('cloudinary').v2;

const getImagesFromFolder = async (req, res) => {
  const folder = req.query.folder; // Ejemplo: 'productos'
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

module.exports = { getImagesFromFolder };