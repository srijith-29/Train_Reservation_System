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
            <a href="browse" class="signup-link">Search for Train Schedules</a>
        </div>
        <div class="form-group">
            <a href="reservation.jsp" class="signup-link">Make a Reservation</a>
        </div>
        <div class="form-group">
            <a href="view_reservations.jsp" class="signup-link">View Your Reservations</a>
        </div>
    </div>
</body>
</html>