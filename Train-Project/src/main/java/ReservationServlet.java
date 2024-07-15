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

        if ("handleAPost".equals(action)) {
            //handleAPost(request, response);
        } else if ("handleBPost".equals(action)) {
            //handleBCost(request, response);
        } else {
            handleReservationPost(request, response);
        }
    }

    protected void handleReservationPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<Map<String, String>> cart = (List<Map<String, String>>) session.getAttribute("cart");
        int fareTypeId = (int) session.getAttribute("FareTypeId");
        double totalCost = (double) session.getAttribute("totalCost");
        boolean isRoundTrip = (boolean) session.getAttribute("isRoundTrip");
        int customerId = (int) session.getAttribute("CustomerId");
        
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
}
