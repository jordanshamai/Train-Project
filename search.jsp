<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
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
        <a href="search.jsp">
            <img src="group17-logo.png" alt="Group 17 Transit Logo">
        </a>
    </div>
    <div class="top-right">
        <form method="post" action="logout">
            <input type="submit" value="Logout">
        </form>
    </div>
</div>

<!-- Aaaro -->
<h2>Search for Train Schedules</h2>
<form method="get" action="QandAServlet">
<input type="submit" value="Q&A">
</form>

<h2>Search for Train Schedules</h2>
<form method="post" action="TrainScheduleServlet">
    <label for="travelDate">Travel Date:</label>
    <input type="date" id="travelDate" name="travelDate" required><br><br>
    <label for="departureAfterTime">Departure After Time:</label>
    <input type="time" id="departureAfterTime" name="departureAfterTime" required><br><br>
    <label for="originStation">Origin Station:</label>
    <select id="originStation" name="originStation" required>
        <option value="">Select Origin Station</option>
        <% 
            List<Map<String, Object>> stations = (List<Map<String, Object>>) request.getAttribute("stations");
            if (stations != null) {
                for (Map<String, Object> station : stations) { %>
                    <option value="<%= station.get("StationId") %>"><%= station.get("StationName") %></option>
        <%      }
            }
        %>
    </select><br><br>
    <label for="destinationStation">Destination Station:</label>
    <select id="destinationStation" name="destinationStation" required>
        <option value="">Select Destination Station</option>
        <% 
            if (stations != null) {
                for (Map<String, Object> station : stations) { %>
                    <option value="<%= station.get("StationId") %>"><%= station.get("StationName") %></option>
        <%      }
            }
        %>
    </select><br><br>
    <input type="submit" value="Search">
</form>

<% 
    String travelDate = (String) request.getAttribute("travelDate");
    String departureAfterTime = (String) request.getAttribute("departureAfterTime");
    if (travelDate != null && !travelDate.isEmpty()) { %>
    <h2>Train Schedules for <%= travelDate %></h2>
<% } %>

<% 
    List<Map<String, Object>> schedules = (List<Map<String, Object>>) request.getAttribute("schedules");
    if (schedules != null && !schedules.isEmpty()) { %>
    <h3>Trains departing after <%= departureAfterTime %></h3>
    <table border="1">
        <tr>
            <th>Origin Station Name</th>
            <th>Departure Time</th>
            <th>Train Number</th>
            <th>Destination Station Name</th>
            <th>Arrival Time</th>
            <th>Total Travel Time (minutes)</th>
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
            <td>
                <form method="post" action="CartServlet">
                    <input type="hidden" name="DepartureDateTime" value="<%= travelDate %> <%= schedule.get("DepartureTime") %>">
                    <input type="hidden" name="OriginStationId" value="<%= schedule.get("OriginStationName") %>">
                    <input type="hidden" name="DestinationStationId" value="<%= schedule.get("DestinationStationName") %>">
                    <input type="hidden" name="LineId" value="1">
                    <input type="hidden" name="TrainId" value="<%= schedule.get("TrainNumber") %>">
                    <input type="hidden" name="CustomerId" value="<%= session.getAttribute("CustomerId") %>">
                    <input type="hidden" name="FareTypeId" value="1">
                    <input type="hidden" name="RoundTrip" value="0">
                    <input type="hidden" name="CalculatedFare" value="10.00">
                    <input type="submit" value="Reserve">
                </form>
            </td>
        </tr>
        <% } %>
    </table>
<% } %>
</body>
</html>
