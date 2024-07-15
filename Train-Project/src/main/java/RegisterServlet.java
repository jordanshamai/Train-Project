import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String firstname = request.getParameter("firstname");
        String lastname = request.getParameter("lastname");
        String email = request.getParameter("email");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Load the MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Connect to the database with limited user credentials
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "limiteduser", "password");

            // Get the maximum CustomerId from the customers table
            String maxIdQuery = "SELECT MAX(CustomerId) AS maxId FROM customer";
            ps = conn.prepareStatement(maxIdQuery);
            rs = ps.executeQuery();

            int newCustomerId = 1; // Default value if table is empty
            if (rs.next()) {
                newCustomerId = rs.getInt("maxId") + 1;
            }

            // Close the previous PreparedStatement and ResultSet
            ps.close();
            rs.close();

            // SQL query to insert a new customer with the new CustomerId
            String sql = "INSERT INTO customer (CustomerId, Username, Password, FirstName, LastName, EmailAddress) VALUES (?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, newCustomerId);
            ps.setString(2, username);
            ps.setString(3, password);
            ps.setString(4, firstname);
            ps.setString(5, lastname);
            ps.setString(6, email);

            // Execute the update
            int result = ps.executeUpdate();

            // Redirect based on the result
            if (result > 0) {
                response.sendRedirect("login.jsp");
            } else {
                response.sendRedirect("register.jsp");
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp");
        } finally {
            // Close resources
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
