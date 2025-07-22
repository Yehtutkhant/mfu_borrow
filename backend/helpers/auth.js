const jwt = require("jsonwebtoken");
require("dotenv").config;

const generateToken = (user, key, expiry) => {
	return jwt.sign({ id: user.user_id, role: user.role }, key, {
		expiresIn: expiry,
	});
};
const verifyUserToken = (req, res, next) => {
	const accessToken = req.headers.authorization;

	if (accessToken) {
		const token = accessToken.split(" ")[1];

		jwt.verify(token, process.env.SCRETE_KEY, (err, user) => {
			if (err) {
				return res.status(403).json({ message: "Token is invalid" });
			}
			req.user = user;
			next();
		});
	} else {
		return res.status(401).json({ message: "Unauthorized Acesss" });
	}
};

const verifyLecturerToken = (req, res, next) => {
	const accessToken = req.headers.authorization;

	if (accessToken) {
		const token = accessToken.split(" ")[1];

		jwt.verify(token, process.env.SCRETE_KEY, (err, user) => {
			if (err) {
				return res.status(403).json({ message: "Token is invalid" });
			}
			if (user.role != "lecturer") {
				return res.status(401).json({ message: "Unauthorized Acesss" });
			}
			req.user = user;
			next();
		});
	} else {
		return res.status(401).json({ message: "Unauthorized Acesss" });
	}
};
const verifyStaffToken = (req, res, next) => {
	const accessToken = req.headers.authorization;

	if (accessToken) {
		const token = accessToken.split(" ")[1];

		jwt.verify(token, process.env.SCRETE_KEY, (err, user) => {
			if (err) {
				return res.status(403).json({ message: "Token is invalid" });
			}

			if (user.role != "staff") {
				return res.status(401).json({ message: "Unauthorized Acesss" });
			}
			req.user = user;
			next();
		});
	} else {
		return res.status(401).json({ message: "Unauthorized Acesss" });
	}
};
module.exports = {
	generateToken,
	verifyUserToken,
	verifyLecturerToken,
	verifyStaffToken,
};
