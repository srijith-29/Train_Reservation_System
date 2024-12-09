<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
    <title>Best Customer and Top Transit Lines</title>
    <link rel="stylesheet" type="text/css" href="http://localhost:8080/train-reservation-system/css/reservationdata.css">
</head>
<body>

    <div class="dropdown">
        <button>Menu</button>
        <div class="dropdown-content">
            <form action="admin-dashboard.jsp" method="post" class="logout-form">
                <button type="submit">Admin Dashboard</button>
            </form>
            <form action="filter-reservations.jsp" method="post" class="logout-form">
                <button type="submit">Filter Reservation</button>
            </form>
            <form action="sales-report.jsp" method="post" class="logout-form">
                <button type="submit">Sales Report</button>
            </form>
            <form action="reservationdata" method="get" class="logout-form">
                <button type="submit">Reservation Data</button>
            </form>
            <form action="revenue.jsp" method="post" class="logout-form">
                <button type="submit">Revenue Filter</button>
            </form>
            <form action="logout" method="post" class="logout-form">
                <button type="submit">Logout</button>
            </form>

        </div>
    </div>

    <h1>Best Customer</h1>
    <%
        String bestCustomerUsername = (String) request.getAttribute("bestCustomerUsername");
        Double bestCustomerRevenue = (Double) request.getAttribute("bestCustomerRevenue");
    %>
    <div>
        <% if (bestCustomerUsername != null) { %>
            <p><strong>Username:</strong> <%= bestCustomerUsername %></p>
            <p><strong>Total Revenue:</strong> $<%= bestCustomerRevenue %></p>
        <% } else { %>
            <p>No customer data found.</p>
        <% } %>
    </div>

    <h1>Top 5 Most Active Transit Lines</h1>
    <%
        ArrayList<String[]> topTransitLines = (ArrayList<String[]>) request.getAttribute("topTransitLines");
    %>
    <table>
        <thead>
            <tr>
                <th>Rank</th>
                <th>Transit Line</th>
                <th>Number of Bookings</th>
            </tr>
        </thead>
        <tbody>
            <% if (topTransitLines != null && !topTransitLines.isEmpty()) { %>
                <% for (int i = 0; i < topTransitLines.size(); i++) { %>
                    <tr>
                        <td><%= i + 1 %></td>
                        <td><%= topTransitLines.get(i)[0] %></td>
                        <td><%= topTransitLines.get(i)[1] %></td>
                    </tr>
                <% } %>
            <% } else { %>
                <tr>
                    <td colspan="3">No transit line data found.</td>
                </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>
