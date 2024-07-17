<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <style>
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px;
            border-bottom: 1px solid #ccc;
        }
      
        .logo img {
            height: 110px;\
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">
                <img src="group17-logo.png" alt="Group 17 Transit Logo">
        </div>
    </div>
</head>
<body>
    <h2>Login</h2>
    <form action="LoginServlet" method="post">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" value="jordan" required><br><br>
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" value="jordan" required><br><br>
        <input type="submit" value="Login">
    </form>
    <br><br>
    <form action="register.jsp" method="get">
        <input type="submit" value="Register">
    </form>
</body>
</html>
