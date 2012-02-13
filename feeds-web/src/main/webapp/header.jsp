<!-- HEADER -->
<div id="header">
	<div id="fondHeader">
        <div id="contentHeader" class="container_12">
            <div class="grid_5">
            	<div id="logo"><a href="./" title="Just Map It! Feeds"><img src="images/logo.png" alt="logo Just Map It Feeds" /></a></div>
            	<h1>Just Map it! Feeds</h1>
                <p>Just Map It! Feeds lets you view and navigate your feeds thru an interactive map!</p>
            </div>
            <div id="menuHeader" class="grid_6">
                <ul>
<%String feed = request.getParameter("feed");
if( feed == null) feed = "";
if( feed.length() > 0) { %>
<li><a title="Add it to your webpage" href="./integrate.jsp?feed=<%=java.net.URLEncoder.encode(feed, "UTF-8")%>">Add it to your webpage</a></li>
<%} else { %>
<li><a title="Add it to your webpage" href="./integrate.jsp">Add it to your webpage</a></li>
<%}%>
                    <li><a id="howtouse" title="How to use it" href="./documentation.jsp">How to use it</a></li>
                    <li><a title="About us" href="http://www.social-computing.com/" target="_blank">About us</a></li>
                    <li><a title="Contact us" href="http://www.social-computing.com/contact/" target="_blank">Contact us</a></li>
                </ul>
            </div>
        </div>
	</div>
</div>
