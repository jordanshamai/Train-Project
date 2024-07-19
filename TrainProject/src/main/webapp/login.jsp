<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Group 17 Transit</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #fff;
            margin: 0;
            padding: 0;
        }
        .header {
            text-align: center;
            padding: 20px;
            background-color: #fff;
        }
        .logo img {
            height: 200px;
            cursor: pointer;
        }
        .container {
            width: 100%;
            max-width: 400px;
            margin: 50px auto;
            background-color: #fff;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
            border-radius: 10px;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        form {
            display: flex;
            flex-direction: column;
        }
        label {
            margin: 10px 0 5px;
            color: #333;
        }
        input[type="text"], input[type="password"] {
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 15px;
            cursor: pointer;
            font-size: 16px;
            border-radius: 5px;
        }
        input[type="submit"]:hover {
            background-color: #45a049;
        }
        .register-button {
            display: flex;
            justify-content: center;
            margin-top: 10px;
        }
        .register-button input {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            font-size: 16px;
            border-radius: 5px;
            width: 200px;
        }
        .register-button input:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">
            <img src="group17-logo.png" alt="Group 17 Transit Logo">
        </div>
    </div>
    <div class="container">
        <h2>Login</h2>
        <form action="LoginServlet" method="post">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" value="employee" required>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" value="employee" required>
            <input type="submit" value="Login">
        </form>
    </div>
    <div class="register-button">
        <form action="register.jsp" method="get">
            <input type="submit" value="Register">
        </form>
    </div>
</body>
</html>
