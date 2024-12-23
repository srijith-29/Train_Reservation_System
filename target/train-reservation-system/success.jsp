<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if user is logged in
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Train Reservation System - Welcome</title>
    <link rel="stylesheet" type="text/css" href="http://localhost:8080/train-reservation-system/css/style.css">
</head>
<body>
    <div class="login-container">
        <h2>Welcome, <%= session.getAttribute("username") %>!</h2>
        <p>What would you like to do?</p>
        <form action="logout" method="post">
            <input type="submit" value="Logout">
        </form>
        <div class="form-group">
            <a href="browse" class="signup-link">Make a Reservation</a>
        </div>
        <div class="form-group">
            <a href="ManageReservations" class="signup-link">Manage Your Reservations</a>
        </div>
        <div class="form-group">
            <a href="ListQuestionsServlet" class="signup-link">Questions & Answsers</a>
        </div>
    </div>
</body>
</html>