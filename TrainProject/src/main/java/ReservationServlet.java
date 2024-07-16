import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ReservationServlet")
public class ReservationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("handleReservationListViewPost".equals(action)) {
           handleReservationListViewPost(request,response);
        } else if ("handleDeleteReservation".equals(action)) {
            handleDeleteReservation(request, response);
        } else {
            handleCreateReservationPost(request, response);
        }
    }

    
    protected void handleCreateReservationPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<Map<String, String>> cart = (List<Map<String, String>>) session.getAttribute("cart");
        int fareTypeId = (int) session.getAttribute("fareTypeId");
        double totalCost = (double) session.getAttribute("totalCost");
        boolean isRoundTrip = (boolean) session.getAttribute("isRoundTrip");
        int customerId = (int) session.getAttribute("customerId");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            // Database connection
        	//Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");
            
            // SQL insert statement
            String sql = "INSERT INTO reservation (CustomerId, DepartureDateTime, OriginStationId, DestinationStationId, LineId, TrainId, FareTypeId, RoundTrip, CalculatedFare) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(sql);
            
            // Iterate over the cart and insert each reservation
            for (Map<String, String> reservation : cart) {
                pstmt.setInt(1, customerId);
                pstmt.setString(2, reservation.get("DepartureDateTime"));
                pstmt.setInt(3, Integer.parseInt(reservation.get("OriginStationId")));
                pstmt.setInt(4, Integer.parseInt(reservation.get("DestinationStationId")));
                pstmt.setInt(5, Integer.parseInt(reservation.get("LineId")));
                pstmt.setInt(6, Integer.parseInt(reservation.get("TrainId")));
                pstmt.setInt(7, fareTypeId);
                pstmt.setBoolean(8, isRoundTrip);
                pstmt.setDouble(9, totalCost);
                
                // Execute the insert
                pstmt.executeUpdate();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close resources
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        
        // request.setAttribute("totalCost", totalCost);
        request.getRequestDispatcher("reservation.jsp").forward(request, response);
    }
    protected void handleReservationListViewPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        int customerId = (int) session.getAttribute("customerId"); // Assuming customerId is stored as an attribute in session
        List<Map<String, String>> reservations = new ArrayList<>();
        try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");
        

        String sql = "SELECT r.DepartureDateTime AS DepartureTime, " +
                     "o.StationName AS Origin, " +
                     "d.StationName AS Destination, " +
                     "l.LineName AS LineName, " +
                     "t.TrainNumber AS TrainNumber, " +
                     "f.FareTypeName AS FareType, " +
                     "r.RoundTrip AS RoundTrip, " +
                     "r.CalculatedFare AS TotalFare, " +
                     "r.reservationId AS ReservationId " +
                     "FROM reservation r " +
                     "JOIN station o ON r.OriginStationId = o.StationId " +
                     "JOIN station d ON r.DestinationStationId = d.StationId " +
                     "JOIN line l ON r.LineId = l.LineId " +
                     "JOIN train t ON r.TrainId = t.TrainId " +
                     "JOIN faretype f ON r.FareTypeId = f.FareTypeId " +
                     "WHERE r.CustomerId = ?";

   
             PreparedStatement ps1 = conn.prepareStatement(sql); 
            
            ps1.setInt(1, customerId);

             ResultSet rs = ps1.executeQuery();
             
                while (rs.next()) {
                    Map<String, String> reservation = new HashMap<>();
                    reservation.put("DepartureTime", rs.getString("DepartureTime"));
                    reservation.put("Origin", rs.getString("Origin"));
                    reservation.put("Destination", rs.getString("Destination"));
                    reservation.put("LineName", rs.getString("LineName"));
                    reservation.put("TrainNumber", rs.getString("TrainNumber"));
                    reservation.put("FareType", rs.getString("FareType"));
                    reservation.put("RoundTrip", rs.getString("RoundTrip"));
                    reservation.put("TotalFare", rs.getString("TotalFare"));
                    reservation.put("ReservationId",rs.getString("ReservationId"));
                    reservations.add(reservation);
                }
            
        }catch (SQLException e) {
            throw new ServletException("Database access error", e);
        } catch (ClassNotFoundException e) {
			
			e.printStackTrace();
		}

        session.setAttribute("reservations", reservations);
        request.getRequestDispatcher("viewReservations.jsp").forward(request, response);
    }
    protected void handleDeleteReservation(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int reservationId = Integer.parseInt(request.getParameter("reservationId"));

        String sql = "DELETE FROM reservation WHERE ReservationId = ?";

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, reservationId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            throw new ServletException("Database access error", e);
        }

        // Refresh the reservations list and redirect back to the view reservations page
        handleReservationListViewPost(request, response);
    }

}
