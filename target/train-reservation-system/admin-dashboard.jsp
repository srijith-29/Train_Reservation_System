<%
    String Userrole = (String) session.getAttribute("role");
    if (!"admin".equalsIgnoreCase(Userrole)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<%
    if (request.getAttribute("userList") == null) {
        response.sendRedirect("admin-dashboard");
        return;
    }
%>

<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="http://localhost:8080/train-reservation-system/css/admin-dashboard.css">
    <title>Admin Dashboard</title>
</head>
<body>
    <div class="dropdown">
        <button>Menu</button>
        <div class="dropdown-content">
            <form action="filter-reservations.jsp" method="post" class="logout-form">
                <button type="submit">Reservation Data</button>
            </form>
            <form action="sales-report.jsp" method="post" class="logout-form">
                <button type="submit">Sales Report</button>
            </form>
            <form action="logout" method="post" class="logout-form">
                <button type="submit">Logout</button>
            </form>
        </div>
    </div>
    <h1>Admin Dashboard</h1>
    <table border="1">
        <thead>
            <tr>
                <th>Username</th>
                <th>Role</th>
                <th>Email</th>
                <th>First Name</th>
                <th>Last Name</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                ArrayList<String[]> userList = (ArrayList<String[]>) request.getAttribute("userList");
                if (userList != null) {
                    for (String[] user : userList) {
            %>
            <tr>
                <td><%= user[0] %></td>
                <td><%= user[1] %></td>
                <td><%= user[2] %></td>
                <td><%= user[3] %></td>
                <td><%= user[4] %></td>
                <td>
                    <a href="edituser?username=<%= user[0] %>">Edit</a>
                    <!-- <a href="deleteuser?username=<%= user[0] %>">Delete</a> -->
                    <form action="deleteuser" method="POST" style="display:inline;">
                        <input type="hidden" name="userId" value="<%= user[0] %>"> <!-- Assuming user[0] contains the user ID -->
                        <button type="submit" onclick="return confirm('Are you sure you want to delete this user?')">Delete</button>
                    </form>
                </td>
            </tr>
            <%
                    }
                }
            %>
        </tbody>
    </table>
</body>
</html>

