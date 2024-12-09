import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

public class SubmitQuestionServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String title = request.getParameter("title");
        String body = request.getParameter("body");

        // Retrieve the username from the session
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            // If the username is not found in the session, redirect to login or show an error message
            response.sendRedirect("login.jsp");
            return;
        }

// Now, you can use the username in the SQL query


        // Get the current timestamp for createdAt
        Timestamp createdAt = new Timestamp(System.currentTimeMillis());

        // Database connection logic via DBHelper class
        try (Connection conn = DBHelper.getConnection()) {
            // SQL query to insert a new question into the database
            String sql = "INSERT INTO Questions (Title, Body, Username, CreatedAt) VALUES (?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, title);
                stmt.setString(2, body);
                stmt.setString(3, username);
                stmt.setTimestamp(4, createdAt);
                
                // Execute the insert and retrieve the generated questionID
                stmt.executeUpdate();
                
                // Get the auto-generated QuestionID
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    int questionID = rs.getInt(1); // The generated questionID
                    // Optionally, you can store the new questionID in the request, or just redirect
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Redirect back to the list of questions after submitting
        response.sendRedirect("ListQuestionsServlet");
    }
}
