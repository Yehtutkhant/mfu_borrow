const Joi = require("joi");

const validator = (schema) => (payload) => {
	return schema.validate(payload);
};

const loginSchema = Joi.object({
	email: Joi.string()
		.email({ minDomainSegments: 4, tlds: { allow: ["th"] } })
		.required(),
	password: Joi.string().required(),
});

const registerSchema = Joi.object({
	username: Joi.string().alphanum().min(3).max(50).required(),
	email: Joi.string()
		.email({ minDomainSegments: 4, tlds: { allow: ["th"] } })
		.required(),
	student_id: Joi.string().length(10).required(),
	password: Joi.string().min(3).max(50).required(),
	re_password: Joi.ref("password"),
});

const profileEditSchema = Joi.object({
	username: Joi.string().alphanum().min(3).max(50).required(),
	email: Joi.string()
		.email({ minDomainSegments: 4, tlds: { allow: ["th"] } })
		.required(),
	student_id: Joi.string().length(10).pattern(/^\d+$/).required(),
	profile_image: Joi.any().optional(),
});
module.exports = {
	validateLogin: validator(loginSchema),
	validateRegister: validator(registerSchema),
	validateProfileEdit: validator(profileEditSchema),
};
