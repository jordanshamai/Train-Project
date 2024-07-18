<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reservation</title>
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
        .content {
            padding: 20px;
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
         <button onclick="window.location.href='ForumServlet'">Have a Question?</button>
        <div class="top-right">
            <form method="post" action="LogoutServlet">
                <input type="submit" value="Logout">
            </form>  
        </div>
    </div>

    <div class="content">
        <h2>Your Reservation</h2>
        

        <%
            List<Map<String, String>> cart = (List<Map<String, String>>) session.getAttribute("cart");
            if (cart != null && !cart.isEmpty()) {
        %>
            <table border="1">
                <tr>
                    <th>Departure Date and Time</th>
                    <th>Origin Station Name</th>
                    <th>Destination Station Name</th>
                    <th>Line Name</th>
                    <th>Train Number</th>
                    <th>Cost</th>
                 
                </tr>
                <% for (int i = 0; i < cart.size(); i++) { 
                    Map<String, String> reservation = cart.get(i);
                %>
                    <tr>
                        <td><%= reservation.get("DepartureDateTime") %></td>
                        <td><%= reservation.get("OriginStationName") %></td>
                        <td><%= reservation.get("DestinationStationName") %></td>
                        <td>Northeast Corridor</td>
                        <td><%= reservation.get("TrainNumber") %></td>
                        <td><%= session.getAttribute("totalCost") %></td>
                    </tr>
                <% } %>
            <% } %>
            
            </table>
            <form method="post" action="ReservationServlet">
            <input type="hidden" name="action" value="handleReservationListViewPost">
            <input type="submit" value="View Reservations">
        </form>
        </div>
    </body>
</html>
