<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page session="true" %>
<%
    String employeeName = (String) session.getAttribute("employeeName");

    if (employeeName == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>List Reservations</title>
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
        .form-section {
            margin-bottom: 20px;
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
    <button onclick="window.location.href='adminDashboard.jsp'">Back to Dashboard</button>
    <div class="top-right">
        <form method="post" action="logout">
            <input type="submit" value="Logout">
        </form>
    </div>
</div>
<h2>Hello, <%= employeeName %></h2>

<div class="form-section">
    <h3>List Reservations by Transit Line</h3>
    <form action="ListReservationServlet" method="post">
        <label for="lineId">Transit Line ID:</label>
        <input type="text" id="lineId" name="lineId" required>
        <input type="hidden" name="action" value="byLine">
        <input type="submit" value="Search">
    </form>
</div>

<div class="form-section">
    <h3>List Reservations by Customer Name</h3>
    <form action="ListReservationServlet" method="post">
        <label for="firstName">First Name:</label>
        <input type="text" id="firstName" name="firstName" required>
        <label for="lastName">Last Name:</label>
        <input type="text" id="lastName" name="lastName" required>
        <input type="hidden" name="action" value="byCustomer">
        <input type="submit" value="Search">
    </form>
</div>

<%
    List<Map<String, String>> reservations = (List<Map<String, String>>) request.getAttribute("reservations");
    if (reservations != null && !reservations.isEmpty()) {
%>
        <h3>Reservations</h3>
        <table border="1">
            <tr>
                <th>Reservation ID</th>
                <th>Customer ID</th>
                <th>Line ID</th>
                <th>Departure Date Time</th>
                <th>Calculated Fare</th>
            </tr>
<%
        for (Map<String, String> reservation : reservations) {
%>
            <tr>
                <td><%= reservation.get("ReservationId") %></td>
                <td><%= reservation.get("CustomerId") %></td>
                <td><%= reservation.get("LineId") %></td>
                <td><%= reservation.get("DepartureDateTime") %></td>
                <td><%= reservation.get("CalculatedFare") %></td>
            </tr>
<%
        }
%>
        </table>
<%
    } else if (request.getAttribute("message") != null) {
%>
        <p><%= request.getAttribute("message") %></p>
<%
    }
%>

</body>
</html>
