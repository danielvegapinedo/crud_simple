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
        <title>Update Device</title>
        <link rel="stylesheet" type="text/css" href="./css/base.css">
        <link rel="stylesheet" type="text/css" href="./css/formStyle10.css">
        <script src="js/util.js"></script>
        <script>

            var required = ["name", "status", "mode", "type", "tariff", "customer"];
            function validate() {
                for (var i = 0; i < required.length; i++) {
                    var d = document.getElementById(required[i]).value;
                    if (d.trim().length === 0) {
                        alert("Field '" + required[i] + "' is required.");
                        return false;
                    }

                    if (required[i] === "name" && (d.trim().length < 2 || d.trim().length > 20)) {
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
            String name = request.getParameter("name");
            Connection connection = (Connection) pageContext.getServletContext().getAttribute("conn");
            Statement stmt2 = connection.createStatement();

            if (request.getMethod().equalsIgnoreCase("post")) {
                String status = request.getParameter("status");
                String mode = request.getParameter("mode");
                String type = request.getParameter("type");
                String tariff = request.getParameter("tariff");
                String customer = request.getParameter("customer");

                stmt2.execute("UPDATE device SET status='" + status + "',mode='" + mode + "',type='" + type + "', tariff='" + tariff + "',customer='" + customer + "' WHERE name='" + name + "'");
            }

            ResultSet rs = stmt2.executeQuery("select name,status,mode,type,tariff,customer from device where name='" + name + "'");
            if (!rs.next()) {
                throw new IllegalStateException("Device does not exist!!");
            };

        %>


        <div class="form-style-10">

            <h1><%= rs.getString("name")%>
                <span id="pageTitle">Update Device</span>

            </h1>
            <form id="form_0" method="post">
                <div class="section"><span>&#10004;</span>Features 

                    <a id="linkGrid" href="grid_device.jsp?name=<%= rs.getString("name")%>">
                        <img src="images/grid-icon.png"/>
                    </a>

                    <a id="linkDisplay" href="display_device.jsp?name=<%= rs.getString("name")%>">
                        <img src="images/view.gif"/>
                    </a>

                    <a id="linkCreate" href="create_device.jsp">
                        <img src="images/doc-option-add.png"/>
                    </a>

                    <a id="linkRemove" href="remove_device.jsp?name=<%= rs.getString("name")%>">
                        <img src="images/doc-option-remove.png"/>
                    </a>

                </div>
                <div class="inner-wrap">
                    <label>Name: <input disabled type="text" name="name"  id="name" value='<%= rs.getString("name")%>'/></label>
                    <label>Status: <input type="text" name="status"  id="status" value='<%= rs.getString("status")%>'/></label>
                    <label>Mode:  <input type="text" name="mode" id="mode" value='<%= rs.getString("mode")%>'/></label>
                    <label>Type:  <input type="text" name="type" id="type" value='<%= rs.getString("type")%>'/></label>
                    <label>Tariff:  <input type="text" name="tariff" id="tariff" value='<%= rs.getString("tariff")%>'/></label>
                    <label>Customer:  <input type="text" name="customer" id="customer" value='<%= rs.getString("customer")%>'/></label>
                </div>
                <div class="button-section">
                    <input type="submit" id="submit" name="Sign Up" />

                </div>

            </form>
        </div>
    </body>
</html>
