<!DOCTYPE html>
<html lang="en">


<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="http://localhost:8080/train-reservation-system/css/style.css">
    <title>Login</title>
</head>
<body>
    <%
    String errorMessage = (String) request.getAttribute("errorMessage");
    if (errorMessage != null) {
    %>
    <script>
        alert("<%= errorMessage %>");
    </script>
    <%
    }
    %>

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
            </div>
            <input type="submit" value="Login">
        </form>
        <a href="signup.jsp" class="signup-link">Don't have an account? Sign up</a>
    </div>
</body>
</html>