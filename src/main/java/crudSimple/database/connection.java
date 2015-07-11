package crudSimple.database;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class connection {

    static Connection conn;

    public static void main(String[] args) throws Exception {

        // connect method #1 - embedded driver
        String driver = "org.apache.derby.jdbc.EmbeddedDriver";

        String connectionURL = "jdbc:derby:database/db";
        String createString = "CREATE TABLE  DEVICE (NAME VARCHAR(32) NOT NULL, STATUS VARCHAR(50) NOT NULL, MODE VARCHAR(50) NOT NULL, TYPE VARCHAR(50) NOT NULL, tariff VARCHAR(50) NOT NULL, CUSTOMER VARCHAR(50) NOT NULL)";
        Class.forName(driver);

        conn = DriverManager.getConnection(connectionURL);

        DatabaseMetaData dbmd = conn.getMetaData();
        ResultSet rs = dbmd.getTables(null, null, "DEVICE", null);
        if (rs.next()) {
            return;
        }

        Statement stmt = conn.createStatement();
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

        Statement stmt2 = conn.createStatement();
        rs = stmt2.executeQuery("select * from DEVICE");
        System.out.println("Addressed present in your Address Book\n\n");
        int num = 0;

        while (rs.next()) {
            System.out.println(++num + "," + rs.getString(1) + "," + rs.getString(2) + "," + rs.getString(3) + "," + rs.getString(4) + "," + rs.getString(5) + "," + rs.getString(6) + ","
                    + rs.getString(2));
        }
        rs.close();
    }
}
