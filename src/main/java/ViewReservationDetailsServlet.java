import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class ViewReservationDetailsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String reservationId = request.getParameter("reservationId");
        
        if (reservationId == null || reservationId.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Reservation ID is required.");
            return;
        }

        try (Connection connection = DBHelper.getConnection()) {
            // Fetch reservation and transit details
            String reservationQuery = """
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
                WHERE r.Reservation_ID = ?
            """;
            PreparedStatement reservationStmt = connection.prepareStatement(reservationQuery);
            reservationStmt.setInt(1, Integer.parseInt(reservationId));
            ResultSet reservationRs = reservationStmt.executeQuery();

            Map<String, Object> reservationDetails = new HashMap<>();
            if (reservationRs.next()) {
                reservationDetails.put("reservationId", reservationRs.getInt("Reservation_ID"));
                reservationDetails.put("username", reservationRs.getString("Username"));
                reservationDetails.put("totalFare", reservationRs.getBigDecimal("Total_Fare"));
                reservationDetails.put("travelDate", reservationRs.getDate("Travel_Date"));
                reservationDetails.put("status", reservationRs.getString("Reservation_Status"));
                reservationDetails.put("outboundTransit", reservationRs.getString("Outbound_Transit"));
                reservationDetails.put("returnTransit", reservationRs.getString("Return_Transit"));
                reservationDetails.put("outboundOrigin", reservationRs.getString("Outbound_Origin"));
                reservationDetails.put("outboundDestination", reservationRs.getString("Outbound_Destination"));
                reservationDetails.put("returnOrigin", reservationRs.getString("Return_Origin"));
                reservationDetails.put("returnDestination", reservationRs.getString("Return_Destination"));

                // Determine Trip Type
                if (reservationRs.getString("Return_Transit") != null) {
                    reservationDetails.put("tripType", "Round Trip");
                } else {
                    reservationDetails.put("tripType", "One-Way");
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Reservation not found.");
                return;
            }

            // Fetch passenger details
            String passengerQuery = """
                SELECT FirstName, LastName, Age, Category
                FROM passenger
                WHERE Reservation_ID = ?
            """;
            PreparedStatement passengerStmt = connection.prepareStatement(passengerQuery);
            passengerStmt.setInt(1, Integer.parseInt(reservationId));
            ResultSet passengerRs = passengerStmt.executeQuery();

            Map<Integer, Map<String, Object>> passengers = new HashMap<>();
            int passengerIndex = 1;
            while (passengerRs.next()) {
                Map<String, Object> passenger = new HashMap<>();
                passenger.put("firstName", passengerRs.getString("FirstName"));
                passenger.put("lastName", passengerRs.getString("LastName"));
                passenger.put("age", passengerRs.getInt("Age"));
                passenger.put("category", passengerRs.getString("Category"));
                passengers.put(passengerIndex++, passenger);
            }

            // Set attributes and forward to JSP
            request.setAttribute("reservationDetails", reservationDetails);
            request.setAttribute("passengers", passengers);
            request.getRequestDispatcher("view_reservation_details.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error.");
        }
    }
}
