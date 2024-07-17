<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
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
    <h1>Admin Dashboard</h1>
    <a href="ManageCustomerRepServlet" class="button">Add/Edit/Delete Customer Rep</a>
    <a href="salesReport.jsp" class="button">Sales Reports Per Month</a>
    <a href="listReservation.jsp" class="button">List Reservations</a>
    <a href="listRevenue.jsp" class="button">Listing Revenue</a>
    <a href="BestCustomerServlet" class="button">Best Customer</a>
    <a href="MostActiveTransitLinesServlet" class="button">Most Active Transit Lines</a>
</body>
</html>
