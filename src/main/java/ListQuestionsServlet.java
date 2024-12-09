import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.*;

public class ListQuestionsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchQuery = request.getParameter("searchQuery");
        List<Map<String, Object>> questions = new ArrayList<>();

        // Database query
        String query = "SELECT QuestionID, Title, Username, Body, CreatedAt FROM Questions";
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            query += " WHERE Title LIKE ? OR Body LIKE ?";
        }

        try (Connection conn = DBHelper.getConnection();
            PreparedStatement stmt = conn.prepareStatement(query)) {

            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String likePattern = "%" + searchQuery + "%";
                stmt.setString(1, likePattern);
                stmt.setString(2, likePattern);
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> questionMap = new HashMap<>();
                questionMap.put("questionID", rs.getInt("QuestionID"));
                questionMap.put("title", rs.getString("Title"));
                questionMap.put("username", rs.getString("Username"));
                questionMap.put("body", rs.getString("Body"));
                questionMap.put("createdAt", rs.getTimestamp("CreatedAt"));
                questions.add(questionMap);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Set questions as request attribute
        request.setAttribute("questions", questions);
        request.setAttribute("searchQuery", searchQuery); // to retain search query in the search bar
        RequestDispatcher dispatcher = request.getRequestDispatcher("/listQuestions.jsp");
        dispatcher.forward(request, response);
    }
}
