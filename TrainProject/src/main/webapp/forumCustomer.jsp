<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Forum - Customer</title>
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
    <header>
        <button onclick="window.location.href='ForumServlet'">Have a Question?</button>
    </header>

    <h1>Customer Forum</h1>

    <form action="ForumServlet" method="get">
        <label for="search">Search Questions:</label>
        <input type="text" id="search" name="search" value="<%= request.getParameter("search") %>">
        <button type="submit">Search</button>
    </form>

    <form action="ForumServlet" method="post">
        <input type="hidden" name="action" value="ask">
        <label for="question">Ask a Question:</label>
        <br>
        <textarea name="question" id="question" rows="4" cols="50"></textarea>
        <br>
        <button type="submit">Submit Question</button>
    </form>

    <h2>Previously Asked Questions</h2>
    <%
        List<Map<String, Object>> questions = (List<Map<String, Object>>) request.getAttribute("questions");
        if (questions != null && !questions.isEmpty()) {
            for (Map<String, Object> question : questions) {
    %>
    <div>
        <h3>Question ID: <%= question.get("QuestionId") %></h3>
        <p><strong>Question:</strong> <%= question.get("question") %></p>
        <p><strong>Answer:</strong> <%= question.get("answer") != null ? question.get("answer") : "No answer yet." %></p>
        <hr>
    </div>
    <%
            }
        } else {
    %>
    <p>No questions have been asked yet.</p>
    <%
        }
    %>

</body>
</html>
