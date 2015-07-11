package crudSimple.listener;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;

/**
 *
 * @author daniel
 */
public class createDatabase {

    public void contextInitialized(ServletContextEvent event) throws ClassNotFoundException, SQLException {

        ServletContext sc = event.getServletContext();

        Connection db;
        db = getDatabase(sc);
        //System.out.println("in the listener!!");
        sc.setAttribute("db", db);

    }

    private Connection getDatabase(ServletContext sc) throws ClassNotFoundException, SQLException {
        String driver = "org.apache.derby.jdbc.EmbeddedDriver";
        String connectionURL = "jdbc:derby:" + sc.getRealPath("/") + "database/db;create=true";
        Statement stmt;
        Class.forName(driver);
        Connection conn = DriverManager.getConnection(connectionURL);

        DatabaseMetaData dbmd = conn.getMetaData();
        ResultSet rs = dbmd.getTables(null, null, "DEVICE", null);
        if (!rs.next()) {
            String createString = "CREATE TABLE  DEVICE (NAME VARCHAR(150) NOT NULL, STATUS VARCHAR(150) NOT NULL, MODE VARCHAR(150) NOT NULL, TYPE VARCHAR(150) NOT NULL, tariff VARCHAR(150) NOT NULL, CUSTOMER VARCHAR(150) NOT NULL)";
            stmt = conn.createStatement();
            stmt.executeUpdate(createString);

            PreparedStatement psInsert = conn.prepareStatement("insert into DEVICE values (?,?,?,?,?,?)");

            for (int i = 0; i < 41; i++) {
                psInsert.clearParameters();
                psInsert.setString(1, (i % 2 == 0 ? "Gmeter" : "Emeter") + (i + 1));
                psInsert.setString(2, "active");
                psInsert.setString(3, "prepay");
                psInsert.setString(4, "gas");
                psInsert.setString(5, "tr1");
                psInsert.setString(6, "customer");
                psInsert.executeUpdate();
            }
        }
return conn;
    }
}
