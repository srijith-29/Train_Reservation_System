import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.nio.charset.StandardCharsets;

public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("login.jsp");
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<html><body>");
        out.println("<h2>Login Page</h2>");
        out.println("<form action='login' method='POST'>");
        out.println("Username: <input type='text' name='username'><br>");
        out.println("Password: <input type='password' name='password'><br>");
        out.println("<input type='submit' value='Login'>");
        out.println("</form>");
        out.println("</body></html>");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            String hashedPassword = hashPassword(password);
            try (Connection conn = DBHelper.getConnection()) {
                String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, username);
                    stmt.setString(2, hashedPassword);
                    ResultSet rs = stmt.executeQuery();

                    if (rs.next()) {
                        String role = rs.getString("role");
                        // Store username and role in session
                        request.getSession().setAttribute("username", username);
                        request.getSession().setAttribute("role", role);

                        // Check if there is a redirectAfterLogin attribute
                        // String redirectAfterLogin = (String) request.getSession().getAttribute("redirectAfterLogin");
                        // if ("reservationDetails".equals(redirectAfterLogin)) {
                        //     // Redirect to reservation details page
                        //     request.getSession().removeAttribute("redirectAfterLogin");
                        //     request.getRequestDispatcher("search.jsp").forward(request, response);
                        //     return;
                        // }

                        // Redirect based on role
                        if ("admin".equalsIgnoreCase(role)) {
                            response.sendRedirect("admin-dashboard.jsp");
                        } else if ("user".equalsIgnoreCase(role)) {
                            response.sendRedirect("success.jsp");
                        } else if ("cusrep".equalsIgnoreCase(role)) {
                            response.sendRedirect("cusrep-dashboard.jsp");
                        } else {
                            // Unknown role
                            request.setAttribute("errorMessage", "Invalid user role.");
                            request.getRequestDispatcher("login.jsp").forward(request, response);
                        }
                    } else {
                        // Invalid credentials
                        request.setAttribute("errorMessage", "Invalid credentials");
                        request.getRequestDispatcher("login.jsp").forward(request, response);
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private String hashPassword(String password) throws NoSuchAlgorithmException {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        return hexString.toString();
    }
}
