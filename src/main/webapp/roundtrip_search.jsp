<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Round Trip Schedules</title>
    <link rel="stylesheet" type="text/css" href="http://localhost:8080/train-reservation-system/css/style_results.css">
    <style>
        .results-table {
            width: 100%;
            border-collapse: collapse;
        }

        .results-table th, .results-table td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }

        .results-table th {
            cursor: pointer;
        }

        .results-table tbody tr:hover {
            cursor: pointer;
            background-color: #f0f0f0;
        }

        .results-table tbody tr.selected {
            background-color: #007bff;
            color: #fff;
        }

        .back-link {
            margin-top: 20px;
            display: inline-block;
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
        }

        .back-link:hover {
            background-color: #0056b3;
        }
    </style>
    <script>
        let selectedOutbound = null;
        let selectedOutboundFare = null;
        let selectedReturn = null;
        let selectedReturnFare = null;
        let selectedOutboundDepartureDate = null;
        let selectedReturnDepartureDate = null;

        function populateTable(jsonData, tableId) {
            const schedules = JSON.parse(jsonData);
            const tableBody = document.getElementById(tableId);
            tableBody.innerHTML = "";

            if (schedules.length === 0) {
                const noResultsRow = document.createElement('tr');
                const noResultsCell = document.createElement('td');
                noResultsCell.colSpan = 5;
                noResultsCell.textContent = 'No train schedules found for the selected criteria.';
                noResultsRow.appendChild(noResultsCell);
                tableBody.appendChild(noResultsRow);
            } else {
                schedules.forEach(schedule => {
                    const row = document.createElement('tr');
                    row.onclick = () => selectSchedule(row, schedule.scheduleId, schedule.fare, schedule.departureDate, tableId);

                    const trainNameCell = document.createElement('td');
                    trainNameCell.textContent = schedule.trainName;

                    const departureCell = document.createElement('td');
                    departureCell.textContent = schedule.departure;

                    const arrivalCell = document.createElement('td');
                    arrivalCell.textContent = schedule.arrival;

                    const fareCell = document.createElement('td');
                    fareCell.textContent = schedule.fare;

                    const departureDateCell = document.createElement('td');
                    departureDateCell.textContent = schedule.departureDate;

                    row.appendChild(trainNameCell);
                    row.appendChild(departureCell);
                    row.appendChild(arrivalCell);
                    row.appendChild(fareCell);
                    row.appendChild(departureDateCell);

                    tableBody.appendChild(row);
                });
            }
        }


        function selectSchedule(row, scheduleId, fare, departureDate, tableId) {
            const tableBody = row.parentNode;

            // Clear previous selection
            Array.from(tableBody.rows).forEach(r => r.classList.remove('selected'));

            // Highlight current selection
            row.classList.add('selected');

            if (tableId === "outboundTable") {
                selectedOutbound = scheduleId;
                selectedOutboundFare = fare;
                selectedOutboundDepartureDate = departureDate;
            } else if (tableId === "returnTable") {
                selectedReturn = scheduleId;
                selectedReturnFare = fare;
                selectedReturnDepartureDate = departureDate;
            }
        }


        function submitSelection() {
            if (!selectedOutbound || !selectedReturn) {
                alert("Please select both outbound and return schedules.");
                return;
            }

            const totalFare = parseFloat(selectedOutboundFare) + parseFloat(selectedReturnFare);

            document.getElementById("outboundScheduleId").value = selectedOutbound;
            document.getElementById("outboundFare").value = selectedOutboundFare;
            document.getElementById("outboundDepartureDate").value = selectedOutboundDepartureDate;

            document.getElementById("returnScheduleId").value = selectedReturn;
            document.getElementById("returnFare").value = selectedReturnFare;
            document.getElementById("returnDepartureDate").value = selectedReturnDepartureDate;

            document.getElementById("totalFare").value = totalFare.toFixed(2);

            document.getElementById("roundTripForm").submit();
        }

        function sortTable(tableId, columnIndex, dataType) {
            const table = document.getElementById(tableId).parentNode;
            const rows = Array.from(table.querySelector("tbody").rows);
            const header = table.querySelectorAll("thead th")[columnIndex];
            const isAscending = !header.classList.contains('asc');

            // Clear previous sort indicators
            Array.from(table.querySelectorAll("thead th")).forEach(cell => {
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
            const tbody = table.querySelector("tbody");
            rows.forEach(row => tbody.appendChild(row));
        }

        window.onload = function () {
            populateTable('<%= request.getAttribute("outboundSchedules") %>', 'outboundTable');
            populateTable('<%= request.getAttribute("returnSchedules") %>', 'returnTable');
        };
    </script>
</head>
<body>
    <div class="search-results-container">
        <h2>Round Trip Schedules</h2>

        <h3>Outbound Schedules</h3>
        <table class="results-table">
            <thead>
                <tr>
                    <th onclick="sortTable('outboundTable', 0, 'text')">Train Name</th>
                    <th onclick="sortTable('outboundTable', 1, 'time')">Departure</th>
                    <th onclick="sortTable('outboundTable', 2, 'time')">Arrival</th>
                    <th onclick="sortTable('outboundTable', 3, 'number')">Fare</th>
                    <th onclick="sortTable('outboundTable', 4, 'text')">Departure Date</th>
                </tr>
            </thead>
            <tbody id="outboundTable"></tbody>
        </table>

        <h3>Return Schedules</h3>
        <table class="results-table">
            <thead>
                <tr>
                    <th onclick="sortTable('returnTable', 0, 'text')">Train Name</th>
                    <th onclick="sortTable('returnTable', 1, 'time')">Departure</th>
                    <th onclick="sortTable('returnTable', 2, 'time')">Arrival</th>
                    <th onclick="sortTable('returnTable', 3, 'number')">Fare</th>
                    <th onclick="sortTable('returnTable', 4, 'text')">Departure Date</th>
                </tr>
            </thead>
            <tbody id="returnTable"></tbody>
        </table>

        <form id="roundTripForm" action="roundtrip_reservation_details.jsp" method="POST">
            <input type="hidden" id="outboundScheduleId" name="outboundScheduleId">
            <input type="hidden" id="outboundDepartureDate" name="outboundDepartureDate">
            <input type="hidden" id="returnDepartureDate" name="returnDepartureDate">
            <input type="hidden" id="outboundFare" name="outboundFare">
            <input type="hidden" id="returnScheduleId" name="returnScheduleId">
            <input type="hidden" id="returnFare" name="returnFare">
            <input type="hidden" id="totalFare" name="totalFare">
            <button type="button" onclick="submitSelection()">Proceed to Reservation</button>
        </form>

        <!-- Back to Browse Link -->
        <div>
            <a href="browse" class="back-link">Back to Browse</a>
        </div>
    </div>
</body>
</html>
