const db = require("../helpers/db");

const borrow = async (req, res) => {
	const q1 =
		"SELECT * FROM borrow WHERE DATE(requested_at) = CURDATE() AND (status = 'Pending' OR status = 'Approved' OR status = 'Disapproved') AND student_id = ?";
	const q2 =
		"INSERT INTO borrow (student_id, asset_id, borrow_date, return_date, request_note) VALUES (?, ?, ?, ?, ?) ";
	const q3 = "UPDATE asset SET status = 'Onholded' WHERE asset_id = ? ";
	const q4 = "SELECT status from asset WHERE asset_id = ?";

	const student_id = req.user.id;
	const { id, asset_id, borrow_date, return_date, request_note } = req.body;

	try {
		const requests = await db.query(q1, [student_id]);
		if (requests[0].length > 0) {
			return res.status(400).json({
				message: "You already have borrowed an asset today!",
			});
		}

		const asset = await db.query(q4, [asset_id]);
		if (asset[0][0].status != "Available") {
			return res.status(400).json({
				message: "The asset has been already holded by other!",
			});
		}
		await db.query(q2, [
			student_id,
			id,
			borrow_date,
			return_date,
			request_note,
		]);

		await db.query(q3, [asset_id]);

		return res.status(201).json({
			message: "Asset borrowed successfully!",
		});
	} catch (err) {
		console.log(err);
		return res.status(500).json({
			message: "Server Error!",
		});
	}
};

//show requests (student)
const studentRequests = async (req, res) => {
	const q =
		"SELECT b.id, a.asset_id, a.asset_name, a.asset_image, a.category, a.location, u.username as validator, b.request_note, DATE_FORMAT(b.borrow_date, '%D %M, %Y') as borrow_date, DATE_FORMAT(b.return_date, '%D %M, %Y') as return_date, b.status FROM borrow b INNER JOIN asset a ON b.asset_id = a.id LEFT JOIN user u ON b.validator_id = u.user_id WHERE b.student_id = ?  AND ((b.status = 'Pending') OR (b.status IN ('Approved', 'Disapproved') AND b.requested_at >= DATE_SUB(CURDATE(), INTERVAL 2 DAY))) ORDER BY requested_at DESC";
	const student_id = req.user.id;

	try {
		const requests = await db.query(q, [student_id]);
		if (requests[0].length == 0) {
			return res.status(404).json({
				message: "No requests to show!",
			});
		}

		return res.status(200).json({
			data: requests[0],
		});
	} catch (err) {
		console.log(err);
		return res.status(500).json({
			message: "Server Error!",
		});
	}
};

//show requests (lecturer)
const lecturerRequests = async (req, res) => {
	let q =
		"SELECT b.id, a.asset_id, a.asset_name, a.asset_image, a.category, u.username as borrower, DATE_FORMAT(b.borrow_date, '%D %M, %Y') as borrow_date, DATE_FORMAT(b.return_date, '%D %M, %Y') as return_date, b.request_note from borrow b INNER JOIN asset a ON b.asset_id = a.id INNER JOIN user u ON b.student_id = u.user_id WHERE b.status = 'Pending'";
	const { category, borrow_date, return_date, student_id } = req.query;
	const queryParams = [];
	if (category && category !== "Select All") {
		q += " AND a.category = ?";
		queryParams.push(category);
	}
	if (borrow_date) {
		q += " AND b.borrow_date >= ?";
		queryParams.push(borrow_date);
	}
	if (return_date) {
		q += " AND b.return_date <= ?";
		queryParams.push(return_date);
	}
	if (student_id) {
		q += " AND b.student_id = ?";
		queryParams.push(student_id);
	}
	q += " ORDER BY requested_at DESC";
	try {
		const requests = await db.query(q, queryParams);
		if (requests[0].length == 0) {
			return res.status(404).json({
				message: "No pending requests yet!",
			});
		}

		return res.status(200).json({
			data: requests[0],
		});
	} catch (err) {
		console.log(err);
		return res.status(500).json({
			message: "Server Error!",
		});
	}
};

//show returns (staff)
const staffReturns = async (req, res) => {
	let q =
		"SELECT b.id, a.asset_id, a.asset_name, a.asset_image, a.category, us.username as borrower, uv.username as validator, DATE_FORMAT(b.borrow_date, '%D %M, %Y') as borrow_date, DATE_FORMAT(b.return_date, '%D %M, %Y') as return_date, b.request_note from borrow b INNER JOIN asset a ON b.asset_id = a.id INNER JOIN user us ON b.student_id = us.user_id INNER JOIN user uv ON b.validator_id = uv.user_id WHERE b.status = 'Approved'";
	const { category, borrow_date, return_date, student_id } = req.query;

	const queryParams = [];
	if (category && category !== "Select All") {
		q += " AND a.category = ?";
		queryParams.push(category);
	}
	if (borrow_date) {
		q += " AND b.borrow_date >= ?";
		queryParams.push(borrow_date);
	}
	if (return_date) {
		q += " AND b.return_date <= ?";
		queryParams.push(return_date);
	}
	if (student_id) {
		q += " AND b.student_id = ?";
		queryParams.push(student_id);
	}
	q += " ORDER BY requested_at DESC";
	try {
		const requests = await db.query(q, queryParams);
		if (requests[0].length == 0) {
			return res.status(404).json({
				message: "No assets to return yet!",
			});
		}
		return res.status(200).json({
			data: requests[0],
		});
	} catch (err) {
		console.log(err);
		return res.status(500).json({
			message: "Server Error!",
		});
	}
};

