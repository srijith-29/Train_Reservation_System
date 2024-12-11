<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="http://localhost:8080/train-reservation-system/css/addUser.css">
    <title>Add User</title>
    <script>
        // Show a popup if there's an error
        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            const error = urlParams.get('error');
            if (error) {
                alert(decodeURIComponent(error));
            }
        };
    </script>
</head>
<body>
    <h1>Add New User</h1>
    <form action="adduser" method="post">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required><br>

        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br>

        <label for="role">Role:</label>
        <select id="role" name="role" required>
            <option value="user">User</option>
            <option value="admin">Admin</option>
            <option value="cusrep">Customer Representative</option>
        </select><br>

        <label for="email">Email:</label>
        <input type="email" id="email" name="email"><br>

        <label for="firstName">First Name:</label>
        <input type="text" id="firstName" name="firstName"><br>

        <label for="lastName">Last Name:</label>
        <input type="text" id="lastName" name="lastName"><br>

        <button type="submit">Add User</button>
    </form>

    <button class="back-button" onclick="location.href='admin-dashboard.jsp'">Back to Dashboard</button>

</body>
</html>
