import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/MostActiveTransitLinesServlet")
public class MostActiveTransitLinesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Map<String, String>> activeLines = getMostActiveTransitLines();

        request.setAttribute("activeLines", activeLines);
        request.getRequestDispatcher("/mostActiveTransitLines.jsp").forward(request, response);
    }

    private List<Map<String, String>> getMostActiveTransitLines() {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Map<String, String>> activeLines = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");

            String sql = "SELECT l.LineName, l.LineId, SUM(r.CalculatedFare) AS TotalFare " +
                         "FROM reservation r " +
                         "JOIN line l ON r.LineId = l.LineId " +
                         "GROUP BY l.LineId " +
                         "ORDER BY TotalFare DESC " +
                         "LIMIT 5";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, String> line = new HashMap<>();
                line.put("LineName", rs.getString("LineName"));
                line.put("LineId", rs.getString("LineId"));
                line.put("TotalFare", rs.getString("TotalFare"));
                activeLines.add(line);
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

        return activeLines;
    }
}