//validate
const validateRequest = async (req, res) => {
	const q1 = "SELECT * from borrow WHERE id = ?";
	const q2 =
		"UPDATE borrow SET validator_id = ?, validated_date = NOW(), status = ? WHERE id = ?";
	const q3 = "UPDATE asset SET status = ? WHERE id = ?";

	const validator_id = req.user.id;
	const { borrow_id, borrow_status } = req.body;
	let asset_status = "";

	try {
		const request = await db.query(q1, [borrow_id]);
		if (request[0][0].status == "Approved") {
			return res.status(400).json({
				message: "This request has already been approved",
			});
		} else if (request[0][0].status == "Disapproved") {
			return res.status(400).json({
				message: "This request has already been disapproved",
			});
		} else if (request[0][0].status == "Canceled") {
			return res.status(400).json({
				message: "This request has already been canceled",
			});
		} else if (request[0][0].status == "Returned") {
			return res.status(400).json({
				message: "This request has already been returned",
			});
		}
		borrow_status === "Approved"
			? (asset_status = "Borrowed")
			: (asset_status = "Available");

		await db.query(q2, [validator_id, borrow_status, borrow_id]);

		await db.query(q3, [asset_status, request[0][0].asset_id]);
		res.status(201).json({
			message: "Validated successfully!",
		});
	} catch (err) {
		console.log(err);
		return res.status(500).json({
			message: "Server Error!",
		});
	}
};

//return
const returnAsset = async (req, res) => {
	const q1 = "SELECT * from borrow WHERE id = ?";
	const q2 = "UPDATE borrow SET status = 'Returned' WHERE id = ?";
	const q3 = "UPDATE asset SET status = 'Available' WHERE id = ?";

	const { borrow_id } = req.body;

	try {
		const request = await db.query(q1, [borrow_id]);
		if (request[0][0].status == "Pending") {
			return res.status(400).json({
				message: "This asset with pending request cannot be returned",
			});
		} else if (request[0][0].status == "Disapproved") {
			return res.status(400).json({
				message: "This asset with disapproved request cannot be returned",
			});
		} else if (request[0][0].status == "Canceled") {
			return res.status(400).json({
				message: "This asset with canceled request cannot be returned",
			});
		} else if (request[0][0].status == "Returned") {
			return res.status(400).json({
				message: "This asset has already been returned",
			});
		}

		await db.query(q2, [borrow_id]);

		await db.query(q3, [request[0][0].asset_id]);
		res.status(201).json({
			message: "Asset returned successfully!",
		});
	} catch (err) {
		console.log(err);
		return res.status(500).json({
			message: "Server Error!",
		});
	}
};
//cancel
const cancelRequest = async (req, res) => {
	const q1 = "SELECT * FROM borrow WHERE id = ?";
	const q2 = "UPDATE borrow SET status = 'Canceled' WHERE id = ?";
	const q3 = "UPDATE asset SET status = 'Available' WHERE id = ?";

	const student_id = req.user.id;
	const { borrow_id } = req.body;

	try {
		const request = await db.query(q1, [borrow_id]);
		if (request[0][0].status != "Pending") {
			return res.status(400).json({
				message: `${request[0][0].status} request cannot be canceled!`,
			});
		}
		if (request[0][0].student_id != student_id) {
			return res.status(400).json({
				message: `Unauthorized user to cancel!`,
			});
		}
		await db.query(q2, [borrow_id]);
		await db.query(q3, [request[0][0].asset_id]);

		return res.status(201).json({
			message: "Request canceled successfully!",
		});
	} catch (err) {
		console.log(err);
		return res.status(500).json({
			message: "Server Error!",
		});
	}
};

