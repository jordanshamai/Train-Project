<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
<title>Search Trains</title>
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

<h2>Search for Train Schedules</h2>
<form method="post" action="SearchServlet">
    <label for="travelDate">Travel Date:</label>
    <%
        String travelDateParam = request.getParameter("travelDate");
        String formattedTravelDate = "";
        if (travelDateParam != null && !travelDateParam.isEmpty()) {
            try {
                SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
                Date date = inputFormat.parse(travelDateParam);
                SimpleDateFormat outputFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy");
                formattedTravelDate = outputFormat.format(date);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    %>
    <input type="date" id="travelDate" name="travelDate" value="<%= travelDateParam != null ? travelDateParam : "" %>" required>
    <br><br>
    <label for="departureAfterTime">Departure After Time:</label>
    <input type="time" id="departureAfterTime" name="departureAfterTime" value="<%= request.getParameter("departureAfterTime") != null ? request.getParameter("departureAfterTime") : "" %>" required><br><br>
    <label for="originStation">Origin Station:</label>
    <select id="originStation" name="originStation" required>
        <option value="">Select Origin Station</option>
        <% 
            List<Map<String, Object>> stations = (List<Map<String, Object>>) request.getAttribute("stations");
            String selectedOriginStation = request.getParameter("originStation");
            if (stations != null) {
                for (Map<String, Object> station : stations) { 
                    String stationId = station.get("StationId").toString();
                    String stationName = station.get("StationName").toString();
                    boolean isSelected = stationId.equals(selectedOriginStation);
        %>
                    <option value="<%= stationId %>" <%= isSelected ? "selected" : "" %>><%= stationName %></option>
        <%      }
            }
        %>
    </select><br><br>
    <label for="destinationStation">Destination Station:</label>
    <select id="destinationStation" name="destinationStation" required>
        <option value="">Select Destination Station</option>
        <% 
            String selectedDestinationStation = request.getParameter("destinationStation");
            if (stations != null) {
                for (Map<String, Object> station : stations) { 
                    String stationId = station.get("StationId").toString();
                    String stationName = station.get("StationName").toString();
                    boolean isSelected = stationId.equals(selectedDestinationStation);
        %>
                    <option value="<%= stationId %>" <%= isSelected ? "selected" : "" %>><%= stationName %></option>
        <%      }
            }
        %>
    </select><br><br>
    <input type="submit" value="Search">
    <button type="button" onclick="history.back()">Back</button>
</form>

<% 
    String travelDate = (String) request.getAttribute("travelDate");
    String departureAfterTime = (String) request.getAttribute("departureAfterTime");
    String formattedTravelDateForDisplay = "";
    String formattedDepartureTimeForDisplay = "";
    if (travelDate != null && !travelDate.isEmpty()) {
        try {
            SimpleDateFormat inputDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date date = inputDateFormat.parse(travelDate);
            SimpleDateFormat outputDateFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy");
            formattedTravelDateForDisplay = outputDateFormat.format(date);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    if (departureAfterTime != null && !departureAfterTime.isEmpty()) {
        try {
            SimpleDateFormat inputTimeFormat = new SimpleDateFormat("HH:mm");
            Date time = inputTimeFormat.parse(departureAfterTime);
            SimpleDateFormat outputTimeFormat = new SimpleDateFormat("h:mm a");
            formattedDepartureTimeForDisplay = outputTimeFormat.format(time);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    if (!formattedTravelDateForDisplay.isEmpty()) { %>
    <h2>Train Schedules for <%= formattedTravelDateForDisplay %></h2>
<% }
    if (!formattedDepartureTimeForDisplay.isEmpty()) { %>
    <h3>Trains departing after <%= formattedDepartureTimeForDisplay %></h3>
<% } %>

<% 
    List<Map<String, Object>> schedules = (List<Map<String, Object>>) request.getAttribute("schedules");
    if (schedules != null && !schedules.isEmpty()) { %>
    <table border="1">
        <tr>
            <th>Origin Station Name</th>
            <th>Departure Time</th>
            <th>Train Number</th>
            <th>Destination Station Name</th>
            <th>Arrival Time</th>
            <th>Total Travel Time (minutes)</th>
            <th>Cost</th>
            <th>Reserve</th>
        </tr>
        <% 
            for (Map<String, Object> schedule : schedules) { %>
        <tr>
            <td><%= schedule.get("OriginStationName") %></td>
            <td><%= schedule.get("DepartureTime") %></td>
            <td><%= schedule.get("TrainNumber") %></td>
            <td><%= schedule.get("DestinationStationName") %></td>
            <td><%= schedule.get("ArrivalTime") %></td>
            <td><%= schedule.get("TotalTravelTime") %></td>
            <%
                double calculatedFare = (Double) schedule.get("CalculatedFare");
                NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(Locale.US); // Change the locale as needed
                String formattedFare = currencyFormatter.format(calculatedFare);
            %>
            <td><%= formattedFare %></td>
            
            <td>
                <form method="post" action="CartServlet">
                    <input type="hidden" name="DepartureDateTime" value="<%= travelDate %> <%= schedule.get("DepartureTime") %>">
                    <input type="hidden" name="OriginStationId" value="<%= schedule.get("OriginStationId") %>">
                    <input type="hidden" name="DestinationStationId" value="<%= schedule.get("DestinationStationId") %>">
                    <input type="hidden" name="OriginStationName" value="<%= schedule.get("OriginStationName") %>">
                    <input type="hidden" name="DestinationStationName" value="<%= schedule.get("DestinationStationName") %>">
                    <input type="hidden" name="LineId" value="<%= schedule.get("LineId") %>">
                    <input type="hidden" name="TrainId" value="<%= schedule.get("TrainNumber") %>">
                    <input type="hidden" name="CustomerId" value="<%= session.getAttribute("CustomerId") %>">
                    <input type="hidden" name="FareTypeId" value="1">
                    <input type="hidden" name="RoundTrip" value="0">
                    <input type="hidden" name="CalculatedFare" value="<%= schedule.get("CalculatedFare") %>">
                    <input type="submit" value="Reserve">
                </form>
            </td>
        </tr>
        <% } %>
    </table>
<% } %>

<br>

</body>
</html>
