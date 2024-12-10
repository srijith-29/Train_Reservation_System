<%@ page language="java" contentType="text/html; charset=UTF-8" import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Reservations</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            color: #333;
        }

        h2 {
            text-align: center;
            margin-top: 20px;
            color: #007bff;
        }

        .heading-note {
            text-align: center;
            margin: 10px 0 20px;
            font-size: 16px;
            color: #555;
            font-style: italic;
        }

        .container {
            max-width: 1200px;
            margin: 20px auto;
            background: #fff;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .filter-container {
            text-align: center;
            margin-bottom: 20px;
        }

        .filter-container form {
            display: inline-block;
            padding: 10px 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background: #f9f9f9;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .filter-container label {
            font-weight: bold;
            margin-right: 10px;
        }

        .filter-container select {
            padding: 5px 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .filter-container button {
            padding: 5px 15px;
            border: none;
            background: #007bff;
            color: white;
            border-radius: 5px;
            cursor: pointer;
        }

        .filter-container button:hover {
            background: #0056b3;
        }

        .reservation-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .reservation-table th {
            background: #007bff;
            color: white;
            text-align: left;
            padding: 10px;
        }

        .reservation-table td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }

        .reservation-table tbody tr:nth-child(even) {
            background: #f9f9f9;
        }

        .reservation-table tbody tr:hover {
            background: #f1f1f1;
        }

        .no-reservations {
            text-align: center;
            font-size: 16px;
            color: #666;
            padding: 20px;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .action-buttons button {
            padding: 5px 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
        }

        .action-buttons button.cancel {
            background-color: #dc3545;
            color: white;
        }

        .action-buttons button.cancel:hover {
            background-color: #b02a37;
        }

        .action-buttons button.view {
            background-color: #007bff;
            color: white;
        }

        .action-buttons button.view:hover {
            background-color: #0056b3;
        }

        .note {
            margin-top: 30px;
            font-size: 14px;
            text-align: center;
            font-style: italic;
            color: #b02a37;
        }
        .back-link {
            display: inline-block;
            margin: 20px auto; /* Center it vertically and horizontally */
            padding: 10px 20px; /* Add some padding for a button-like appearance */
            background: #007bff; /* Blue background color */
            color: #fff; /* White text */
            text-align: center;
            border-radius: 5px; /* Rounded corners */
            text-decoration: none; /* Remove underline */
            font-size: 16px; /* Increase font size */
            font-weight: bold; /* Make text bold */
            transition: background 0.3s ease, transform 0.2s ease; /* Add transition effects */
            position: absolute; /* Position it at the bottom */
            left: 50%; /* Horizontally center */
            transform: translateX(-50%); /* Adjust position */
            bottom: 20px; /* Distance from bottom */
        }

        .back-link:hover {
            background: #0056b3; /* Darker blue on hover */
            transform: translateX(-50%) scale(1.05); /* Slightly enlarge on hover */
        }
    </style>
</head>
<body>
    <h2>Manage Reservations</h2>

    <div class="heading-note">
        For past reservations, filter by <strong>Completed</strong>. For active reservations, filter by <strong>Confirmed</strong>.
    </div>

    <div class="filter-container">
        <form method="get" action="ManageReservations">
            <label for="filter">Filter by Status:</label>
            <select name="filter" id="filter">
                <option value="All" <%= "All".equals(request.getAttribute("filter")) ? "selected" : "" %>>All</option>
                <option value="Pending" <%= "Pending".equals(request.getAttribute("filter")) ? "selected" : "" %>>Pending</option>
                <option value="Confirmed" <%= "Confirmed".equals(request.getAttribute("filter")) ? "selected" : "" %>>Confirmed</option>
                <option value="Completed" <%= "Completed".equals(request.getAttribute("filter")) ? "selected" : "" %>>Completed</option>
            </select>
            <button type="submit">Filter</button>
        </form>
    </div>

    <table class="reservation-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Total Fare</th>
                <th>Travel Date</th>
                <th>Status</th>
                <th>Trip Type</th>
                <th>Outbound (Origin → Destination)</th>
                <th>Return (Origin → Destination)</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<Map<String, Object>> reservations = (List<Map<String, Object>>) request.getAttribute("reservations");
                if (reservations != null && !reservations.isEmpty()) {
                    for (Map<String, Object> res : reservations) {
                        String reservationId = res.get("reservationId").toString();
            %>
            <tr>
                <td><%= reservationId %></td>
                <td><%= res.get("username") %></td>
                <td>$<%= res.get("totalFare") %></td>
                <td><%= res.get("travelDate") %></td>
                <td><%= res.get("status") %></td>
                <td><%= res.get("tripType") %></td>
                <td><%= res.get("outboundOrigin") %> → <%= res.get("outboundDestination") %></td>
                <td><%= res.get("tripType").equals("Round Trip") ? res.get("returnOrigin") + " → " + res.get("returnDestination") : "N/A" %></td>
                <td class="action-buttons">
                    <form method="post" action="CancelReservation" style="display:inline;">
                        <input type="hidden" name="reservationId" value="<%= reservationId %>">
                        <button type="submit" class="cancel">Cancel</button>
                    </form>
                    <button class="view" onclick="viewDetails('<%= reservationId %>')">View</button>
                </td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="9" class="no-reservations">No reservations found.</td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>

    <div class="note">
        Note: No charges will be refunded upon cancellation.
    </div>
    <div>
        <a href="success.jsp" class="back-link">Go back to Home Dashboard</a>
    </div>
    <script>
        function viewDetails(reservationId) {
            window.location.href = "ViewReservationDetails?reservationId=" + reservationId;
        }
    </script>
</body>
</html>
