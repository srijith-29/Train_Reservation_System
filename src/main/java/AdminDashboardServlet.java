import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class AdminDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String role = (String) request.getSession().getAttribute("role");
        if (role == null || !"admin".equalsIgnoreCase(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Retrieve user list from the database
        ArrayList<String[]> userList = new ArrayList<>();
        String sql = "SELECT Username, Role, Email, First_Name, Last_Name FROM users";

        try (Connection conn = DBHelper.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String[] user = new String[5];
                user[0] = rs.getString("Username");
                user[1] = rs.getString("Role");
                user[2] = rs.getString("Email");
                user[3] = rs.getString("First_Name");
                user[4] = rs.getString("Last_Name");
                userList.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Set the user list as a request attribute
        request.setAttribute("userList", userList);

        // Forward to the admin dashboard JSP
        request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
    }
}
