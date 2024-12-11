<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Reservations</title>
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

        h1 {
            text-align: center;
            color: #333;
        }

        form {
            text-align: center;
            margin-bottom: 20px;
        }

        form label {
            font-weight: bold;
            margin-right: 10px;
        }

        form select, form input {
            padding: 8px 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-right: 10px;
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
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: #fff;
        }

        table th, table td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: center;
        }

        table th {
            background-color: #007bff;
            color: white;
        }

        .no-results {
            text-align: center;
            color: #888;
            font-size: 16px;
        }

        .back-link-container {
            text-align: center; /* Center align the content inside the container */
            margin-top: 20px; /* Add spacing at the top */
        }

        .back-link {
            display: inline-block; /* Ensure the link behaves like an inline-block element */
            padding: 10px 15px;
            text-decoration: none;
            color: white;
            background-color: #007bff;
            border-radius: 5px;
            font-weight: bold;
        }

        .back-link:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>User Reservations</h1>

        <!-- Filter Form -->
        <form method="get" action="UserReservationServlet">
            <label for="transitLine">Transit Line:</label>
            <select name="transitLine" id="transitLine">
                <option value="">Select</option>
                <% 
                    List<Map<String, Object>> transitLines = (List<Map<String, Object>>) request.getAttribute("transitLines");
                    String selectedTransitLine = request.getParameter("transitLine");
                    for (Map<String, Object> line : transitLines) {
                        String lineName = (String) line.get("transitLine");
                %>
                    <option value="<%= lineName %>" <%= lineName.equals(selectedTransitLine) ? "selected" : "" %>>
                        <%= lineName %>
                    </option>
                <% } %>
            </select>

            <label for="travelDate">Travel Date:</label>
            <input type="date" name="travelDate" id="travelDate" value="<%= request.getParameter("travelDate") %>">
            <button type="submit">Filter</button>
        </form>

        <!-- User Records -->
        <% 
            List<Map<String, Object>> userRecords = (List<Map<String, Object>>) request.getAttribute("userRecords");
            if (userRecords == null || userRecords.isEmpty()) {
        %>
            <p class="no-results">No users found for the selected transit line and travel date.</p>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>Username</th>
                        <th>Email</th>
                        <th>First Name</th>
                        <th>Last Name</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, Object> user : userRecords) { %>
                        <tr>
                            <td><%= user.get("username") %></td>
                            <td><%= user.get("email") %></td>
                            <td><%= user.get("firstName") %></td>
                            <td><%= user.get("lastName") %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>

        <div class="back-link-container">
            <a href="ScheduleManagementServlet" class="back-link">Back to Dashboard</a>
        </div>        
    </div>
</body>
</html>
