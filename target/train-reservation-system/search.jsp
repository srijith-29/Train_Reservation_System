<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Search Results</title>
    <link rel="stylesheet" type="text/css" href="http://localhost:8080/train-reservation-system/css/style_results.css">
    <script>
        // Function to populate the search results table
        function populateResultsTable(schedulesJson) {
            const schedules = JSON.parse(schedulesJson);

            const resultsTableBody = document.getElementById('resultsTableBody');

            // Clear any existing rows
            resultsTableBody.innerHTML = '';

            if (schedules.length === 0) {
                // No results found
                const noResultsRow = document.createElement('tr');
                const noResultsCell = document.createElement('td');
                noResultsCell.colSpan = 7;
                noResultsCell.textContent = 'No train schedules found for the selected criteria.';
                noResultsRow.appendChild(noResultsCell);
                resultsTableBody.appendChild(noResultsRow);
            } else {
                // Populate rows with data
                schedules.forEach(schedule => {
                    const row = document.createElement('tr');

                    const transitLineCell = document.createElement('td');
                    transitLineCell.textContent = schedule.transitLine;

                    const trainNameCell = document.createElement('td');
                    trainNameCell.textContent = schedule.trainName;

                    const departureDateCell = document.createElement('td'); // New column for departure date
                    departureDateCell.textContent = schedule.departureDate;

                    const departureCell = document.createElement('td');
                    departureCell.textContent = schedule.departure;

                    const arrivalCell = document.createElement('td');
                    arrivalCell.textContent = schedule.arrival;

                    const fareCell = document.createElement('td');
                    fareCell.textContent = schedule.fare;

                    const stopsCell = document.createElement('td');
                    stopsCell.textContent = schedule.stops;

                    row.appendChild(transitLineCell);
                    row.appendChild(trainNameCell);
                    row.appendChild(departureDateCell); // Append departure date
                    row.appendChild(departureCell);
                    row.appendChild(arrivalCell);
                    row.appendChild(fareCell);
                    row.appendChild(stopsCell);

                    resultsTableBody.appendChild(row);
                });
            }
        }

        // Function to sort table rows based on a specific column index
        function sortTable(columnIndex, dataType) {
            const table = document.querySelector('.results-table');
            const rows = Array.from(table.tBodies[0].rows);
            const header = table.tHead.rows[0].cells[columnIndex];
            const isAscending = !header.classList.contains('asc');

            // Clear previous sort indicators
            Array.from(table.tHead.rows[0].cells).forEach(cell => {
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
            rows.forEach(row => table.tBodies[0].appendChild(row));
        }
    </script>
</head>
<body>
    <div class="search-results-container">
        <h2>Search Results</h2>

        <!-- JSON Data for JavaScript -->
        <script>
            const schedulesJson = '<%= request.getAttribute("schedulesJson") %>';
            window.onload = function () {
                populateResultsTable(schedulesJson);
            };
        </script>

        <!-- Results Table -->
        <table class="results-table">
            <thead>
                <tr>
                    <th onclick="sortTable(0, 'text')">Transit Line</th>
                    <th onclick="sortTable(1, 'text')">Train Name</th>
                    <th onclick="sortTable(2, 'text')">Departure Date</th> <!-- New column -->
                    <th onclick="sortTable(3, 'time')">Departure Time</th>
                    <th onclick="sortTable(4, 'time')">Arrival</th>
                    <th onclick="sortTable(5, 'number')">Fare</th>
                    <th>Stops</th>
                </tr>
            </thead>
            <tbody id="resultsTableBody">
                <!-- Rows will be populated by JavaScript -->
            </tbody>
        </table>

        <!-- Back to Browse Link -->
        <div>
            <a href="browse" class="back-link">Back to Browse</a>
        </div>
    </div>
</body>
</html>
