import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ForumServlet")
public class ForumServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchQuery = request.getParameter("search");
        List<Map<String, Object>> questions = fetchQuestions(searchQuery);
        request.setAttribute("questions", questions);
        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("employeeType");
        if ("customerRep".equals(userType)) {
            request.getRequestDispatcher("/forumEmployee.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/forumCustomer.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("ask".equals(action)) {
            handleAskQuestion(request, response);
        } else if ("answer".equals(action)) {
            handleAnswerQuestion(request, response);
        }
    }

    private List<Map<String, Object>> fetchQuestions(String searchQuery) {
        List<Map<String, Object>> questions = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");

            String query = "SELECT QuestionId, CustomerId, question, answer FROM forum";
            if (searchQuery != null && !searchQuery.isEmpty()) {
                query += " WHERE question LIKE ?";
            }
            query += " ORDER BY QuestionId DESC";

            PreparedStatement ps = conn.prepareStatement(query);
            if (searchQuery != null && !searchQuery.isEmpty()) {
                ps.setString(1, "%" + searchQuery + "%");
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> question = new HashMap<>();
                question.put("QuestionId", rs.getInt("QuestionId"));
                question.put("CustomerId", rs.getInt("CustomerId"));
                question.put("question", rs.getString("question"));
                question.put("answer", rs.getString("answer"));
                questions.add(question);
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return questions;
    }

    private void handleAskQuestion(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        int customerId = (Integer) session.getAttribute("customerId");
        String question = request.getParameter("question");

        Connection conn = null;
        PreparedStatement statement = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");

            String query = "INSERT INTO forum (CustomerId, question) VALUES (?, ?)";
            statement = conn.prepareStatement(query);
            statement.setInt(1, customerId);
            statement.setString(2, question);
            statement.executeUpdate();
        } catch (Exception e) {
            throw new ServletException(e);
        } finally {
            try {
                if (statement != null) statement.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                throw new ServletException(e);
            }
        }

        response.sendRedirect("ForumServlet");
    }

    private void handleAnswerQuestion(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int questionId = Integer.parseInt(request.getParameter("questionId"));
        String answer = request.getParameter("answer");

        Connection conn = null;
        PreparedStatement statement = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");

            String query = "UPDATE forum SET answer=? WHERE QuestionId=?";
            statement = conn.prepareStatement(query);
            statement.setString(1, answer);
            statement.setInt(2, questionId);
            statement.executeUpdate();
        } catch (Exception e) {
            throw new ServletException(e);
        } finally {
            try {
                if (statement != null) statement.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                throw new ServletException(e);
            }
        }

        response.sendRedirect("ForumServlet");
    }
}
