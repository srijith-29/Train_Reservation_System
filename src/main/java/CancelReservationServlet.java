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
import java.sql.SQLException;

public class CancelReservationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int reservationId = Integer.parseInt(request.getParameter("reservationId"));

        try (Connection connection = DBHelper.getConnection()) {
            String query = "DELETE FROM reservation WHERE Reservation_ID = ?";
            PreparedStatement statement = connection.prepareStatement(query);
            statement.setInt(1, reservationId);
            int rowsAffected = statement.executeUpdate();

            if (rowsAffected > 0) {
                request.setAttribute("message", "Reservation ID " + reservationId + " has been successfully cancelled.");
            } else {
                request.setAttribute("message", "Reservation ID " + reservationId + " could not be cancelled.");
            }

            request.getRequestDispatcher("cancel_success.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error.");
        }
    }
}
