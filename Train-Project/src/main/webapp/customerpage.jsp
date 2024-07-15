<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    String customerName = (String) session.getAttribute("customerName");
    if (customerName == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Portal</title>
</head>
<body>
    <h2>Hello, <%=customerName %></h2>
    <form action="logout" method="post">
        <input type="submit" value="Logout">
    </form>
</body>
</html>
