<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reservation Cart</title>
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
    <script>
        function confirmReservation(totalCost) {
            return confirm("You are about to make a reservation for " + totalCost + ". Are you sure?");
        }
    </script>
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

    <h2>Your Reservation Cart</h2>
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
                <th>Actions</th>
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
                    <td><%= reservation.get("CalculatedFare") %></td>
                    <td>
                        <form method="post" action="CartServlet">
                            <input type="hidden" name="action" value="handleDeleteReservationPost">
                            <input type="hidden" name="reservationIndex" value="<%= i %>">
                            <input type="submit" value="Delete">
                        </form>
                    </td>
                </tr>
            <% } %>
        </table>

        <h3>Select Fare Type</h3>
        <form method="post" action="CartServlet">
            <%
                String selectedFareType = request.getParameter("fareType");
                String roundTripValue = request.getParameter("roundTrip");
                List<Map<String, String>> fareTypes = (List<Map<String, String>>) request.getAttribute("fareTypes");
                if (fareTypes != null) {
                    for (Map<String, String> fareType : fareTypes) { 
                        String fareTypeId = fareType.get("FareTypeId");
                        String fareTypeName = fareType.get("FareTypeName");
                        boolean isSelected = fareTypeId.equals(selectedFareType);
            %>
                        <input type="radio" id="fareType<%= fareTypeId %>" name="fareType" value="<%= fareTypeId %>" <%= isSelected ? "checked" : "" %> required>
                        <label for="fareType<%= fareTypeId %>"><%= fareTypeName %></label><br>
            <%      }
                }
            %>
            <h3>Round Trip</h3>
            <input type="radio" id="oneWay" name="roundTrip" value="false" <%= "false".equals(roundTripValue) ? "checked" : "" %> required>
            <label for="oneWay">One Way</label><br>
            <input type="radio" id="roundTrip" name="roundTrip" value="true" <%= "true".equals(roundTripValue) ? "checked" : "" %> required>
            <label for="roundTrip">Round Trip</label><br><br>
            
            <input type="hidden" name="action" value="calculateCost">
            <input type="submit" value="Calculate Cost">
            <button type="button" onclick="history.back()">Back</button>
        </form>

        <%
            
        	String totalCostString = "";
            double totalCostValue = 0.0;
            if (request.getAttribute("totalCost") != null) {
            	totalCostString = request.getAttribute("totalCost").toString();
	            if (totalCostString != null && !totalCostString.isEmpty()) {
	                try {
	                    totalCostValue = Double.parseDouble(totalCostString);
	                } catch (NumberFormatException e) {
	                    totalCostValue = 0.0; // or handle the error appropriately
	                }
	            }
            }
            String formattedTotalCost = String.format(Locale.US, "$%,.2f", totalCostValue);
        %>

        <% if (totalCostValue > 0) { %>
            <h3>Ready to Reserve?</h3>
            <div id="calculatedCost">Your Reservation Cost: <%= formattedTotalCost %></div>
            <br>
            <form method="post" action="ReservationServlet" onsubmit="return confirmReservation('<%= formattedTotalCost %>')">
                <input type="hidden" name="action" value="handleCreateReservation">
                <input type="submit" value="Create Reservation">
            </form>
        <% } %>
    <% } else { %>
        <p>Your cart is empty.</p>
    <% } %>
</body>
</html>
