<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="http://localhost:8080/train-reservation-system/css/style.css">
    <title>Login</title>
    <script>
        function togglePassword() {
            var passwordField = document.getElementById("password");
            var toggleButton = document.getElementById("toggle-password");
            if (passwordField.type === "password") {
                passwordField.type = "text";
                toggleButton.innerHTML = "Hide Password";
            } else {
                passwordField.type = "password";
                toggleButton.innerHTML = "Show Password";
            }
        }
    </script>
</head>

<body>
    <% if(request.getAttribute("errorMessage") != null) { %>
        <div class="error">
            <%= request.getAttribute("errorMessage") %>
        </div>
    <% } %>

    <div class="login-container">
        <h2>Login</h2>
        <form action="login" method="POST">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
                <div class="show-password-container">
                    <button type="button" id="toggle-password" onclick="togglePassword()">Show Password</button>
                </div>
            </div>
            <input type="submit" value="Login">
        </form>
        <a href="signup.jsp" class="signup-link">Don't have an account? Sign up</a>
        <a href="browse" class="signup-link">Browse Train Schedules</a>
    </div>
</body>

</html>
