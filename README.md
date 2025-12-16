# Online Bookstore E-Commerce Web Application

A comprehensive online bookstore e-commerce web application built with Java, JSP, and MySQL. This application provides a complete book shopping experience with user authentication, shopping cart, order management, payment processing, and admin panel.

## Features

### User Features
- **User Registration & Login**: Secure user authentication with password hashing
- **Book Browsing**: Browse books by category, search functionality
- **Book Details**: Detailed book information with images, descriptions, and pricing
- **Order Management**: Place orders, view order history, track order status
- **UPI Payment**: Simulated UPI payment gateway integration
- **Session Management**: Secure session handling and user state management

### Admin Features
- **Admin Dashboard**: Overview of books, orders, users, and statistics
- **Book Management**: Add, edit, delete books with image upload
- **Inventory Management**: Stock tracking, pricing, and discount management
- **Order Management**: View and update order status, payment tracking
- **User Management**: View registered users and their activity
- **File Upload**: Book cover image upload functionality

## Technology Stack

- **Backend**: Java Servlets, JSP (JavaServer Pages)
- **Database**: MySQL (via XAMPP)
- **Server**: Apache Tomcat 9.0.104
- **Frontend**: HTML5, CSS3, Bootstrap 5.1.3, JavaScript
- **Icons**: Font Awesome 6.0.0
- **Architecture**: MVC (Model-View-Controller) pattern

## Project Structure

```
bookstore/
├── WEB-INF/
│   ├── web.xml                     # Web application configuration
│   ├── classes/
│   │   └── com/bookstore/
│   │       ├── model/              # Data models (User, Book, Order, etc.)
│   │       ├── dao/                # Data Access Objects
│   │       ├── servlet/            # Servlet controllers
│   │       └── util/               # Utility classes
│   └── lib/                        # Required JAR files
├── admin/                          # Admin panel JSP pages
├── database/                       # Database schema and setup
├── uploads/                        # Uploaded images directory
├── *.jsp                          # User-facing JSP pages
└── README.md                      # This file
```

## Database Schema

The application uses the following main tables:
- `users` - User accounts and authentication
- `books` - Book inventory and details
- `cart` - Shopping cart items
- `orders` - Customer orders
- `order_items` - Individual items in orders

## Setup Instructions

### Prerequisites
1. **XAMPP** - For MySQL database server
2. **Apache Tomcat 9.0.104** - Web server
3. **Java 8+** - Runtime environment
4. **Web Browser** - For accessing the application

### Installation Steps

1. **Database Setup**
   ```sql
   -- Start XAMPP and open phpMyAdmin
   -- Import the database schema from: database/bookstore_schema.sql
   -- This will create the database and sample data
   ```

2. **Required Libraries**
   Download and place these JAR files in `WEB-INF/lib/`:
   - `mysql-connector-java-8.0.33.jar`
   - `jstl-1.2.jar`
   - `standard-1.1.2.jar`

3. **Tomcat Configuration**
   - Ensure the bookstore folder is in `webapps/` directory
   - Start Tomcat server
   - Access the application at: `http://localhost:8080/bookstore/`

4. **Database Connection**
   - Default connection: `localhost:3306/bookstore_db`
   - Username: `root`
   - Password: (empty)
   - Modify `DatabaseConnection.java` if needed

## Default Accounts

### Admin Account
- **Username**: `admin`
- **Password**: `admin123`
- **Access**: Full admin panel access

### Test User
- **Username**: `testuser`
- **Password**: `test123`
- **Access**: User Panel Access

## Application URLs

### User Pages
- **Home**: `/bookstore/`
- **Books**: `/bookstore/books`
- **Login**: `/bookstore/login`
- **Register**: `/bookstore/register`
- **Cart**: `/bookstore/cart`
- **Orders**: `/bookstore/order`
- **Checkout**: `/bookstore/order?action=checkout`
- **Payment**: `/bookstore/payment`

### Admin Pages
- **Dashboard**: `/bookstore/admin`
- **Manage Books**: `/bookstore/admin?action=books`
- **Add Book**: `/bookstore/admin?action=addBook`
- **Manage Orders**: `/bookstore/admin?action=orders`
- **Manage Users**: `/bookstore/admin?action=users`

## Key Features Implementation

### Security
- Password hashing using SHA-256
- Session-based authentication
- Admin role-based access control
- SQL injection prevention with PreparedStatements

### Shopping Cart
- Persistent cart storage in database
- Real-time quantity updates
- Stock validation
- Price calculations with discounts

### Payment System
- Simulated UPI payment gateway
- Transaction ID generation
- Payment status tracking
- Order confirmation workflow

### File Upload
- Book cover image upload
- File size and type validation
- Unique filename generation
- Secure file storage

## API Endpoints

### Servlets
- `/login` - User authentication
- `/register` - User registration
- `/logout` - Session termination
- `/books` - Book browsing and search
- `/cart` - Shopping cart operations
- `/order` - Order management
- `/payment` - Payment processing
- `/admin` - Admin panel operations
- `/upload` - File upload handling

## Database Configuration

### Connection Settings
```java
// DatabaseConnection.java
private static final String URL = "jdbc:mysql://localhost:3306/bookstore_db";
private static final String USERNAME = "root";
private static final String PASSWORD = "";
```

### Sample Data
The database includes:
- 10 sample books with different categories
- 1 admin user account
- Various book categories (Fiction, Science Fiction, Fantasy, etc.)

## Troubleshooting

### Common Issues

1. **Database Connection Error**
   - Ensure XAMPP MySQL is running
   - Check database credentials in `DatabaseConnection.java`
   - Verify `mysql-connector-java.jar` is in `WEB-INF/lib/`

2. **JSP Compilation Error**
   - Ensure `jstl-1.2.jar` and `standard-1.1.2.jar` are in `WEB-INF/lib/`
   - Restart Tomcat server

3. **File Upload Not Working**
   - Check write permissions on `uploads/` directory
   - Verify admin login before uploading

4. **Session Issues**
   - Clear browser cookies
   - Restart Tomcat server
   - Check session timeout in `web.xml`

## Development Notes

### Code Organization
- **Models**: Plain Java objects representing data entities
- **DAOs**: Database access layer with CRUD operations
- **Servlets**: Request handling and business logic
- **JSPs**: Presentation layer with dynamic content

### Design Patterns Used
- **MVC Pattern**: Separation of concerns
- **DAO Pattern**: Data access abstraction
- **Singleton Pattern**: Database connection management
- **Factory Pattern**: Object creation

## Future Enhancements

- Real payment gateway integration
- Email notifications
- Advanced search and filtering
- Book reviews and ratings
- Wishlist functionality
- Order tracking with shipping
- Inventory alerts
- Sales analytics
- Mobile responsive improvements

## License

This project is created for educational purposes. Feel free to use and modify as needed.

## Support

For issues or questions:
1. Check the troubleshooting section
2. Verify all setup steps are completed
3. Ensure all required JAR files are present
4. Check Tomcat and MySQL server status

---

**Note**: This is a demonstration application with simulated payment processing. Do not use in production without proper security enhancements and real payment gateway integration.

---

**Owner**: Vindicator (Rich David)
