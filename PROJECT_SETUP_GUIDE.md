# Online Bookstore - Project Setup Guide

## Table of Contents
1. [System Requirements](#system-requirements)
2. [Prerequisites Installation](#prerequisites-installation)
3. [Database Setup](#database-setup)
4. [Project Deployment](#project-deployment)
5. [Server Configuration](#server-configuration)
6. [Testing the Application](#testing-the-application)
7. [Admin Panel Access](#admin-panel-access)
8. [Troubleshooting](#troubleshooting)
9. [Project Structure](#project-structure)

---

## System Requirements

### Minimum Requirements:
- **Operating System**: Windows 10/11, macOS 10.14+, or Linux (Ubuntu 18.04+)
- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: 2GB free space
- **Java**: JDK 8 or higher (JDK 11+ recommended)
- **Browser**: Chrome, Firefox, Safari, or Edge (latest versions)

---

## Prerequisites Installation

### 1. Install Java Development Kit (JDK)
```bash
# Check if Java is installed
java -version
javac -version

# If not installed, download from:
# https://www.oracle.com/java/technologies/downloads/
# or use OpenJDK: https://openjdk.org/
```

### 2. Install Apache Tomcat 9.0+
- Download from: https://tomcat.apache.org/download-90.cgi
- Extract to desired location (e.g., `C:\apache-tomcat-9.0.104\`)
- Set `CATALINA_HOME` environment variable to Tomcat directory

### 3. Install MySQL Database
**Option A: XAMPP (Recommended for beginners)**
- Download from: https://www.apachefriends.org/
- Install and start Apache + MySQL services

**Option B: Standalone MySQL**
- Download from: https://dev.mysql.com/downloads/mysql/
- Install MySQL Server and MySQL Workbench

---

## Database Setup

### 1. Start MySQL Server
```bash
# If using XAMPP
# Start XAMPP Control Panel → Start MySQL

# If using standalone MySQL
# Windows: Start MySQL service from Services
# Linux/macOS: sudo systemctl start mysql
```

### 2. Create Database
```sql
-- Connect to MySQL as root user
mysql -u root -p

-- Create database
CREATE DATABASE bookstore_db;

-- Create user (optional but recommended)
CREATE USER 'bookstore_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON bookstore_db.* TO 'bookstore_user'@'localhost';
FLUSH PRIVILEGES;
```

### 3. Import Database Schema
```bash
# Navigate to project database folder
cd /path/to/bookstore/database/

# Import schema
mysql -u root -p bookstore_db < bookstore_complete_schema.sql
```

### 4. Verify Database Setup
```sql
-- Connect to database
USE bookstore_db;

-- Check tables
SHOW TABLES;

-- Verify sample data
SELECT * FROM books LIMIT 5;
SELECT * FROM users LIMIT 5;
SELECT * FROM orders LIMIT 5;
```

---

## Project Deployment

### 1. Copy Project Files
```bash
# Copy the entire bookstore folder to Tomcat webapps directory
cp -r /path/to/bookstore/ /path/to/tomcat/webapps/

# Windows example:
# Copy bookstore folder to C:\apache-tomcat-9.0.104\webapps\
```

### 2. Configure Database Connection
Edit `WEB-INF/classes/com/bookstore/util/DatabaseConnection.java`:
```java
private static final String URL = "jdbc:mysql://localhost:3306/bookstore_db";
private static final String USERNAME = "root"; // or your MySQL username
private static final String PASSWORD = "";     // your MySQL password
```

### 3. Compile Java Classes
```bash
# Navigate to bookstore directory
cd /path/to/tomcat/webapps/bookstore/

# Run compilation script
# Windows:
compile-optimized.bat

# Linux/macOS: Create similar script or compile manually
javac -cp "WEB-INF/classes:WEB-INF/lib/*" -d WEB-INF/classes WEB-INF/classes/com/bookstore/*/*.java
```

---

## Server Configuration

### 1. Start Tomcat Server
```bash
# Windows
cd C:\apache-tomcat-9.0.104\bin\
startup.bat

# Linux/macOS
cd /path/to/tomcat/bin/
./startup.sh
```

### 2. Verify Server Status
- Open browser and navigate to: `http://localhost:8080`
- You should see Tomcat welcome page
- Check application: `http://localhost:8080/bookstore`

### 3. Configure Server Settings (Optional)
Edit `conf/server.xml` for custom configurations:
```xml
<!-- Change default port if needed -->
<Connector port="8080" protocol="HTTP/1.1" />

<!-- Increase memory if required -->
<!-- Add to catalina.bat/catalina.sh -->
set JAVA_OPTS=-Xmx1024m -Xms512m
```

---

## Testing the Application

### 1. Access Main Application
- URL: `http://localhost:8080/bookstore`
- Browse books, register new account, login

### 2. Test User Features
- **Registration**: Create new user account
- **Login**: Sign in with credentials
- **Browse Books**: View book catalog with search/filter
- **Shopping Cart**: Add books to cart
- **Checkout**: Complete purchase with UPI payment simulation
- **Order History**: View past orders

### 3. Test Admin Features
- **Admin Login**: Use admin credentials
- **Dashboard**: View statistics and metrics
- **Book Management**: Add, edit, delete books
- **Order Management**: Update order status and payment status
- **User Management**: View registered users

---

## Admin Panel Access

### Default Admin Credentials
```
Username: admin
Password: admin123
```

### Admin Panel URL
`http://localhost:8080/bookstore/admin`

### Admin Features
- **Dashboard**: Overview of orders, books, users
- **Book Management**: CRUD operations on book catalog
- **Order Management**: 
  - Update order status (pending → confirmed → shipped → delivered)
  - Update payment status (pending → paid/failed)
  - Search and filter orders
  - Pagination support
- **User Management**: View registered users

---

## Troubleshooting

### Common Issues and Solutions

#### 1. Port 8080 Already in Use
```bash
# Find process using port 8080
netstat -ano | findstr :8080

# Kill the process or change Tomcat port in server.xml
```

#### 2. Database Connection Failed
- Verify MySQL is running
- Check database credentials in `DatabaseConnection.java`
- Ensure database `bookstore_db` exists
- Verify MySQL JDBC driver is in `WEB-INF/lib/`

#### 3. Compilation Errors
```bash
# Ensure JAVA_HOME is set correctly
echo $JAVA_HOME

# Check classpath includes servlet-api.jar
# Verify all required JAR files are in WEB-INF/lib/
```

#### 4. 404 Error - Application Not Found
- Verify bookstore folder is in `webapps/` directory
- Check Tomcat logs in `logs/catalina.out`
- Ensure web.xml is properly configured

#### 5. Payment Status Not Updating
- Verify MySQL server is running
- Check Tomcat logs for SQL errors
- Ensure admin user has proper session

### Log Files Location
```
Tomcat Logs: /path/to/tomcat/logs/
- catalina.out (main log)
- localhost.YYYY-MM-DD.log (application log)
```

---

## Project Structure

```
bookstore/
├── WEB-INF/
│   ├── classes/
│   │   └── com/bookstore/
│   │       ├── dao/           # Database Access Objects
│   │       ├── model/         # Entity Classes
│   │       ├── servlet/       # Servlet Controllers
│   │       └── util/          # Utility Classes
│   ├── lib/                   # JAR Dependencies
│   │   ├── jstl-1.2.jar
│   │   └── mysql-connector-java-8.0.33.jar
│   └── web.xml               # Web Application Configuration
├── admin/                    # Admin Panel JSP Pages
├── database/                 # Database Schema and Sample Data
├── uploads/                  # File Upload Directory
├── *.jsp                     # Main Application Pages
├── compile-optimized.bat     # Compilation Script
└── PROJECT_SETUP_GUIDE.md    # This Guide
```

---

## Additional Notes

### Security Considerations
- Change default admin credentials in production
- Use environment variables for database passwords
- Enable HTTPS in production environment
- Implement proper input validation and sanitization

### Performance Optimization
- Configure connection pooling for database
- Enable Tomcat compression
- Optimize database queries with indexes
- Implement caching where appropriate

### Backup and Maintenance
- Regular database backups
- Monitor log files for errors
- Keep Java and Tomcat updated
- Regular security patches

---

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review Tomcat and application logs
3. Verify all prerequisites are correctly installed
4. Ensure database is properly configured and accessible

---

**Last Updated**: August 2025
**Version**: 1.0
**Compatible with**: Java 8+, Tomcat 9.0+, MySQL 5.7+
