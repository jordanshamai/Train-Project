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
        List<Map<String,Object>> lines = fetchLines();
        request.setAttribute("lines", lines);
        request.getRequestDispatcher("search.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	String action = request.getParameter("formAction");

        if ("search".equals(action)) {
            handleSearchPost(request, response);
        } else if ("lineChange".equals(action)) {
            handleLineChangePost(request, response);
        } else if ("directionChange".equals(action)) {
            handleDirectionChangePost(request, response);
        } else {
            
        }
    }
    
    protected void handleLineChangePost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	int lineId = Integer.parseInt(request.getParameter("line"));
    	List<Map<String, Object>> directionsByLine = fetchDirections(lineId);
    	request.setAttribute("directions", directionsByLine);
    	    	
    	List<Map<String,Object>> lines = fetchLines();
    	request.setAttribute("lines", lines);
    	request.setAttribute("selectedLineId", String.valueOf(lineId));
    	request.getRequestDispatcher("search.jsp").forward(request, response);
    }
    
    protected void handleDirectionChangePost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	int lineId = Integer.parseInt(request.getParameter("line"));
    	int directionId = Integer.parseInt(request.getParameter("direction"));
    	    	
    	List<Map<String, Object>> stationsbyLine = fetchStations(lineId, directionId);
    	request.setAttribute("stations", stationsbyLine);
    	    	
    	List<Map<String,Object>> lines = fetchLines();
    	request.setAttribute("lines", lines);
    	request.setAttribute("selectedLineId", String.valueOf(lineId));
    	
    	List<Map<String, Object>> directionsbyLine = fetchDirections(lineId);
    	request.setAttribute("directions", directionsbyLine);
    	request.setAttribute("selectedDirectionId", String.valueOf(directionId));
    	
    	request.getRequestDispatcher("search.jsp").forward(request, response);
    }
    
    
    protected void handleSearchPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	int originStationId = 0;
    	if (request.getParameter("originStation") != null && request.getParameter("originStation") != "") {
    		originStationId = Integer.parseInt(request.getParameter("originStation"));
    	}
    	
    	int destinationStationId = 0;
    	if (request.getParameter("destinationStation") != null && request.getParameter("destinationStation") != "") {
    		destinationStationId = Integer.parseInt(request.getParameter("destinationStation"));
    	}
    	
        String travelDate = request.getParameter("travelDate");
        String departureAfterTime = request.getParameter("departureAfterTime");
        int lineId = Integer.parseInt(request.getParameter("line"));
        int directionId = Integer.parseInt(request.getParameter("direction"));
        List<Map<String, Object>> schedules = new ArrayList<>();
        HttpSession session = request.getSession();
        int numStops = 0;
        
        // Fetching data for dropdowns
        
        List<Map<String,Object>> lines = fetchLines();
    	request.setAttribute("lines", lines);
    	request.setAttribute("selectedLineId", String.valueOf(lineId));
    	
    	List<Map<String, Object>> directionsbyLine = fetchDirections(lineId);
    	request.setAttribute("directions", directionsbyLine);
    	request.setAttribute("selectedDirectionId", String.valueOf(directionId));
        
        List<Map<String, Object>> stations = fetchStations(lineId, directionId);
        request.setAttribute("stations", stations);
        
        if (originStationId == 0) {
        	for (Map<String, Object> direction : directionsbyLine) {
        		System.out.println("direction.get(\"DirectionId\").toString(): " + direction.get("DirectionId").toString());
        		System.out.println("directionId: " + directionId);
        		if (Integer.parseInt(String.valueOf(directionId)) == Integer.parseInt(direction.get("DirectionId").toString())) {
        			System.out.println("Do we ever get here?");
        			originStationId = Integer.parseInt(direction.get("LineOriginStationId").toString());
        		}
        	}
        }
        
        if (destinationStationId == 0) {
        	for (Map<String, Object> direction : directionsbyLine) {
        		System.out.println("direction.get(\"DirectionId\").toString(): " + direction.get("DirectionId").toString());
        		System.out.println("directionId: " + directionId);
        		if (Integer.parseInt(String.valueOf(directionId)) == Integer.parseInt(direction.get("DirectionId").toString())) {
        			System.out.println("Do we ever get here?");
        			destinationStationId = Integer.parseInt(direction.get("LineDestinationStationId").toString());
        		}
        	}
        }
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");
            PreparedStatement ps1 = conn.prepareStatement (
            		("WITH OnboardingStation AS (SELECT s.StationId, s.StopOrder, stn.StationName, s.LineId FROM stop s JOIN station stn ON s.StationId = stn.StationId WHERE s.StationId = ? AND s.LineId = ? AND s.DirectionId = ?), OffboardingStation AS (SELECT s.StationId, s.StopOrder, stn.StationName, s.LineId FROM stop s JOIN station stn ON s.StationId = stn.StationId WHERE s.StationId = ? AND s.LineId = ? AND s.DirectionId = ?) SELECT onboarding.StationId AS OnboardingStationId, offboarding.StationId AS OffboardingStationId, onboarding.StationName AS OnboardingStation, TIME(TIMESTAMP(DATE_ADD(t.DepartureTime, INTERVAL SUM(CASE WHEN s.StopOrder <= onboarding.StopOrder THEN s.MinutesFromLastStop ELSE 0 END) MINUTE))) AS DepartureTime, t.TrainId, t.TrainNumber, offboarding.StationName AS OffboardingStation, TIME(TIMESTAMP(DATE_ADD(DATE_ADD(t.DepartureTime, INTERVAL SUM(CASE WHEN s.StopOrder <= onboarding.StopOrder THEN s.MinutesFromLastStop ELSE 0 END) MINUTE), INTERVAL SUM(CASE WHEN s.StopOrder > onboarding.StopOrder AND s.StopOrder <= offboarding.StopOrder THEN s.MinutesFromLastStop ELSE 0 END) MINUTE))) AS ArrivalTime, SUM(CASE WHEN s.StopOrder > onboarding.StopOrder AND s.StopOrder <= offboarding.StopOrder THEN s.MinutesFromLastStop ELSE 0 END) AS TotalTravelTime, ((SELECT LineCost FROM line WHERE LineId = onboarding.LineId) / (SELECT MAX(StopOrder) FROM stop WHERE LineId = onboarding.LineId) * ABS(offboarding.StopOrder - onboarding.StopOrder)) AS CalculatedFare, l.LineName FROM stop s JOIN train t ON s.LineId = t.LineId AND t.DirectionId = s.DirectionId JOIN OnboardingStation onboarding ON s.LineId = onboarding.LineId JOIN OffboardingStation offboarding ON s.LineId = offboarding.LineId JOIN line l ON t.LineId = l.LineId WHERE t.DirectionId = ? AND t.LineId = ? AND s.DirectionId = t.DirectionId GROUP BY t.TrainId, t.TrainNumber, t.DepartureTime, onboarding.StationName, offboarding.StationName, t.LineId, onboarding.StopOrder, offboarding.StopOrder, l.LineName HAVING DepartureTime BETWEEN ? AND '24:00:00' ORDER BY DepartureTime;"));
            
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
                schedule.put("TrainId", rs1.getInt("TrainId"));
                schedule.put("TrainNumber", rs1.getInt("TrainNumber"));
                schedule.put("DestinationStationName", rs1.getString("OffboardingStation"));
                schedule.put("ArrivalTime", rs1.getString("ArrivalTime"));
                schedule.put("TotalTravelTime", rs1.getInt("TotalTravelTime"));
                schedule.put("CalculatedFare", rs1.getDouble("CalculatedFare"));
                schedule.put("LineId", lineId);
                schedule.put("DirectionId", directionId);
                schedule.put("LineName", rs1.getString("LineName"));
                
                schedules.add(schedule);
            }
            
            rs1.close();
            ps1.close();
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
    
    
    private List<Map<String, Object>> fetchLines() {
        List<Map<String, Object>> lines = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");

            String query = "SELECT LineId, LineName FROM line order by LineName";
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
    
    private List<Map<String, Object>> fetchDirections(int lineId) {
        List<Map<String, Object>> directions = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");

            String query = "SELECT DirectionId, DirectionName, OriginStationId AS LineOriginStationId, DestinationStationId AS LineDestinationStationId FROM line_direction where LineId = ? order by DirectionId";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, lineId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> direction = new HashMap<>();
                direction.put("DirectionId", rs.getInt("DirectionId"));
                direction.put("DirectionName", rs.getString("DirectionName"));
                direction.put("LineOriginStationId", rs.getInt("LineOriginStationId"));
                direction.put("LineDestinationStationId", rs.getInt("LineDestinationStationId"));
                directions.add(direction);
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return directions;
    }
    private List<Map<String, Object>> fetchStations(int lineId, int directionId) {
        List<Map<String, Object>> stations = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");

            String query = "SELECT s.StationId, s.StationName FROM station s INNER JOIN stop st ON s.StationId = st.StationId AND st.LineId = ? and st.DirectionId = ? ORDER BY st.StopOrder";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, lineId);
            ps.setInt(2, directionId);
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
