import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;
import java.sql.*;
import java.util.*;

public class SalesReportServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String role = (String) request.getSession().getAttribute("role");
        if (role == null || !"admin".equalsIgnoreCase(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String monthName = request.getParameter("month");
        String year = request.getParameter("year");

        // Convert month name to number
        int month = getMonthNumber(monthName);

        double totalFare = 0.0;
        List<Map<String, Object>> reservations = new ArrayList<>();

        if (month == -1) {
            request.setAttribute("errorMessage", "Invalid month name provided.");
            request.getRequestDispatcher("sales-report.jsp").forward(request, response);
            return;
        }

        // SQL query to get reservation data for the selected month and year
        String sql = "SELECT Reservation_ID, Username, Passenger_ID, Outbound_Schedule_ID, Return_Schedule_ID, Total_Fare, Reservation_Date, Travel_Date " +
                    "FROM Reservation " +
                    "WHERE MONTH(Reservation_Date) = ? AND YEAR(Reservation_Date) = ?";

        try (Connection conn = DBHelper.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, month);  // Set the month parameter
            stmt.setInt(2, Integer.parseInt(year));   // Set the year parameter

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> reservation = new HashMap<>();
                reservation.put("reservationId", rs.getInt("Reservation_ID"));
                reservation.put("username", rs.getString("Username"));
                reservation.put("passengerId", rs.getInt("Passenger_ID"));
                reservation.put("outboundScheduleId", rs.getInt("Outbound_Schedule_ID"));
                reservation.put("returnScheduleId", rs.getObject("Return_Schedule_ID"));
                reservation.put("totalFare", rs.getDouble("Total_Fare"));
                reservation.put("reservationDate", rs.getDate("Reservation_Date"));
                reservation.put("travelDate", rs.getDate("Travel_Date"));

                reservations.add(reservation);
                totalFare += rs.getDouble("Total_Fare");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while fetching the data.");
            request.getRequestDispatcher("sales-report.jsp").forward(request, response);
            return;
        }

        // Set attributes for JSP
        request.setAttribute("totalFare", totalFare);
        request.setAttribute("month", monthName);
        request.setAttribute("year", year);
        request.setAttribute("reservations", reservations);

        // Forward the request to the JSP to display the result
        request.getRequestDispatcher("sales-report.jsp").forward(request, response);
    }

    private int getMonthNumber(String monthName) {
        switch (monthName) {
            case "January": return 1;
            case "February": return 2;
            case "March": return 3;
            case "April": return 4;
            case "May": return 5;
            case "June": return 6;
            case "July": return 7;
            case "August": return 8;
            case "September": return 9;
            case "October": return 10;
            case "November": return 11;
            case "December": return 12;
            default: return -1;  // Invalid month
        }
    }
}
