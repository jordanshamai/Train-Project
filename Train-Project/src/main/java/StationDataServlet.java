// StationDataServlet.java
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

@WebServlet("/stationData")
public class StationDataServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        StringBuilder stationOptions = new StringBuilder();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");
            String query = "SELECT StationId, StationName FROM station";
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            while (rs.next()) {
                stationOptions.append("<option value='").append(rs.getInt("StationId")).append("'>")
                              .append(rs.getString("StationName")).append("</option>");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        request.setAttribute("stationOptions", stationOptions.toString());
        request.getRequestDispatcher("/search.jsp").forward(request, response);
    }
}
