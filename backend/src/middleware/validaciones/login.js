const {
    body,
    validationResult
} = require('express-validator');

const validarLogin = () => {
    return [
        body('email')
            .isEmail().trim().isLength({ max: 255 }).normalizeEmail()
            .withMessage('El email debe ser un correo electrónico válido'),
        body('password')
            .notEmpty()
            .withMessage('La contraseña no puede estar vacía')
            .isLength({ min: 6, max: 255 })
            .withMessage('La contraseña debe tener minimo 6 carcteres'),
    ];
};

const validate = (req, res, next) => {
    const errors = validationResult(req);
    // console.log('errors', errors); // Eliminar en producción
    if (errors.isEmpty()) {
        return next();
    }
    const extractedErrors = [];
    errors.array().forEach(err => {
        extractedErrors.push({
            [err.path]: err.msg
        });
    });

    return res.status(422).json({
        errors: extractedErrors,
    });
}

module.exports = {
    validarLogin,
    validate
};