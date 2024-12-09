import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class ReservationData extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String role = (String) request.getSession().getAttribute("role");
        if (role == null || !"admin".equalsIgnoreCase(role)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try (Connection conn = DBHelper.getConnection()) {
            // Query for the best customer
            String bestCustomerQuery = """
                    SELECT Username, SUM(Total_Fare) AS TotalRevenue
                    FROM reservation
                    GROUP BY Username
                    ORDER BY TotalRevenue DESC
                    LIMIT 1
                    """;

            PreparedStatement bestCustomerStmt = conn.prepareStatement(bestCustomerQuery);
            ResultSet bestCustomerResult = bestCustomerStmt.executeQuery();

            if (bestCustomerResult.next()) {
                String bestCustomerUsername = bestCustomerResult.getString("Username");
                Double bestCustomerRevenue = bestCustomerResult.getDouble("TotalRevenue");

                // Set attributes to be used in the JSP
                request.setAttribute("bestCustomerUsername", bestCustomerUsername);
                request.setAttribute("bestCustomerRevenue", bestCustomerRevenue);
            }

            // Query for the top 5 most active transit lines
            String topTransitLinesQuery = """
                    SELECT s.Transit_Line, COUNT(r.Reservation_ID) AS BookingCount
                    FROM reservation r
                    JOIN schedule s ON r.Outbound_Schedule_ID = s.Schedule_ID
                    GROUP BY s.Transit_Line
                    ORDER BY BookingCount DESC
                    LIMIT 5
                    """;

            PreparedStatement topTransitLinesStmt = conn.prepareStatement(topTransitLinesQuery);
            ResultSet topTransitLinesResult = topTransitLinesStmt.executeQuery();

            ArrayList<String[]> topTransitLines = new ArrayList<>();
            while (topTransitLinesResult.next()) {
                String transitLine = topTransitLinesResult.getString("Transit_Line");
                int bookingCount = topTransitLinesResult.getInt("BookingCount");

                topTransitLines.add(new String[]{transitLine, String.valueOf(bookingCount)});
            }

            // Set the top transit lines to be used in the JSP
            request.setAttribute("topTransitLines", topTransitLines);

            // Forward to JSP
            request.getRequestDispatcher("reservation-data.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while fetching data: " + e.getMessage());
            request.getRequestDispatcher("reservation-data.jsp").forward(request, response);
        }
    }
}
