<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Train Schedules</title>
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
        .container {
            display: flex;
            justify-content: space-between;
        }
        .table-container {
            flex: 2;
        }
        .form-container {
            flex: 1;
            margin-left: 20px;
        }
        .hidden {
            display: none;
        }
    </style>
    <script>
        function showEditForm(trainId, departureTime) {
            document.getElementById('editForm').classList.remove('hidden');
            document.getElementById('trainId').value = trainId;
            document.getElementById('newDepartureTime').value = departureTime;
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
        <button onclick="window.location.href='customerRepDashboard.jsp'">Back to Dashboard</button>
        <div class="top-right">
            <form method="post" action="logout">
                <input type="submit" value="Logout">
            </form>
        </div>
    </div>

    <h1>Train Schedules</h1>
    <form action="ProduceSchedulesServlet" method="get">
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

    <div class="container">
        <div class="table-container">
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
                    <th>Actions</th>
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
                    <td>
                        <button type="button" onclick="showEditForm('<%= schedule.get("TrainId") %>', '<%= schedule.get("DepartureTime") %>')">Edit</button>
                        <form action="ProduceSchedulesServlet" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="trainId" value="<%= schedule.get("TrainId") %>">
                            <button type="submit">Delete</button>
                        </form>
                    </td>
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
        </div>
        <div class="form-container">
            <div id="editForm" class="hidden">
                <h2>Edit Schedule</h2>
                <form action="ProduceSchedulesServlet" method="post">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" id="trainId" name="trainId">
                    <input type="hidden" id="stationId" name="stationId" value="<%= request.getParameter("stationId") %>">
                    <label for="newDepartureTime">New Departure Time:</label>
                    <input type="time" id="newDepartureTime" name="newDepartureTime" required>
                    <button type="submit">Save</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
