import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ManageCustomerRepServlet")
public class ManageCustomerRepServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");

            // Refresh the page with updated data
            refreshManageCustomerReps(conn, request, response);

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            request.getRequestDispatcher("/manageCustomerReps.jsp").forward(request, response);
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String SSN = request.getParameter("ssn");
        String idToProcess = request.getParameter("idToProcess");
        String button = request.getParameter("button");
        String password = request.getParameter("password");
        String firstname = request.getParameter("firstname");
        String lastname = request.getParameter("lastname");
        String username = request.getParameter("username");

        Connection conn = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");

            switch (button) {
                case "Add Customer Representative":
                    handleCreateCustomerRep(conn, request, response, SSN, firstname, lastname, username, password);
                    break;
                case "Edit Customer Representative":
                    handleEditCustomerRep(conn, request, response, idToProcess);
                    break;
                case "Delete Customer Representative":
                    handleDeleteCustomerRep(conn, request, response, idToProcess);
                    break;
                case "Update Customer Representative":
                    handleUpdateCustomerRep(conn, request, response, idToProcess, SSN, firstname, lastname, username, password);
                    break;
                default:
                    throw new ServletException("Invalid action");
            }

            // Refresh the page with updated data
            refreshManageCustomerReps(conn, request, response);

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            request.getRequestDispatcher("/manageCustomerReps.jsp").forward(request, response);
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private void handleCreateCustomerRep(Connection conn, HttpServletRequest request, HttpServletResponse response, String SSN, String firstname, String lastname, String username, String password) throws SQLException, ServletException, IOException {
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            String maxIdQuery = "SELECT MAX(EmployeeId) AS maxId FROM employee";
            ps = conn.prepareStatement(maxIdQuery);
            rs = ps.executeQuery();

            int newEmployeeId = 1; // Default value if table is empty
            if (rs.next()) {
                newEmployeeId = rs.getInt("maxId") + 1;
            }

            ps.close();
            rs.close();

            String sql = "INSERT INTO employee (EmployeeId, SSN, Lastname, FirstName, Username, Password, EmployeeType) VALUES (?, ?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, newEmployeeId);
            ps.setString(2, SSN);
            ps.setString(3, lastname);
            ps.setString(4, firstname);
            ps.setString(5, username);
            ps.setString(6, password);
            ps.setString(7, "customerRep");

            int result = ps.executeUpdate();

            if (result > 0) {
                request.setAttribute("executionStatus", "<font color=green>Successfully added " + firstname + " " + lastname + "</font>");
            } else {
                request.setAttribute("executionStatus", "<font color=red>Customer representative " + firstname + " " + lastname + " was not added</font>");
            }
        } finally {
            if (ps != null) ps.close();
            if (rs != null) rs.close();
        }
    }

    private void handleEditCustomerRep(Connection conn, HttpServletRequest request, HttpServletResponse response, String idToProcess) throws SQLException, ServletException, IOException {
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            String selectQuery = "SELECT EmployeeId, SSN, LastName, FirstName, UserName, Password FROM employee WHERE EmployeeId=?";
            ps = conn.prepareStatement(selectQuery);
            ps.setInt(1, Integer.parseInt(idToProcess));
            rs = ps.executeQuery();

            if (rs.next()) {
                request.setAttribute("SSN", rs.getString("SSN"));
                request.setAttribute("LastName", rs.getString("LastName"));
                request.setAttribute("FirstName", rs.getString("FirstName"));
                request.setAttribute("UserName", rs.getString("UserName"));
                request.setAttribute("Password", rs.getString("Password"));
                request.setAttribute("idToProcess", idToProcess);
                request.setAttribute("button", "Update Customer Representative");
            }
        } finally {
            if (ps != null) ps.close();
            if (rs != null) rs.close();
        }

        // Forward to the JSP to display the edit form
        request.getRequestDispatcher("/manageCustomerReps.jsp").forward(request, response);
    }

    private void handleDeleteCustomerRep(Connection conn, HttpServletRequest request, HttpServletResponse response, String idToProcess) throws SQLException, ServletException, IOException {
        PreparedStatement ps = null;

        try {
            String sql = "DELETE FROM employee WHERE EmployeeId=?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(idToProcess));
            int result = ps.executeUpdate();

            if (result > 0) {
                request.setAttribute("executionStatus", "<font color=green>Customer representative with ID " + idToProcess + " was deleted</font>");
            } else {
                request.setAttribute("executionStatus", "<font color=red>Customer representative with ID " + idToProcess + " was not deleted</font>");
            }
        } finally {
            if (ps != null) ps.close();
        }
    }

    private void handleUpdateCustomerRep(Connection conn, HttpServletRequest request, HttpServletResponse response, String idToProcess, String SSN, String firstname, String lastname, String username, String password) throws SQLException, ServletException, IOException {
        PreparedStatement ps = null;

        try {
            String sql = "UPDATE employee SET SSN=?, Lastname=?, FirstName=?, Username=?, Password=? WHERE EmployeeId=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, SSN);
            ps.setString(2, lastname);
            ps.setString(3, firstname);
            ps.setString(4, username);
            ps.setString(5, password);
            ps.setInt(6, Integer.parseInt(idToProcess));
            int result = ps.executeUpdate();

            if (result > 0) {
                request.setAttribute("executionStatus", "<font color=green>Customer representative with ID " + idToProcess + " was modified</font>");
            } else {
                request.setAttribute("executionStatus", "<font color=red>Customer representative with ID " + idToProcess + " was not modified</font>");
            }
        } finally {
            if (ps != null) ps.close();
        }
    }

    private void refreshManageCustomerReps(Connection conn, HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        Statement stmt = conn.createStatement();
        String sql = "SELECT EmployeeId, SSN, Lastname, FirstName, Username, Password, EmployeeType FROM employee WHERE EmployeeType='customerRep'";
        ResultSet rs = stmt.executeQuery(sql);

        List<HashMap<String, String>> users = new ArrayList<>();
        while (rs.next()) {
            HashMap<String, String> user = new HashMap<>();
            user.put("EmployeeId", String.valueOf(rs.getInt("EmployeeId")));
            user.put("SSN", rs.getString("SSN"));
            user.put("LastName", rs.getString("Lastname"));
            user.put("FirstName", rs.getString("FirstName"));
            user.put("Username", rs.getString("Username"));
            user.put("EmployeeType", rs.getString("EmployeeType"));
            users.add(user);
        }

        request.setAttribute("users", users);
        System.out.println("Users list size: " + users.size()); // Debugging statement
        for (HashMap<String, String> user : users) {
            System.out.println(user); // Debugging statement
        }
        request.getRequestDispatcher("/manageCustomerReps.jsp").forward(request, response);
    }
}
