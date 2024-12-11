<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*, java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Confirmation</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f9f9f9;
        }
        .container {
            max-width: 90%;
            margin: auto;
            padding: 20px;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        h1, h3 {
            text-align: center;
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        table th, table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
            word-wrap: break-word;
        }
        table th {
            background-color: #007bff;
            color: white;
        }
        table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        table tr:hover {
            background-color: #f1f1f1;
        }
        .actions {
            text-align: center;
            margin-top: 20px;
        }
        .back-link {
            text-decoration: none;
            color: white;
            background-color: #007bff;
            padding: 10px 15px;
            border-radius: 5px;
            font-weight: bold;
        }
        .back-link:hover {
            background-color: #0056b3;
        }
        .no-impact {
            text-align: center;
            color: #888;
            font-size: 16px;
            margin-top: 20px;
        }
        .responsive-table {
            overflow-x: auto;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Edit Confirmation</h1>
        <p>The following changes have been made:</p>

        <!-- Display updated schedule details -->
        <h3>Updated Schedule Details</h3>
        <div class="responsive-table">
            <table>
                <tr>
                    <th>Schedule ID</th>
                    <th>Transit Line</th>
                    <th>Origin</th>
                    <th>Destination</th>
                    <th>Departure</th>
                    <th>Arrival</th>
                    <th>Departure Date</th>
                    <th>Travel Time</th>
                </tr>
                <tr>
                    <td><%= request.getAttribute("scheduleId") %></td>
                    <td><%= request.getAttribute("transitLine") %></td>
                    <td><%= request.getAttribute("origin") %></td>
                    <td><%= request.getAttribute("destination") %></td>
                    <td><%= request.getAttribute("departure") %></td>
                    <td><%= request.getAttribute("arrival") %></td>
                    <td><%= request.getAttribute("departureDate") %></td>
                    <td><%= request.getAttribute("travelTime") %></td>
                </tr>
            </table>
        </div>

        <!-- Display affected reservations -->
        <h3>Affected Reservations</h3>
        <div class="responsive-table">
            <% 
                List<String> reservationColumnNames = (List<String>) request.getAttribute("reservationColumnNames");
                List<Map<String, Object>> reservations = (List<Map<String, Object>>) request.getAttribute("reservations");
                if (reservations == null || reservations.isEmpty()) {
            %>
                <p class="no-impact">No reservations were impacted by this change.</p>
            <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <% for (String columnName : reservationColumnNames) { %>
                                <th><%= columnName %></th>
                            <% } %>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Map<String, Object> reservation : reservations) { %>
                            <tr>
                                <% for (String columnName : reservationColumnNames) { %>
                                    <td>
                                        <% 
                                            Object value = reservation.get(columnName);
                                            if ("Return_Schedule_ID".equals(columnName) && value == null) { 
                                        %>
                                            N/A
                                        <% 
                                            } else { 
                                        %>
                                            <%= value %>
                                        <% 
                                            } 
                                        %>
                                    </td>                                    
                                <% } %>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>

        <div class="actions">
            <a href="ScheduleManagementServlet" class="back-link">Back to Manage Schedules</a>
        </div>
    </div>
</body>
</html>
