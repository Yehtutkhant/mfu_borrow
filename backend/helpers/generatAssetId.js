const { v4: uuidv4 } = require("uuid");

function generateAssetId() {
	const uuid = uuidv4();
	const numericID = parseInt(uuid.replace(/-/g, "").slice(0, 8), 16);
	const sixDigitID = numericID % 1000000;
	return sixDigitID.toString().padStart(6, "0");
}

module.exports = {
	generateAssetId,
};
