const isCreateAssetFieldsEmpty = (req, res, next) => {
	const { asset_name, category, description, location, status, asset_image } =
		req.body;

	if (
		!asset_name ||
		!category ||
		!description ||
		!location ||
		!status ||
		!asset_image
	) {
		return res.status(400).json({
			message: "All fields must be provided!",
		});
	}
	next();
};

const isEditAssetFieldsEmpty = (req, res, next) => {
	const { asset_name, category, description, location, status } = req.body;

	if (!asset_name || !category || !description || !location || !status) {
		return res.status(400).json({
			message: "All fields must be provided!",
		});
	}
	next();
};

module.exports = {
	isCreateAssetFieldsEmpty,
	isEditAssetFieldsEmpty,
};
