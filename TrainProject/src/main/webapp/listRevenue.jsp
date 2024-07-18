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
    <title>Revenue Report</title>
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
        .form-section {
            margin-bottom: 20px;
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

<div class="form-section">
    <h3>Revenue by Transit Line</h3>
    <form action="ListRevenueServlet" method="post">
        <label for="lineId">Transit Line ID:</label>
        <input type="text" id="lineId" name="lineId" required>
        <input type="hidden" name="action" value="byLine">
        <input type="submit" value="Generate Report">
    </form>
</div>

<div class="form-section">
    <h3>Revenue by Customer Name</h3>
    <form action="ListRevenueServlet" method="post">
        <label for="firstName">First Name:</label>
        <input type="text" id="firstName" name="firstName" required>
        <label for="lastName">Last Name:</label>
        <input type="text" id="lastName" name="lastName" required>
        <input type="hidden" name="action" value="byCustomer">
        <input type="submit" value="Generate Report">
    </form>
</div>

<%
    String report = (String) request.getAttribute("report");
    if (report != null) {
%>
        <h3>Revenue Report</h3>
        <p><%= report %></p>
<%
    } else if (request.getAttribute("message") != null) {
%>
        <p><%= request.getAttribute("message") %></p>
<%
    }
%>

</body>
</html>
