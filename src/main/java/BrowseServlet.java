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
import java.util.List;

public class BrowseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (Connection conn = DBHelper.getConnection()) {
            // Fetch distinct origins
            String originQuery = "SELECT DISTINCT s.Name FROM schedule sc JOIN station s ON sc.Origin = s.Station_ID";
            PreparedStatement originStmt = conn.prepareStatement(originQuery);
            ResultSet originResultSet = originStmt.executeQuery();
            List<String> origins = new ArrayList<>();
            while (originResultSet.next()) {
                origins.add(originResultSet.getString("Name"));
            }

            // Fetch distinct destinations
            String destinationQuery = "SELECT DISTINCT s.Name FROM schedule sc JOIN station s ON sc.Destination = s.Station_ID";
            PreparedStatement destinationStmt = conn.prepareStatement(destinationQuery);
            ResultSet destinationResultSet = destinationStmt.executeQuery();
            List<String> destinations = new ArrayList<>();
            while (destinationResultSet.next()) {
                destinations.add(destinationResultSet.getString("Name"));
            }

            // Serialize the data into JSON
            Gson gson = new Gson();
            String originsJson = gson.toJson(origins);
            String destinationsJson = gson.toJson(destinations);

            // Add JSON strings to the request attributes
            request.setAttribute("originsJson", originsJson);
            request.setAttribute("destinationsJson", destinationsJson);

            // Forward request to browse.jsp
            request.getRequestDispatcher("browse.jsp").forward(request, response);

        } catch (Exception e) {
            // Handle exceptions
            request.setAttribute("errorMessage", "An error occurred while fetching schedule data: " + e.getMessage());
            request.getRequestDispatcher("browse.jsp").forward(request, response);
        }
    }
}
