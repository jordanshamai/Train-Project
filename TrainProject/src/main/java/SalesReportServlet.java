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

@WebServlet("/SalesReportServlet")
public class SalesReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String month = request.getParameter("month");
        String report = generateSalesReport(month);

        request.setAttribute("report", report);
        request.getRequestDispatcher("/salesReport.jsp").forward(request, response);
    }

    private String generateSalesReport(String month) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String report = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");

            String sql = "SELECT count(*), sum(CalculatedFare) FROM reservation r WHERE DepartureDateTime LIKE ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, "%-" + month + "-%");
            rs = ps.executeQuery();

            if (rs.next()) {
                int count = rs.getInt(1);
                double totalFare = rs.getDouble(2);
                report = "Total reservations: " + count + ", Total sales: $" + totalFare;
            } else {
                report = "No sales data found for the selected month.";
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            report = "Error generating sales report.";
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
