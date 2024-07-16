import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/DeleteReservationServlet")
public class DeleteReservationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        int reservationIndex = Integer.parseInt(request.getParameter("reservationIndex"));

        List<Map<String, String>> cart = (List<Map<String, String>>) session.getAttribute("cart");
        if (cart != null && reservationIndex >= 0 && reservationIndex < cart.size()) {
            cart.remove(reservationIndex);
            session.setAttribute("cart", cart);
        }

        response.sendRedirect("cart.jsp");
    }
}
