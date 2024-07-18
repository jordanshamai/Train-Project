<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
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
    <h1>Admin Dashboard</h1>
    <a href="ManageCustomerRepServlet" class="button">Add/Edit/Delete Customer Rep</a>
    <a href="salesReport.jsp" class="button">Sales Reports Per Month</a>
    <a href="listReservation.jsp" class="button">List Reservations</a>
    <a href="listRevenue.jsp" class="button">Listing Revenue</a>
    <a href="BestCustomerServlet" class="button">Best Customer</a>
    <a href="MostActiveTransitLinesServlet" class="button">Most Active Transit Lines</a>
</body>
</html>
