<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
    <title>Revenue Report</title>
    <link rel="stylesheet" type="text/css" href="http://localhost:8080/train-reservation-system/css/revenue.css">
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
    <h1>Revenue Report</h1>

    <!-- Filter Form -->
    <!-- Filter Form -->
    <form method="get" action="RevenueServlet">
        <label for="transitLine">Transit Line:</label>
        <input 
            type="text" 
            id="transitLine" 
            name="transitLine" 
            value="<%= request.getParameter("transitLine") != null ? request.getParameter("transitLine") : "" %>" 
        />

        <label for="username">Customer Name:</label>
        <input 
            type="text" 
            id="username" 
            name="username" 
            value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>" 
        />

        <button type="submit">Filter</button>
    </form>


    <!-- Total Fare -->
    <div class="total-fare">
        Total Fare: $<%= request.getAttribute("totalFare") != null ? request.getAttribute("totalFare") : "0.00" %>
    </div>

    <!-- Reservations Table -->
    <table>
        <thead>
            <tr>
                <th onclick="sortTable(0, 'number')">Reservation ID</th>
                <th onclick="sortTable(1, 'string')">Username</th>
                <th onclick="sortTable(2, 'number')">Total Fare</th>
                <th onclick="sortTable(3, 'time')">Reservation Date</th>
                <th onclick="sortTable(4, 'string')">Transit Line</th>
                <th onclick="sortTable(5, 'time')">Departure</th>
                <th onclick="sortTable(6, 'time')">Arrival</th>
            </tr>
        </thead>
        <tbody>
            <%
                ArrayList<String[]> reservations = (ArrayList<String[]>) request.getAttribute("reservations");
                if (reservations != null && !reservations.isEmpty()) {
                    for (String[] reservation : reservations) {
            %>
                        <tr>
                            <td><%= reservation[0] %></td>
                            <td><%= reservation[1] %></td>
                            <td><%= reservation[2] %></td>
                            <td><%= reservation[3] %></td>
                            <td><%= reservation[4] %></td>
                            <td><%= reservation[5] %></td>
                            <td><%= reservation[6] %></td>
                        </tr>
            <%
                    }
                } else {
            %>
                    <tr>
                        <td colspan="7" class="no-data">No reservations found.</td>
                    </tr>
            <%
                }
            %>
        </tbody>
    </table>
</body>
</html>
