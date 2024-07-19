<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Station Management</title>
    <style>
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px;
            border-bottom: 1px solid #ccc;
        }
        .top-right {
            display: flex;
            align-items: center;
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
            padding: 8px;
            text-align: left;
        }
        .hidden {
            display: none;
        }
        .form-table {
            width: 50%;
            margin: auto;
            margin-top: 20px;
            border: 1px solid #ccc;
            padding: 10px;
        }
        .form-table th, .form-table td {
            border: none;
            padding: 8px;
            text-align: left;
        }
        .buttons {
            margin-left: 10px;
        }
    </style>
    <script>
        function editRow(stationId) {
            var row = document.getElementById("row-" + stationId);
            var inputs = row.getElementsByTagName("input");
            for (var i = 0; i < inputs.length; i++) {
                inputs[i].classList.remove("hidden");
            }
            document.getElementById("display-stationName-" + stationId).classList.add("hidden");
            document.getElementById("display-city-" + stationId).classList.add("hidden");
            document.getElementById("display-state-" + stationId).classList.add("hidden");
            document.getElementById("edit-button-" + stationId).classList.add("hidden");
            document.getElementById("save-button-" + stationId).classList.remove("hidden");
        }

        function saveRow(stationId) {
            document.getElementById("form-" + stationId).submit();
        }

        function deleteRow(stationId) {
            document.getElementById("delete-action").value = "delete";
            document.getElementById("delete-id").value = stationId;
            document.getElementById("delete-form").submit();
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
        <div class="top-right">
            <button onclick="window.location.href='customerRepDashboard.jsp'" class="buttons">Back to Dashboard</button>
            <form method="post" action="logout" style="display: inline;">
                <input type="submit" value="Logout" class="buttons">
            </form>
        </div>
    </div>
    <h2>Station Management</h2>

    <h3>Add New Station</h3>
    <form action="AdminStationServlet" method="post">
        <input type="hidden" name="action" value="insert">
        <table class="form-table">
            <tr>
                <td><label>Station Name:</label></td>
                <td><input type="text" name="stationName"></td>
            </tr>
            <tr>
                <td><label>City:</label></td>
                <td><input type="text" name="city"></td>
            </tr>
            <tr>
                <td><label>State:</label></td>
                <td><input type="text" name="state" maxlength="2"></td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center;"><input type="submit" value="Add Station"></td>
            </tr>
        </table>
    </form>

    <%
        List<Map<String, Object>> stations = (List<Map<String, Object>>) request.getAttribute("stations");
        if (stations != null) {
    %>
    <table>
        <tr>
            <th>Station ID</th>
            <th>Station Name</th>
            <th>City</th>
            <th>State</th>
            <th>Actions</th>
        </tr>
        <%
            for (Map<String, Object> station : stations) {
                int stationId = (int) station.get("StationId");
        %>
        <tr id="row-<%= stationId %>">
            <form id="form-<%= stationId %>" action="AdminStationServlet" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= stationId %>">
                <td><%= stationId %></td>
                <td>
                    <span id="display-stationName-<%= stationId %>"><%= station.get("StationName") %></span>
                    <input type="text" name="stationName" value="<%= station.get("StationName") %>" class="hidden">
                </td>
                <td>
                    <span id="display-city-<%= stationId %>"><%= station.get("city") %></span>
                    <input type="text" name="city" value="<%= station.get("city") %>" class="hidden">
                </td>
                <td>
                    <span id="display-state-<%= stationId %>"><%= station.get("state") %></span>
                    <input type="text" name="state" value="<%= station.get("state") %>" class="hidden" maxlength="2">
                </td>
                <td>
                    <button type="button" id="edit-button-<%= stationId %>" onclick="editRow(<%= stationId %>)">Edit</button>
                    <button type="button" id="save-button-<%= stationId %>" class="hidden" onclick="saveRow(<%= stationId %>)">Save</button>
                    <button type="button" onclick="deleteRow(<%= stationId %>)">Delete</button>
                </td>
            </form>
        </tr>
        <%
            }
        %>
    </table>
    <form id="delete-form" action="AdminStationServlet" method="post" style="display: none;">
        <input type="hidden" id="delete-action" name="action" value="delete">
        <input type="hidden" id="delete-id" name="id" value="">
    </form>
    <%
        }
    %>
</body>
</html>
