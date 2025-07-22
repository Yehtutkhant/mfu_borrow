const express = require("express");
const {
	verifyUserToken,
	verifyLecturerToken,
	verifyStaffToken,
} = require("../helpers/auth");
const {
	borrow,
	studentRequests,
	lecturerRequests,
	staffReturns,
	validateRequest,
	returnAsset,
	cancelRequest,
	studentHistory,
	lecturerHistory,
	staffHistory,
} = require("../controllers/borrow");

const router = express.Router();

router.post("/api/borrow", verifyUserToken, borrow);

router.get("/api/student_requests", verifyUserToken, studentRequests);
router.get("/api/lecturer_requests", verifyLecturerToken, lecturerRequests);
router.get("/api/staff_returns", verifyStaffToken, staffReturns);

router.put("/api/lecturer_requests", verifyLecturerToken, validateRequest);
router.put("/api/staff_returns", verifyStaffToken, returnAsset);
router.put("/api/student_requests", verifyUserToken, cancelRequest);

router.get("/api/student_history", verifyUserToken, studentHistory);
router.get("/api/lecturer_history", verifyLecturerToken, lecturerHistory);
router.get("/api/staff_history", verifyStaffToken, staffHistory);

module.exports = router;
