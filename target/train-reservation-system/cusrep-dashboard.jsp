<%
    String role = (String) session.getAttribute("role");
    if (!"cusrep".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome</title>
</head>
<body>
    <h2>Welcome, <%= session.getAttribute("username") %>!</h2>
    <p>YOU ARE THE CUSTOMER REP!</p>
    
    <form action="logout" method="post">
        <input type="submit" value="Logout">
    </form>
</body>
</html>