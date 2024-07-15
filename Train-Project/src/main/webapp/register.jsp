<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register</title>
    <style>
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px;
            border-bottom: 1px solid #ccc;
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
            
                <img src="group17-logo.png" alt="Group 17 Transit Logo">
            
        </div>
       
    </div>
</head>
<body>
    <h2>Register</h2>
    <form action="RegisterServlet" method="post">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required><br><br>
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br><br>
        <label for="firstname">First Name:</label>
        <input type="text" id="firstname" name="firstname" required><br><br>
        <label for="lastname">Last Name:</label>
        <input type="text" id="lastname" name="lastname" required><br><br>
        <label for="email">Email Address:</label>
        <input type="email" id="email" name="email" required><br><br>
        <input type="submit" value="Register">
    </form>
</body>
</html>
