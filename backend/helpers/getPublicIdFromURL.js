const cloudinary = require("cloudinary").v2;

function getPublicIdFromUrl(cloudinaryUrl) {
	// Split the URL at '/v1/' and take the part after it
	const parts = cloudinaryUrl.split("/v1/");
	if (parts.length < 2) {
		throw new Error("Invalid Cloudinary URL format");
	}

	// Remove the file extension if there is one (like .jpeg, .jpg, etc.)
	const publicId = decodeURIComponent(parts[1]); // Removes file extension if present

	return publicId;
}

module.exports = {
	getPublicIdFromUrl,
};
