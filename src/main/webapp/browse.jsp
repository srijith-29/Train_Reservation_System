<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Browse Train Schedules</title>
    <link rel="stylesheet" type="text/css" href="http://localhost:8080/train-reservation-system/css/style.css">
    <script>
        // Function to populate dropdowns dynamically
        function populateDropdowns(originsJson, destinationsJson) {
            const origins = JSON.parse(originsJson);
            const destinations = JSON.parse(destinationsJson);

            const originSelect = document.getElementById('origin');
            origins.forEach(origin => {
                const option = document.createElement('option');
                option.value = origin;
                option.textContent = origin;
                originSelect.appendChild(option);
            });

            const destinationSelect = document.getElementById('destination');
            destinations.forEach(destination => {
                const option = document.createElement('option');
                option.value = destination;
                option.textContent = destination;
                destinationSelect.appendChild(option);
            });
        }

        // Function to toggle return date input
        function toggleReturnDate() {
            const tripType = document.getElementById('tripType').value;
            const returnDateDiv = document.getElementById('returnDateDiv');
            const returnDateInput = document.getElementById('returnDate');

            if (tripType === 'round-trip') {
                returnDateDiv.style.display = 'block';
                returnDateInput.setAttribute('required', 'required'); // Add required attribute
            } else {
                returnDateDiv.style.display = 'none';
                returnDateInput.removeAttribute('required'); // Remove required attribute
            }
        }

        // Function to set the correct action before form submission
        function setFormAction(event) {
            const tripType = document.getElementById('tripType').value;
            const scheduleForm = document.getElementById('scheduleForm');

            if (tripType === 'round-trip') {
                scheduleForm.action = 'roundtripSearch'; // Set action to round trip servlet
            } else {
                scheduleForm.action = 'search'; // Set action to one way servlet
            }
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

        <form id="scheduleForm" method="get" onsubmit="setFormAction(event)">
            <div class="form-group">
                <label for="origin">Origin:</label>
                <select id="origin" name="origin" required></select>
            </div>
            <div class="form-group">
                <label for="destination">Destination:</label>
                <select id="destination" name="destination" required></select>
            </div>
            <div class="form-group">
                <label for="departureDate">Date of Travel:</label>
                <input type="date" id="departureDate" name="departureDate" required>
            </div>
            <div class="form-group">
                <label for="tripType">Trip Type:</label>
                <select id="tripType" name="tripType" onchange="toggleReturnDate()" required>
                    <option value="one-way" selected>One Way</option>
                    <option value="round-trip">Round Trip</option>
                </select>
            </div>
            <div class="form-group" id="returnDateDiv" style="display: none;">
                <label for="returnDate">Return Date:</label>
                <input type="date" id="returnDate" name="returnDate">
            </div>
            <input type="submit" value="Search">
        </form>

        <div>
            <p><a href="success.jsp" class="signup-link">Go back to Home Dashboard</a></p>
        </div>
    </div>
</body>
</html>
