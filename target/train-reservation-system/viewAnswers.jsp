<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.Timestamp" %>

<html>
<head>
    <title>View Answers</title>
    <link rel="stylesheet" type="text/css" href="http://localhost:8080/train-reservation-system/css/viewAnswers.css">
</head>
<body>
    <button class="back-button" onclick="window.location.href='ListQuestionsServlet'">Back</button>
    <h2>Answers</h2>
    
    <%
        // Retrieve the answers map from the request
        Map<Integer, Map<String, Object>> answersMap = (Map<Integer, Map<String, Object>>) request.getAttribute("answers");

        if (answersMap != null && !answersMap.isEmpty()) {
    %>
        <ul>
            <%
                // Iterate through the answers map and display each answer
                for (Map.Entry<Integer, Map<String, Object>> entry : answersMap.entrySet()) {
                    Map<String, Object> answer = entry.getValue();
                    int answerID = (int) answer.get("answerID");
                    String username = (String) answer.get("username");
                    String body = (String) answer.get("body");
                    Timestamp createdAt = (Timestamp) answer.get("createdAt");
            %>
                <li>
                    <strong>Answer by <%= username %>:</strong><br>
                    <p><%= body %></p>
                    <p><em>Posted on: <%= createdAt %></em></p>
                </li>
                <hr>
            <%
                }
            %>
        </ul>
    <%
        } else {
    %>
        <p>No answers available for this question.</p>
    <%
        }
    %>
</body>
</html>
