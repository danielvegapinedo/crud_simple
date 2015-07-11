<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DatabaseMetaData"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page contentType="text/html; charset=utf-8" language="java" import="javax.xml.parsers.DocumentBuilderFactory,javax.xml.parsers.DocumentBuilder,org.w3c.dom.*" errorPage="" %>
<%

    String search = request.getParameter("search");
    String pg = request.getParameter("pg");

    boolean useSearch = search != null && search.trim().length() > 0;
    if (!useSearch) {
        search = "";
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Device grid</title>
        <link rel="stylesheet" type="text/css" href="./css/base.css">
        <link rel="stylesheet" type="text/css" href="./css/grid.css">
        <link rel="stylesheet" type="text/css" href="./css/formStyle10.css">
        <script src="js/util.js"></script>
        <script>
            var usernameHello, add, btnSearch, btnCleanSearch;

            function init() {
                btnSearch = document.getElementById("btnSearch");
                btnCleanSearch = document.getElementById("btnCleanSearch");
                usernameHello = document.getElementById("usernameHello");
                add = document.getElementById("linkCreate");
                usernameHello.innerHTML = "Hello " + (getCookie("email") ? getCookie("email") : "???") + "! - ";
                add.onclick = goCreate;
                add.style.cursor = "pointer";
                btnSearch.onclick = goGridWithSearch;
                btnCleanSearch.onclick = goGridWithoutSearch;
            }

            function goGridWithSearch() {
                var toSearchValue = document.getElementById("inputSearch").value;
                if (toSearchValue.trim().length > 0) {
                    go("grid_device.jsp?search=" + toSearchValue);
                }

            }

            function goGridWithoutSearch() {
                go("grid_device.jsp");
            }

            function goCreate() {
                go("create_device.jsp");
            }
            function go(target) {
                window.location = target;
            }

            function viewDevice(name) {

                go("display_device.jsp?name=" + name);
            }
            function updateDevice(name) {
                //alert(evet);
                go("update_device.jsp?name=" + name);
            }
            function removeDevice(name) {
                //alert(evet);
                go("remove_device.jsp?name=" + name);
            }

            window.onload = init;
        </script>
    </head>

    <body>


        <div class="divHeader">
            <div class="menu01"><a href="logout.html">Log out</a> <span id="usernameHello">  </span></div>
            <div class="title" id="pageTitle">Device grid</div>

        </div>

        <div class="pgrille">
            <div><img src="images/doc-option-add.png" id='linkCreate'/></div>
            <table class="bordered" id="tableGrid">
                <thead>

                    <tr><th colspan="9">
                <div><input type="text" value="<%= search%>" id="inputSearch"/>
                    <button id="btnSearch">Search</button>
                    <button id="btnCleanSearch">Clean</button>
                </div></th></tr>
                <tr>
                    <th>Name</th> 
                    <th>State</th>
                    <th>Mode</th>
                    <th>Type</th>
                    <th>Tariff</th>
                    <th>Customer</th>
                    <th>View</th>
                    <th>Edit</th>
                    <th>Remove</th>
                </tr>
                </thead>
                <tbody>
                    <%
                        ResultSet rs;

                        Connection connection = (Connection) pageContext.getServletContext().getAttribute("conn");
                        Statement stmt2 = connection.createStatement();
                        if (useSearch) {
                            search = search.trim();
                            rs = stmt2.executeQuery("SELECT COUNT(*) as total FROM DEVICE where name like '%" + search + "%'");
                        } else {
                            rs = stmt2.executeQuery("SELECT COUNT(*) as total FROM DEVICE");
                        }

                        rs.next();

                        int totalItem = rs.getInt("total"), i, deviceByPage = 10, count = 1, pgInt, totlaPage = totalItem / deviceByPage;

                        if (totalItem % deviceByPage != 0) {
                            totlaPage++;
                        }

                        if (pg == null || pg.equals("1")) {
                            i = 0;
                            pgInt = 1;
                        } else {
                            try {
                                pgInt = Integer.parseInt(pg);
                                i = deviceByPage * (pgInt - 1);
                                if ((i + 1) > totalItem) {
                                    i = 0;
                                    pgInt = 1;
                                }
                            } catch (java.lang.NumberFormatException e) {
                                i = 0;
                                pgInt = 1;
                            }

                            if (pgInt > totlaPage) {
                                i = 0;
                                pgInt = 1;
                            }
                        }
                        int offSet = pgInt <= 1 ? pgInt : (pgInt * deviceByPage - deviceByPage + 1);
                        offSet--;
                        // rs = stmt2.executeQuery("select name,status,mode,type,tariff,customer  from device ORDER BY name asc ");
                        if (useSearch) {
                            rs = stmt2.executeQuery("select name,status,mode,type,tariff,customer from device  where name like '%" + search + "%' ORDER BY name asc OFFSET " + offSet + " ROWS FETCH NEXT "  + deviceByPage + " ROWS ONLY");
                        } else {
                            rs = stmt2.executeQuery("select name,status,mode,type,tariff,customer from device ORDER BY name asc OFFSET " + offSet + " ROWS FETCH NEXT " + deviceByPage + " ROWS ONLY");
                        }
                        int num = 0;

                        while (rs.next()) {
                    %>
                    <tr>
                        <td> <a href="javascript:void(0)" onclick="viewDevice('<%= rs.getString("name")%>')"><%= rs.getString("name")%></a></td>
                        <td> <%= rs.getString("status")%></td>
                        <td> <%= rs.getString("mode")%></td>
                        <td> <%= rs.getString("type")%></td>
                        <td> <%= rs.getString("tariff")%></td>
                        <td> <%= rs.getString("customer")%></td>
                        <td><img id="linkDisplay<%= rs.getString("name")%>" src="images/view.gif" onclick="viewDevice('<%= rs.getString("name")%>')"/></td>
                        <td><img id="linkUpdate<%= rs.getString("name")%>" src="images/doc-option-edit.png" onclick="updateDevice('<%= rs.getString("name")%>')"/></td>

                        <td><img class="imgDelete" id="linkRemove<%= rs.getString("name")%>" src="images/doc-option-remove.png" onclick="removeDevice('<%= rs.getString("name")%>')"/></td>
                    </tr>
                    <% }
                        rs.close();
                    %>
                </tbody>
                <tfoot>
                    <tr>
                        <th colspan="8">Page <span id="currentPage"><%= pgInt%></span> of <span id="totalPage"><%= totlaPage%></span> - <span id="totalItems">Total of devices: <%= totalItem%></span></th><th>

                            <%
                                String prev = "";
                                String next = "";
                                String txtSearch = useSearch ? "&search=" + search : "";
                                if (pgInt < totlaPage) {
                                    next = "<a id='paginationNext' href='grid_device.jsp?pg=" + (pgInt + 1) + txtSearch + "'><img src='images/arrow-small-right-green.png' alt='Next page'/></a>";
                                }

                                if (pgInt > 1) {
                                    prev = "<a id='paginationPrev' href='grid_device.jsp?pg=" + (pgInt - 1) + txtSearch + "'><img src='images/arrow-small-left-green.png' alt='Prev page'/></a>";
                                }
                            %>
                            <%=prev%> &nbsp; <%=next%>
                        </th>
                    </tr>
                </tfoot>
            </table>

        </div>
    </body>
</html>
