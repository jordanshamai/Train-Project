<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page session="true" %>
<%
    String employeeName = (String) session.getAttribute("employeeName");

    if (employeeName == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String idToProcess = (String) request.getAttribute("idToProcess");
    String ssn = (String) request.getAttribute("SSN");
    String lastname = (String) request.getAttribute("LastName");
    String firstname = (String) request.getAttribute("FirstName");
    String username = (String) request.getAttribute("UserName");
    String password = (String) request.getAttribute("Password");
    String button = (String) request.getAttribute("button");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Customer Representatives</title>
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
    <div class="top-right">
        <form method="post" action="logout">
            <input type="submit" value="Logout">
        </form>
    </div>
</div>
<h2>Hello, <%= employeeName %></h2>
<form action="ManageCustomerRepServlet" method="post">
    <input type="hidden" name="idToProcess" value="<%= idToProcess %>">
    <table>
        <tr><th>ID</th><th>SSN</th><th>Last Name</th><th>First Name</th><th>User name</th><th>Password</th><th>Action</th></tr>
        <tr>
            <td><%= idToProcess != null ? idToProcess : "" %></td>
            <td><input type="text" id="ssn" name="ssn" value="<%= ssn != null ? ssn : "" %>" required></td>
            <td><input type="text" id="lastname" name="lastname" value="<%= lastname != null ? lastname : "" %>" required></td>
            <td><input type="text" id="firstname" name="firstname" value="<%= firstname != null ? firstname : "" %>" required></td>
            <td><input type="text" id="username" name="username" value="<%= username != null ? username : "" %>" required></td>
            <td><input type="password" id="password" name="password" value="<%= password != null ? password : "" %>" required></td>
            <td><input type="submit" name="button" value="<%= button != null ? button : "Add Customer Representative" %>"></td>
        </tr>
    </table>
</form>
<br><br>

<table border="0.5">
    <tr><th>ID</th><th>SSN</th><th>Last Name</th><th>First Name</th><th>User name</th><th>Action</th></tr>

    <% 
        String executionStatus = (String) request.getAttribute("executionStatus");
        if (executionStatus != null) { %>
            <h2><%= executionStatus %></h2>
    <% } %>
    
    <% 
        List<Map<String, String>> users = (List<Map<String, String>>) request.getAttribute("users");
        if (users != null) {
            out.println("Number of users: " + users.size()); // Debugging statement
            for (Map<String, String> user : users) { %>
                <tr>
                    <td><%= user.get("EmployeeId") %></td>
                    <td><%= user.get("SSN") %></td>
                    <td><%= user.get("LastName") %></td>
                    <td><%= user.get("FirstName") %></td>
                    <td><%= user.get("Username") %></td>
                    <td>
                        <form action="ManageCustomerRepServlet" method="post">
                            <input type="hidden" name="idToProcess" value="<%= user.get("EmployeeId") %>">
                            <input type="submit" name="button" value="Edit Customer Representative">
                        </form>
                        <form action="ManageCustomerRepServlet" method="post">
                            <input type="hidden" name="idToProcess" value="<%= user.get("EmployeeId") %>">
                            <input type="submit" name="button" value="Delete Customer Representative"> 
                        </form>
                    </td>
                </tr>
    <%      }
        } else {
            out.println("No users found."); // Debugging statement
        }
    %>
</table>
</body>
</html>
