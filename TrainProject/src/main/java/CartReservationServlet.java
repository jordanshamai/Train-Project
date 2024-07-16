// CartReservationServlet.java
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
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartReservationServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<Map<String, String>> cart = (List<Map<String, String>>) session.getAttribute("cart");

        List<Map<String, String>> fareTypes = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");
            String query = "SELECT FareTypeId, FareTypeName FROM faretype";
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> fareType = new HashMap<>();
                fareType.put("FareTypeId", String.valueOf(rs.getInt("FareTypeId")));
                fareType.put("FareTypeName", rs.getString("FareTypeName"));
                fareTypes.add(fareType);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        request.setAttribute("cart", cart);
        request.setAttribute("fareTypes", fareTypes);
        request.getRequestDispatcher("/displayData.jsp").forward(request, response);
    }
}
