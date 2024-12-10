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

public class CompleteRoundTripReservationServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = (String) request.getSession().getAttribute("username");
        if (username == null) {
            request.setAttribute("errorMessage", "Session lost. Please log in again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        String outboundScheduleId = request.getParameter("outboundScheduleId");
        String returnScheduleId = request.getParameter("returnScheduleId");
        String travelDate = request.getParameter("outboundDepartureDate");
        String returnDate = request.getParameter("returnDepartureDate");
        String totalBaseFareStr = request.getParameter("totalBaseFare");
        String totalDiscountStr = request.getParameter("totalDiscount");
        String totalFinalFareStr = request.getParameter("totalFinalFare");
        String passengerDataJson = request.getParameter("passengerData");

        System.out.println("outboundScheduleId: " + outboundScheduleId);
        System.out.println("returnScheduleId: " + returnScheduleId);
        System.out.println("travelDate: " + travelDate);
        System.out.println("totalBaseFareStr: " + totalBaseFareStr);
        System.out.println("totalDiscountStr: " + totalDiscountStr);
        System.out.println("totalFinalFareStr: " + totalFinalFareStr);
        System.out.println("passengerDataJson: " + passengerDataJson);

        if (outboundScheduleId == null || returnScheduleId == null || travelDate == null ||
            totalBaseFareStr == null || totalDiscountStr == null || totalFinalFareStr == null || passengerDataJson == null) {
            request.setAttribute("errorMessage", "Missing required data.");
            request.getRequestDispatcher("roundtrip_reservation_details.jsp").forward(request, response);
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
                (Username, Outbound_Schedule_ID, Return_Schedule_ID, Total_Fare, Reservation_Date, Travel_Date, Base_Fare, Discount_Applied, Reservation_Status) 
                VALUES (?, ?, ?, ?, NOW(), ?, ?, ?, 'Confirmed')
            """;
            PreparedStatement reservationStmt = conn.prepareStatement(reservationSql, PreparedStatement.RETURN_GENERATED_KEYS);
            reservationStmt.setString(1, username);
            reservationStmt.setInt(2, Integer.parseInt(outboundScheduleId));
            reservationStmt.setInt(3, Integer.parseInt(returnScheduleId));
            reservationStmt.setDouble(4, totalFinalFare);
            reservationStmt.setString(5, travelDate);
            reservationStmt.setDouble(6, totalBaseFare);
            reservationStmt.setDouble(7, totalDiscount);
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

                // Fetch outbound schedule details
                String scheduleQuery = """
                    SELECT s1.Name AS Origin, s2.Name AS Destination, sc.Travel_Time, sc.Departure, sc.Arrival
                    FROM schedule sc
                    JOIN station s1 ON sc.Origin = s1.Station_ID
                    JOIN station s2 ON sc.Destination = s2.Station_ID
                    WHERE sc.Schedule_ID = ?
                """;
                PreparedStatement outboundScheduleStmt = conn.prepareStatement(scheduleQuery);
                outboundScheduleStmt.setInt(1, Integer.parseInt(outboundScheduleId));
                ResultSet outboundScheduleRs = outboundScheduleStmt.executeQuery();

                // Fetch return schedule details
                PreparedStatement returnScheduleStmt = conn.prepareStatement(scheduleQuery);
                returnScheduleStmt.setInt(1, Integer.parseInt(returnScheduleId));
                ResultSet returnScheduleRs = returnScheduleStmt.executeQuery();

                if (outboundScheduleRs.next() && returnScheduleRs.next()) {
                    request.setAttribute("reservationId", reservationId);
                    request.setAttribute("OutboundOrigin", outboundScheduleRs.getString("Origin"));
                    request.setAttribute("OutboundDestination", outboundScheduleRs.getString("Destination"));
                    request.setAttribute("OutboundTravelTime", outboundScheduleRs.getString("Travel_Time"));
                    request.setAttribute("OutboundDeparture", outboundScheduleRs.getString("Departure"));
                    request.setAttribute("OutboundArrival", outboundScheduleRs.getString("Arrival"));

                    request.setAttribute("ReturnOrigin", returnScheduleRs.getString("Origin"));
                    request.setAttribute("ReturnDestination", returnScheduleRs.getString("Destination"));
                    request.setAttribute("ReturnTravelTime", returnScheduleRs.getString("Travel_Time"));
                    request.setAttribute("ReturnDeparture", returnScheduleRs.getString("Departure"));
                    request.setAttribute("ReturnArrival", returnScheduleRs.getString("Arrival"));

                    request.setAttribute("travelDate", travelDate);
                    request.setAttribute("returnDate", returnDate);
                    request.setAttribute("totalBaseFare", totalBaseFare);
                    request.setAttribute("totalDiscount", totalDiscount);
                    request.setAttribute("totalFinalFare", totalFinalFare);
                    request.setAttribute("reservationStatus", "Confirmed");

                    request.getRequestDispatcher("roundtrip_reservation_success.jsp").forward(request, response);
                } else {
                    throw new Exception("Failed to fetch schedule details.");
                }
            } else {
                throw new Exception("Failed to retrieve the reservation ID.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("roundtrip_reservation_details.jsp").forward(request, response);
        }
    }
}
