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
        String departureDate = request.getParameter("departureDate"); // Changed from travelDate
        String sortCriteria = request.getParameter("sortCriteria");

        // Print variables for debugging
        System.out.println("origin: " + origin);
        System.out.println("destination: " + destination);
        System.out.println("departureDate: " + departureDate);

        try (Connection conn = DBHelper.getConnection()) {
            // Updated query to include departure_date and sort by departure time
            String query = """
                    SELECT sc.Transit_Line, sc.Departure_Date, sc.Departure, sc.Arrival, sc.Fare, sc.Stops, t.Train_Name
                    FROM schedule sc
                    JOIN station s1 ON sc.Origin = s1.Station_ID
                    JOIN station s2 ON sc.Destination = s2.Station_ID
                    JOIN train t ON sc.Train_ID = t.Train_ID
                    WHERE s1.Name = ? AND s2.Name = ? AND sc.Departure_Date = ?
                    ORDER BY %s
                    """.formatted(sortCriteria != null ? sortCriteria : "sc.Departure");

            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, origin);
            stmt.setString(2, destination);
            stmt.setString(3, departureDate); // Bind departure date instead of travel time

            ResultSet resultSet = stmt.executeQuery();

            // List to hold schedule data
            List<Map<String, Object>> schedules = new ArrayList<>();

            while (resultSet.next()) {
                Map<String, Object> schedule = new HashMap<>();
                schedule.put("transitLine", resultSet.getString("Transit_Line"));
                schedule.put("departureDate", resultSet.getDate("Departure_Date").toString()); // Collect departure_date
                schedule.put("departure", resultSet.getTime("Departure").toString()); // Collect departure time
                schedule.put("arrival", resultSet.getTime("Arrival").toString());
                schedule.put("fare", resultSet.getBigDecimal("Fare"));
                schedule.put("stops", resultSet.getString("Stops"));
                schedule.put("trainName", resultSet.getString("Train_Name"));
                schedules.add(schedule);
            }

            // Convert schedules to JSON
            Gson gson = new Gson();
            String schedulesJson = gson.toJson(schedules);
            
            // Print the JSON for debugging
            System.out.println("Schedules JSON: " + schedulesJson);

            // Add schedules JSON to request attribute
            request.setAttribute("schedulesJson", schedulesJson);

            // Forward to search.jsp
            request.getRequestDispatcher("search.jsp").forward(request, response);

        } catch (Exception e) {
            // Handle exceptions
            request.setAttribute("errorMessage", "An error occurred while searching for schedules: " + e.getMessage());
            request.getRequestDispatcher("search.jsp").forward(request, response);
        }
    }
}
