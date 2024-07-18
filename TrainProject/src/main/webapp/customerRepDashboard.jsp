<!DOCTYPE html>
<html>
<head>
    <title>Customer Rep Dashboard</title>
    <style>
.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px;
    border-bottom: 1px solid #ccc;
}
.top-right {
    position: absolute;
    top: 10px;
    right: 10px;
}
.logo img {
    height: 110px;
    cursor: pointer;
}
</style>
    <style>
        .button {
            display: block;
            width: 200px;
            margin: 10px auto;
            padding: 10px;
            text-align: center;
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        .button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
<div class="header">
    <div class="logo">
        <a href="SearchServlet">
            <img src="group17-logo.png" alt="Group 17 Transit Logo">
        </a>
    </div>
    <div class="top-right">
        <form method="post" action="logout">
            <input type="submit" value="Logout">
        </form>
    </div>
</div>
    <h1>Customer Representative Dashboard</h1>
    <a href="AdminStationServlet" class="button">Edit Train Schedules</a>
    <a href="ForumServlet" class="button">Customer Forum</a>
    <a href="ProduceSchedulesServlet" class="button">List Train Schedules</a>
    <a href="ListCustomersServlet" class="button">List Customers</a>
</body>
</html>