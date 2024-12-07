import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;
import java.sql.*;
import java.util.*;

public class FilterReservationsServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Ensure the user is logged in and has the "admin" role
        String role = (String) request.getSession().getAttribute("role");
        if (role == null || !"admin".equalsIgnoreCase(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Retrieve form data: username and transit line filter
        String username = request.getParameter("username");
        String transitLine = request.getParameter("transitLine");

        double totalFare = 0.0;
        List<Map<String, Object>> reservations = new ArrayList<>();

        // SQL query to get reservation data for the selected username and transit line
        String sql = "SELECT r.Reservation_ID, r.Username, r.Passenger_ID, r.Outbound_Schedule_ID, r.Return_Schedule_ID, r.Total_Fare, r.Reservation_Date, r.Travel_Date " +
                    "FROM Reservation r " +
                    "LEFT JOIN Schedule s ON r.Outbound_Schedule_ID = s.Schedule_ID " +
                    "LEFT JOIN Schedule rs ON r.Return_Schedule_ID = rs.Schedule_ID " +
                    "WHERE 1=1 ";

        // Add filter for Username if provided
        if (username != null && !username.isEmpty()) {
            sql += " AND r.Username = ? ";
        }

        // Add filter for Transit Line if provided
        if (transitLine != null && !transitLine.isEmpty()) {
            sql += " AND (s.Transit_Line = ? OR rs.Transit_Line = ?)";
        }

        try (Connection conn = DBHelper.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            int parameterIndex = 1;

            // Set username parameter if present
            if (username != null && !username.isEmpty()) {
                stmt.setString(parameterIndex++, username);
            }

            // Set transit line parameter if present
            if (transitLine != null && !transitLine.isEmpty()) {
                stmt.setString(parameterIndex++, transitLine);  // Set Transit Line filter for Outbound Schedule
                stmt.setString(parameterIndex++, transitLine);  // Set Transit Line filter for Return Schedule
            }

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
            request.getRequestDispatcher("filter-reservation.jsp").forward(request, response);
            return;
        }

        // Set attributes for JSP
        request.setAttribute("totalFare", totalFare);
        request.setAttribute("username", username);
        request.setAttribute("transitLine", transitLine);
        request.setAttribute("reservations", reservations);

        // Forward the request to the JSP to display the result
        request.getRequestDispatcher("filter-reservations.jsp").forward(request, response);
    }
}
