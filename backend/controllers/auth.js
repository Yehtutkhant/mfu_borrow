const db = require("../helpers/db");
const bcrypt = require("bcrypt");
const { validateLogin, validateRegister } = require("../helpers/validator");
const { generateToken } = require("../helpers/auth");
require("dotenv").config();

const login = async (req, res) => {
	const q = "SELECT * FROM user WHERE email = ? ";

	try {
		const { error, value } = validateLogin(req.body);

		if (error) {
			return res.status(400).json({ message: "Invalid Inputs" });
		}

		const user = await db.query(q, [value.email]);

		if (user[0].length == 0) {
			return res.status(400).json({
				message: "Invalid credentials!",
			});
		} else {
			bcrypt.compare(
				value.password,
				user[0][0].password,
				function (err, result) {
					if (err) {
						console.log(err);
						return res.status(500).json({ message: "Server Error!" });
					}

					if (!result) {
						return res.status(400).json({ message: "Invalid credentials!" });
					} else {
						const accessToken = generateToken(
							user[0][0],
							process.env.SCRETE_KEY,
							"30d",
						);

						return res.status(201).json({ accessToken });
					}
				},
			);
		}
	} catch (err) {
		console.log(err);
		return res.status(500).json({ message: "Server Error!" });
	}
};

const register = async (req, res) => {
	const q1 = "SELECT * FROM user WHERE email = ? OR student_id = ?";
	const q2 =
		"INSERT INTO user (username, email, password, student_id) VALUES (?, ?, ?, ?)";

	try {
		const { error, value } = validateRegister(req.body);

		if (error) {
			return res.status(400).json({ message: "Invalid Inputs" });
		}
		const user = await db.query(q1, [value.email, value.student_id]);
		if (user[0].length !== 0) {
			return res.status(400).json({ message: "User already exists!" });
		} else {
			bcrypt.hash(value.password, 10, async function (err, hash) {
				if (err) {
					console.log(err);
					return res.status(500).json({ message: "Server Error!" });
				} else {
					await db.query(q2, [
						value.username,
						value.email,
						hash,
						value.student_id,
					]);

					return res.status(201).json({
						message: "Registered successfully!",
					});
				}
			});
		}
	} catch (err) {
		console.log(err);
		return res.status(500).json({ message: "Server Error!" });
	}
};

module.exports = {
	login,
	register,
};
