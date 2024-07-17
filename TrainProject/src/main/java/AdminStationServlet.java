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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
 
@WebServlet("/AdminStationServlet")
public class AdminStationServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
 
        if (action == null) {
            action = "";
        }
 
        try {
            switch (action) {
                case "delete":
                    deleteStation(request);
                    response.sendRedirect("AdminStationServlet");
                    break;
                case "edit":
                    // Implement edit logic here
                    break;
                default:
                    listStations(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
 
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
 
        try {
            switch (action) {
                case "insert":
                    insertStation(request);
                    break;
                case "update":
                    updateStation(request);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
        response.sendRedirect("AdminStationServlet");
    }
 
    private void listStations(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Map<String, Object>> stations = new ArrayList<>();
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
        	Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");
            String sql = "SELECT * FROM station";
        	PreparedStatement statement = conn.prepareStatement(sql);
        	ResultSet resultSet = statement.executeQuery();
             
            while (resultSet.next()) {
                Map<String, Object> station = new HashMap<>();
                station.put("StationId", resultSet.getInt("StationId"));
                station.put("StationName", resultSet.getString("StationName"));
                station.put("city", resultSet.getString("city"));
                station.put("state", resultSet.getString("state"));
                stations.add(station);
            }
            if (statement != null) statement.close();
            if (conn != null) conn.close();
        } catch (Exception e) {
        	e.printStackTrace();
        }
        request.setAttribute("stations", stations);
        request.getRequestDispatcher("adminStation.jsp").forward(request, response);
    }
 
    private void insertStation(HttpServletRequest request) throws ServletException, IOException {
        String stationName = request.getParameter("stationName");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        
        try {
        	Class.forName("com.mysql.cj.jdbc.Driver");
        	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");
        	String sql1 = "SELECT MAX(StationId) AS maxStation FROM station";
        	PreparedStatement ps1 = conn.prepareStatement(sql1);
        	ResultSet rs1 = ps1.executeQuery();

        	int stationId =-1;
        	if (rs1.next()) {
        	    stationId = rs1.getInt("maxStation")+1;
        	   
        	}

      
        	rs1.close();
        	ps1.close();
            String sql = "INSERT INTO station (StationId, StationName, city, state) VALUES (?, ?, ?, ?)";
            PreparedStatement statement = conn.prepareStatement(sql);
            
            statement.setInt(1, stationId);
            statement.setString(2, stationName);
            statement.setString(3, city);
            statement.setString(4, state);
            statement.executeUpdate();
            if (statement != null) statement.close();
            if (conn != null) conn.close();
        } catch (Exception e) {
        	e.printStackTrace();
        }
    }
 
    private void updateStation(HttpServletRequest request) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String stationName = request.getParameter("stationName");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
 
        try {
        	Class.forName("com.mysql.cj.jdbc.Driver");
        	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");
        	
            String sql = "UPDATE station SET StationName = ?, city = ?, state = ? WHERE StationId = ?";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, stationName);
            statement.setString(2, city);
            statement.setString(3, state);
            statement.setInt(4, id);
            statement.executeUpdate();
            if (statement != null) statement.close();
            if (conn != null) conn.close();
        } catch (Exception e) {
        	e.printStackTrace();
        } 
    }
 
    private void deleteStation(HttpServletRequest request) throws SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
 
        try {
        	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");
        	String sql = "DELETE FROM station WHERE StationId = ?";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setInt(1, id);
            statement.executeUpdate();
            if (statement != null) statement.close();
            if (conn != null) conn.close();
        } catch (Exception e) {
            throw new SQLException(e);
        } 
    }
}