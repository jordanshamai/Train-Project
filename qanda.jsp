<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page session="true" %>
<%
    String employeeName = (String) session.getAttribute("employeeName");
    String customerName = (String) session.getAttribute("customerName");
    if(employeeName==null && customerName==null) {
         response.sendRedirect("login.jsp");
         return;
    }

    int customerId = 0;
    if (session.getAttribute("customerId")!=null) {
    	customerId = (int) session.getAttribute("customerId");
    }
 	String loginUserName = ""; 
    if (employeeName == null) {
    	loginUserName = customerName;
    } else {
    	loginUserName = employeeName;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Employee Portal</title>
</head>
<body>
    <h2>Hello, <%= loginUserName  %></h2>
    
    <form action="QandAServlet" method="get">
    <hr>
    	<table>
    	<tr>
        <td><input type="text" name="search" ></td>
        <td><input type="submit" name="button" value="Search questions"></td>
        </tr>
    	<tr>
        <td>
        <input type=hidden name=CustomerId value='<%= customerId  %>'>
        <input type="text" name="question" ></td>
        <td><input type="submit" name="button" value="Ask Question"></td>
        </tr>
        </table>
    	<hr>
    </form>
   <%= request.getAttribute("qandatable") %>
   
   <% 
            String executionStatus = (String) request.getAttribute("executionStatus");
            if (executionStatus != null) {      %>
                    <h2><%= executionStatus %></h2>
        <%      }
        %>
        
</body>
</html>
