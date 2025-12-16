<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Test Order Status Update</title>
</head>
<body>
    <h2>Test Order Status Update</h2>
    
    <form action="${pageContext.request.contextPath}/admin" method="post">
        <input type="hidden" name="action" value="updateOrderStatus">
        <label>Order ID:</label>
        <input type="number" name="orderId" value="1" required><br><br>
        
        <label>New Status:</label>
        <select name="status" required>
            <option value="pending">Pending</option>
            <option value="confirmed">Confirmed</option>
            <option value="shipped">Shipped</option>
            <option value="delivered">Delivered</option>
            <option value="cancelled">Cancelled</option>
        </select><br><br>
        
        <button type="submit">Update Status</button>
    </form>
    
    <hr>
    <p>Debug: Check Tomcat logs for debug messages</p>
</body>
</html>
