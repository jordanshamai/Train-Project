import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/BestCustomerServlet")
public class BestCustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Map<String, String> bestCustomer = getBestCustomer();

        request.setAttribute("bestCustomer", bestCustomer);
        request.getRequestDispatcher("/bestCustomer.jsp").forward(request, response);
    }

    private Map<String, String> getBestCustomer() {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Map<String, String> bestCustomer = new HashMap<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");

            String sql = "SELECT c.CustomerId, c.FirstName, c.LastName, SUM(r.CalculatedFare) AS TotalFare " +
                         "FROM reservation r " +
                         "JOIN customer c ON r.CustomerId = c.CustomerId " +
                         "GROUP BY c.CustomerId " +
                         "ORDER BY TotalFare DESC " +
                         "LIMIT 1";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                bestCustomer.put("CustomerId", rs.getString("CustomerId"));
                bestCustomer.put("FirstName", rs.getString("FirstName"));
                bestCustomer.put("LastName", rs.getString("LastName"));
                bestCustomer.put("TotalFare", rs.getString("TotalFare"));
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return bestCustomer;
    }
}
