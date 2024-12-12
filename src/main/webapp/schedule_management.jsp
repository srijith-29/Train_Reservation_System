<%@ page language="java" contentType="text/html; charset=UTF-8" import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Schedules</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
        }

        h1 {
            text-align: center;
            margin-top: 20px;
            color: #333;
        }

        form {
            text-align: center;
            margin: 20px 0;
        }

        form label {
            font-weight: bold;
            margin-right: 10px;
        }

        form select {
            padding: 8px 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-right: 10px;
        }

        .no-results {
            text-align: center;
            margin: 10px 0 20px;
            font-size: 16px;
            color: #555;
            font-style: italic;
        }

        form button {
            padding: 8px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
        }

        form button:hover {
            background-color: #0056b3;
        }

        table {
            width: 90%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        table thead {
            background-color: #007bff;
            color: white;
        }

        table th, table td {
            padding: 15px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }

        table th {
            font-weight: bold;
            user-select: none; /* Prevent text selection */
            cursor: pointer;
        }

        table tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        /* table tr:hover {
            background-color: #f1f1f1;
            cursor: pointer;
        } */

        table td button {
            padding: 8px 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
        }

        table td form {
            display: inline-block;
            margin: 0;
        }

        table td button[type="submit"] {
            background-color: #28a745;
            color: white;
        }

        table td button[type="submit"]:hover {
            background-color: #218838;
        }

        table td button[type="submit"].delete {
            background-color: #dc3545;
            color: white;
        }

        table td button[type="submit"].delete:hover {
            background-color: #b02a37;
        }

        table td button.edit {
            background-color: #007bff;
            color: white;
        }

        table td button.edit:hover {
            background-color: #0056b3;
        }

        .no-schedules {
            text-align: center;
            padding: 20px;
            font-size: 18px;
            color: #777;
        }
        .back-link-container {
            text-align: center;
            margin: 20px;
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


    </style>
</head>
<body>
    <h1>Schedule Management</h1>

    <!-- Filter Form -->
    <form method="get" action="ScheduleManagementServlet">
        <label for="origin">Origin:</label>
        <select name="origin" id="origin">
            <option value="">All</option>
            <% 
                List<Map<String, Object>> stations = (List<Map<String, Object>>) request.getAttribute("stations");
                String selectedOrigin = request.getParameter("origin");
                if (stations != null) {
                    for (Map<String, Object> station : stations) {
                        String stationName = (String) station.get("stationName");
            %>
                <option value="<%= stationName %>" <%= stationName.equals(selectedOrigin) ? "selected" : "" %>><%= stationName %></option>
            <% 
                    }
                }
            %>
        </select>
        <label for="destination">Destination:</label>
        <select name="destination" id="destination">
            <option value="">All</option>
            <% 
                String selectedDestination = request.getParameter("destination");
                if (stations != null) {
                    for (Map<String, Object> station : stations) {
                        String stationName = (String) station.get("stationName");
            %>
                <option value="<%= stationName %>" <%= stationName.equals(selectedDestination) ? "selected" : "" %>><%= stationName %></option>
            <% 
                    }
                }
            %>
        </select>
        <button type="submit">Filter</button>
    </form>

    <div class="back-link-container">
        <a href="cusrep-dashboard.jsp" class="back-link">Back to Dashboard</a>
    </div>
    
    <!-- Schedule Table -->
    <table border="1">
        <thead>
            <tr>
                <th>Schedule ID</th>
                <th>Transit Line</th>
                <th>Origin</th>
                <th>Destination</th>
                <th>Departure</th>
                <th>Arrival</th>
                <th>Fare</th>
                <th>Stops</th>
                <th>Departure Date</th>
                <th>Travel Time</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <% List<Map<String, Object>> schedules = (List<Map<String, Object>>) request.getAttribute("schedules");
                if (schedules != null && !schedules.isEmpty()) {
                   for (Map<String, Object> schedule : schedules) { %>
                       <tr>
                           <td><%= schedule.get("scheduleId") %></td>
                           <td><%= schedule.get("transitLine") %></td>
                           <td><%= schedule.get("origin") %></td>
                           <td><%= schedule.get("destination") %></td>
                           <td><%= schedule.get("departure") %></td>
                           <td><%= schedule.get("arrival") %></td>
                           <td><%= schedule.get("fare") %></td>
                           <td><%= schedule.get("stops") %></td>
                           <td><%= schedule.get("departureDate") %></td>
                           <td><%= schedule.get("travelTime") %></td>
                           <td>
                               <form method="get" action="ScheduleManagementServlet" style="display:inline;">
                                   <input type="hidden" name="scheduleId" value="<%= schedule.get("scheduleId") %>">
                                   <input type="hidden" name="action" value="loadEditForm">
                                   <button type="submit">Edit</button>
                               </form>
                               <form method="post" action="ScheduleManagementServlet" style="display:inline;">
                                   <input type="hidden" name="scheduleId" value="<%= schedule.get("scheduleId") %>">
                                   <input type="hidden" name="action" value="delete">
                                   <button type="submit">Delete</button>
                               </form>
                           </td>
                       </tr>
            <%     }
               } else { %>
                   <tr>
                    <td colspan="11" class="no-schedules">No schedules found.</td>
                   </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>
