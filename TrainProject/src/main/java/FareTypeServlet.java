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

@WebServlet("/FareTypeServlet")
public class FareTypeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Fetch fare types
        List<Map<String, String>> fareTypes = fetchFareTypes();
        // Debug: Print the fareTypes list to verify it is not null
        System.out.println("Fare Types in doGet: " + fareTypes);
        // Set fare types attribute for the JSP
        request.setAttribute("fareTypes", fareTypes);
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    private List<Map<String, String>> fetchFareTypes() {
        List<Map<String, String>> fareTypes = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");

            String query = "SELECT FareTypeId, FareTypeName FROM faretype";
            PreparedStatement ps = conn.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> fareType = new HashMap<>();
                fareType.put("FareTypeId", String.valueOf(rs.getInt("FareTypeId")));
                fareType.put("FareTypeName", rs.getString("FareTypeName"));
                fareTypes.add(fareType);
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return fareTypes;
    }
}
