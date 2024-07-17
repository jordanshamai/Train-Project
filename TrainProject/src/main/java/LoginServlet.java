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
import jakarta.servlet.http.HttpSession;


@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Load the MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Connect to the database with limited user credentials
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");

            // First, try to authenticate against the employees table
            String sql = "SELECT * FROM employee WHERE Username = ? AND Password = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
            	String employeeName = rs.getString("FirstName") + " " +rs.getString("LastName");
            	String employeeType = rs.getString("EmployeeType");
            	int employeeId = rs.getInt("EmployeeId");
            	HttpSession session = request.getSession();
            	
            	session.setAttribute("employeeId", employeeId);
                session.setAttribute("employeeName", employeeName);             // If a match is found in the employees table, redirect to hello.jsp
                if(employeeType.equals("Admin")) {
                response.sendRedirect("adminDashboard.jsp");
            } else {
            	response.sendRedirect("customerRepDashboard.jsp");
            }
                return;
            }

            // Close the previous PreparedStatement and ResultSet
            ps.close();
            rs.close();

            // Next, try to authenticate against the customers table
            sql = "SELECT * FROM customer WHERE Username = ? AND Password = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                // If a match is found in the customers table, redirect to hello.jsp
            	String customerName = rs.getString("FirstName") + " " +rs.getString("LastName");;
            	
            	HttpSession session = request.getSession();
            	Integer customerId = rs.getInt("CustomerId");
            	session.setAttribute("customerId", customerId);
                session.setAttribute("customerName", customerName);
                response.sendRedirect("SearchServlet");
            } else {
                // If no match is found, redirect to the login page
                response.sendRedirect("login.jsp");
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp");
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}

