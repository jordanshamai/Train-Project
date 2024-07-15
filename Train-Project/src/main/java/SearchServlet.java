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

@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {
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
        int lineId = 1;
        int directionId = 1;
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
            PreparedStatement ps1 = conn.prepareStatement (
            		("WITH OnboardingStation AS (SELECT s.StationId, s.StopOrder, stn.StationName, s.LineId FROM stop s JOIN station stn ON s.StationId = stn.StationId WHERE s.StationId = ? AND s.LineId = ? AND s.DirectionId = ?), OffboardingStation AS (SELECT s.StationId, s.StopOrder, stn.StationName, s.LineId FROM stop s JOIN station stn ON s.StationId = stn.StationId WHERE s.StationId = ? AND s.LineId = ? AND s.DirectionId = ?) SELECT onboarding.StationId AS OnboardingStationId, offboarding.StationId AS OffboardingStationId, onboarding.StationName AS OnboardingStation, TIME(TIMESTAMP(DATE_ADD(t.DepartureTime, INTERVAL SUM(CASE WHEN s.StopOrder <= onboarding.StopOrder THEN s.MinutesFromLastStop ELSE 0 END) MINUTE))) AS DepartureTime, t.TrainNumber, offboarding.StationName AS OffboardingStation, TIME(TIMESTAMP(DATE_ADD(DATE_ADD(t.DepartureTime, INTERVAL SUM(CASE WHEN s.StopOrder <= onboarding.StopOrder THEN s.MinutesFromLastStop ELSE 0 END) MINUTE), INTERVAL SUM(CASE WHEN s.StopOrder > onboarding.StopOrder AND s.StopOrder <= offboarding.StopOrder THEN s.MinutesFromLastStop ELSE 0 END) MINUTE))) AS ArrivalTime, SUM(CASE WHEN s.StopOrder > onboarding.StopOrder AND s.StopOrder <= offboarding.StopOrder THEN s.MinutesFromLastStop ELSE 0 END) AS TotalTravelTime, ((SELECT LineCost FROM line WHERE LineId = onboarding.LineId) / (SELECT MAX(StopOrder) FROM stop WHERE LineId = onboarding.LineId) * ABS(offboarding.StopOrder - onboarding.StopOrder)) AS CalculatedFare FROM stop s JOIN train t ON s.LineId = t.LineId AND t.DirectionId = s.DirectionId JOIN OnboardingStation onboarding ON s.LineId = onboarding.LineId JOIN OffboardingStation offboarding ON s.LineId = offboarding.LineId WHERE t.DirectionId = ? AND t.LineId = ? and s.DirectionId = t.DirectionId GROUP BY t.TrainNumber, t.DepartureTime, onboarding.StationName, offboarding.StationName, t.LineId, onboarding.StopOrder, offboarding.StopOrder HAVING DepartureTime BETWEEN ? AND '24:00:00' ORDER BY DepartureTime;")
            ); 
            
            ps1.setInt(1, originStationId);
            ps1.setInt(2, lineId);
            ps1.setInt(3, directionId);
            ps1.setInt(4, destinationStationId);
            ps1.setInt(5, lineId);
            ps1.setInt(6, directionId);
            ps1.setInt(7, directionId);
            ps1.setInt(8, lineId);
            ps1.setString(9, departureAfterTime);
            ResultSet rs1=ps1.executeQuery();
            
            while (rs1.next()) {
                Map<String, Object> schedule = new HashMap<>();
                schedule.put("OriginStationName", rs1.getString("OnboardingStation"));
                schedule.put("OriginStationId", rs1.getString("OnboardingStationId"));
                schedule.put("DestinationStationId", rs1.getString("OffboardingStationId"));
                schedule.put("DepartureTime", rs1.getString("DepartureTime"));
                schedule.put("TrainNumber", rs1.getInt("TrainNumber"));
                schedule.put("DestinationStationName", rs1.getString("OffboardingStation"));
                schedule.put("ArrivalTime", rs1.getString("ArrivalTime"));
                schedule.put("TotalTravelTime", rs1.getInt("TotalTravelTime"));
                schedule.put("CalculatedFare", rs1.getDouble("CalculatedFare"));
                schedules.add(schedule);
            }
           
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
