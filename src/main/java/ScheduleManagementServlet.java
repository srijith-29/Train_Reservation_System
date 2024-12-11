import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class ScheduleManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String action = request.getParameter("action");

        if ("loadEditForm".equals(action)) {
            // Handle the "loadEditForm" action
            int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));

            try (Connection connection = DBHelper.getConnection()) {
                String query = """
                    SELECT Schedule_ID, Fare, departure_date, 
                        (SELECT Name FROM station WHERE Station_ID = Origin) AS Origin, 
                        (SELECT Name FROM station WHERE Station_ID = Destination) AS Destination 
                    FROM schedule WHERE Schedule_ID = ?;
                """;
                PreparedStatement statement = connection.prepareStatement(query);
                statement.setInt(1, scheduleId);

                ResultSet rs = statement.executeQuery();
                if (rs.next()) {
                    request.setAttribute("scheduleId", rs.getInt("Schedule_ID"));
                    request.setAttribute("fare", rs.getDouble("Fare"));
                    request.setAttribute("departureDate", rs.getDate("departure_date"));
                    request.setAttribute("origin", rs.getString("Origin"));
                    request.setAttribute("destination", rs.getString("Destination"));
                }

                request.getRequestDispatcher("edit_schedule.jsp").forward(request, response);

            } catch (SQLException e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
            }

        } else {
            try (Connection connection = DBHelper.getConnection()) {
                // Fetch station list
                String stationQuery = "SELECT Station_ID, Name FROM station;";
                PreparedStatement stationStatement = connection.prepareStatement(stationQuery);
                ResultSet stationResultSet = stationStatement.executeQuery();

                List<Map<String, Object>> stations = new ArrayList<>();
                while (stationResultSet.next()) {
                    Map<String, Object> station = new HashMap<>();
                    station.put("stationId", stationResultSet.getInt("Station_ID"));
                    station.put("stationName", stationResultSet.getString("Name"));
                    stations.add(station);
                }
                request.setAttribute("stations", stations);

                // Fetch schedules
                String scheduleQuery = """
                    SELECT s.Schedule_ID, s.Transit_Line, st1.Name AS Origin, st2.Name AS Destination,
                        s.Departure, s.Arrival, s.Fare, s.Stops, s.departure_date, s.Travel_Time
                    FROM schedule s
                    JOIN station st1 ON s.Origin = st1.Station_ID
                    JOIN station st2 ON s.Destination = st2.Station_ID
                    WHERE (? IS NULL OR ? = '' OR st1.Name = ?)
                    AND (? IS NULL OR ? = '' OR st2.Name = ?);
                """;

                PreparedStatement scheduleStatement = connection.prepareStatement(scheduleQuery);
                scheduleStatement.setString(1, origin);
                scheduleStatement.setString(2, origin);
                scheduleStatement.setString(3, origin);
                scheduleStatement.setString(4, destination);
                scheduleStatement.setString(5, destination);
                scheduleStatement.setString(6, destination);

                ResultSet scheduleResultSet = scheduleStatement.executeQuery();

                List<Map<String, Object>> schedules = new ArrayList<>();
                while (scheduleResultSet.next()) {
                    Map<String, Object> schedule = new HashMap<>();
                    schedule.put("scheduleId", scheduleResultSet.getInt("Schedule_ID"));
                    schedule.put("transitLine", scheduleResultSet.getString("Transit_Line"));
                    schedule.put("origin", scheduleResultSet.getString("Origin"));
                    schedule.put("destination", scheduleResultSet.getString("Destination"));
                    schedule.put("departure", scheduleResultSet.getTime("Departure"));
                    schedule.put("arrival", scheduleResultSet.getTime("Arrival"));
                    schedule.put("fare", scheduleResultSet.getDouble("Fare"));
                    schedule.put("stops", scheduleResultSet.getString("Stops"));
                    schedule.put("departureDate", scheduleResultSet.getDate("departure_date"));
                    schedule.put("travelTime", scheduleResultSet.getTime("Travel_Time"));

                    schedules.add(schedule);
                }

                request.setAttribute("schedules", schedules);
                request.getRequestDispatcher("schedule_management.jsp").forward(request, response);

            } catch (SQLException e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));

        try (Connection connection = DBHelper.getConnection()) {
            if ("edit".equals(action)) {
                // Validate and retrieve parameters
                String departureDate = request.getParameter("departureDate");
                String departureTime = request.getParameter("departureTime");
                String arrivalTime = request.getParameter("arrivalTime");

                System.out.println("departureDate: " + departureDate);
                System.out.println("departureTime: " + departureTime);
                System.out.println("arrivalTime: " + arrivalTime);

                if (departureDate == null || departureDate.trim().isEmpty() ||
                    departureTime == null || departureTime.trim().isEmpty() ||
                    arrivalTime == null || arrivalTime.trim().isEmpty()) {
                    throw new IllegalArgumentException("Required parameter(s) missing or empty.");
                }

                // Convert times to HH:mm:ss format
                DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm:ss");
                LocalTime formattedDepartureTime = LocalTime.parse(departureTime.trim());
                LocalTime formattedArrivalTime = LocalTime.parse(arrivalTime.trim());

                System.out.println("Formatted Departure Time: " + formattedDepartureTime.format(timeFormatter));
                System.out.println("Formatted Arrival Time: " + formattedArrivalTime.format(timeFormatter));

                try {
                    // Start a transaction
                    connection.setAutoCommit(false);

                    // Update schedule table
                    PreparedStatement updateStmt = connection.prepareStatement(
                        "UPDATE schedule SET departure_date = ?, Departure = ?, Arrival = ?, " +
                        "Travel_Time = TIMEDIFF(Arrival, Departure) WHERE Schedule_ID = ?");

                    updateStmt.setDate(1, java.sql.Date.valueOf(departureDate.trim()));
                    updateStmt.setTime(2, java.sql.Time.valueOf(formattedDepartureTime));
                    updateStmt.setTime(3, java.sql.Time.valueOf(formattedArrivalTime));
                    updateStmt.setInt(4, scheduleId);

                    updateStmt.executeUpdate();

                    // Fetch updated Travel_Time
                    PreparedStatement fetchUpdatedTravelTimeStmt = connection.prepareStatement(
                        "SELECT Transit_Line, " +
                        "(SELECT Name FROM station WHERE Station_ID = Origin) AS Origin, " +
                        "(SELECT Name FROM station WHERE Station_ID = Destination) AS Destination, " +
                        "Travel_Time FROM schedule WHERE Schedule_ID = ?;");
                    fetchUpdatedTravelTimeStmt.setInt(1, scheduleId);

                    ResultSet updatedScheduleRs = fetchUpdatedTravelTimeStmt.executeQuery();

                    String transitLine = null;
                    String origin = null;
                    String destination = null;
                    String updatedTravelTime = null;

                    if (updatedScheduleRs.next()) {
                        transitLine = updatedScheduleRs.getString("Transit_Line");
                        origin = updatedScheduleRs.getString("Origin");
                        destination = updatedScheduleRs.getString("Destination");
                        updatedTravelTime = updatedScheduleRs.getString("Travel_Time");
                    }

                    // Update travel_date for outbound references
                    PreparedStatement updateTravelDateStmt = connection.prepareStatement(
                        "UPDATE reservation SET Travel_Date = ? WHERE Outbound_Schedule_ID = ?;");
                    updateTravelDateStmt.setDate(1, java.sql.Date.valueOf(departureDate.trim()));
                    updateTravelDateStmt.setInt(2, scheduleId);
                    updateTravelDateStmt.executeUpdate();

                    // Fetch impacted reservations
                    PreparedStatement fetchImpactedReservationsStmt = connection.prepareStatement(
                        "SELECT * FROM reservation WHERE Outbound_Schedule_ID = ? OR Return_Schedule_ID = ?;");
                    fetchImpactedReservationsStmt.setInt(1, scheduleId);
                    fetchImpactedReservationsStmt.setInt(2, scheduleId);

                    ResultSet rs = fetchImpactedReservationsStmt.executeQuery();
                    List<Map<String, Object>> impactedReservations = new ArrayList<>();
                    List<String> reservationColumnNames = new ArrayList<>();

                    // Dynamically fetch column names
                    if (rs != null) {
                        ResultSetMetaData metaData = rs.getMetaData();
                        int columnCount = metaData.getColumnCount();
                        for (int i = 1; i <= columnCount; i++) {
                            reservationColumnNames.add(metaData.getColumnName(i));
                        }

                        // Fetch reservation data dynamically
                        while (rs.next()) {
                            Map<String, Object> reservation = new HashMap<>();
                            for (String columnName : reservationColumnNames) {
                                reservation.put(columnName, rs.getObject(columnName));
                            }
                            impactedReservations.add(reservation);
                        }
                    }

                    // Commit the transaction
                    connection.commit();

                    // Set attributes for confirmation page
                    request.setAttribute("scheduleId", scheduleId);
                    request.setAttribute("transitLine", transitLine);
                    request.setAttribute("origin", origin);
                    request.setAttribute("destination", destination);
                    request.setAttribute("departureDate", departureDate);
                    request.setAttribute("departure", formattedDepartureTime.toString());
                    request.setAttribute("arrival", formattedArrivalTime.toString());
                    request.setAttribute("travelTime", updatedTravelTime); // Updated travel time
                    request.setAttribute("reservationColumnNames", reservationColumnNames);
                    request.setAttribute("reservations", impactedReservations);

                    // Forward to confirmation page
                    request.getRequestDispatcher("confirm_edit.jsp").forward(request, response);

                } catch (SQLException e) {
                    connection.rollback(); // Rollback in case of error
                    e.printStackTrace();
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
                } finally {
                    connection.setAutoCommit(true); // Reset auto-commit
                }
            }
            else if ("delete".equals(action)) {
                try {
                    // Start transaction
                    connection.setAutoCommit(false);

                    // Fetch deleted schedule details
                    PreparedStatement fetchScheduleStmt = connection.prepareStatement(
                            "SELECT Schedule_ID, Transit_Line, " +
                            "(SELECT Name FROM station WHERE Station_ID = Origin) AS Origin, " +
                            "(SELECT Name FROM station WHERE Station_ID = Destination) AS Destination, " +
                            "Departure, Arrival, Departure_Date, Travel_Time " +
                            "FROM schedule WHERE Schedule_ID = ?;");
                    fetchScheduleStmt.setInt(1, scheduleId);
                    ResultSet scheduleRs = fetchScheduleStmt.executeQuery();

                    Map<String, Object> deletedScheduleDetails = new HashMap<>();
                    if (scheduleRs.next()) {
                        deletedScheduleDetails.put("scheduleId", scheduleRs.getInt("Schedule_ID"));
                        deletedScheduleDetails.put("transitLine", scheduleRs.getString("Transit_Line"));
                        deletedScheduleDetails.put("origin", scheduleRs.getString("Origin"));
                        deletedScheduleDetails.put("destination", scheduleRs.getString("Destination"));
                        deletedScheduleDetails.put("departure", scheduleRs.getTime("Departure").toString());
                        deletedScheduleDetails.put("arrival", scheduleRs.getTime("Arrival").toString());
                        deletedScheduleDetails.put("departureDate", scheduleRs.getDate("Departure_Date").toString());
                        deletedScheduleDetails.put("travelTime", scheduleRs.getString("Travel_Time"));
                    }

                    // Fetch impacted reservations
                    List<Map<String, Object>> impactedReservations = new ArrayList<>();
                    List<String> reservationColumnNames = new ArrayList<>();
                    PreparedStatement fetchReservationsStmt = connection.prepareStatement(
                            "SELECT * FROM reservation WHERE Outbound_Schedule_ID = ? OR Return_Schedule_ID = ?;");
                    fetchReservationsStmt.setInt(1, scheduleId);
                    fetchReservationsStmt.setInt(2, scheduleId);
                    ResultSet reservationsRs = fetchReservationsStmt.executeQuery();

                    // Dynamically fetch column names
                    if (reservationsRs != null) {
                        ResultSetMetaData metaData = reservationsRs.getMetaData();
                        int columnCount = metaData.getColumnCount();
                        for (int i = 1; i <= columnCount; i++) {
                            reservationColumnNames.add(metaData.getColumnName(i));
                        }

                        // Fetch reservation data dynamically
                        while (reservationsRs.next()) {
                            Map<String, Object> reservation = new HashMap<>();
                            for (String columnName : reservationColumnNames) {
                                Object value = reservationsRs.getObject(columnName);
                                reservation.put(columnName, value);
                            }
                            impactedReservations.add(reservation);
                        }
                    }

                    // Delete reservations and schedule
                    PreparedStatement deleteReservationsStmt = connection.prepareStatement(
                            "DELETE FROM reservation WHERE Outbound_Schedule_ID = ? OR Return_Schedule_ID = ?;");
                    deleteReservationsStmt.setInt(1, scheduleId);
                    deleteReservationsStmt.setInt(2, scheduleId);
                    deleteReservationsStmt.executeUpdate();

                    PreparedStatement deleteScheduleStmt = connection.prepareStatement(
                            "DELETE FROM schedule WHERE Schedule_ID = ?;");
                    deleteScheduleStmt.setInt(1, scheduleId);
                    deleteScheduleStmt.executeUpdate();

                    // Commit transaction
                    connection.commit();

                    // Set attributes for JSP
                    request.setAttribute("scheduleId", deletedScheduleDetails.get("scheduleId"));
                    request.setAttribute("transitLine", deletedScheduleDetails.get("transitLine"));
                    request.setAttribute("origin", deletedScheduleDetails.get("origin"));
                    request.setAttribute("destination", deletedScheduleDetails.get("destination"));
                    request.setAttribute("departure", deletedScheduleDetails.get("departure"));
                    request.setAttribute("arrival", deletedScheduleDetails.get("arrival"));
                    request.setAttribute("departureDate", deletedScheduleDetails.get("departureDate"));
                    request.setAttribute("travelTime", deletedScheduleDetails.get("travelTime"));
                    request.setAttribute("reservationColumnNames", reservationColumnNames);
                    request.setAttribute("reservations", impactedReservations);

                    // Forward to confirmation page
                    request.getRequestDispatcher("confirm_delete.jsp").forward(request, response);

                } catch (SQLException e) {
                    connection.rollback(); // Rollback in case of error
                    e.printStackTrace();
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
                } finally {
                    connection.setAutoCommit(true); // Reset auto-commit
                }
            }

        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }
}
