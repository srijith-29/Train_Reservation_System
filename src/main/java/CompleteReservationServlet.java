import com.google.gson.Gson;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CompleteReservationServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = (String) request.getSession().getAttribute("username");
        if (username == null) {
            request.setAttribute("errorMessage", "Session lost. Please log in again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        String scheduleId = request.getParameter("scheduleId");
        String travelDate = request.getParameter("travelDate");
        String totalBaseFareStr = request.getParameter("totalBaseFare");
        String totalDiscountStr = request.getParameter("totalDiscount");
        String totalFinalFareStr = request.getParameter("totalFinalFare");
        String passengerDataJson = request.getParameter("passengerData");

        if (scheduleId == null || travelDate == null || totalBaseFareStr == null || 
            totalDiscountStr == null || totalFinalFareStr == null || passengerDataJson == null) {
            request.setAttribute("errorMessage", "Missing required data.");
            request.getRequestDispatcher("reservationDetails.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBHelper.getConnection()) {
            Gson gson = new Gson();
            List<Map<String, String>> passengers = gson.fromJson(passengerDataJson, List.class);

            double totalBaseFare = Double.parseDouble(totalBaseFareStr);
            double totalDiscount = Double.parseDouble(totalDiscountStr);
            double totalFinalFare = Double.parseDouble(totalFinalFareStr);

            // Insert reservation
            String reservationSql = """
                INSERT INTO reservation 
                (Username, Outbound_Schedule_ID, Total_Fare, Reservation_Date, Travel_Date, Base_Fare, Discount_Applied, Reservation_Status) 
                VALUES (?, ?, ?, NOW(), ?, ?, ?, 'Confirmed')
            """;
            PreparedStatement reservationStmt = conn.prepareStatement(reservationSql, PreparedStatement.RETURN_GENERATED_KEYS);
            reservationStmt.setString(1, username);
            reservationStmt.setInt(2, Integer.parseInt(scheduleId));
            reservationStmt.setDouble(3, totalFinalFare);
            reservationStmt.setString(4, travelDate);
            reservationStmt.setDouble(5, totalBaseFare);
            reservationStmt.setDouble(6, totalDiscount);
            reservationStmt.executeUpdate();

            ResultSet rs = reservationStmt.getGeneratedKeys();
            if (rs.next()) {
                int reservationId = rs.getInt(1);

                // Insert passengers
                for (Map<String, String> passenger : passengers) {
                    String insertPassengerSql = """
                        INSERT INTO passenger (FirstName, LastName, Age, Category, Reservation_ID) 
                        VALUES (?, ?, ?, ?, ?)
                    """;
                    PreparedStatement passengerStmt = conn.prepareStatement(insertPassengerSql);
                    passengerStmt.setString(1, passenger.get("firstName"));
                    passengerStmt.setString(2, passenger.get("lastName"));
                    passengerStmt.setInt(3, Integer.parseInt(passenger.get("age")));
                    passengerStmt.setString(4, passenger.get("category"));
                    passengerStmt.setInt(5, reservationId);
                    passengerStmt.executeUpdate();
                }

                // Fetch schedule details
                String scheduleQuery = """
                    SELECT s1.Name AS Origin, s2.Name AS Destination, sc.Travel_Time, sc.Departure, sc.Arrival
                    FROM schedule sc
                    JOIN station s1 ON sc.Origin = s1.Station_ID
                    JOIN station s2 ON sc.Destination = s2.Station_ID
                    WHERE sc.Schedule_ID = ?
                """;
                PreparedStatement scheduleStmt = conn.prepareStatement(scheduleQuery);
                scheduleStmt.setInt(1, Integer.parseInt(scheduleId));
                ResultSet scheduleRs = scheduleStmt.executeQuery();

                if (scheduleRs.next()) {
                    request.setAttribute("reservationId", reservationId);
                    request.setAttribute("Origin", scheduleRs.getString("Origin"));
                    request.setAttribute("Destination", scheduleRs.getString("Destination"));
                    request.setAttribute("travelTime", scheduleRs.getString("Travel_Time"));
                    request.setAttribute("departure", scheduleRs.getString("Departure"));
                    request.setAttribute("arrival", scheduleRs.getString("Arrival"));
                    request.setAttribute("travelDate", travelDate);
                    request.setAttribute("totalBaseFare", totalBaseFare);
                    request.setAttribute("totalDiscount", totalDiscount);
                    request.setAttribute("totalFinalFare", totalFinalFare);
                    request.setAttribute("reservationStatus", "Confirmed");

                    request.getRequestDispatcher("reservation_success.jsp").forward(request, response);
                } else {
                    throw new Exception("Failed to fetch schedule details.");
                }
            } else {
                throw new Exception("Failed to retrieve the reservation ID.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("reservationDetails.jsp").forward(request, response);
        }
    }
}
