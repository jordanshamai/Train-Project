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
import java.util.logging.Logger;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/QandAServlet")
public class QandAServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    
    // Create a Logger
    private static final Logger LOGGER = Logger.getLogger(QandAServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	 String SSN = request.getParameter("ssn");  	 
    	 String idToProcess = request.getParameter("idToProcess");
    	 //Delete Customer Representitive
    	 String button = request.getParameter("button");
    	 LOGGER.info("button="+button);
    	 String CustomerId = request.getParameter("CustomerId");
    	 String question = request.getParameter("question");
         String password = request.getParameter("password");
         String firstname = request.getParameter("firstname");
         String lastname = request.getParameter("lastname");
         String username = request.getParameter("username");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Load the MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Connect to the database with limited user credentials
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");
            if(SSN!=null && button.equals("Add Customer Representitive")) {

	            // Get the maximum EmployeeId from the customers table
	            String maxIdQuery = "SELECT MAX(EmployeeId) AS maxId FROM employee";
	            ps = conn.prepareStatement(maxIdQuery);
	            rs = ps.executeQuery();
	            
	            String employeeType = "costumerRep";
	            
	            int newEmployeeId = 1; // Default value if table is empty
	            if (rs.next()) {
	                newEmployeeId = rs.getInt("maxId") + 1;
	            }
	
	            // Close the previous PreparedStatement and ResultSet
	            ps.close();
	            rs.close();
	
	            // SQL query to insert a new customer with the new CustomerId
	            String sql = "INSERT INTO employee (EmployeeId, SSN, Lastname, FirstName, Username, Password, EmployeeType) VALUES (?, ?, ?, ?, ?, ?, ?)";
	            ps = conn.prepareStatement(sql);
	            ps.setInt(1, newEmployeeId);
	            ps.setString(2, SSN);
	            ps.setString(3, firstname);
	            ps.setString(4, lastname);
	            ps.setString(5, username);
	            ps.setString(6, password);
	            ps.setString(7, employeeType);
	
	
	
	            // Execute the update
	            int result = ps.executeUpdate();
	
	            // Reset screen if successful
	            if (result > 0) {
	            	request.setAttribute("button", "Add Customer Representitive");
	            	request.setAttribute("executionStatus", "<font color=green>Successfully added "+firstname+" "+lastname+"</font>");
	            	//request.getRequestDispatcher("/employeepage.jsp").forward(request, response);

	            	//response.sendRedirect("employeepage.jsp");
	            } else {
	            	request.setAttribute("executionStatus", "<font color=red>Customer representitive "+firstname+" "+lastname+" was not added</font>");
	            }
	            SSN="";
	            firstname="";
	            lastname="";
	            username="";
	            password="";
	            employeeType="";
	            //button = "See Customer Representitives";
            } 

            if(idToProcess!=null && button.equals("Edit Customer Representitive")) {

	            // Get the maximum EmployeeId from the customers table
	            String selectQuery = "select EmployeeId, SSN, LastName, FirstName, UserName, Password from employee where EmployeeId=?";
	            ps = conn.prepareStatement(selectQuery);
	            ps.setInt(1, Integer.parseInt(idToProcess));
	            rs = ps.executeQuery();
	          
	            
	            if (rs.next()) {
	                SSN = rs.getString("SSN");
	                lastname = rs.getString("LastName");
	                firstname = rs.getString("FirstName");
	                username = rs.getString("UserName");
	                password = rs.getString("Password");
	            }
	
	            // Close the previous PreparedStatement and ResultSet
	            ps.close();
	            rs.close();
	
	       
	
	
	
	            // Execute the update
	            //int result = ps.executeUpdate();
	
	            // Reset screen if successful
	            //if (result > 0) {
	            request.setAttribute("SSN", SSN);
	            	request.setAttribute("LastName", lastname);
	            	request.setAttribute("FirstName", firstname);
	            	request.setAttribute("UserName", username);
	            	request.setAttribute("Password", password);
	            	request.setAttribute("button", "Edit Customer Representitive");
	            	//request.setAttribute("executionStatus", "<font color=green>Successfully added "+firstname+" "+lastname+"</font>");
	            	//request.getRequestDispatcher("/employeepage.jsp").forward(request, response);

	            	//response.sendRedirect("employeepage.jsp");
	            //} else {
	            	//request.setAttribute("executionStatus", "<font color=red>Customer representitive "+firstname+" "+lastname+" can not be edited</font>");
	            //}
            } 
            
            
            
            if (idToProcess!=null && button.equals("Delete Customer Representitive")) {
            	String sql = "delete from employee where EmployeeId=?";
	            ps = conn.prepareStatement(sql);
	            ps.setInt(1, Integer.parseInt(idToProcess));
	            int result = ps.executeUpdate();
	           
	            	
	            request.setAttribute("button", "Add Customer Representitive");
	            if (result > 0) {
	            	request.setAttribute("executionStatus", "<font color=green>Customer representitive with ID  "+idToProcess+" was deleted</font>");
	            } else {
	            	request.setAttribute("executionStatus", "<font color=red>Customer representitive with ID  "+idToProcess+" was not deleted</font>");
	            }
            }
            
            if (idToProcess!=null && button.equals("Update Customer Representitive")) {
            	String sql = "update employee set SSN=?, Lastname=?, FirstName=?, Username=?, Password=? where EmployeeId=?";
	            ps = conn.prepareStatement(sql);
	            ps.setString(1, SSN);
	            ps.setString(2, lastname);
	            ps.setString(3, firstname);
	            ps.setString(4, username);
	            ps.setString(5, password);
	            ps.setInt(6, Integer.parseInt(idToProcess));
	            int result = ps.executeUpdate();
	           
	            	
	            request.setAttribute("button", "Add Customer Representitive");
	            if (result > 0) {
	            	request.setAttribute("executionStatus", "<font color=green>Customer representitive with ID  "+idToProcess+" was modified</font>");
	            } else {
	            	request.setAttribute("executionStatus", "<font color=red>Customer representitive with ID  "+idToProcess+" was not modified</font>");
	            }
	            SSN="";
	            firstname="";
	            lastname="";
	            username="";
	            password="";
            }
            
            // LOGGER.info("button="+button);
            if (button!=null && button.equals("Show monthly sales")) {
            	request.setAttribute("button", "Add Customer Representitive");
            	Statement stmt = conn.createStatement();
            	String sql = "SELECT "
            			//+ "    DATE_FORMAT(DepartureDateTime, '%M, %Y') AS short_month, "
            			+ "    DATE_FORMAT(DepartureDateTime, '%Y-%m-01') AS month, "
            			+ "    format(SUM(CalculatedFare),2) AS total_sales "
            			+ "FROM reservation GROUP BY month ORDER BY month";
                rs = stmt.executeQuery(sql);

                List<HashMap<String, String>> sale = new ArrayList<>();
                String all ="Monthly sales report</h2><table border=1><th>Monh</th><th>Sales</th>";
                // LOGGER.info("all="+all);
                while (rs.next()) {
                    //HashMap<String, String> user = new HashMap<String, String>();
                    //user.put("month", rs.getString("month"));
                    //user.put("total_sales", rs.getString("total_sales"));
                    all+="<tr><td>"+rs.getString("month")+"</td><td>$"+rs.getString("total_sales")+"</td></tr>";
                    // LOGGER.info("all="+all);
                    //sale.add(user);
                }
                all+="</table><br>";
                request.setAttribute("executionStatus", all);
                request.setAttribute("button", button);
	        	request.getRequestDispatcher("/qanda.jsp").forward(request, response);
            }
            
            if (button!=null && button.equals("Reservations By Transit Line")) {
            	request.setAttribute("button", "Add Customer Representitive");
            	Statement stmt = conn.createStatement();
            	String sql = "SELECT "
            			//+ "    DATE_FORMAT(DepartureDateTime, '%M, %Y') AS short_month, "
            			+ "    reservationID, customerID,"
            			+ "FROM reservation GROUP BY month ORDER BY month";
                rs = stmt.executeQuery(sql);

                List<HashMap<String, String>> sale = new ArrayList<>();
                String all ="Monthly sales report</h2><table border=1><th>Monh</th><th>Sales</th>";
                // LOGGER.info("all="+all);
                while (rs.next()) {
                    //HashMap<String, String> user = new HashMap<String, String>();
                    //user.put("month", rs.getString("month"));
                    //user.put("total_sales", rs.getString("total_sales"));
                    all+="<tr><td>"+rs.getString("month")+"</td><td>$"+rs.getString("total_sales")+"</td></tr>";
                    // LOGGER.info("all="+all);
                    //sale.add(user);
                }
                all+="</table><br>";
                request.setAttribute("executionStatus", all);
                request.setAttribute("button", button);
	        	request.getRequestDispatcher("/qanda.jsp").forward(request, response);
            }
            
            // LOGGER.info("processing button '"+button+"'");
 

        	// LOGGER.info("processing button '"+button+"'");
        	
        	//response.sendRedirect("employeepage.jsp");
        	Statement stmt = conn.createStatement();
        	String keyword = request.getParameter("search");
        	LOGGER.info("processing keyword '"+keyword+"'");
        	if (keyword!=null && keyword.length()!=0) {
        		keyword = " and question like '%"+keyword+"%' ";
        	} else {
        		keyword="";
        	}
        	String sql = "SELECT question, answer FROM qanda where answer is not NULL "+keyword;
        	LOGGER.info("processing sql '"+sql+"'");
            rs = stmt.executeQuery(sql);
            String qandatable = "<table border=1><tr><th>Question</th><th>Answer</th></tr>";
            while (rs.next()) {
            	qandatable+="<tr><td>"+rs.getString("question")+"</td><td>"+rs.getString("answer")+"</td></tr>";
            }
            qandatable+="</table>";
            
            
            if (button!=null && button.equals("Ask Question")) {

	            String maxIdQuery = "SELECT MAX(QID) AS maxId FROM qanda";
	            ps = conn.prepareStatement(maxIdQuery);
	            rs = ps.executeQuery();
	            
	            int newId = 1; // Default value if table is empty
	            if (rs.next()) {
	                newId = rs.getInt("maxId") + 1;
	            }
            	
            	
            	sql = "INSERT INTO qanda (QID, CustomerId, question) VALUES (?, ?, ?)";
	            ps = conn.prepareStatement(sql);
	            ps.setInt(1, newId);
	            ps.setString(2, CustomerId);
	            ps.setString(3, question);
	
	            // Execute the update
	            int result = ps.executeUpdate();
            	if (result>0) {
            		qandatable="<h2>Question: '"+question+"' was added </h2>"+qandatable;
            	}
            }

            request.setAttribute("qandatable", qandatable);
            
            if(SSN==null) SSN="";
            request.setAttribute("SSN", SSN);
            if(lastname==null) lastname="";
            request.setAttribute("LastName", lastname);
            if(firstname==null) firstname="";
        	request.setAttribute("FirstName", firstname);
        	if(username==null) username="";
        	request.setAttribute("UserName", username);
        	if(password==null) password="";
        	request.setAttribute("Password", password);
        	if(button==null || button.equals("See Customer Representitives")) {
        		request.setAttribute("button", "Add Customer Representitive");
        	} else {
        		if(button.equals("Edit Customer Representitive")) {
        			request.setAttribute("idToProcess", idToProcess);
        			request.setAttribute("button", "Update Customer Representitive");
        		}
        	}
        	request.getRequestDispatcher("/qanda.jsp").forward(request, response);
            
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            //response.sendRedirect("employeepage.jsp");
            request.getRequestDispatcher("/qanda.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            //response.sendRedirect("employeepage.jsp");
            request.getRequestDispatcher("/qanda.jsp").forward(request, response);
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
