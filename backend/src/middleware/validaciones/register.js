const { body, validationResult } = require('express-validator');

const validarRegistro = () => [
  body('name')
    .notEmpty().withMessage('El nombre es requerido')
    .isLength({ min: 2, max: 100 }).withMessage('El nombre debe tener entre 2 y 100 caracteres'),
  body('email')
    .isEmail().withMessage('El email debe ser válido')
    .isLength({ max: 255 }).withMessage('El email no debe superar los 255 caracteres')
    .normalizeEmail(),
  body('password')
    .notEmpty().withMessage('La contraseña es requerida')
    .isLength({ min: 6, max: 255 }).withMessage('La contraseña debe tener mínimo 6 caracteres'),
  body('phone')
    .optional()
    .isLength({ min: 7, max: 20 }).withMessage('El teléfono debe tener entre 7 y 20 caracteres'),
];

const validate = (req, res, next) => {
  const errors = validationResult(req);
  if (errors.isEmpty()) return next();
  const extractedErrors = errors.array().map(err => ({ [err.path]: err.msg }));
  return res.status(422).json({ errors: extractedErrors });
};

module.exports = {
  validarRegistro,
  validate
};