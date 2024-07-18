<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    String employeeName = (String) session.getAttribute("employeeName");

    if (employeeName == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Most Active Transit Lines</title>
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
    <button onclick="window.location.href='adminDashboard.jsp'">Back to Dashboard</button>
    <div class="top-right">
        <form method="post" action="logout">
            <input type="submit" value="Logout">
        </form>
    </div>
</div>
<h2>Hello, <%= employeeName %></h2>

<h3>Most Active Transit Lines</h3>
<%
    List<Map<String, String>> activeLines = (List<Map<String, String>>) request.getAttribute("activeLines");
    if (activeLines != null && !activeLines.isEmpty()) {
%>
    <table border="1">
        <tr>
            <th>Line Name</th>
            <th>Line ID</th>
            <th>Total Fare</th>
        </tr>
<%
        for (Map<String, String> line : activeLines) {
%>
        <tr>
            <td><%= line.get("LineName") %></td>
            <td><%= line.get("LineId") %></td>
            <td><%= line.get("TotalFare") %></td>
        </tr>
<%
        }
%>
    </table>
<%
    } else {
%>
    <p>No data found.</p>
<%
    }
%>

</body>
</html>
