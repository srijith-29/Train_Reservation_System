<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="http://localhost:8080/train-reservation-system/css/style_signup.css">
    <title>Signup</title>
</head>
<body>

    <div class="signup-container">
        <h2>Signup</h2>
        
        <% if(request.getAttribute("errorMessage") != null) { %>
        <div class="error">
            <%= request.getAttribute("errorMessage") %>
        </div>
        <% } %>

        <form action="signup" method="POST">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required>
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input type="text" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="firstname">First Name</label>
                <input type="text" id="firstname" name="firstname" required>
            </div>
            <div class="form-group">
                <label for="lastname">Last Name</label>
                <input type="text" id="lastname" name="lastname" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>
            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required>
            </div>
            <input type="submit" value="Signup">
        </form>
        
        <a href="login.jsp" class="login-link">Already have an account? Login</a>
    </div>
</body>
</html>
