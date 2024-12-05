<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit User</title>
    <link rel="stylesheet" type="text/css" href="http://localhost:8080/train-reservation-system/css/edit-user.css"> <!-- Link to the external CSS file -->
</head>
<body>
    <div class="container">
        <h1>Edit User</h1>
        <form action="edituser" method="post" class="edit-form">
            <input type="hidden" name="username" value="<%= request.getAttribute("username") %>" />
            <div class="form-group">
                <label for="role">Role:</label>
                <input type="text" id="role" name="role" value="<%= request.getAttribute("role") %>" />
            </div>
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="text" id="email" name="email" value="<%= request.getAttribute("email") %>" />
            </div>
            <div class="form-group">
                <label for="firstName">First Name:</label>
                <input type="text" id="firstName" name="firstName" value="<%= request.getAttribute("firstName") %>" />
            </div>
            <div class="form-group">
                <label for="lastName">Last Name:</label>
                <input type="text" id="lastName" name="lastName" value="<%= request.getAttribute("lastName") %>" />
            </div>
            <div class="form-group">
                <button type="submit" class="submit-btn">Save Changes</button>
            </div>
        </form>
        <a href="admin-dashboard" class="back-btn">Back to Admin Dashboard</a>
    </div>
</body>
</html>
