<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Reservation Details</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }

        .container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            color: #007bff;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        table th, table td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }

        table th {
            background-color: #f4f4f4;
            font-weight: bold;
        }

        .no-data {
            text-align: center;
            color: gray;
            padding: 20px;
        }

        .back-link {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background: #007bff;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
            text-align: center;
        }

        .back-link:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Reservation Details</h2>

        <!-- Reservation Information -->
        <table>
            <thead>
                <tr>
                    <th>Field</th>
                    <th>Value</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Map<String, Object> reservationDetails = (Map<String, Object>) request.getAttribute("reservationDetails");
                    if (reservationDetails != null) {
                %>
                <tr>
                    <td>Reservation ID</td>
                    <td><%= reservationDetails.get("reservationId") %></td>
                </tr>
                <tr>
                    <td>Username</td>
                    <td><%= reservationDetails.get("username") %></td>
                </tr>
                <tr>
                    <td>Total Fare</td>
                    <td>$<%= reservationDetails.get("totalFare") %></td>
                </tr>
                <tr>
                    <td>Travel Date</td>
                    <td><%= reservationDetails.get("travelDate") %></td>
                </tr>
                <tr>
                    <td>Status</td>
                    <td><%= reservationDetails.get("status") %></td>
                </tr>
                <tr>
                    <td>Trip Type</td>
                    <td><%= reservationDetails.get("returnTransit") != null ? "Round Trip" : "One-Way" %></td>
                </tr>
                <tr>
                    <td>Outbound Route</td>
                    <td>
                        <%= reservationDetails.get("outboundOrigin") %> → <%= reservationDetails.get("outboundDestination") %>
                    </td>
                </tr>
                <tr>
                    <td>Return Route</td>
                    <td>
                        <%= reservationDetails.get("returnTransit") != null ? 
                            reservationDetails.get("returnOrigin") + " → " + reservationDetails.get("returnDestination") : "N/A" %>
                    </td>
                </tr>
                <%
                    } else {
                %>
                <tr>
                    <td colspan="2" class="no-data">No reservation details available.</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>

        <!-- Passenger Information -->
        <h3>Passengers</h3>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>First Name</th>
                    <th>Last Name</th>
                    <th>Age</th>
                    <th>Category</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Map<Integer, Map<String, Object>> passengers = (Map<Integer, Map<String, Object>>) request.getAttribute("passengers");
                    if (passengers != null && !passengers.isEmpty()) {
                        for (Map.Entry<Integer, Map<String, Object>> entry : passengers.entrySet()) {
                            int index = entry.getKey();
                            Map<String, Object> passenger = entry.getValue();
                %>
                <tr>
                    <td><%= index %></td>
                    <td><%= passenger.get("firstName") %></td>
                    <td><%= passenger.get("lastName") %></td>
                    <td><%= passenger.get("age") %></td>
                    <td><%= passenger.get("category") %></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="5" class="no-data">No passenger details available.</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>

        <!-- Back to Manage Reservations -->
        <a href="ManageReservations" class="back-link">Back to Manage Reservations</a>
    </div>
</body>
</html>