//student history
const studentHistory = async (req, res) => {
	let q =
		"SELECT b.id, a.asset_name, a.asset_image, a.category, u.username as validator, DATE_FORMAT(b.borrow_date, '%D %M, %Y') as borrow_date, DATE_FORMAT(b.return_date, '%D %M, %Y') as return_date, b.status, b.request_note from borrow b INNER JOIN asset a ON b.asset_id = a.id INNER JOIN user u ON b.validator_id = u.user_id WHERE b.student_id = ? AND b.status IN (?)";
	const student_id = req.user.id;
	const { asset_name, category, borrow_status, borrow_date, return_date } =
		req.query;
	const queryParams = [student_id];

	if (borrow_status !== "" && borrow_status !== "Select All") {
		queryParams.push(borrow_status);
	} else {
		queryParams.push(["Approved", "Returned"]);
	}
	if (asset_name) {
		q += " AND a.asset_name LIKE ?";
		queryParams.push(`%${asset_name}%`);
	}
	if (category && category !== "Select All") {
		q += " AND a.category = ?";
		queryParams.push(category);
	}
	if (borrow_date) {
		q += " AND b.borrow_date >= ?";
		queryParams.push(borrow_date);
	}
	if (return_date) {
		q += " AND b.return_date <= ?";
		queryParams.push(return_date);
	}
	q += " ORDER BY requested_at DESC";
	console.log(queryParams);

	try {
		const requests = await db.query(q, queryParams);
		if (requests[0].length == 0) {
			return res.status(404).json({
				message: "No history to show!",
			});
		}
		return res.status(200).json({
			data: requests[0],
		});
	} catch (err) {
		console.log(err);
		return res.status(500).json({
			message: "Server Error!",
		});
	}
};

//lecturer histoy
const lecturerHistory = async (req, res) => {
	let q =
		"SELECT b.id, a.asset_name, a.asset_image, a.category, u.username as borrower, DATE_FORMAT(b.borrow_date, '%D %M, %Y') as borrow_date, DATE_FORMAT(b.return_date, '%D %M, %Y') as return_date, b.status, b.request_note from borrow b INNER JOIN asset a ON b.asset_id = a.id INNER JOIN user u ON b.student_id = u.user_id WHERE b.validator_id = ? AND b.status IN (?)";
	const validator_id = req.user.id;
	const { asset_name, category, borrow_status, borrow_date, return_date } =
		req.query;
	const queryParams = [validator_id];

	if (borrow_status !== "" && borrow_status !== "Select All") {
		queryParams.push(borrow_status);
	} else {
		queryParams.push(["Approved", "Disapproved", "Returned"]);
	}
	if (asset_name) {
		q += " AND a.asset_name LIKE ?";
		queryParams.push(`%${asset_name}%`);
	}
	if (category && category !== "Select All") {
		q += " AND a.category = ?";
		queryParams.push(category);
	}
	if (borrow_date) {
		q += " AND b.borrow_date >= ?";
		queryParams.push(borrow_date);
	}
	if (return_date) {
		q += " AND b.return_date <= ?";
		queryParams.push(return_date);
	}
	q += " ORDER BY requested_at DESC";
	console.log(queryParams);
	try {
		const requests = await db.query(q, queryParams);
		if (requests[0].length == 0) {
			return res.status(404).json({
				message: "No history to show!",
			});
		}
		return res.status(200).json({
			data: requests[0],
		});
	} catch (err) {
		console.log(err);
		return res.status(500).json({
			message: "Server Error!",
		});
	}
};

//staff history
const staffHistory = async (req, res) => {
	let q =
		"SELECT b.id, a.asset_name, a.asset_image, a.category, us.username as borrower, uv.username as validator, DATE_FORMAT(b.borrow_date, '%D %M, %Y') as borrow_date, DATE_FORMAT(b.return_date, '%D %M, %Y') as return_date, b.status, b.request_note from borrow b INNER JOIN asset a ON b.asset_id = a.id INNER JOIN user us ON b.student_id = us.user_id INNER JOIN user uv ON b.student_id = uv.user_id WHERE b.status IN (?)";

	const { asset_name, category, borrow_status, borrow_date, return_date } =
		req.query;
	const queryParams = [];

	if (borrow_status != "" && borrow_status !== "Select All") {
		queryParams.push(borrow_status);
	} else {
		queryParams.push(["Approved", "Disapproved", "Returned", "Canceled"]);
	}
	if (asset_name) {
		q += " AND a.asset_name LIKE ?";
		queryParams.push(`%${asset_name}%`);
	}
	if (category && category !== "Select All") {
		q += " AND a.category = ?";
		queryParams.push(category);
	}
	if (borrow_date) {
		q += " AND b.borrow_date >= ?";
		queryParams.push(borrow_date);
	}
	if (return_date) {
		q += " AND b.return_date <= ?";
		queryParams.push(return_date);
	}
	q += " ORDER BY requested_at DESC";

	try {
		const requests = await db.query(q, queryParams);

		if (requests[0].length == 0) {
			return res.status(404).json({
				message: "No history to show!",
			});
		}
		return res.status(200).json({
			data: requests[0],
		});
	} catch (err) {
		console.log(err);
		return res.status(500).json({
			message: "Server Error!",
		});
	}
};

module.exports = {
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
};
