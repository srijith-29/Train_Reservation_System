<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservation Success</title>
    <link rel="stylesheet" type="text/css" href="http://localhost:8080/train-reservation-system/css/style.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
            color: #333;
        }

        .container {
            max-width: 900px;
            margin: 50px auto;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .header {
            background: #28a745;
            color: #fff;
            padding: 20px;
            text-align: center;
        }

        .header h2 {
            margin: 0;
            font-size: 24px;
        }

        .reservation-details {
            padding: 20px;
        }

        .reservation-details h3 {
            margin-bottom: 15px;
            font-size: 20px;
            color: #28a745;
            text-align: center;
        }

        .reservation-details p {
            margin: 10px 0;
            font-size: 16px;
        }

        .reservation-details p strong {
            color: #555;
        }

        .back-link {
            display: inline-block;
            margin: 20px auto;
            padding: 10px 20px;
            background: #007bff;
            color: #fff;
            text-align: center;
            border-radius: 5px;
            text-decoration: none;
            font-size: 16px;
            transition: background 0.3s ease;
            text-align: center;
        }

        .back-link:hover {
            background: #0056b3;
        }

        .summary-table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }

        .summary-table th, .summary-table td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }

        .summary-table th {
            background: #f9f9f9;
            color: #555;
            font-weight: bold;
        }

        .summary-table td:first-child {
            font-weight: bold;
            color: #333;
        }

        .highlight {
            background: #eaffea;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>Your reservation was successful!</h2>
        </div>
        <div class="reservation-details">
            <h3>Reservation Details</h3>
            <table class="summary-table">
                <tr>
                    <td>Reservation ID:</td>
                    <td><%= request.getAttribute("reservationId") %></td>
                </tr>
                <tr>
                    <td>Origin:</td>
                    <td><%= request.getAttribute("Origin") %></td>
                </tr>
                <tr>
                    <td>Destination:</td>
                    <td><%= request.getAttribute("Destination") %></td>
                </tr>
                <tr>
                    <td>Travel Date:</td>
                    <td><%= request.getAttribute("travelDate") %></td>
                </tr>
                <tr>
                    <td>Departure Time:</td>
                    <td><%= request.getAttribute("departure") %></td>
                </tr>
                <tr>
                    <td>Arrival Time:</td>
                    <td><%= request.getAttribute("arrival") %></td>
                </tr>
                <tr>
                    <td>Travel Time:</td>
                    <td><%= request.getAttribute("travelTime") %></td>
                </tr>
                <tr class="highlight">
                    <td>Total Base Fare:</td>
                    <td>$<%= request.getAttribute("totalBaseFare") %></td>
                </tr>
                <tr class="highlight">
                    <td>Total Discount:</td>
                    <td>-$<%= request.getAttribute("totalDiscount") %></td>
                </tr>
                <tr class="highlight">
                    <td>Total Final Fare:</td>
                    <td><strong>$<%= request.getAttribute("totalFinalFare") %></strong></td>
                </tr>
                <tr>
                    <td>Reservation Status:</td>
                    <td><%= request.getAttribute("reservationStatus") %></td>
                </tr>
            </table>
            <a href="browse" class="back-link">Make Another Reservation</a>
        </div>
    </div>
</body>
</html>
