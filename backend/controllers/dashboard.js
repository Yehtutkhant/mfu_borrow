const db = require("../helpers/db");

const getStats = async (_req, res) => {
	const q =
		" SELECT category, status, COUNT(*) AS count FROM asset GROUP BY category, status";
	try {
		const result = await db.query(q);

		const stats = result[0].reduce((acc, row) => {
			const { category, status, count } = row;
			let categoryEntry = acc.find((c) => c.category === category);
			if (!categoryEntry) {
				categoryEntry = { category, statuses: [], totalCount: 0 };
				acc.push(categoryEntry);
			}

			// Add status count
			categoryEntry.statuses.push({ status, count });
			categoryEntry.totalCount += count;

			return acc;
		}, []);
		return res.status(200).json({
			data: stats,
		});
	} catch (err) {
		console.log(err);
		return res.status(500).json({
			message: "Server Error!",
		});
	}
};

module.exports = {
	getStats,
};
