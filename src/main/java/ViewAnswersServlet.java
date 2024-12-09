import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.*;

public class ViewAnswersServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int questionID = Integer.parseInt(request.getParameter("questionID"));
        
        // Create a Map to store answers
        Map<Integer, Map<String, Object>> answersMap = new HashMap<>();
        
        // Database connection logic via DBHelper class
        try (Connection conn = DBHelper.getConnection()) {
            // SQL query to fetch answers for the question
            String sql = "SELECT * FROM answers WHERE QuestionID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, questionID);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        // Create a map for each answer
                        Map<String, Object> answerMap = new HashMap<>();
                        answerMap.put("answerID", rs.getInt("AnswerID"));
                        answerMap.put("username", rs.getString("Username"));
                        answerMap.put("body", rs.getString("Body"));
                        answerMap.put("createdAt", rs.getTimestamp("CreatedAt"));
                        
                        // Add this answer map to the answersMap using the AnswerID as key
                        answersMap.put(rs.getInt("AnswerID"), answerMap);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Set the answers map as a request attribute
        request.setAttribute("answers", answersMap);

        // Forward to the JSP page to display answers
        RequestDispatcher dispatcher = request.getRequestDispatcher("viewAnswers.jsp");
        dispatcher.forward(request, response);
    }
}
