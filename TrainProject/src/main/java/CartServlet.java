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

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("handleDeleteReservationPost".equals(action)) {
            handleDeleteReservationPost(request, response);
        } else if ("calculateCost".equals(action)) {
            handleCalculateCost(request, response);
        } else {
            handleReservationPost(request, response);
        }
    }

    protected void handleReservationPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        String departureDateTime = request.getParameter("DepartureDateTime");
        String originStationId = request.getParameter("OriginStationId");
        String destinationStationId = request.getParameter("DestinationStationId");
        String destinationStationName = request.getParameter("DestinationStationName");
        String originStationName = request.getParameter("OriginStationName");
        String lineId = request.getParameter("LineId");
        String lineName = request.getParameter("LineName");
        String trainId = request.getParameter("TrainId");
        String customerId = request.getParameter("CustomerId");
        String fareTypeId = request.getParameter("FareTypeId");
        String roundTrip = request.getParameter("RoundTrip");
        String calculatedFare = request.getParameter("CalculatedFare");
        String trainNumber = request.getParameter("TrainNumber");

        Map<String, String> reservation = new HashMap<>();
        reservation.put("DepartureDateTime", departureDateTime);
        reservation.put("OriginStationId", originStationId);
        reservation.put("DestinationStationId", destinationStationId);
        reservation.put("OriginStationName", originStationName);
        reservation.put("DestinationStationName", destinationStationName);
        reservation.put("LineId", lineId);
        reservation.put("LineName", lineName);
        reservation.put("TrainId", trainId);
        reservation.put("CustomerId", customerId);
        reservation.put("FareTypeId", fareTypeId);
        reservation.put("RoundTrip", roundTrip);
        reservation.put("CalculatedFare", calculatedFare);
        reservation.put("TrainNumber", trainNumber);

        //List<Map<String, String>> cart = (List<Map<String, String>>) session.getAttribute("cart");
        //if (cart == null) {
        //    cart = new ArrayList<>();
        //}
        
        List<Map<String, String>> cart = new ArrayList<>();
        cart.add(reservation);

        session.setAttribute("cart", cart);

        request.setAttribute("fareTypes", fetchFareTypes());
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    protected void handleDeleteReservationPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        int reservationIndex = Integer.parseInt(request.getParameter("reservationIndex"));

        List<Map<String, String>> cart = (List<Map<String, String>>) session.getAttribute("cart");
        if (cart != null && reservationIndex >= 0 && reservationIndex < cart.size()) {
            cart.remove(reservationIndex);
            session.setAttribute("cart", cart);
        }

        request.setAttribute("fareTypes", fetchFareTypes());
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    protected void handleCalculateCost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<Map<String, String>> cart = (List<Map<String, String>>) session.getAttribute("cart");
        int selectedFareTypeId = Integer.parseInt(request.getParameter("fareType"));
        boolean isRoundTrip = Boolean.parseBoolean(request.getParameter("roundTrip"));
        double totalCost = 0.0;
        if (cart != null) {
            for (Map<String, String> reservation : cart) {
                double fare = Double.parseDouble(reservation.get("CalculatedFare"));
                totalCost += fare;
            }
        }
        
        List<Map<String, String>> fareTypes = fetchFareTypes();
        double fareMultiplier = 1.0;
        String fareTypeName = "";
        for (Map<String, String> fareType : fareTypes) {
            if (Integer.parseInt(fareType.get("FareTypeId")) == selectedFareTypeId) {
                fareMultiplier = Double.parseDouble(fareType.get("FareTypeMultiplier"));
                fareTypeName = fareType.get("FareTypeName").toString();
                break;
            }
        }
        
        totalCost *= fareMultiplier;
        
        if (isRoundTrip) {
            totalCost *= 2;
        }
        
        request.setAttribute("fareTypes", fareTypes);
        request.setAttribute("totalCost", totalCost);
        
        session.setAttribute("fareTypeId", selectedFareTypeId);
        session.setAttribute("fareTypeName", fareTypeName);
        session.setAttribute("totalCost", totalCost);
        session.setAttribute("isRoundTrip", isRoundTrip);
        
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    private List<Map<String, String>> fetchFareTypes() {
        List<Map<String, String>> fareTypes = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");

            String query = "SELECT FareTypeId, FareTypeName, FareTypeMultiplier FROM faretype";
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Map<String, String> fareType = new HashMap<>();
                fareType.put("FareTypeId", String.valueOf(rs.getInt("FareTypeId")));
                
                String fareTypeName = rs.getString("FareTypeName");
                double fareTypeMultiplier = rs.getDouble("FareTypeMultiplier");
                
                // Calculate the discount percentage
                int discountPercentage = (int) ((1 - fareTypeMultiplier) * 100);
                
                // Format the fareTypeMultiplier as a percentage and concatenate with the FareTypeName
                String formattedFareTypeName = fareTypeName + " (" + discountPercentage + "% discount)";
                
                fareType.put("FareTypeName", formattedFareTypeName);
                fareType.put("FareTypeMultiplier", String.valueOf(fareTypeMultiplier));
                
                fareTypes.add(fareType);
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error fetching fare types: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("Error closing resources: " + e.getMessage());
            }
        }
        return fareTypes;
    }
}
