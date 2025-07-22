const db = require("../helpers/db");
const cloudinary = require("cloudinary").v2;
const { validateProfileEdit } = require("../helpers/validator");
const { getPublicIdFromUrl } = require("../helpers/getPublicIdFromURL");

const getProfile = async (req, res) => {
	const q = "SELECT * FROM user WHERE user_id = ?";
	const user_id = req.user.id;

	try {
		const result = await db.query(q, [user_id]);

		const { password, ...user } = result[0][0];

		return res.status(200).json({
			user,
		});
	} catch (err) {
		console.log(err);
		return res.status(500).json({
			message: "Server Error!",
		});
	}
};

const editProfile = async (req, res) => {
	const q1 = "SELECT profile_image from user WHERE user_id = ?";
	const q2 =
		"UPDATE user SET username = ?, email = ?, student_id = ?, profile_image = ? WHERE user_id = ?";
	const q3 = "SELECT * FROM user WHERE email = ? OR student_id = ?";
	const user_id = req.user.id;
	let profile_image = null;

	try {
		const { error, value } = validateProfileEdit(req.body);
		if (error) {
			if (req.file) {
				const result = await cloudinary.uploader.destroy(req.file.filename);
				if (result.result != "ok") {
					console.log(result);
					return res.status(500).json({
						message: "Server Error C!",
					});
				}
			}
			return res.status(400).json({ message: error.details[0].message });
		}
		const user = await db.query(q3, [value.email, value.student_id]);

		if (user[0].length != 0 && user_id != user[0][0].user_id) {
			if (req.file) {
				const result = await cloudinary.uploader.destroy(req.file.filename);
				if (result.result != "ok") {
					console.log(result);
					return res.status(500).json({
						message: "Server Error B!",
					});
				}
			}
			return res
				.status(400)
				.json({ message: "Email or student_id used by other!" });
		}
		if (req.file) {
			const profile = await db.query(q1, [user_id]);

			//delete old profile image in cloudinary
			if (profile[0][0].profile_image) {
				const publicId = getPublicIdFromUrl(profile[0][0].profile_image);

				const result = await cloudinary.uploader.destroy(publicId);
				if (result.result != "ok") {
					console.log(result);
					return res.status(400).json({
						message: "Server Erorr C!",
					});
				}
			}

			//create url for new image
			const url = cloudinary.url(req.file.filename, {
				secure: true,
				transformation: [
					{
						quality: "auto",
					},
					{
						fetch_format: "auto",
					},
				],
			});
			profile_image = url;
		}

		await db.query(q2, [
			value.username,
			value.email,
			value.student_id,
			profile_image,
			user_id,
		]);
		return res.status(201).json({
			message: "Profile updated successfully!",
		});
	} catch (err) {
		console.log(err);
		return res.status(500).json({
			message: "Server Error!",
		});
	}
};

module.exports = {
	getProfile,
	editProfile,
};
