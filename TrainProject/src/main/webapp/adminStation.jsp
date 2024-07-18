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
    <button onclick="window.location.href='customerRepDashboard.jsp'">Back to Dashboard</button>
    <div class="top-right">
        <form method="post" action="logout">
            <input type="submit" value="Logout">
        </form>
    </div>
</div>
<h2>Station Management</h2>
 
<%
    List<Map<String, Object>> stations = (List<Map<String, Object>>) request.getAttribute("stations");
    if (stations != null) {
%>
<table border="1">
<tr>
<th>Station ID</th>
<th>Station Name</th>
<th>City</th>
<th>State</th>
<th>Actions</th>
</tr>
<%
        for (Map<String, Object> station : stations) {
    %>
<tr>
<td><%= station.get("StationId") %></td>
<td><%= station.get("StationName") %></td>
<td><%= station.get("city") %></td>
<td><%= station.get("state") %></td>
<td>
<a href="AdminStationServlet?action=edit&id=<%= station.get("StationId") %>">Edit</a>
<a href="AdminStationServlet?action=delete&id=<%= station.get("StationId") %>">Delete</a>
</td>
</tr>
<%
        }
    %>
</table>
<%
    }
%>
 
<h3>Add New Station</h3>
<form action="AdminStationServlet" method="post">
<input type="hidden" name="action" value="insert">
<label>Station Name:</label>
<input type="text" name="stationName"><br>
<label>City:</label>
<input type="text" name="city"><br>
<label>State:</label>
<input type="text" name="state"><br>
<input type="submit" value="Add Station">
</form>
 
</body>
</html>