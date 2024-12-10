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
import com.google.gson.Gson;

public class RoundTripSearchServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String departureDate = request.getParameter("departureDate");
        String returnDate = request.getParameter("returnDate");

        if (origin == null || destination == null || departureDate == null || returnDate == null) {
            request.setAttribute("errorMessage", "Missing required parameters for round-trip search.");
            request.getRequestDispatcher("browse.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBHelper.getConnection()) {
            // Fetch outbound schedules
            String outboundQuery = """
                SELECT sc.Schedule_ID, sc.Transit_Line, sc.Departure_Date, sc.Departure, sc.Arrival, sc.Fare, t.Train_Name
                FROM schedule sc
                JOIN train t ON sc.Train_ID = t.Train_ID
                JOIN station s1 ON sc.Origin = s1.Station_ID
                JOIN station s2 ON sc.Destination = s2.Station_ID
                WHERE s1.Name = ? AND s2.Name = ? AND sc.Departure_Date = ?
                ORDER BY sc.Departure
            """;
            PreparedStatement outboundStmt = conn.prepareStatement(outboundQuery);
            outboundStmt.setString(1, origin);
            outboundStmt.setString(2, destination);
            outboundStmt.setString(3, departureDate);
            ResultSet outboundRs = outboundStmt.executeQuery();

            List<Map<String, Object>> outboundSchedules = new ArrayList<>();
            while (outboundRs.next()) {
                Map<String, Object> schedule = new HashMap<>();
                schedule.put("scheduleId", outboundRs.getInt("Schedule_ID"));
                schedule.put("trainName", outboundRs.getString("Train_Name"));
                schedule.put("departure", outboundRs.getString("Departure"));
                schedule.put("arrival", outboundRs.getString("Arrival"));
                schedule.put("fare", outboundRs.getDouble("Fare"));
                schedule.put("departureDate", outboundRs.getString("Departure_Date"));
                outboundSchedules.add(schedule);
            }

            // Fetch return schedules
            String returnQuery = """
                SELECT sc.Schedule_ID, sc.Transit_Line, sc.Departure_Date, sc.Departure, sc.Arrival, sc.Fare, t.Train_Name
                FROM schedule sc
                JOIN train t ON sc.Train_ID = t.Train_ID
                JOIN station s1 ON sc.Origin = s1.Station_ID
                JOIN station s2 ON sc.Destination = s2.Station_ID
                WHERE s1.Name = ? AND s2.Name = ? AND sc.Departure_Date = ?
                ORDER BY sc.Departure
            """;
            PreparedStatement returnStmt = conn.prepareStatement(returnQuery);
            returnStmt.setString(1, destination);
            returnStmt.setString(2, origin);
            returnStmt.setString(3, returnDate);
            ResultSet returnRs = returnStmt.executeQuery();

            List<Map<String, Object>> returnSchedules = new ArrayList<>();
            while (returnRs.next()) {
                Map<String, Object> schedule = new HashMap<>();
                schedule.put("scheduleId", returnRs.getInt("Schedule_ID"));
                schedule.put("trainName", returnRs.getString("Train_Name"));
                schedule.put("departure", returnRs.getString("Departure"));
                schedule.put("arrival", returnRs.getString("Arrival"));
                schedule.put("fare", returnRs.getDouble("Fare"));
                schedule.put("departureDate", returnRs.getString("Departure_Date"));
                returnSchedules.add(schedule);
            }

            Gson gson = new Gson();
            request.setAttribute("outboundSchedules", gson.toJson(outboundSchedules));
            request.setAttribute("returnSchedules", gson.toJson(returnSchedules));

            request.getRequestDispatcher("roundtrip_search.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error fetching round-trip schedules: " + e.getMessage());
            request.getRequestDispatcher("browse.jsp").forward(request, response);
        }
    }
}
