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

table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
}

table, th, td {
    border: 1px solid black;
}

th, td {
    padding: 10px;
    text-align: left;
}
</style>
<script>
    function submitFormByLineChange() {
        document.getElementById('formAction').value = 'lineChange';
        document.getElementById('searchForm').submit();
    }
    
    function submitFormByDirectionChange() {
        document.getElementById('formAction').value = 'directionChange';
        document.getElementById('searchForm').submit();
    }
    
    function submitFormBySearchButton() {
        document.getElementById('formAction').value = 'search';
        document.getElementById('searchForm').submit();
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
        <form method="post" action="logout">
            <input type="submit" value="Logout">
        </form>
    </div>
</div>

<% 
	String customerName = (String) session.getAttribute("customerName");
%>
<h1>Welcome, <%= customerName != null ? customerName : "Guest" %>!</h1>

<h2>Search for Train Schedules</h2>
<form method="post" id="searchForm" name="searchForm" action="SearchServlet">
    <input type="hidden" id="formAction" name="formAction" value="">
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
    <label for="line">Line:</label>
    <select id="line" name="line" required onChange="submitFormByLineChange()">
        <option value="">Select a Line</option>
        <% 
            List<Map<String, Object>> lines = (List<Map<String, Object>>) request.getAttribute("lines");
            String selectedLineId = (String) request.getAttribute("selectedLineId");
            if (lines != null) {
                for (Map<String, Object> line : lines) { 
                    String lineId = line.get("LineId").toString();
                    String lineName = line.get("LineName").toString();
                    boolean isSelected = lineId.equals(selectedLineId);
        %>
                    <option value="<%= lineId %>" <%= isSelected ? "selected" : "" %>><%= lineName %></option>
        <%      }
            }
        %>
    </select><br><br>
    <% if (selectedLineId != null && !selectedLineId.isEmpty()) { %>
        <label for="direction">Direction:</label>
        <select id="direction" name="direction" required onChange="submitFormByDirectionChange()">
        <option value="">Select a Direction</option>
        <% 
            List<Map<String, Object>> directions = (List<Map<String, Object>>) request.getAttribute("directions");
            String selectedDirectionId = (String) request.getAttribute("selectedDirectionId");
            if (directions != null) {
                for (Map<String, Object> direction : directions) { 
                    String directionId = direction.get("DirectionId").toString();
                    String directionName = direction.get("DirectionName").toString();
                    boolean isSelected = directionId.equals(selectedDirectionId);
        %>
                    <option value="<%= directionId %>" <%= isSelected ? "selected" : "" %>><%= directionName %></option>
        <%      }
            }
        %>
        </select><br><br>
        <% if (selectedDirectionId != null && !selectedDirectionId.isEmpty()) { %>
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
            <input type="button" value="Search" onclick="submitFormBySearchButton()">
            <button type="button" onclick="history.back()">Back</button>
        <% } %>
    <% } %>        
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
    <h3>Train Schedules for <%= formattedTravelDateForDisplay %></h3>
<% }
    if (!formattedDepartureTimeForDisplay.isEmpty()) { %>
    <h4>Trains departing after <%= formattedDepartureTimeForDisplay %></h4>
<% } %>

<% 
    List<Map<String, Object>> schedules = (List<Map<String, Object>>) request.getAttribute("schedules");
    if (schedules != null && !schedules.isEmpty()) { %>
    <table>
        <tr>
            <th>Line Name</th>
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
            <td><%= schedule.get("LineName") %></td>
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
                    <input type="hidden" name="TrainId" value="<%= schedule.get("TrainId") %>">
                    <input type="hidden" name="TrainNumber" value="<%= schedule.get("TrainNumber") %>">
                    <input type="hidden" name="CustomerId" value="<%= session.getAttribute("CustomerId") %>">
                    <input type="hidden" name="CalculatedFare" value="<%= schedule.get("CalculatedFare") %>">
                    <input type="hidden" name="LineName" value="<%= schedule.get("LineName") %>">
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
