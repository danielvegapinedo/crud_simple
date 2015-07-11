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
        <title>Create Device</title>
        <link rel="stylesheet" type="text/css" href="./css/base.css">
        <link rel="stylesheet" type="text/css" href="./css/formStyle10.css">
        <script src="js/util.js"></script>
        <script>
            var required = ["name", "status", "mode", "type", "tariff", "customer"];
            var MIN = 2, MAX = 20;
            
            function validate() {
                for (var i = 0; i < required.length; i++) {
                    var d = document.getElementById(required[i]).value;
                    if (d.trim().length === 0) {
                        alert("Field '" + required[i] + "' is required.");
                        return false;
                    }
                     document.getElementById(required[i]).value = d.trim();

                    if (required[i] === "name" && (d.trim().length < MIN || d.trim().length > MAX)) {
                        alert("Field '" + required[i] + "' is must have between 2 and 20 characters.");
                        return false;
                    }
                }
                return true;
            }

            function init() {
                document.getElementById("form_0").onsubmit = validate;

            }


            window.onload = init;
        </script>
    </head>

    <body>




        <%
            if (request.getMethod().equalsIgnoreCase("post")) {

                Connection connection = (Connection) pageContext.getServletContext().getAttribute("conn");
                Statement stmt2 = connection.createStatement();

                String name = request.getParameter("name");

                ResultSet rs = stmt2.executeQuery("select count(*)as total from device where name='" + request.getParameter("name") + "'");
                rs.next();
                if (rs.getInt("total") > 0) {
                    throw new IllegalStateException("Device already exists.");
                };

                String status = request.getParameter("status");
                String mode = request.getParameter("mode");
                String type = request.getParameter("type");
                String tariff = request.getParameter("tariff");
                String customer = request.getParameter("customer");

                stmt2.execute("INSERT INTO device (name, status, mode, type, tariff, customer) VALUES ('" + name + "','" + status + "','" + mode + "','" + type + "','" + tariff + "','" + customer + "')");
        %>
        Creating...
        <script>
            window.location = "update_device.jsp?name=<%= name%>";
        </script>
        <%
        } else {

        %>
        <div class="form-style-10">

            <h1>Create Device
                <span id="pageTitle">Create Device</span>

            </h1>
            <form id="form_0" method="post">
                <div class="section"><span>&#10004;</span>Features 

                    <a id="linkGrid" href="grid_device.jsp">
                        <img src="images/grid-icon.png"/>
                    </a>


                </div>

                <div class="inner-wrap">
                    <label>Name: <input type="text" name="name" id="name" value=''/></label>
                    <label>Status: <input type="text" name="status" id="status" value=''/></label>
                    <label>Mode:  <input type="text" name="mode" id="mode" value=''/></label>
                    <label>Type:  <input type="text" name="type" id="type" value=''/></label>
                    <label>Tariff:  <input type="text" name="tariff" id="tariff" value=''/></label>
                    <label>Customer:  <input type="text" name="customer" id="customer" value=''/></label>
                </div>
                <div class="button-section">

                    <input id="submit" type="submit" name="Create" value="Create"/>
                </div>
            </form>
        </div>


        <%            }

        %>






    </body>
</html>
