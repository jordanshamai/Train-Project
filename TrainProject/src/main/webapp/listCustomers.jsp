<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>List Customers</title>
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
<h1>List Customers with Reservations</h1>
    <form action="ListCustomersServlet" method="post">
        <label for="lineId">Select Line:</label>
        <select name="lineId" id="lineId">
            <option value="">Select a line</option>
            <%
                List<Map<String, Object>> lines = (List<Map<String, Object>>) request.getAttribute("lines");
                for (Map<String, Object> line : lines) {
            %>
            <option value="<%= line.get("LineId") %>" <%= line.get("LineId").equals(request.getParameter("lineId")) ? "selected" : "" %>>
                <%= line.get("LineName") %>
            </option>
            <%
                }
            %>
        </select>
        <br>
        <label for="date">Select Date:</label>
        <input type="date" name="date" id="date" value="<%= request.getParameter("date") %>">
        <br>
        <button type="submit">Get Customers</button>
    </form>
    <%
        List<Map<String, Object>> customers = (List<Map<String, Object>>) request.getAttribute("customers");
        if (customers != null && !customers.isEmpty()) {
    %>
    <table border="1">
        <tr>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Customer ID</th>
        </tr>
        <%
            for (Map<String, Object> customer : customers) {
        %>
        <tr>
            <td><%= customer.get("FirstName") %></td>
            <td><%= customer.get("LastName") %></td>
            <td><%= customer.get("CustomerId") %></td>
        </tr>
        <%
            }
        %>
    </table>
    <%
        } else {
    %>
    <p>No customers found for the given line and date.</p>
    <%
        }
    %>
</body>
</html>
