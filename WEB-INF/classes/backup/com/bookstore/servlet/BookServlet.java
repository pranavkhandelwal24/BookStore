package com.bookstore.servlet;

import com.bookstore.dao.BookDAO;
import com.bookstore.model.Book;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class BookServlet extends HttpServlet {
    private BookDAO bookDAO;
    
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listBooks(request, response);
                break;
            case "view":
                viewBook(request, response);
                break;
            case "search":
                searchBooks(request, response);
                break;
            case "category":
                getBooksByCategory(request, response);
                break;
            default:
                listBooks(request, response);
                break;
        }
    }
    
    private void listBooks(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Book> books = bookDAO.getAllBooks();
        List<String> categories = bookDAO.getAllCategories();
        
        request.setAttribute("books", books);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/books.jsp").forward(request, response);
    }
    
    private void viewBook(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String bookIdStr = request.getParameter("id");
        
        if (bookIdStr != null && !bookIdStr.isEmpty()) {
            try {
                int bookId = Integer.parseInt(bookIdStr);
                Book book = bookDAO.getBookById(bookId);
                
                if (book != null) {
                    request.setAttribute("book", book);
                    request.getRequestDispatcher("/book-details.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Book not found");
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid book ID");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Book ID is required");
        }
    }
    
    private void searchBooks(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String searchTerm = request.getParameter("q");
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            List<Book> books = bookDAO.searchBooks(searchTerm.trim());
            List<String> categories = bookDAO.getAllCategories();
            
            request.setAttribute("books", books);
            request.setAttribute("categories", categories);
            request.setAttribute("searchTerm", searchTerm);
            request.getRequestDispatcher("/books.jsp").forward(request, response);
        } else {
            listBooks(request, response);
        }
    }
    
    private void getBooksByCategory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String category = request.getParameter("name");
        
        if (category != null && !category.trim().isEmpty()) {
            List<Book> books = bookDAO.getBooksByCategory(category);
            List<String> categories = bookDAO.getAllCategories();
            
            request.setAttribute("books", books);
            request.setAttribute("categories", categories);
            request.setAttribute("selectedCategory", category);
            request.getRequestDispatcher("/books.jsp").forward(request, response);
        } else {
            listBooks(request, response);
        }
    }
}
