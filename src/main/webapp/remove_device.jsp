<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DatabaseMetaData"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page contentType="text/html; charset=utf-8" language="java" import="javax.xml.parsers.DocumentBuilderFactory,javax.xml.parsers.DocumentBuilder,org.w3c.dom.*" errorPage="" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="refresh" content="3; url=grid_device.jsp">
        <title>Remove device</title>


    <body>
        <h1>Create Device
            <span id="pageTitle">Remove Device</span>

        </h1>
        <%
            String pg = request.getParameter("pg");
            Connection connection = (Connection) pageContext.getServletContext().getAttribute("conn");
            Statement stmt2 = connection.createStatement();
            ResultSet rs = stmt2.executeQuery("select name,status,mode,type,tariff,customer from device where name='" + request.getParameter("name") + "'");
            if (!rs.next()) {
        %>
        Nothing to remove!
        <%
        } else {
            stmt2.execute("delete from device where name ='" + request.getParameter("name") + "'");
        %>
        Removing...
        <%
            }


        %>

    </body>
</html>
