<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.util.Map" %>
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
    <title>Best Customer</title>
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

<h3>Best Customer</h3>
<%
    Map<String, String> bestCustomer = (Map<String, String>) request.getAttribute("bestCustomer");
    if (bestCustomer != null) {
%>
    <table border="1">
        <tr>
            <th>Customer ID</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Total Fare</th>
        </tr>
        <tr>
            <td><%= bestCustomer.get("CustomerId") %></td>
            <td><%= bestCustomer.get("FirstName") %></td>
            <td><%= bestCustomer.get("LastName") %></td>
            <td><%= bestCustomer.get("TotalFare") %></td>
        </tr>
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
