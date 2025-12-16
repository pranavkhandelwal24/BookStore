package com.bookstore.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

@MultipartConfig(
    maxFileSize = 5 * 1024 * 1024,      // 5MB
    maxRequestSize = 10 * 1024 * 1024,   // 10MB
    fileSizeThreshold = 1024 * 1024      // 1MB
)
public class FileUploadServlet extends HttpServlet {
    
    private static final String UPLOAD_DIR = "uploads";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        
        if (!"admin".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        // Get the absolute path of the web application
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + UPLOAD_DIR;
        
        // Create upload directory if it doesn't exist
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        try {
            Part filePart = request.getPart("file");
            
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                
                // Generate unique filename to avoid conflicts
                String fileExtension = "";
                int dotIndex = fileName.lastIndexOf('.');
                if (dotIndex > 0) {
                    fileExtension = fileName.substring(dotIndex);
                    fileName = fileName.substring(0, dotIndex);
                }
                
                String uniqueFileName = fileName + "_" + System.currentTimeMillis() + fileExtension;
                String filePath = uploadPath + File.separator + uniqueFileName;
                
                // Save file
                filePart.write(filePath);
                
                // Return the relative URL for the uploaded file
                String fileUrl = request.getContextPath() + "/" + UPLOAD_DIR + "/" + uniqueFileName;
                
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true, \"fileUrl\": \"" + fileUrl + "\"}");
                
            } else {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"error\": \"No file selected\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"error\": \"File upload failed\"}");
        }
    }
}
