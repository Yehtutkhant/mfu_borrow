const express = require("express");
const {
	createAsset,
	editAsset,
	getAssets,
	getAsset,
} = require("../controllers/asset");
const { upload } = require("../helpers/fileConfig");
const { verifyStaffToken } = require("../helpers/auth");

const router = express.Router();

router.post(
	"/api/asset",
	verifyStaffToken,
	upload("assets").single("asset_image"),
	createAsset,
);
router.put(
	"/api/asset",
	verifyStaffToken,
	upload("assets").single("asset_image"),
	editAsset,
);

router.get("/api/assets", getAssets);
router.get("/api/asset/:id", getAsset);

module.exports = router;
