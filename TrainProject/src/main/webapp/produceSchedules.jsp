<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Train Schedules</title>
</head>
<body>
<h1>Train Schedules</h1>
    <form action="ProduceSchedulesServlet" method="post">
        <label for="stationId">Select Station:</label>
        <select name="stationId" id="stationId">
            <option value="">Select a station</option>
            <%
                List<Map<String, Object>> stations = (List<Map<String, Object>>) request.getAttribute("stations");
                for (Map<String, Object> station : stations) {
            %>
            <option value="<%= station.get("StationId") %>" <%= station.get("StationId").equals(request.getParameter("stationId")) ? "selected" : "" %>>
                <%= station.get("StationName") %>
            </option>
            <%
                }
            %>
        </select>
        <button type="submit">Get Schedules</button>
    </form>
    <%
        List<Map<String, Object>> schedules = (List<Map<String, Object>>) request.getAttribute("schedules");
        if (schedules != null && !schedules.isEmpty()) {
    %>
    <table border="1">
        <tr>
                  
            <th>Onboarding Station</th>
            <th>Departure Time</th>
            <th>Train Number</th>
            <th>Offboarding Station</th>
            <th>Arrival Time</th>
            <th>Total Travel Time</th>
        </tr>
        <%
            for (Map<String, Object> schedule : schedules) {
        %>
        <tr>

            <td><%= schedule.get("OnboardingStation") %></td>
            <td><%= schedule.get("DepartureTime") %></td>
            <td><%= schedule.get("TrainNumber") %></td>
            <td><%= schedule.get("OffboardingStation") %></td>
            <td><%= schedule.get("ArrivalTime") %></td>
            <td><%= schedule.get("TotalTravelTime") %></td>
        </tr>
        <%
            }
        %>
    </table>
    <%
        } else {
    %>
    <p>No schedules found for the given station.</p>
    <%
        }
    %>
</body>
</html>
