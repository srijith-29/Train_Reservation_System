<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    String errorMessage = (String) request.getAttribute("errorMessage");
    List<Map<String, Object>> reservations = (List<Map<String, Object>>) request.getAttribute("reservations");
    Double totalFare = (Double) request.getAttribute("totalFare");
    String month = (String) request.getAttribute("month");
    String year = (String) request.getAttribute("year");
%>

<html>
<head>
    <link rel="stylesheet" type="text/css" href="http://localhost:8080/train-reservation-system/css/sales-report.css">
    <title>Sales Report</title>

    <style>
        th {
            cursor: pointer;
        }

        th.asc::after {
            content: " ↑";
        }

        th.desc::after {
            content: " ↓";
        }
    </style>

    <script>
        // Function to sort the table based on the column index and data type
        function sortTable(columnIndex, dataType) {
            const table = document.querySelector('.results-table');
            const rows = Array.from(table.tBodies[0].rows);
            const header = table.tHead.rows[0].cells[columnIndex];
            const isAscending = !header.classList.contains('asc');

            // Clear previous sort indicators
            Array.from(table.tHead.rows[0].cells).forEach(cell => {
                cell.classList.remove('asc', 'desc');
            });

            // Add sort indicator
            header.classList.add(isAscending ? 'asc' : 'desc');

            rows.sort((a, b) => {
                const cellA = a.cells[columnIndex].textContent.trim();
                const cellB = b.cells[columnIndex].textContent.trim();

                if (dataType === 'number') {
                    return isAscending
                        ? parseFloat(cellA) - parseFloat(cellB)
                        : parseFloat(cellB) - parseFloat(cellA);
                } else if (dataType === 'time') {
                    return isAscending
                        ? new Date(`1970-01-01T${cellA}Z`) - new Date(`1970-01-01T${cellB}Z`)
                        : new Date(`1970-01-01T${cellB}Z`) - new Date(`1970-01-01T${cellA}Z`);
                } else {
                    return isAscending
                        ? cellA.localeCompare(cellB)
                        : cellB.localeCompare(cellA);
                }
            });

            // Append sorted rows back to the table
            rows.forEach(row => table.tBodies[0].appendChild(row));
        }
    </script>
</head>
<body>
    <h1>Sales Report - Filter by Month</h1>

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

    <form action="salesreport" method="post">
        <label for="month">Select Month: </label>
        <select name="month" id="month">
            <option value="January">January</option>
            <option value="February">February</option>
            <option value="March">March</option>
            <option value="April">April</option>
            <option value="May">May</option>
            <option value="June">June</option>
            <option value="July">July</option>
            <option value="August">August</option>
            <option value="September">September</option>
            <option value="October">October</option>
            <option value="November">November</option>
            <option value="December">December</option>
        </select>

        <label for="year">Select Year: </label>
        <select name="year" id="year">
            <option value="2023">2023</option>
            <option value="2024">2024</option>
            <option value="2025">2025</option>
        </select>

        <button type="submit">Generate Report</button>
    </form>

    <br>

    <% if (totalFare != null) { %>
        <h3>Total Fare for <%= month %> <%= year %>: $<%= totalFare %></h3>
    <% } else if (errorMessage != null) { %>
        <h3 style="color: red;"><%= errorMessage %></h3>
    <% } %>

    <% if (reservations != null && !reservations.isEmpty()) { %>
        <table class="results-table" border="1">
            <thead>
                <tr>
                    <th onclick="sortTable(0, 'number')">Reservation ID</th>
                    <th onclick="sortTable(1, 'string')">Username</th>
                    <th onclick="sortTable(2, 'number')">Outbound Schedule ID</th>
                    <th onclick="sortTable(3, 'number')">Return Schedule ID</th>
                    <th onclick="sortTable(4, 'number')">Total Fare</th>
                    <th onclick="sortTable(5, 'time')">Reservation Date</th>
                    <th onclick="sortTable(6, 'time')">Travel Date</th>
                </tr>
            </thead>
            <tbody>
                <% for (Map<String, Object> reservation : reservations) { %>
                    <tr>
                        <td><%= reservation.get("reservationId") %></td>
                        <td><%= reservation.get("username") %></td>
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
        <p>No reservations found for the selected month and year.</p>
    <% } %>

</body>
</html>
