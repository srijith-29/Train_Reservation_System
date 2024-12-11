import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class UserReservationServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String transitLine = request.getParameter("transitLine");
        String travelDate = request.getParameter("travelDate");

        List<Map<String, Object>> userRecords = new ArrayList<>();
        List<Map<String, Object>> transitLines = new ArrayList<>(); // Populate transit lines dynamically for the form

        try (Connection connection = DBHelper.getConnection()) {
            // Fetch list of transit lines
            PreparedStatement fetchTransitLinesStmt = connection.prepareStatement("SELECT DISTINCT Transit_Line FROM schedule");
            ResultSet transitRs = fetchTransitLinesStmt.executeQuery();
            while (transitRs.next()) {
                Map<String, Object> line = new HashMap<>();
                line.put("transitLine", transitRs.getString("Transit_Line"));
                transitLines.add(line);
            }

            // If both filters are provided
            if (transitLine != null && !transitLine.isEmpty() && travelDate != null && !travelDate.isEmpty()) {
                PreparedStatement fetchUsersStmt = connection.prepareStatement(
                    "SELECT DISTINCT u.Username, u.Email, u.First_Name, u.Last_Name " +
                    "FROM users u " +
                    "JOIN reservation r ON (u.Username = r.Username) " +
                    "JOIN schedule outbound ON (outbound.Schedule_ID = r.Outbound_Schedule_ID) " +
                    "LEFT JOIN schedule return_s ON (return_s.Schedule_ID = r.Return_Schedule_ID) " +
                    "WHERE u.Role = 'user' " +
                    "AND (outbound.Transit_Line = ? OR return_s.Transit_Line = ?) " +
                    "AND (outbound.Departure_Date = ? OR return_s.Departure_Date = ?)"
                );
                fetchUsersStmt.setString(1, transitLine);
                fetchUsersStmt.setString(2, transitLine);
                fetchUsersStmt.setDate(3, java.sql.Date.valueOf(travelDate));
                fetchUsersStmt.setDate(4, java.sql.Date.valueOf(travelDate));

                ResultSet userRs = fetchUsersStmt.executeQuery();
                while (userRs.next()) {
                    Map<String, Object> user = new HashMap<>();
                    user.put("username", userRs.getString("Username"));
                    user.put("email", userRs.getString("Email"));
                    user.put("firstName", userRs.getString("First_Name"));
                    user.put("lastName", userRs.getString("Last_Name"));
                    userRecords.add(user);
                }
            }

            request.setAttribute("transitLines", transitLines);
            request.setAttribute("userRecords", userRecords);
            request.getRequestDispatcher("user_reservations.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }
}
