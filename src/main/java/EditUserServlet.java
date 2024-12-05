import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class EditUserServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");

        try (Connection conn = DBHelper.getConnection()) {
            String sql = "SELECT Username, Role, Email, First_Name, Last_Name FROM users WHERE Username = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, username);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    request.setAttribute("username", rs.getString("Username"));
                    request.setAttribute("role", rs.getString("Role"));
                    request.setAttribute("email", rs.getString("Email"));
                    request.setAttribute("firstName", rs.getString("First_Name"));
                    request.setAttribute("lastName", rs.getString("Last_Name"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("edit-user.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String role = request.getParameter("role");
        String email = request.getParameter("email");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");

        try (Connection conn = DBHelper.getConnection()) {
            String sql = "UPDATE users SET Role = ?, Email = ?, First_Name = ?, Last_Name = ? WHERE Username = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, role);
                ps.setString(2, email);
                ps.setString(3, firstName);
                ps.setString(4, lastName);
                ps.setString(5, username);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin-dashboard");
    }
}
