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
import jakarta.servlet.http.HttpSession;

@WebServlet("/TrainScheduleServlet")
public class TrainScheduleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Fetching stations for dropdowns
        List<Map<String, Object>> stations = fetchStations();
        // Debug: Print the stations list to verify it is not null
        System.out.println("Stations in doGet: " + stations);
        // Setting stations attribute for the JSP
        request.setAttribute("stations", stations);
        request.getRequestDispatcher("search.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int originStationId = Integer.parseInt(request.getParameter("originStation"));
        int destinationStationId = Integer.parseInt(request.getParameter("destinationStation"));
        String travelDate = request.getParameter("travelDate");
        String departureAfterTime = request.getParameter("departureAfterTime");
        List<Map<String, Object>> schedules = new ArrayList<>();
        HttpSession session = request.getSession();
        int numStops = 0;

        // Fetching stations for dropdowns
        List<Map<String, Object>> stations = fetchStations();
        // Debug: Print the stations list to verify it is not null
        System.out.println("Stations in doPost: " + stations);
        // Setting stations attribute for the JSP
        request.setAttribute("stations", stations);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");

            conn.prepareStatement("DROP TEMPORARY TABLE IF EXISTS TempOrigin").executeUpdate();
            conn.prepareStatement("DROP TEMPORARY TABLE IF EXISTS TempDestination").executeUpdate();
            conn.prepareStatement("DROP TEMPORARY TABLE IF EXISTS TempSchedule").executeUpdate();

            PreparedStatement ps1 = conn.prepareStatement(
                "CREATE TEMPORARY TABLE TempOrigin AS " +
                "SELECT st1.StationId, st1.StopOrder, stn1.StationName, st1.LineId " +
                "FROM stop st1 " +
                "JOIN station stn1 ON st1.StationId = stn1.StationId " +
                "WHERE st1.StationId = ?"
            );
            ps1.setInt(1, originStationId);
            ps1.executeUpdate();

            PreparedStatement ps2 = conn.prepareStatement(
                "CREATE TEMPORARY TABLE TempDestination AS " +
                "SELECT st2.StationId, st2.StopOrder, stn2.StationName, st2.LineId " +
                "FROM stop st2 " +
                "JOIN station stn2 ON st2.StationId = stn2.StationId " +
                "WHERE st2.StationId = ?"
            );
            ps2.setInt(1, destinationStationId);
            ps2.executeUpdate();

            PreparedStatement ps3 = conn.prepareStatement(
                "SELECT COUNT(*) AS NumStops " +
                "FROM stop s " +
                "JOIN TempOrigin origin ON s.LineId = origin.LineId " +
                "JOIN TempDestination destination ON s.LineId = destination.LineId " +
                "WHERE s.StopOrder > origin.StopOrder AND s.StopOrder < destination.StopOrder"
            );
            ResultSet rs3 = ps3.executeQuery();
            if (rs3.next()) {
                numStops = rs3.getInt("NumStops") + 2;
            }
            rs3.close();
            ps3.close();

            PreparedStatement ps4 = conn.prepareStatement(
                "CREATE TEMPORARY TABLE TempSchedule AS " +
                "SELECT " +
                "    origin.StationId as OriginStationId, origin.StationName AS OriginStationName, " +
                "    TIME(DATE_ADD(t.DepartureTime, INTERVAL SUM(CASE " +
                "        WHEN s.StopOrder <= origin.StopOrder THEN s.MinutesFromLastStop " +
                "        ELSE 0 " +
                "    END) MINUTE)) AS DepartureTime, " +
                "    t.TrainNumber, " +
                "    destination.StationId as DestinationStationId, destination.StationName AS DestinationStationName, " +
                "    TIME(DATE_ADD(DATE_ADD(t.DepartureTime, INTERVAL SUM(CASE " +
                "        WHEN s.StopOrder <= origin.StopOrder THEN s.MinutesFromLastStop " +
                "        ELSE 0 " +
                "    END) MINUTE), INTERVAL SUM(CASE " +
                "        WHEN s.StopOrder > origin.StopOrder AND s.StopOrder <= destination.StopOrder THEN s.MinutesFromLastStop " +
                "        ELSE 0 " +
                "    END) MINUTE)) AS ArrivalTime, " +
                "    SUM(CASE " +
                "        WHEN s.StopOrder > origin.StopOrder AND s.StopOrder <= destination.StopOrder THEN s.MinutesFromLastStop " +
                "        ELSE 0 " +
                "    END) AS TotalTravelTime " +
                "FROM stop s " +
                "JOIN train t ON s.LineId = t.LineId " +
                "JOIN TempOrigin origin ON s.LineId = origin.LineId " +
                "JOIN TempDestination destination ON s.LineId = destination.LineId " +
                "GROUP BY origin.StationId, destination.StationId, t.TrainNumber, t.DepartureTime, origin.StationName, destination.StationName, t.LineId, origin.StopOrder, destination.StopOrder"
            );
            ps4.executeUpdate();

            PreparedStatement ps5 = conn.prepareStatement(
                "SELECT * FROM TempSchedule WHERE DepartureTime > ? ORDER BY DepartureTime"
            );
            ps5.setString(1, departureAfterTime);
            ResultSet rs5 = ps5.executeQuery();

            while (rs5.next()) {
                Map<String, Object> schedule = new HashMap<>();
                schedule.put("OriginStationName", rs5.getString("OriginStationName"));
                schedule.put("OriginStationId", rs5.getString("OriginStationId"));
                schedule.put("DestinationStationId", rs5.getString("DestinationStationId"));
                schedule.put("DepartureTime", rs5.getString("DepartureTime"));
                schedule.put("TrainNumber", rs5.getInt("TrainNumber"));
                schedule.put("DestinationStationName", rs5.getString("DestinationStationName"));
                schedule.put("ArrivalTime", rs5.getString("ArrivalTime"));
                schedule.put("TotalTravelTime", rs5.getInt("TotalTravelTime"));
                schedules.add(schedule);
            }

            rs5.close();
            ps5.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        session.setAttribute("originStationId", originStationId);
        session.setAttribute("destinationStationId", destinationStationId);
        session.setAttribute("numStops", numStops);
        request.setAttribute("schedules", schedules);
        request.setAttribute("travelDate", travelDate);
        request.setAttribute("departureAfterTime", departureAfterTime);
        request.getRequestDispatcher("search.jsp").forward(request, response);
    }

    private List<Map<String, Object>> fetchStations() {
        List<Map<String, Object>> stations = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");

            String query = "SELECT StationId, StationName FROM station";
            PreparedStatement ps = conn.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> station = new HashMap<>();
                station.put("StationId", rs.getInt("StationId"));
                station.put("StationName", rs.getString("StationName"));
                stations.add(station);
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stations;
    }
}
