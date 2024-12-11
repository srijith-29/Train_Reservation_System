<%@ page language="java" contentType="text/html; charset=UTF-8" import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Schedule</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
        }
        .form-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .form-container h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .form-group input, .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .form-group button {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
        }
        .form-group button:hover {
            background-color: #0056b3;
        }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            text-align: center;
            text-decoration: none;
            color: #007bff;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        .error-message {
            color: red;
            font-size: 14px;
            text-align: center;
            margin-top: 10px;
        }
    </style>
    <script>
        function validateSchedule() {
            // Get departure and arrival times
            var departureTime = document.getElementById("departureTime").value;
            var arrivalTime = document.getElementById("arrivalTime").value;

            // Check if arrival time is earlier than departure time
            if (arrivalTime < departureTime) {
                document.getElementById("error-message").innerText = "Arrival time cannot be earlier than departure time.";
                return false;  // Prevent form submission
            }

            document.getElementById("error-message").innerText = "";  // Clear error message
            return true;  // Allow form submission
        }
    </script>
</head>
<body>
    <div class="form-container">
        <h2>Edit Schedule</h2>
        <form method="post" action="ScheduleManagementServlet" onsubmit="return validateSchedule()">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="scheduleId" value="<%= request.getAttribute("scheduleId") %>">
    
            <div class="form-group">
                <label for="departureDate">Departure Date</label>
                <input type="date" id="departureDate" name="departureDate" value="<%= request.getAttribute("departureDate") %>" required>
            </div>
    
            <div class="form-group">
                <label for="departureTime">Departure Time</label>
                <input type="time" id="departureTime" name="departureTime" value="<%= request.getAttribute("departureTime") %>" required>
            </div>
    
            <div class="form-group">
                <label for="arrivalTime">Arrival Time</label>
                <input type="time" id="arrivalTime" name="arrivalTime" value="<%= request.getAttribute("arrivalTime") %>" required>
            </div>
    
            <div class="form-group">
                <button type="submit">Update Schedule</button>
            </div>

            <!-- Error message will be displayed here -->
            <div id="error-message" class="error-message"></div>
        </form>
        <a href="ScheduleManagementServlet" class="back-link">Back to Manage Schedules</a>
    </div>
</body>
</html>
