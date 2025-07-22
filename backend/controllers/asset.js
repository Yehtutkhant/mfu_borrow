const db = require("../helpers/db");
const { generateAssetId } = require("../helpers/generatAssetId");
const cloudinary = require("cloudinary").v2;
const { getPublicIdFromUrl } = require("../helpers/getPublicIdFromURL");

const createAsset = async (req, res) => {
	const q =
		"INSERT INTO asset (asset_id, asset_name, category, description, location, status, asset_image) VALUES (?, ?, ?, ?, ?, ?, ?)";
	const { asset_name, category, description, location, status } = req.body;

	try {
		if (
			!asset_name ||
			!category ||
			!description ||
			!location ||
			!status ||
			!req.file
		) {
			if (req.file) {
				//delete the uploaded photo
				const result = await cloudinary.uploader.destroy(req.file.filename);

				if (result.result != "ok") {
					console.log(result);
					return res.status(500).json({
						message: "Server Error!",
					});
				}
			}
			return res.status(400).json({
				message: "All fields must be provided!",
			});
		}
		//generate random unique asset id
		const asset_id = generateAssetId();

		//format the image url
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
		await db.query(q, [
			asset_id,
			asset_name,
			category,
			description,
			location,
			status,
			url,
		]);

		return res.status(201).json({
			message: "Asset created successfully!",
		});
	} catch (err) {
		console.log(err);
		return res.status(500).json({
			message: "Server Error!",
		});
	}
};

const editAsset = async (req, res) => {
	const q1 = "SELECT * from asset WHERE asset_id = ?";
	const q2 =
		"UPDATE asset SET asset_name = ?, category = ?, description = ?, location = ?, status = ? WHERE asset_id = ?";
	const q3 = "UPDATE asset SET asset_image = ? WHERE asset_id = ?";
	const { id, asset_name, category, description, location, status } = req.body;

	try {
		//no need to check image beacuse user may not change the existing image and so image here can be null
		if (!asset_name || !category || !description || !location || !status) {
			if (req.file) {
				//delete the uploaded photo
				const result = await cloudinary.uploader.destroy(req.file.filename);
				if (result.result != "ok") {
					console.log(result);
					return res.status(500).json({
						message: "Server Error!",
					});
				}
			}
			return res.status(400).json({
				message: "All fields must be provided!",
			});
		}

		const old_asset = await db.query(q1, [id]);

		if (old_asset[0].length == 0) {
			if (req.file) {
				//delete the uploaded photo
				const result = await cloudinary.uploader.destroy(req.file.filename);
				if (result.result != "ok") {
					console.log(result);
					return res.status(500).json({
						message: "Server Erorr!",
					});
				}
			}
			return res.status(404).json({
				message: "No asset found to be edited!",
			});
		}

		if (req.file) {
			//delete old image in cloudinary
			const publicId = getPublicIdFromUrl(old_asset[0][0].asset_image);

			const result = await cloudinary.uploader.destroy(publicId);
			if (result.result != "ok") {
				console.log(result);
				return res.status(400).json({
					message: "Server Erorr!",
				});
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

			//update asset_image in db
			await db.query(q3, [url, id]);
		}
		await db.query(q2, [
			asset_name,
			category,
			description,
			location,
			status,
			id,
		]);

		return res.status(201).json({
			message: "Asset edited successfully!",
		});
	} catch (err) {
		console.log(err);
		return res.status(500).json({
			message: "Server Error!",
		});
	}
};

const getAssets = async (req, res) => {
	const q =
		"SELECT * FROM asset WHERE asset_name LIKE ? AND category IN (?) ORDER BY id DESC LIMIT ? OFFSET ?";
	const defaultCategories = [
		"Laptop",
		"Book",
		"Projector",
		"Lab Tool",
		"Audio-Visual",
		"Entertainment",
	];
	const limit = parseInt(req.query.limit) || 10;
	const page = parseInt(req.query.page) || 1;
	const asset_name = req.query.asset_name || "";
	let category = req.query.category || defaultCategories;

	const offset = (page - 1) * limit;

	if (typeof category === "string") {
		category = [category];
	}

	try {
		const assets = await db.query(q, [
			`%${asset_name}%`,
			category,
			limit,
			offset,
		]);

		if (assets[0].length == 0) {
			return res.status(404).json({
				message: "No assets found!",
			});
		}

		return res.status(200).json({
			data: assets[0],
		});
	} catch (err) {
		console.log(err);
		return res.status(500).json({
			message: "Server Error!",
		});
	}
};

const getAsset = async (req, res) => {
	const q = "SELECT * from asset WHERE id = ?";
	const id = req.params.id;

	try {
		const asset = await db.query(q, [id]);
		return res.status(200).json({
			data: asset[0][0],
		});
	} catch (err) {
		console.log(err);
		return res.status(500).json({
			message: "Server Error!",
		});
	}
};

module.exports = {
	createAsset,
	editAsset,
	getAssets,
	getAsset,
};
