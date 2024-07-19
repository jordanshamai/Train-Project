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

    private Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        listStations(request, response);
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
                case "delete":
                    deleteStation(request);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
        response.sendRedirect("AdminStationServlet");
    }

    private void listStations(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Map<String, Object>> stations = new ArrayList<>();

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM station");
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> station = new HashMap<>();
                station.put("StationId", rs.getInt("StationId"));
                station.put("StationName", rs.getString("StationName"));
                station.put("city", rs.getString("city"));
                station.put("state", rs.getString("state"));
                stations.add(station);
            }
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

        try (Connection conn = getConnection()) {
            PreparedStatement ps1 = conn.prepareStatement("SELECT MAX(StationId) AS maxStation FROM station");
            ResultSet rs1 = ps1.executeQuery();

            int stationId = -1;
            if (rs1.next()) {
                stationId = rs1.getInt("maxStation") + 1;
            }

            rs1.close();
            ps1.close();

            PreparedStatement ps = conn.prepareStatement("INSERT INTO station (StationId, StationName, city, state) VALUES (?, ?, ?, ?)");
            ps.setInt(1, stationId);
            ps.setString(2, stationName);
            ps.setString(3, city);
            ps.setString(4, state);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void updateStation(HttpServletRequest request) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String stationName = request.getParameter("stationName");
        String city = request.getParameter("city");
        String state = request.getParameter("state");

        try (Connection conn = getConnection()) {
            PreparedStatement ps = conn.prepareStatement("UPDATE station SET StationName = ?, city = ?, state = ? WHERE StationId = ?");
            ps.setString(1, stationName);
            ps.setString(2, city);
            ps.setString(3, state);
            ps.setInt(4, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void deleteStation(HttpServletRequest request) throws SQLException {
        int id = Integer.parseInt(request.getParameter("id"));

        try (Connection conn = getConnection()) {
            PreparedStatement ps = conn.prepareStatement("DELETE FROM station WHERE StationId = ?");
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new SQLException(e);
        }
    }
}
