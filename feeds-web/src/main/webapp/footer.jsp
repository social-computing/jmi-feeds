<!-- FOOTER -->
<div id="footer">
	<div id="contentFooter" class="container_12">
    	<div id="menuFooter" class="grid_7">
        	<ul>
<%String feed = request.getParameter("feed");
if( feed == null) feed = "";
if( feed.length() > 0) { %>
<li><a title="Add it to your webpage" href="./integrate.jsp?feed=<%=java.net.URLEncoder.encode(feed, "UTF-8")%>">Add it to your webpage</a></li>
<%} else { %>
<li><a title="Add it to your webpage" href="./integrate.jsp">Add it to your webpage</a></li>
<%}%>
                <li><a id="howtouse2" title="How to use it" href="./documentation.jsp">How to use it</a></li>
                <li><a title="About us" href="http://www.social-computing.com/" target="_blank">About us</a></li>
                <li><a title="Contact us" href="http://www.social-computing.com/contact/" target="_blank">Contact us</a></li>
            </ul>
            
            <ul id="copy">
            	<li>&copy; 2011 - 2012 <a title="Social Computing" href="http://www.social-computing.com" target="_blank">Social Computing</a> | </li>
                <li><a title="Terms of use" href="./termsofuse.jsp">Terms of use</a> | </li>
                <li>Powered by <a title="Just Map It!" href="http://www.just-map-it.com" target="_blank">Just Map It!</a></li>
            </ul>
            
        </div>
        
        <div id="zoneReseaux" class="grid_5">
        	<p>Like JMI Feeds? Share it!</p>
            <!--div id="barreReseaux"></div-->
			<div class="network">
<table border="1"><tr>
<td class="social"><g:plusone size="medium" href="http://feeds.just-map-it.com/"></g:plusone></td>
<td class="social"><fb:like href="http://feeds.just-map-it.com<%=(request.getQueryString() != null? "?"+request.getQueryString() : "")%>" send="true" layout="button_count" width="450" show_faces="false" font="arial"></fb:like></td>
</tr><tr>
<td class="social"><a href="https://twitter.com/share" class="twitter-share-button" data-url="http://feeds.just-map-it.com<%=(request.getQueryString() != null? "?"+request.getQueryString() : "")%>" data-lang="en">Tweet</a><script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script></td>
<td class="social"><script src="http://platform.linkedin.com/in.js" type="text/javascript"></script><script type="IN/Share" data-counter="right"></script></td>
</tr></table>
			</div>
        </div>
    </div>
</div>
<script type="text/javascript" src="https://apis.google.com/js/plusone.js"></script>

