import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLIntegrityConstraintViolationException;

public class AddUserServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String role1 = (String) request.getSession().getAttribute("role");
        if (role1 == null || !"admin".equalsIgnoreCase(role1)) {
            response.sendRedirect("login.jsp");
            return;
        }
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String email = request.getParameter("email");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");

        try (Connection conn = DBHelper.getConnection()) {
            String sql = "INSERT INTO Users (Username, Password, Role, Email, First_Name, Last_Name) VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username);
                stmt.setString(2, password); // Note: You should hash the password before storing it.
                stmt.setString(3, role);
                stmt.setString(4, email);
                stmt.setString(5, firstName);
                stmt.setString(6, lastName);

                int rowsInserted = stmt.executeUpdate();
                if (rowsInserted > 0) {
                    response.sendRedirect("admin-dashboard.jsp?success=true");
                } else {
                    response.sendRedirect("adduser.jsp?error=Failed+to+add+user");
                }
            }
        } catch (SQLIntegrityConstraintViolationException e) {
            // Specific error for duplicate key violation (e.g., duplicate username or email)
            response.sendRedirect("adduser.jsp?error=The+username+or+email+already+exists");
        } catch (Exception e) {
            e.printStackTrace(); // Log the error for debugging
            response.sendRedirect("adduser.jsp?error=An+unexpected+error+occurred");
        }
    }
}
