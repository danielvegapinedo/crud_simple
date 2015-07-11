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
        <title>Display Device</title>
        <link rel="stylesheet" type="text/css" href="./css/base.css">
        <link rel="stylesheet" type="text/css" href="./css/formStyle10.css">
        <script src="js/util.js"></script>
        <script>


            function init() {

            }


            window.onload = init;
        </script>
    </head>

    <body>

        <%
            String pg = request.getParameter("pg");
            Connection connection = (Connection) pageContext.getServletContext().getAttribute("conn");
            Statement stmt2 = connection.createStatement();
            ResultSet rs = stmt2.executeQuery("select name,status,mode,type,tariff,customer from device where name='" + request.getParameter("name") + "'");
            rs.next();
        %>


        <div class="form-style-10">

            <h1><%= rs.getString("name")%>
                <span id="pageTitle">Display Device</span>

            </h1>
            <form>
                <div class="section"><span>&#10004;</span>Features 

                    <a id="linkGrid" href="grid_device.jsp?name=<%= rs.getString("name")%>">
                        <img src="images/grid-icon.png"/>
                    </a>

                    <a id="linkUpdate" href="update_device.jsp?name=<%= rs.getString("name")%>">
                        <img src="images/doc-option-edit.png"/>
                    </a>

                    <a id="linkCreate" href="create_device.jsp">
                        <img src="images/doc-option-add.png"/>
                    </a>

                    <a id="linkRemove" href="remove_device.jsp?name=<%= rs.getString("name")%>">
                        <img src="images/doc-option-remove.png"/>
                    </a>

                </div>
                <div class="inner-wrap">
                    <label>Name: <input disabled type="text" name="name" id="name" value='<%= rs.getString("name")%>'/></label>
                    <label>Status: <input disabled type="text" name="status" id="status" value='<%= rs.getString("status")%>'/></label>
                    <label>Mode:  <input disabled type="text" name="mode" id="mode" value='<%= rs.getString("mode")%>'/></label>
                    <label>Type:  <input disabled type="text" name="type" id="type" value='<%= rs.getString("type")%>'/></label>
                    <label>Tariff:  <input disabled type="text" name="tariff" id="tariff" value='<%= rs.getString("tariff")%>'/></label>
                    <label>Customer:  <input disabled type="text" name="customer" id="customer" value='<%= rs.getString("customer")%>'/></label>
                </div>
                <div class="button-section">
                    <input type="submit" style="display:none" name="Sign Up" />

                </div>

            </form>
        </div>
    </body>
</html>
