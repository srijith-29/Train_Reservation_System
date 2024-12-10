import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SearchServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String departureDate = request.getParameter("departureDate");
        String tripType = request.getParameter("tripType");

        String outboundScheduleId = request.getParameter("outboundScheduleId");
        String outboundFare = request.getParameter("outboundFare");
        String outboundDate = request.getParameter("outboundDate");

        try (Connection conn = DBHelper.getConnection()) {
            String query = """
                    SELECT sc.Transit_Line, sc.Departure_Date, sc.Departure, sc.Arrival, sc.Fare, sc.Stops, t.Train_Name, sc.Schedule_ID
                    FROM schedule sc
                    JOIN station s1 ON sc.Origin = s1.Station_ID
                    JOIN station s2 ON sc.Destination = s2.Station_ID
                    JOIN train t ON sc.Train_ID = t.Train_ID
                    WHERE s1.Name = ? AND s2.Name = ? AND sc.Departure_Date = ?
                    ORDER BY sc.Departure
                    """;

            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, origin);
            stmt.setString(2, destination);
            stmt.setString(3, departureDate);

            ResultSet resultSet = stmt.executeQuery();
            List<Map<String, Object>> schedules = new ArrayList<>();
            while (resultSet.next()) {
                Map<String, Object> schedule = new HashMap<>();
                schedule.put("scheduleId", resultSet.getInt("Schedule_ID"));
                schedule.put("transitLine", resultSet.getString("Transit_Line"));
                schedule.put("departureDate", resultSet.getDate("Departure_Date").toString());
                schedule.put("departure", resultSet.getTime("Departure").toString());
                schedule.put("arrival", resultSet.getTime("Arrival").toString());
                schedule.put("fare", resultSet.getBigDecimal("Fare"));
                schedule.put("stops", resultSet.getString("Stops"));
                schedule.put("trainName", resultSet.getString("Train_Name"));
                schedules.add(schedule);
            }

            Gson gson = new Gson();
            String schedulesJson = gson.toJson(schedules);

            // if (tripType != null && tripType.equals("round-trip") && outboundScheduleId != null) {
            //     // Fetch return schedules
            //     request.setAttribute("schedulesJson", schedulesJson);
            //     request.setAttribute("outboundScheduleId", outboundScheduleId);
            //     request.setAttribute("outboundFare", outboundFare);
            //     request.setAttribute("outboundDate", outboundDate);
            //     request.getRequestDispatcher("search_return.jsp").forward(request, response);
            // } else {
            // Forward to search.jsp for initial outbound search
            request.setAttribute("schedulesJson", schedulesJson);
            request.getRequestDispatcher("search.jsp").forward(request, response);
            // }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("search.jsp").forward(request, response);
        }
    }
}
