<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    String errorMessage = (String) request.getAttribute("errorMessage");
    List<Map<String, Object>> reservations = (List<Map<String, Object>>) request.getAttribute("reservations");
    String username = (String) request.getAttribute("username");
    String transitLine = (String) request.getAttribute("transitLine");
%>

<html>
<head>
    <title>Filter Reservations</title>
    <link rel="stylesheet" type="text/css" href="http://localhost:8080/train-reservation-system/css/filter-reservations.css">
    <script>
        function sortTable(columnIndex, dataType) {
            const table = document.querySelector('table');
            const rows = Array.from(table.rows).slice(1); // Skip header row
            const header = table.rows[0].cells[columnIndex];
            const isAscending = !header.classList.contains('asc');

            // Clear previous sort indicators
            Array.from(table.rows[0].cells).forEach(cell => {
                cell.classList.remove('asc', 'desc');
                const arrow = cell.querySelector('.arrow');
                if (arrow) {
                    arrow.remove();
                }
            });

            // Add sort indicator to the clicked header
            header.classList.add(isAscending ? 'asc' : 'desc');
            const arrow = document.createElement('span');
            arrow.classList.add('arrow');
            arrow.innerHTML = isAscending ? ' &#9650;' : ' &#9660;';
            header.appendChild(arrow);

            rows.sort((a, b) => {
                const cellA = a.cells[columnIndex].textContent.trim();
                const cellB = b.cells[columnIndex].textContent.trim();

                if (dataType === 'number') {
                    return isAscending ? parseFloat(cellA) - parseFloat(cellB) : parseFloat(cellB) - parseFloat(cellA);
                } else if (dataType === 'time') {
                    return isAscending ? new Date(`1970-01-01T${cellA}Z`) - new Date(`1970-01-01T${cellB}Z`) : new Date(`1970-01-01T${cellB}Z`) - new Date(`1970-01-01T${cellA}Z`);
                } else {
                    return isAscending ? cellA.localeCompare(cellB) : cellB.localeCompare(cellA);
                }
            });

            // Append sorted rows back to the table
            rows.forEach(row => table.appendChild(row));
        }
    </script>
</head>
<body>

    <div class="dropdown">
        <button>Menu</button>
        <div class="dropdown-content">
            <form action="sales-report.jsp" method="post" class="logout-form">
                <button type="submit">Sales Report</button>
            </form>
            <form action="admin-dashboard.jsp" method="post" class="logout-form">
                <button type="submit">Admin Dashboard</button>
            </form>
            <form action="logout" method="post" class="logout-form">
                <button type="submit">Logout</button>
            </form>
        </div>
    </div>

    <h1>Filter Reservations</h1>

    <form action="filterreservation" method="post">
        <label for="username">Username: </label>
        <input type="text" id="username" name="username" value="<%= username != null ? username : "" %>" placeholder="Enter Username">

        <label for="transitLine">Transit Line: </label>
        <input type="text" id="transitLine" name="transitLine" value="<%= transitLine != null ? transitLine : "" %>" placeholder="Enter Transit Line">

        <button type="submit">Filter Reservations</button>
    </form>

    <br>

    <% if (reservations != null && !reservations.isEmpty()) { %>
        <table>
            <thead>
                <tr>
                    <th onclick="sortTable(0, 'number')">Reservation ID</th>
                    <th onclick="sortTable(1, 'string')">Username</th>
                    <th onclick="sortTable(2, 'number')">Passenger ID</th>
                    <th onclick="sortTable(3, 'number')">Outbound Schedule ID</th>
                    <th onclick="sortTable(4, 'number')">Return Schedule ID</th>
                    <th onclick="sortTable(5, 'number')">Total Fare</th>
                    <th onclick="sortTable(6, 'time')">Reservation Date</th>
                    <th onclick="sortTable(7, 'time')">Travel Date</th>
                </tr>
            </thead>
            <tbody>
                <% for (Map<String, Object> reservation : reservations) { %>
                    <tr>
                        <td><%= reservation.get("reservationId") %></td>
                        <td><%= reservation.get("username") %></td>
                        <td><%= reservation.get("passengerId") %></td>
                        <td><%= reservation.get("outboundScheduleId") %></td>
                        <td><%= reservation.get("returnScheduleId") != null ? reservation.get("returnScheduleId") : "N/A" %></td>
                        <td><%= reservation.get("totalFare") %></td>
                        <td><%= reservation.get("reservationDate") %></td>
                        <td><%= reservation.get("travelDate") %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } else { %>
        <h3>No reservations found for the given filters.</h3>
    <% } %>

</body>
</html>
