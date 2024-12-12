import java.sql.Connection;
import java.sql.DriverManager;

import java.sql.SQLException;

public class DBHelper {
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/train_reservation_system";
            String username = "root";
            String password = "mysql_root_password"; // Change root Password for your DB
            System.out.println("Attempting database connection...");
            Connection conn = DriverManager.getConnection(url, username, password);
            System.out.println("Database connection successful!");
            return conn; 
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL Driver not found: " + e.getMessage());
            e.printStackTrace();
            throw new SQLException("MySQL Driver not found", e);
        } catch (SQLException e) {
            System.err.println("Database connection error: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
            throw e;
        }
    }
}

