package com.bookstore.servlet;

import com.bookstore.dao.BookDAO;
import com.bookstore.dao.OrderDAO;
import com.bookstore.dao.UserDAO;
import com.bookstore.model.Book;
import com.bookstore.model.Order;
import com.bookstore.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.util.List;

@MultipartConfig(
    maxFileSize = 5 * 1024 * 1024,      // 5MB
    maxRequestSize = 10 * 1024 * 1024,   // 10MB
    fileSizeThreshold = 1024 * 1024      // 1MB
)
public class AdminServlet extends HttpServlet {
    private BookDAO bookDAO;
    private OrderDAO orderDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
        orderDAO = new OrderDAO();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!isAdmin(request, response)) {
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "dashboard";
        }
        
        switch (action) {
            case "dashboard":
                showDashboard(request, response);
                break;
            case "books":
                manageBooks(request, response);
                break;
            case "addBook":
                showAddBookForm(request, response);
                break;
            case "editBook":
                showEditBookForm(request, response);
                break;
            case "deleteBook":
                deleteBook(request, response);
                break;
            case "orders":
                manageOrders(request, response);
                break;
            case "users":
                manageUsers(request, response);
                break;
            default:
                showDashboard(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!isAdmin(request, response)) {
            return;
        }
        
        String action = request.getParameter("action");
        
        switch (action) {
            case "addBook":
                addBook(request, response);
                break;
            case "updateBook":
                updateBook(request, response);
                break;
            case "updateOrderStatus":
                updateOrderStatus(request, response);
                break;
            case "updatePaymentStatus":
                updatePaymentStatus(request, response);
                break;
            default:
                showDashboard(request, response);
                break;
        }
    }
    
    private boolean isAdmin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        
        if (!"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        
        return true;
    }
    
    private void showDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Book> books = bookDAO.getAllBooks();
        List<Order> orders = orderDAO.getAllOrders();
        List<User> users = userDAO.getAllUsers();
        
        request.setAttribute("totalBooks", books.size());
        request.setAttribute("totalOrders", orders.size());
        request.setAttribute("totalUsers", users.size());
        request.setAttribute("recentOrders", orders.subList(0, Math.min(5, orders.size())));
        
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
    
    private void manageBooks(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Book> books = bookDAO.getAllBooks();
        request.setAttribute("books", books);
        request.getRequestDispatcher("/admin/books.jsp").forward(request, response);
    }
    
    private void showAddBookForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/admin/add-book.jsp").forward(request, response);
    }
    
    private void showEditBookForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String bookIdStr = request.getParameter("id");
        
        if (bookIdStr != null && !bookIdStr.isEmpty()) {
            try {
                int bookId = Integer.parseInt(bookIdStr);
                Book book = bookDAO.getBookById(bookId);
                
                if (book != null) {
                    request.setAttribute("book", book);
                    request.getRequestDispatcher("/admin/edit-book.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin?action=books");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin?action=books");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin?action=books");
        }
    }
    
    private void addBook(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            String isbn = request.getParameter("isbn");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String discountPriceStr = request.getParameter("discountPrice");
            String stockStr = request.getParameter("stock");
            String category = request.getParameter("category");
            String imageUrl = request.getParameter("imageUrl");
            
            // Handle file upload if present
            Part filePart = request.getPart("imageFile");
            if (filePart != null && filePart.getSize() > 0) {
                String uploadedImageUrl = handleFileUpload(request, filePart);
                if (uploadedImageUrl != null) {
                    imageUrl = uploadedImageUrl;
                }
            }
            
            // Validation
            if (title == null || author == null || priceStr == null || stockStr == null ||
                title.trim().isEmpty() || author.trim().isEmpty()) {
                request.setAttribute("error", "Title, author, price, and stock are required");
                request.getRequestDispatcher("/admin/add-book.jsp").forward(request, response);
                return;
            }
            
            BigDecimal price = new BigDecimal(priceStr);
            BigDecimal discountPrice = null;
            if (discountPriceStr != null && !discountPriceStr.trim().isEmpty()) {
                discountPrice = new BigDecimal(discountPriceStr);
            }
            int stock = Integer.parseInt(stockStr);
            
            Book book = new Book(title, author, isbn, description, price, stock, category, imageUrl);
            book.setDiscountPrice(discountPrice);
            
            if (bookDAO.addBook(book)) {
                response.sendRedirect(request.getContextPath() + "/admin?action=books");
            } else {
                request.setAttribute("error", "Failed to add book");
                request.getRequestDispatcher("/admin/add-book.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format");
            request.getRequestDispatcher("/admin/add-book.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while adding the book");
            request.getRequestDispatcher("/admin/add-book.jsp").forward(request, response);
        }
    }
    
    private String handleFileUpload(HttpServletRequest request, Part filePart) {
        try {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            
            // Generate unique filename to avoid conflicts
            String fileExtension = "";
            int dotIndex = fileName.lastIndexOf('.');
            if (dotIndex > 0) {
                fileExtension = fileName.substring(dotIndex);
                fileName = fileName.substring(0, dotIndex);
            }
            
            String uniqueFileName = fileName + "_" + System.currentTimeMillis() + fileExtension;
            
            // Get the absolute path of the web application
            String applicationPath = request.getServletContext().getRealPath("");
            String uploadPath = applicationPath + File.separator + "uploads";
            
            // Create upload directory if it doesn't exist
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            String filePath = uploadPath + File.separator + uniqueFileName;
            
            // Save file
            filePart.write(filePath);
            
            // Return the relative URL for the uploaded file
            return request.getContextPath() + "/uploads/" + uniqueFileName;
            
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    private void updateBook(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String bookIdStr = request.getParameter("bookId");
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            String isbn = request.getParameter("isbn");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String discountPriceStr = request.getParameter("discountPrice");
            String stockStr = request.getParameter("stock");
            String category = request.getParameter("category");
            String imageUrl = request.getParameter("imageUrl");
            
            int bookId = Integer.parseInt(bookIdStr);
            BigDecimal price = new BigDecimal(priceStr);
            BigDecimal discountPrice = null;
            if (discountPriceStr != null && !discountPriceStr.trim().isEmpty()) {
                discountPrice = new BigDecimal(discountPriceStr);
            }
            int stock = Integer.parseInt(stockStr);
            
            Book book = new Book(title, author, isbn, description, price, stock, category, imageUrl);
            book.setBookId(bookId);
            book.setDiscountPrice(discountPrice);
            
            if (bookDAO.updateBook(book)) {
                response.sendRedirect(request.getContextPath() + "/admin?action=books");
            } else {
                request.setAttribute("error", "Failed to update book");
                request.setAttribute("book", book);
                request.getRequestDispatcher("/admin/edit-book.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid input values");
            response.sendRedirect(request.getContextPath() + "/admin?action=books");
        }
    }
    
    private void deleteBook(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String bookIdStr = request.getParameter("id");
        
        if (bookIdStr != null && !bookIdStr.isEmpty()) {
            try {
                int bookId = Integer.parseInt(bookIdStr);
                bookDAO.deleteBook(bookId);
            } catch (NumberFormatException e) {
                // Ignore invalid ID
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin?action=books");
    }
    
    private void manageOrders(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get pagination parameters
        String pageStr = request.getParameter("page");
        String statusFilter = request.getParameter("status");
        String searchQuery = request.getParameter("search");
        
        int page = 1;
        int pageSize = 10;
        
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        // Get orders with pagination and filtering
        List<Order> orders = orderDAO.getAllOrdersWithPagination(page, pageSize, statusFilter, searchQuery);
        int totalOrders = orderDAO.getTotalOrderCount(statusFilter, searchQuery);
        int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
        
        // Get order statistics for dashboard cards
        int pendingCount = orderDAO.getOrderCountByStatus("pending");
        int confirmedCount = orderDAO.getOrderCountByStatus("confirmed");
        int shippedCount = orderDAO.getOrderCountByStatus("shipped");
        int deliveredCount = orderDAO.getOrderCountByStatus("delivered");
        int cancelledCount = orderDAO.getOrderCountByStatus("cancelled");
        
        // Set attributes
        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("pageSize", pageSize);
        
        // Order statistics
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("confirmedCount", confirmedCount);
        request.setAttribute("shippedCount", shippedCount);
        request.setAttribute("deliveredCount", deliveredCount);
        request.setAttribute("cancelledCount", cancelledCount);
        
        request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
    }
    
    /**
     * Updates the status of an order (pending, confirmed, shipped, delivered, cancelled)
     * Preserves pagination and filter parameters when redirecting back to orders page
     */
    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String orderIdStr = request.getParameter("orderId");
        String status = request.getParameter("status");
        String currentPage = request.getParameter("page");
        String statusFilter = request.getParameter("statusFilter");
        String searchQuery = request.getParameter("searchQuery");
        
        if (orderIdStr != null && status != null && !orderIdStr.isEmpty() && !status.isEmpty()) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                boolean success = orderDAO.updateOrderStatus(orderId, status);
                
                HttpSession session = request.getSession();
                if (success) {
                    session.setAttribute("success", "Order #" + orderId + " status updated to " + status.toUpperCase());
                } else {
                    session.setAttribute("error", "Failed to update order status");
                }
            } catch (NumberFormatException e) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Invalid order ID");
            }
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Missing order ID or status");
        }
        
        // Build redirect URL preserving pagination and filters
        StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/admin?action=orders");
        if (currentPage != null && !currentPage.isEmpty()) {
            redirectUrl.append("&page=").append(currentPage);
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            redirectUrl.append("&status=").append(statusFilter);
        }
        if (searchQuery != null && !searchQuery.isEmpty()) {
            redirectUrl.append("&search=").append(searchQuery);
        }
        
        response.sendRedirect(redirectUrl.toString());
    }
    
    /**
     * Updates the payment status of an order (pending, paid, failed)
     * Preserves pagination and filter parameters when redirecting back to orders page
     */
    private void updatePaymentStatus(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String orderIdStr = request.getParameter("orderId");
        String paymentStatus = request.getParameter("paymentStatus");
        String currentPage = request.getParameter("page");
        String statusFilter = request.getParameter("statusFilter");
        String searchQuery = request.getParameter("searchQuery");
        
        if (orderIdStr != null && paymentStatus != null && !orderIdStr.isEmpty() && !paymentStatus.isEmpty()) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                boolean success = orderDAO.updatePaymentStatus(orderId, paymentStatus);
                
                HttpSession session = request.getSession();
                if (success) {
                    session.setAttribute("success", "Payment status for Order #" + orderId + " updated to " + paymentStatus.toUpperCase());
                } else {
                    session.setAttribute("error", "Failed to update payment status");
                }
                
            } catch (NumberFormatException e) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Invalid order ID");
            }
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Missing order ID or payment status");
        }
        
        // Build redirect URL preserving pagination and filters
        StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/admin?action=orders");
        if (currentPage != null && !currentPage.isEmpty()) {
            redirectUrl.append("&page=").append(currentPage);
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            redirectUrl.append("&status=").append(statusFilter);
        }
        if (searchQuery != null && !searchQuery.isEmpty()) {
            redirectUrl.append("&search=").append(searchQuery);
        }
        
        response.sendRedirect(redirectUrl.toString());
    }
    
    private void manageUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }
}
