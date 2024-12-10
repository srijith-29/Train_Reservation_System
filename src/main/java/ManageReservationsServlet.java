import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ManageReservationsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the current username from the session
        String username = (String) request.getSession().getAttribute("username");

        if (username == null || username.isEmpty()) {
            request.setAttribute("errorMessage", "Session lost. Please log in again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        String filter = request.getParameter("filter") == null ? "All" : request.getParameter("filter");

        try (Connection connection = DBHelper.getConnection()) {
            // Build SQL query with optional filter
            String query = """
                SELECT r.Reservation_ID, r.Username, r.Total_Fare, r.Travel_Date, r.Reservation_Status, 
                       s1.Transit_Line AS Outbound_Transit, s2.Transit_Line AS Return_Transit,
                       origin1.Name AS Outbound_Origin, dest1.Name AS Outbound_Destination,
                       origin2.Name AS Return_Origin, dest2.Name AS Return_Destination
                FROM reservation r
                LEFT JOIN schedule s1 ON r.Outbound_Schedule_ID = s1.Schedule_ID
                LEFT JOIN schedule s2 ON r.Return_Schedule_ID = s2.Schedule_ID
                LEFT JOIN station origin1 ON s1.Origin = origin1.Station_ID
                LEFT JOIN station dest1 ON s1.Destination = dest1.Station_ID
                LEFT JOIN station origin2 ON s2.Origin = origin2.Station_ID
                LEFT JOIN station dest2 ON s2.Destination = dest2.Station_ID
                WHERE r.Username = ?
            """;

            if (!filter.equals("All")) {
                query += " AND r.Reservation_Status = ?";
            }

            PreparedStatement statement = connection.prepareStatement(query);

            // Set query parameters
            statement.setString(1, username);

            if (!filter.equals("All")) {
                statement.setString(2, filter);
            }

            ResultSet rs = statement.executeQuery();

            // Process the result set into a list of reservations
            List<Map<String, Object>> reservations = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> reservation = new HashMap<>();
                reservation.put("reservationId", rs.getInt("Reservation_ID"));
                reservation.put("username", rs.getString("Username"));
                reservation.put("totalFare", rs.getDouble("Total_Fare"));
                reservation.put("travelDate", rs.getDate("Travel_Date"));
                reservation.put("status", rs.getString("Reservation_Status"));
                reservation.put("outboundTransit", rs.getString("Outbound_Transit"));
                reservation.put("returnTransit", rs.getString("Return_Transit"));
                reservation.put("outboundOrigin", rs.getString("Outbound_Origin"));
                reservation.put("outboundDestination", rs.getString("Outbound_Destination"));
                reservation.put("returnOrigin", rs.getString("Return_Origin"));
                reservation.put("returnDestination", rs.getString("Return_Destination"));

                // Determine Trip Type
                if (rs.getString("Return_Transit") != null) {
                    reservation.put("tripType", "Round Trip");
                } else {
                    reservation.put("tripType", "One-Way");
                }

                reservations.add(reservation);
            }

            // Set attributes for JSP
            request.setAttribute("reservations", reservations);
            request.setAttribute("filter", filter);
            request.getRequestDispatcher("manage_reservations.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }
}
