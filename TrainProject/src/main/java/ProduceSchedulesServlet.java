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

@WebServlet("/ProduceSchedulesServlet")
public class ProduceSchedulesServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Map<String, Object>> stations = fetchStations();
        request.setAttribute("stations", stations);
        request.getRequestDispatcher("/produceSchedules.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String stationId = request.getParameter("stationId");
        List<Map<String, Object>> schedules = new ArrayList<>();

        if (stationId != null && !stationId.isEmpty()) {
            Connection conn = null;
            PreparedStatement statement = null;
            ResultSet resultSet = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");

                // Replace this placeholder with your actual query
                String query = "(WITH OnboardingStation AS (SELECT s.StationId, s.StopOrder, stn.StationName, s.LineId FROM stop s JOIN station stn ON s.StationId = stn.StationId WHERE s.StationId = ? AND s.DirectionId = 1), OffboardingStation AS (SELECT s.StationId, s.StopOrder, stn.StationName, s.LineId FROM stop s JOIN station stn ON s.StationId = stn.StationId WHERE s.DirectionId = 1) SELECT DISTINCT t.DirectionId, onboarding.StationId AS OnboardingStationId, offboarding.StationId AS OffboardingStationId, onboarding.StationName AS OnboardingStation, TIME(TIMESTAMP(DATE_ADD(t.DepartureTime, INTERVAL SUM(CASE WHEN s.StopOrder <= onboarding.StopOrder THEN s.MinutesFromLastStop ELSE 0 END) MINUTE))) AS DepartureTime, t.TrainId, t.TrainNumber, offboarding.StationName AS OffboardingStation, TIME(TIMESTAMP(DATE_ADD(DATE_ADD(t.DepartureTime, INTERVAL SUM(CASE WHEN s.StopOrder <= onboarding.StopOrder THEN s.MinutesFromLastStop ELSE 0 END) MINUTE), INTERVAL SUM(CASE WHEN s.StopOrder > onboarding.StopOrder AND s.StopOrder <= offboarding.StopOrder THEN s.MinutesFromLastStop ELSE 0 END) MINUTE))) AS ArrivalTime, SUM(CASE WHEN s.StopOrder > onboarding.StopOrder AND s.StopOrder <= offboarding.StopOrder THEN s.MinutesFromLastStop ELSE 0 END) AS TotalTravelTime FROM stop s JOIN train t ON s.LineId = t.LineId AND t.DirectionId = s.DirectionId JOIN OnboardingStation onboarding ON s.LineId = onboarding.LineId JOIN OffboardingStation offboarding ON s.LineId = offboarding.LineId WHERE onboarding.StationId <> offboarding.StationId AND offboarding.StopOrder > onboarding.StopOrder AND t.DirectionId = 1 AND s.DirectionId = t.DirectionId GROUP BY offboarding.StationId, t.DirectionId, t.TrainId, t.TrainNumber, t.DepartureTime, onboarding.StationName, offboarding.StationName, t.LineId, onboarding.StopOrder, offboarding.StopOrder HAVING DepartureTime BETWEEN '00:00:00' AND '24:00:00' AND t.DirectionId = 1 ORDER BY t.DirectionId, OnboardingStation, DepartureTime, ArrivalTime) UNION (WITH OnboardingStation AS (SELECT s.StationId, s.StopOrder, stn.StationName, s.LineId FROM stop s JOIN station stn ON s.StationId = stn.StationId WHERE s.StationId = ? AND s.DirectionId = 2), OffboardingStation AS (SELECT s.StationId, s.StopOrder, stn.StationName, s.LineId FROM stop s JOIN station stn ON s.StationId = stn.StationId WHERE s.DirectionId = 2) SELECT DISTINCT t.DirectionId, onboarding.StationId AS OnboardingStationId, offboarding.StationId AS OffboardingStationId, onboarding.StationName AS OnboardingStation, TIME(TIMESTAMP(DATE_ADD(t.DepartureTime, INTERVAL SUM(CASE WHEN s.StopOrder <= onboarding.StopOrder THEN s.MinutesFromLastStop ELSE 0 END) MINUTE))) AS DepartureTime, t.TrainId, t.TrainNumber, offboarding.StationName AS OffboardingStation, TIME(TIMESTAMP(DATE_ADD(DATE_ADD(t.DepartureTime, INTERVAL SUM(CASE WHEN s.StopOrder <= onboarding.StopOrder THEN s.MinutesFromLastStop ELSE 0 END) MINUTE), INTERVAL SUM(CASE WHEN s.StopOrder > onboarding.StopOrder AND s.StopOrder <= offboarding.StopOrder THEN s.MinutesFromLastStop ELSE 0 END) MINUTE))) AS ArrivalTime, SUM(CASE WHEN s.StopOrder > onboarding.StopOrder AND s.StopOrder <= offboarding.StopOrder THEN s.MinutesFromLastStop ELSE 0 END) AS TotalTravelTime FROM stop s JOIN train t ON s.LineId = t.LineId AND t.DirectionId = s.DirectionId JOIN OnboardingStation onboarding ON s.LineId = onboarding.LineId JOIN OffboardingStation offboarding ON s.LineId = offboarding.LineId WHERE onboarding.StationId <> offboarding.StationId AND offboarding.StopOrder > onboarding.StopOrder AND t.DirectionId = 2 AND s.DirectionId = t.DirectionId GROUP BY offboarding.StationId, t.DirectionId, t.TrainId, t.TrainNumber, t.DepartureTime, onboarding.StationName, offboarding.StationName, t.LineId, onboarding.StopOrder, offboarding.StopOrder HAVING DepartureTime BETWEEN '00:00:00' AND '24:00:00' AND t.DirectionId = 2 ORDER BY t.DirectionId, OnboardingStation, DepartureTime, ArrivalTime);\r\n"
                		;

                statement = conn.prepareStatement(query);
                statement.setInt(1, Integer.parseInt(stationId)); // For the first ?
                statement.setInt(2, Integer.parseInt(stationId)); // For the second ?
                // Set other parameters if needed

                resultSet = statement.executeQuery();

                while (resultSet.next()) {
                    Map<String, Object> schedule = new HashMap<>();
                    schedule.put("DirectionId", resultSet.getInt("DirectionId"));
                    schedule.put("OnboardingStationId", resultSet.getInt("OnboardingStationId"));
                    schedule.put("OffboardingStationId", resultSet.getInt("OffboardingStationId"));
                    schedule.put("OnboardingStation", resultSet.getString("OnboardingStation"));
                    schedule.put("DepartureTime", resultSet.getTime("DepartureTime"));
                    schedule.put("TrainId", resultSet.getInt("TrainId"));
                    schedule.put("TrainNumber", resultSet.getString("TrainNumber"));
                    schedule.put("OffboardingStation", resultSet.getString("OffboardingStation"));
                    schedule.put("ArrivalTime", resultSet.getTime("ArrivalTime"));
                    schedule.put("TotalTravelTime", resultSet.getInt("TotalTravelTime"));
                    schedules.add(schedule);
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

        request.setAttribute("schedules", schedules);
        doGet(request, response);
    }
    private List<Map<String, Object>> fetchStations() {
        List<Map<String, Object>> stations = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");

            String query = "SELECT s.StationId, s.StationName FROM station s INNER JOIN ( SELECT DISTINCT StationId, StopOrder FROM stop oRDER BY StopOrder) st ON s.StationId = st.StationId ORDER BY st.StopOrder;";
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
