<%@ page import="java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <title>List of Questions</title>
    <link rel="stylesheet" type="text/css" href="http://localhost:8080/train-reservation-system/css/listQuestions.css">
</head>
<body>
    <%
        String role1 = (String) session.getAttribute("role");  // Retrieve the role from the session
        String backUrl = "success.jsp";  // Default URL
        if ("cusrep".equals(role1)) {
            backUrl = "cusrep-dashboard.jsp";
        }
    %>

    <button class="back-button" onclick="window.location.href='<%= backUrl %>';">Back</button>


    <!-- Form to submit a new question -->
    <h3>Ask a New Question</h3>
    <form action="SubmitQuestionServlet" method="POST">
        <label for="title">Title:</label><br>
        <input type="text" name="title" required placeholder="Enter the title of your question" size="50"><br><br>
        
        <label for="body">Body:</label><br>
        <textarea name="body" rows="4" cols="50" required placeholder="Type your question here..."></textarea><br><br>

        <input type="submit" value="Submit Question" />
    </form>
    <hr>

    <!-- Search Bar -->
    <form action="ListQuestionsServlet" method="get">
        <input type="text" name="searchQuery" value="<%= request.getAttribute("searchQuery") != null ? request.getAttribute("searchQuery") : "" %>" placeholder="Search for questions...">
        <button type="submit">Search</button>
    </form>

    <h2>Questions</h2>

    <!-- Display questions -->
    <%
        List<Map<String, Object>> questions = (List<Map<String, Object>>) request.getAttribute("questions");
        String role = (String) session.getAttribute("role");
        if (questions != null && !questions.isEmpty()) {
    %>
        <ul>
            <%
                for (Map<String, Object> question : questions) {
            %>
                <li>
                    <strong><%= question.get("title") %></strong><br>
                    Asked by <%= question.get("username") %> on <%= question.get("createdAt") %><br>
                    <p><%= question.get("body") %></p>
                    <a href="ViewAnswersServlet?questionID=<%= question.get("questionID") %>">View Answers</a>
                    
                    <!-- Reply form (only visible to cusrep role) -->
                    <%
                        if ("cusrep".equals(role)) {
                    %>
                        <form action="SubmitQuestionServlet" method="POST" style="margin-top: 10px;">
                            <input type="hidden" name="questionID" value="<%= question.get("questionID") %>" />
                            <textarea name="replyBody" rows="2" cols="50" placeholder="Write your reply here..." required></textarea><br>
                            <button type="submit">Submit Reply</button>
                        </form>
                    <%
                        }
                    %>
                </li>
            <%
                }
            %>
        </ul>
    <%
        } else {
    %>
        <p>No questions found.</p>
    <%
        }
    %>
</body>
</html>
