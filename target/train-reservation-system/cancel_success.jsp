<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Cancellation Success</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            color: #333;
        }

        .container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        h2 {
            color: #28a745;
            margin-bottom: 20px;
        }

        p {
            font-size: 18px;
            color: #555;
            margin: 20px 0;
        }

        a {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
            transition: background 0.3s ease, transform 0.2s ease;
        }

        a:hover {
            background: #0056b3;
            transform: scale(1.05);
        }

        .icon {
            font-size: 50px;
            color: #28a745;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="icon">✔</div>
        <h2>Reservation Successfully Cancelled</h2>
        <p><%= request.getAttribute("message") %></p>
        <a href="ManageReservations">Back to Manage Reservations</a>
    </div>
</body>
</html>
