const express = require("express");
const authRoutes = require("./routes/auth");
const assetRoutes = require("./routes/asset");
const borrowRoutes = require("./routes/borrow");
const userRoutes = require("./routes/user");
const dashboardRoutes = require("./routes/dashboard");

const app = express();

//middlewares
app.use(express.json());

//routes
app.use("/", authRoutes);
app.use("/", assetRoutes);
app.use("/", borrowRoutes);
app.use("/", userRoutes);
app.use("/", dashboardRoutes);

app.listen(process.env.PORT, () => {
	console.log(`Server is up in ${process.env.PORT}`);
});
