import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ListRevenueServlet")
public class ListRevenueServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String report = null;
        String message = null;

        if ("byLine".equals(action)) {
            String lineId = request.getParameter("lineId");
            report = getRevenueByLine(lineId);
            if (report == null) {
                message = "No revenue data found for Transit Line ID: " + lineId;
            }
        } else if ("byCustomer".equals(action)) {
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            report = getRevenueByCustomer(firstName, lastName);
            if (report == null) {
                message = "No revenue data found for Customer: " + firstName + " " + lastName;
            }
        }

        request.setAttribute("report", report);
        request.setAttribute("message", message);
        request.getRequestDispatcher("/listRevenue.jsp").forward(request, response);
    }

    private String getRevenueByLine(String lineId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String report = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");

            String sql = "SELECT count(*), sum(r.CalculatedFare) FROM reservation r WHERE r.LineId = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(lineId));
            rs = ps.executeQuery();

            if (rs.next()) {
                int count = rs.getInt(1);
                double totalFare = rs.getDouble(2);
                report = "Total reservations: " + count + ", Total revenue: $" + totalFare;
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

        return report;
    }

    private String getRevenueByCustomer(String firstName, String lastName) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String report = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");

            String sql = "SELECT count(*), sum(r.CalculatedFare) FROM reservation r JOIN customer c ON r.CustomerId = c.CustomerId WHERE c.FirstName = ? AND c.LastName = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, firstName);
            ps.setString(2, lastName);
            rs = ps.executeQuery();

            if (rs.next()) {
                int count = rs.getInt(1);
                double totalFare = rs.getDouble(2);
                report = "Total reservations: " + count + ", Total revenue: $" + totalFare;
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

        return report;
    }
}
