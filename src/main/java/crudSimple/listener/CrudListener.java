package crudSimple.listener;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * Web application lifecycle listener.
 *
 * @author daniel
 */
public class CrudListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext sc = sce.getServletContext();

        Connection conn = null;
        try {
            conn = getConnection(sc);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(CrudListener.class.getName()).log(Level.SEVERE, null, ex);
            ex.printStackTrace();
        } catch (SQLException ex) {
            ex.printStackTrace();
            Logger.getLogger(CrudListener.class.getName()).log(Level.SEVERE, null, ex);
        }
        //System.out.println("in the listener!!");
        sc.setAttribute("conn", conn);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
//        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    private Connection getConnection(ServletContext sc) throws ClassNotFoundException, SQLException {
        String driver = "org.apache.derby.jdbc.EmbeddedDriver";
        String connectionURL = "jdbc:derby:" + sc.getRealPath("/") + "database/db;create=true";
        Statement stmt;
        Class.forName(driver);
        Connection conn = DriverManager.getConnection(connectionURL);

        DatabaseMetaData dbmd = conn.getMetaData();
        ResultSet rs = dbmd.getTables(null, null, "DEVICE", null);
        if (!rs.next()) {
            StringBuilder createString = new StringBuilder();
            createString.append("CREATE TABLE  DEVICE (");
            createString.append("NAME VARCHAR(32) NOT NULL,");
            createString.append("STATUS VARCHAR(50) NOT NULL,");
            createString.append("MODE VARCHAR(50) NOT NULL,");
            createString.append("TYPE VARCHAR(50) NOT NULL,"); 
            createString.append("TARIFF VARCHAR(50) NOT NULL,");
            createString.append("CUSTOMER VARCHAR(50) NOT NULL");
            createString.append(")");
            stmt = conn.createStatement();
            stmt.executeUpdate(createString.toString());

            PreparedStatement psInsert = conn.prepareStatement("insert into DEVICE values (?,?,?,?,?,?)");

            for (int i = 0; i < 42; i++) {
                psInsert.clearParameters();
                
                String v = i+"";
                if(v.length() == 1){
                    v = "0"+v;
                }
                psInsert.setString(1, (i % 2 == 0 ? "Gmeter" : "Emeter") + "_" + v);
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
