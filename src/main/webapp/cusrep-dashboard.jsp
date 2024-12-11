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
    <link rel="stylesheet" type="text/css" href="http://localhost:8080/train-reservation-system/css/style.css">
</head>
<body>
    <h2>Welcome, <%= session.getAttribute("username") %>!</h2>
    <p>YOU ARE THE CUSTOMER REP!</p>
    
    <form action="logout" method="post">
        <input type="submit" value="Logout">
    </form>

    <div class="form-group">
        <a href="ScheduleManagementServlet" class="signup-link">Manage Train Schedules</a>
    </div>
    <div class="form-group">
        <a href="UserReservationServlet" class="signup-link">Get Customer Report</a>
    </div>
</body>
</html>