<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Browse Train Schedules</title>
    <link rel="stylesheet" type="text/css" href="http://localhost:8080/train-reservation-system/css/style.css">
    <script>
        // Function to populate dropdowns dynamically
        function populateDropdowns(originsJson, destinationsJson) {
            // Parse the JSON data
            const origins = JSON.parse(originsJson);
            const destinations = JSON.parse(destinationsJson);

            // Populate the origins dropdown
            const originSelect = document.getElementById('origin');
            origins.forEach(origin => {
                const option = document.createElement('option');
                option.value = origin;
                option.textContent = origin;
                originSelect.appendChild(option);
            });

            // Populate the destinations dropdown
            const destinationSelect = document.getElementById('destination');
            destinations.forEach(destination => {
                const option = document.createElement('option');
                option.value = destination;
                option.textContent = destination;
                destinationSelect.appendChild(option);
            });
        }
    </script>
</head>
<body>
    <div class="login-container">
        <h2>Browse Train Schedules</h2>

        <!-- JSON Data for JavaScript -->
        <script>
            const originsJson = '<%= request.getAttribute("originsJson") %>';
            const destinationsJson = '<%= request.getAttribute("destinationsJson") %>';
            window.onload = function () {
                populateDropdowns(originsJson, destinationsJson);
            };
        </script>

        <form action="search" method="get">
            <div class="form-group">
                <label for="origin">Origin:</label>
                <select id="origin" name="origin" required>
                    <!-- Options will be populated by JavaScript -->
                </select>
            </div>
            <div class="form-group">
                <label for="destination">Destination:</label>
                <select id="destination" name="destination" required>
                    <!-- Options will be populated by JavaScript -->
                </select>
            </div>
            <div class="form-group">
                <label for="departureDate">Date of Travel:</label>
                <input type="date" id="departureDate" name="departureDate" required>
            </div>
            <input type="submit" value="Search">
        </form>

        <div>
            <p><a href="login.jsp" class="signup-link">Go to Login</a></p>
        </div>
    </div>
</body>
</html>
