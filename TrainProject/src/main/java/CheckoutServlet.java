import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        int customerId = (int) session.getAttribute("customerId");
        List<Map<String, String>> cart = (List<Map<String, String>>) session.getAttribute("cart");
        int fareTypeId = Integer.parseInt(request.getParameter("fareType"));
        boolean roundTrip = Boolean.parseBoolean(request.getParameter("roundTrip"));
        Integer numStops = (Integer) session.getAttribute("numStops");
        int originStationId = (int)session.getAttribute("originStationId");
        int destinationStationId = (int)session.getAttribute("destinationStationId");
        if (numStops == null) {
            response.sendRedirect("cart.jsp");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");

            for (Map<String, String> reservation : cart) {
                String departureDateTime = reservation.get("DepartureDateTime");
                int lineId = Integer.parseInt(reservation.get("LineId"));
                int trainId = Integer.parseInt(reservation.get("TrainId"));

                // Calculate fare
                String fareQuery = "SELECT l.LineCost, ft.FareTypeMultiplier " +
                        "FROM line l " +
                        "JOIN reservation r ON l.LineId = r.LineId " +
                        "JOIN faretype ft ON r.FareTypeId = ft.FareTypeId " +
                        "WHERE l.LineId = ?";
     PreparedStatement farePs = conn.prepareStatement(fareQuery);
     farePs.setInt(1, lineId);

     ResultSet fareRs = farePs.executeQuery();
     double lineCost = 0;
     double fareTypeMultiplier = 0;
     if (fareRs.next()) {
         lineCost = fareRs.getDouble("LineCost");
         fareTypeMultiplier = fareRs.getDouble("FareTypeMultiplier");
     }
     fareRs.close();
     farePs.close();

     double calculatedFare = (fareTypeMultiplier * lineCost/16) * numStops;


                // Insert reservation
                String insertQuery = "INSERT INTO reservation (CustomerId, DepartureDateTime, OriginStationId, DestinationStationId, LineId, TrainId, FareTypeId, RoundTrip, CalculatedFare) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement insertPs = conn.prepareStatement(insertQuery);
                insertPs.setInt(1, customerId);
                insertPs.setString(2, departureDateTime);
                insertPs.setInt(3, originStationId);
                insertPs.setInt(4, destinationStationId);
                insertPs.setInt(5, lineId);
                insertPs.setInt(6, trainId);
                insertPs.setInt(7, fareTypeId);
                insertPs.setBoolean(8, roundTrip);
                insertPs.setDouble(9, calculatedFare);
                insertPs.executeUpdate();
                insertPs.close();
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        session.removeAttribute("cart");
        response.sendRedirect("confirmation.jsp");
    }
}
