<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Reservations</title>
    
    <style>
        table {
            width: 70%;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
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

    <h2>Your Reservations</h2>
    <%
        List<Map<String, String>> reservations = (List<Map<String, String>>) session.getAttribute("reservations");
        if (reservations != null && !reservations.isEmpty()) {
    %>
        <table>
            <tr>
                <th>Departure Time</th>
                <th>Origin</th>
                <th>Destination</th>
                <th>Line Name</th>
                <th>Train Number</th>
                <th>Fare Type</th>
                <th>Round Trip</th>
                <th>Total Fare</th>
                <th>Actions</th>
            </tr>
            <% for (Map<String, String> reservation : reservations) { %>
                <tr>
                    <td><%= reservation.get("DepartureTime") %></td>
                    <td><%= reservation.get("Origin") %></td>
                    <td><%= reservation.get("Destination") %></td>
                    <td><%= reservation.get("LineName") %></td>
                    <td><%= reservation.get("TrainNumber") %></td>
                    <td><%= reservation.get("FareType") %></td>
                    <td><%= reservation.get("RoundTrip") %></td>
                    <td><%= reservation.get("TotalFare") %></td>
                    <td>
                        <form method="post" action="ReservationServlet">
                            <input type="hidden" name="action" value="handleDeleteReservation">
                            <input type="hidden" name="reservationId" value="<%= reservation.get("ReservationId") %>">
                            <input type="submit" value="Delete">
                        </form>
                    </td>
                </tr>
            <% } %>
        </table>
    <% } else { %>
        <p>No reservations found.</p>
    <% } %>
</body>
</html>
