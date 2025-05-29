const{
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
            .withMessage('La contraseña no puede estar vacía').isLength({ min: 6, max: 255 })
            .withMessage('La contraseña debe tener entre 6 y 255 caracteres'),
    ];
};

const validate = (req, res, next) => {
    const errors = validationResult(req);
    console.log('errors',errors);
    if(errors.isEmpty()) {
        return next();
    }
    const extractedErrors = [];
    errors.array().map(err => {
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