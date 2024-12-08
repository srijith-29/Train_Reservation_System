import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/RevenueServlet")
public class RevenueServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String transitLine = request.getParameter("transitLine");
        String username = request.getParameter("username");

        // Query to get the total fare based on the provided filters
        String totalFareQuery = "SELECT SUM(r.Total_Fare) AS TotalFare " +
                                "FROM reservation r " +
                                "JOIN schedule s ON r.Outbound_Schedule_ID = s.Schedule_ID " +
                                "WHERE (? IS NULL OR s.Transit_Line = ?) " +  // Apply filter for transitLine if provided
                                "AND (? IS NULL OR r.Username = ?);";        // Apply filter for username if provided

        // Query to get reservations based on the filters
        String reservationsQuery = "SELECT r.Reservation_ID, r.Username, r.Total_Fare, r.Reservation_Date, s.Transit_Line, s.Departure, s.Arrival " +
                                "FROM reservation r " +
                                "JOIN schedule s ON r.Outbound_Schedule_ID = s.Schedule_ID " +
                                   "WHERE (? IS NULL OR s.Transit_Line = ?) " +  // Apply filter for transitLine if provided
                                   "AND (? IS NULL OR r.Username = ?);";        // Apply filter for username if provided

        double totalFare = 0.0;
        ArrayList<String[]> reservations = new ArrayList<>();

        try (Connection conn = DBHelper.getConnection();
            PreparedStatement totalFareStmt = conn.prepareStatement(totalFareQuery);
            PreparedStatement reservationsStmt = conn.prepareStatement(reservationsQuery)) {

            // Set parameters for the total fare query
            totalFareStmt.setString(1, transitLine != null && !transitLine.isEmpty() ? transitLine : null);  // Set transitLine if not empty
            totalFareStmt.setString(2, transitLine != null && !transitLine.isEmpty() ? transitLine : null);
            totalFareStmt.setString(3, username != null && !username.isEmpty() ? username : null);  // Set username if not empty
            totalFareStmt.setString(4, username != null && !username.isEmpty() ? username : null);

            // Set parameters for the reservations query
            reservationsStmt.setString(1, transitLine != null && !transitLine.isEmpty() ? transitLine : null);
            reservationsStmt.setString(2, transitLine != null && !transitLine.isEmpty() ? transitLine : null);
            reservationsStmt.setString(3, username != null && !username.isEmpty() ? username : null);
            reservationsStmt.setString(4, username != null && !username.isEmpty() ? username : null);

            // Execute total fare query
            ResultSet totalFareResult = totalFareStmt.executeQuery();
            if (totalFareResult.next()) {
                totalFare = totalFareResult.getDouble("TotalFare");
            }

            // Execute reservations query
            ResultSet reservationsResult = reservationsStmt.executeQuery();
            while (reservationsResult.next()) {
                String[] reservation = new String[]{
                    reservationsResult.getString("Reservation_ID"),
                    reservationsResult.getString("Username"),
                    reservationsResult.getString("Total_Fare"),
                    reservationsResult.getString("Reservation_Date"),
                    reservationsResult.getString("Transit_Line"),
                    reservationsResult.getString("Departure"),
                    reservationsResult.getString("Arrival")
                };
                reservations.add(reservation);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Set attributes to pass to the JSP
        request.setAttribute("totalFare", totalFare);
        request.setAttribute("reservations", reservations);

        // Forward to JSP
        request.getRequestDispatcher("/revenue.jsp").forward(request, response);
    }
}
