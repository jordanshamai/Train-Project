import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ListReservationServlet")
public class ListReservationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        List<Map<String, String>> reservations = null;
        String message = null;

        if ("byLine".equals(action)) {
            String lineId = request.getParameter("lineId");
            reservations = getReservationsByLine(lineId);
            if (reservations == null || reservations.isEmpty()) {
                message = "No reservations found for Transit Line ID: " + lineId;
            }
        } else if ("byCustomer".equals(action)) {
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            reservations = getReservationsByCustomer(firstName, lastName);
            if (reservations == null || reservations.isEmpty()) {
                message = "No reservations found for Customer: " + firstName + " " + lastName;
            }
        }

        request.setAttribute("reservations", reservations);
        request.setAttribute("message", message);
        request.getRequestDispatcher("/listReservation.jsp").forward(request, response);
    }

    private List<Map<String, String>> getReservationsByLine(String lineId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Map<String, String>> reservations = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");

            String sql = "SELECT * FROM reservation r WHERE r.LineId = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(lineId));
            rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, String> reservation = new HashMap<>();
                reservation.put("ReservationId", rs.getString("ReservationId"));
                reservation.put("CustomerId", rs.getString("CustomerId"));
                reservation.put("LineId", rs.getString("LineId"));
                reservation.put("DepartureDateTime", rs.getString("DepartureDateTime"));
                reservation.put("CalculatedFare", rs.getString("CalculatedFare"));
                reservations.add(reservation);
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return reservations;
    }

    private List<Map<String, String>> getReservationsByCustomer(String firstName, String lastName) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Map<String, String>> reservations = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336project", "root", "Secret Password");

            String sql = "SELECT * FROM reservation r JOIN customer c ON r.CustomerId = c.CustomerId WHERE c.FirstName = ? AND c.LastName = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, firstName);
            ps.setString(2, lastName);
            rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, String> reservation = new HashMap<>();
                reservation.put("ReservationId", rs.getString("ReservationId"));
                reservation.put("CustomerId", rs.getString("CustomerId"));
                reservation.put("LineId", rs.getString("LineId"));
                reservation.put("DepartureDateTime", rs.getString("DepartureDateTime"));
                reservation.put("CalculatedFare", rs.getString("CalculatedFare"));
                reservations.add(reservation);
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return reservations;
    }
}
