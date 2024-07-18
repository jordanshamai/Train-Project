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

@WebServlet("/ListCustomersServlet")
public class ListCustomersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Map<String, Object>> lines = fetchLines();
        request.setAttribute("lines", lines);
        request.getRequestDispatcher("/listCustomers.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String lineId = request.getParameter("lineId");
        String date = request.getParameter("date");

        List<Map<String, Object>> customers = new ArrayList<>();

        if (lineId != null && !lineId.isEmpty() && date != null && !date.isEmpty()) {
            Connection conn = null;
            PreparedStatement statement = null;
            ResultSet resultSet = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");

                String query = "SELECT DISTINCT c.FirstName, c.LastName, r.CustomerId FROM reservation r JOIN customer c ON r.CustomerId=c.CustomerId WHERE r.LineId=? AND r.DepartureDateTime LIKE ?";
                statement = conn.prepareStatement(query);
                statement.setInt(1, Integer.parseInt(lineId));
                statement.setString(2, date + "%");

                resultSet = statement.executeQuery();

                while (resultSet.next()) {
                    Map<String, Object> customer = new HashMap<>();
                    customer.put("FirstName", resultSet.getString("FirstName"));
                    customer.put("LastName", resultSet.getString("LastName"));
                    customer.put("CustomerId", resultSet.getInt("CustomerId"));
                    customers.add(customer);
                }
            } catch (Exception e) {
                throw new ServletException(e);
            } finally {
                try {
                    if (resultSet != null) resultSet.close();
                    if (statement != null) statement.close();
                    if (conn != null) conn.close();
                } catch (Exception e) {
                    throw new ServletException(e);
                }
            }
        }

        request.setAttribute("customers", customers);
        doGet(request, response);
    }

    private List<Map<String, Object>> fetchLines() {
        List<Map<String, Object>> lines = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");

            String query = "SELECT LineId, LineName FROM line ORDER BY LineName";
            PreparedStatement ps = conn.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> line = new HashMap<>();
                line.put("LineId", rs.getInt("LineId"));
                line.put("LineName", rs.getString("LineName"));
                lines.add(line);
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lines;
    }
}
