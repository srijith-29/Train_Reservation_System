<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Round Trip Reservation Success</title>
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
            max-height: 90vh; /* Limit the height to 90% of the viewport */
            overflow-y: auto; /* Add vertical scrolling */
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
            <h2>Your Round Trip Reservation was Successful!</h2>
        </div>
        <div class="reservation-details">
            <h3>Outbound Reservation Details</h3>
            <table class="summary-table">
                <tr>
                    <td>Origin:</td>
                    <td><%= request.getAttribute("OutboundOrigin") %></td>
                </tr>
                <tr>
                    <td>Destination:</td>
                    <td><%= request.getAttribute("OutboundDestination") %></td>
                </tr>
                <tr>
                    <td>Outbound Travel Date:</td>
                    <td><%= request.getAttribute("travelDate") %></td>
                </tr>
                <tr>
                    <td>Departure Time:</td>
                    <td><%= request.getAttribute("OutboundDeparture") %></td>
                </tr>
                <tr>
                    <td>Arrival Time:</td>
                    <td><%= request.getAttribute("OutboundArrival") %></td>
                </tr>
                <tr>
                    <td>Travel Time:</td>
                    <td><%= request.getAttribute("OutboundTravelTime") %></td>
                </tr>
            </table>

            <h3>Return Reservation Details</h3>
            <table class="summary-table">
                <tr>
                    <td>Origin:</td>
                    <td><%= request.getAttribute("ReturnOrigin") %></td>
                </tr>
                <tr>
                    <td>Destination:</td>
                    <td><%= request.getAttribute("ReturnDestination") %></td>
                </tr>
                <tr>
                    <td>Return Travel Date:</td>
                    <td><%= request.getAttribute("returnDate") %></td>
                </tr>
                <tr>
                    <td>Departure Time:</td>
                    <td><%= request.getAttribute("ReturnDeparture") %></td>
                </tr>
                <tr>
                    <td>Arrival Time:</td>
                    <td><%= request.getAttribute("ReturnArrival") %></td>
                </tr>
                <tr>
                    <td>Travel Time:</td>
                    <td><%= request.getAttribute("ReturnTravelTime") %></td>
                </tr>
            </table>

            <h3>Fare Summary</h3>
            <table class="summary-table">
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
