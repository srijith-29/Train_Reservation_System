<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Enter Passenger Details</title>
    <link rel="stylesheet" type="text/css" href="http://localhost:8080/train-reservation-system/css/style_passenger.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        .reservation-container {
            max-width: 800px;
            margin: auto;
            padding: 20px;
            background-color: #f9f9f9;
        }
        .fare-summary {
            position: fixed;
            top: 0;
            left: 50%;
            transform: translateX(-50%);
            background-color: #eef;
            border: 1px solid #cce;
            border-radius: 8px;
            padding: 15px;
            width: 90%;
            max-width: 760px;
            z-index: 1000;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .fare-summary p {
            font-size: 16px;
            margin: 5px 0;
        }
        .form-container {
            margin-top: 150px;
        }
        .passenger {
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #fff;
            overflow: hidden;
        }
        .passenger-header {
            background-color: #f1f1f1;
            padding: 10px;
            cursor: pointer;
            font-weight: bold;
        }
        .passenger-body {
            padding: 15px;
            display: none;
        }
        .form-group {
            margin-bottom: 10px;
        }
        .form-group label {
            display: block;
            font-weight: bold;
        }
        .form-group input, .form-group select {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .btn {
            padding: 10px 15px;
            font-size: 16px;
            cursor: pointer;
            border: none;
            border-radius: 4px;
            margin-top: 10px;
        }
        .btn-add {
            background-color: #007bff;
            color: white;
            display: block;
            margin: 10px auto;
        }
        .btn-remove {
            background-color: #dc3545;
            color: white;
            display: block;
            margin: 10px auto;
        }
        .btn:hover {
            opacity: 0.9;
        }
        .submit-section {
            text-align: center;
            margin-top: 20px;
        }
        .submit-section input[type="submit"] {
            background-color: #28a745;
            color: white;
            padding: 10px 20px;
            font-size: 18px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .submit-section input[type="submit"]:hover {
            opacity: 0.9;
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
    <script>
        let passengerIndex = 1;

        function addPassenger() {
            const passengerForm = `
                <div class="passenger" id="passenger-${passengerIndex}">
                    <div class="passenger-header" onclick="togglePassenger(${passengerIndex})">
                        Passenger ${passengerIndex}
                    </div>
                    <div class="passenger-body">
                        <div class="form-group">
                            <label>First Name:</label>
                            <input type="text" name="passenger[${passengerIndex}][firstName]" required>
                        </div>
                        <div class="form-group">
                            <label>Last Name:</label>
                            <input type="text" name="passenger[${passengerIndex}][lastName]" required>
                        </div>
                        <div class="form-group">
                            <label>Age:</label>
                            <input type="number" name="passenger[${passengerIndex}][age]" required>
                        </div>
                        <div class="form-group">
                            <label>Category:</label>
                            <select name="passenger[${passengerIndex}][category]" onchange="updateFare()" required>
                                <option value="Adult">Adult</option>
                                <option value="Child">Child</option>
                                <option value="Senior">Senior</option>
                                <option value="Disabled">Disabled</option>
                            </select>
                        </div>
                        <p>
                            <strong>Fare for Passenger:</strong> 
                            $<span class="fare-passenger" id="fare-${passengerIndex}">0.00</span> 
                            <span class="discount-info" id="discount-${passengerIndex}" style="color: green;"></span>
                        </p>
                        <button class="btn btn-remove" type="button" onclick="removePassenger(${passengerIndex})">Remove Passenger</button>
                    </div>
                </div>
            `;
            document.getElementById('passengerList').insertAdjacentHTML('beforeend', passengerForm);
            togglePassenger(passengerIndex);
            updateFare();
            passengerIndex++;
        }

        function removePassenger(index) {
            document.getElementById(`passenger-${index}`).remove();
            reindexPassengers();
            updateFare();
        }

        function reindexPassengers() {
            const passengers = document.querySelectorAll('.passenger');
            passengerIndex = 1;

            passengers.forEach((passenger) => {
                // Update the ID for the passenger div
                passenger.id = `passenger-${passengerIndex}`;

                // Update the passenger header text
                passenger.querySelector('.passenger-header').textContent = `Passenger ${passengerIndex}`;

                // Update the togglePassenger function's onclick attribute
                passenger.querySelector('.passenger-header').setAttribute('onclick', `togglePassenger(${passengerIndex})`);

                // Update the removePassenger function's onclick attribute
                const removeButton = passenger.querySelector('.btn-remove');
                removeButton.setAttribute('onclick', `removePassenger(${passengerIndex})`);

                // Update the fare and discount IDs
                passenger.querySelector('.fare-passenger').id = `fare-${passengerIndex}`;
                passenger.querySelector('.discount-info').id = `discount-${passengerIndex}`;

                // Update the input names to reflect the new index
                passenger.querySelectorAll('input, select').forEach((input) => {
                    input.name = input.name.replace(/\[\d+\]/, `[${passengerIndex}]`);
                });

                // Increment the passenger index
                passengerIndex++;
            });
        }

        function togglePassenger(index) {
            const passengerBody = document.querySelector(`#passenger-${index} .passenger-body`);
            const isVisible = passengerBody.style.display === "block";
            document.querySelectorAll('.passenger-body').forEach(body => body.style.display = "none");
            passengerBody.style.display = isVisible ? "none" : "block";
        }

        function serializePassengerData(event) {
            const passengers = [];
            const errorMessage = document.getElementById("error-message");
            errorMessage.style.display = "none"; // Hide error message initially
            errorMessage.textContent = ""; // Clear previous messages

            document.querySelectorAll('.passenger').forEach(passenger => {
                const firstName = passenger.querySelector('input[name*="[firstName]"]').value.trim();
                const lastName = passenger.querySelector('input[name*="[lastName]"]').value.trim();
                const age = passenger.querySelector('input[name*="[age]"]').value.trim();
                const category = passenger.querySelector('select[name*="[category]"]').value.trim();

                // Validate passenger details
                if (!firstName || !lastName || !age || !category) {
                    event.preventDefault();
                    errorMessage.style.display = "block";
                    errorMessage.textContent = "All passenger details are required. Please fill out all fields.";
                    return;
                }

                if (isNaN(age) || age <= 0) {
                    event.preventDefault();
                    errorMessage.style.display = "block";
                    errorMessage.textContent = "Age must be a valid positive number.";
                    return;
                }

                passengers.push({ firstName, lastName, age, category });
            });

            // Ensure at least one passenger is added
            if (passengers.length === 0) {
                event.preventDefault();
                errorMessage.style.display = "block";
                errorMessage.textContent = "You must add at least one passenger to complete the reservation.";
                return;
            }

            // If validation passes, add the serialized data to the form
            const serializedInput = document.createElement('input');
            serializedInput.type = 'hidden';
            serializedInput.name = 'passengerData';
            serializedInput.value = JSON.stringify(passengers);
            document.getElementById('passengerForm').appendChild(serializedInput);
        }


        function updateFare() {
            const baseFare = parseFloat(document.getElementById("fare").value);
            let totalBaseFare = 0;
            let totalDiscount = 0;
            let totalFinalFare = 0;

            const passengers = document.querySelectorAll('.passenger');
            passengers.forEach((passenger, idx) => {
                const category = passenger.querySelector(`select[name="passenger[${idx + 1}][category]"]`).value;
                let discountPercentage = 0;

                if (category === "Child") discountPercentage = 5;
                else if (category === "Senior") discountPercentage = 10;
                else if (category === "Disabled") discountPercentage = 20;

                const discount = (baseFare * discountPercentage) / 100;
                const finalFare = baseFare - discount;

                passenger.querySelector(`#fare-${idx + 1}`).innerText = finalFare.toFixed(2);
                passenger.querySelector(`#discount-${idx + 1}`).innerText = discountPercentage > 0
                    ? `(Discount: $${discount.toFixed(2)}, ${discountPercentage}%)`
                    : "";

                totalBaseFare += baseFare;
                totalDiscount += discount;
                totalFinalFare += finalFare;
            });

            document.getElementById('totalBaseFare').innerText = totalBaseFare.toFixed(2);
            document.getElementById('totalDiscount').innerText = totalDiscount.toFixed(2);
            document.getElementById('totalFinalFare').innerText = totalFinalFare.toFixed(2);

            document.getElementById('totalBaseFareInput').value = totalBaseFare.toFixed(2);
            document.getElementById('totalDiscountInput').value = totalDiscount.toFixed(2);
            document.getElementById('totalFinalFareInput').value = totalFinalFare.toFixed(2);
        }
    </script>
</head>
<body>
    <div class="fare-summary">
        <p><strong>Base Fare (Per Passenger):</strong> $<%= request.getParameter("fare") %></p>
        <p><strong>Total Base Fare:</strong> $<span id="totalBaseFare">0.00</span></p>
        <p><strong>Total Discount:</strong> $<span id="totalDiscount">0.00</span></p>
        <p><strong>Total Final Fare:</strong> $<span id="totalFinalFare">0.00</span></p>
    </div>

    <div class="reservation-container form-container">
        <h2>Passenger Details</h2>
        <div id="error-message" style="display: none; color: red; font-weight: bold; margin-bottom: 20px;"></div>
        <form id="passengerForm" action="completeReservation" method="POST" onsubmit="serializePassengerData(event)">
            <input type="hidden" name="scheduleId" value="<%= request.getParameter("scheduleId") %>">
            <input type="hidden" name="fare" id="fare" value="<%= request.getParameter("fare") %>">
            <input type="hidden" name="travelDate" value="<%= request.getParameter("travelDate") %>">
            <input type="hidden" name="totalBaseFare" id="totalBaseFareInput" value="0.00">
            <input type="hidden" name="totalDiscount" id="totalDiscountInput" value="0.00">
            <input type="hidden" name="totalFinalFare" id="totalFinalFareInput" value="0.00">
            <div id="passengerList"></div>
            <button class="btn btn-add" type="button" onclick="addPassenger()">Add Passenger</button>
            <div class="submit-section">
                <input type="submit" value="Complete Reservation">
            </div>
        </form>
    </div>
    <!-- Back to Browse Link -->
    <div>
        <a href="browse" class="back-link">Back to Browse</a>
    </div>
</body>
</html>
