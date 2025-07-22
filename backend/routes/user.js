const express = require("express");
const { verifyUserToken } = require("../helpers/auth");
const { getProfile, editProfile } = require("../controllers/user");
const { upload } = require("../helpers/fileConfig");

const router = express.Router();

router.get("/api/profile", verifyUserToken, getProfile);
router.put(
	"/api/profile",
	verifyUserToken,
	upload("profiles").single("profile_image"),
	editProfile,
);

module.exports = router;
