const cloudinary = require("cloudinary").v2;
const multer = require("multer");
const { CloudinaryStorage } = require("multer-storage-cloudinary");
const { v4: uuidv4 } = require("uuid");
require("dotenv").config;

cloudinary.config({
	cloud_name: process.env.CLOUD_NAME,
	api_key: process.env.CLOUDINARY_API_KEY,
	api_secret: process.env.CLOUDINARY_SECRETE_API_KEY,
});

const storage = (path) => {
	return new CloudinaryStorage({
		cloudinary: cloudinary,
		params: {
			folder: `MFU BORROW/${path}`,
			format: async (_, file) => "jpeg",
			public_id: (_, file) => {
				const uniqueFileName = uuidv4();
				console;
				return `${file.originalname.replace(/\s+/g, "_")}_${uniqueFileName}`;
			},
		},
	});
};

const upload = (path) => multer({ storage: storage(path) });

module.exports = {
	upload,
};
