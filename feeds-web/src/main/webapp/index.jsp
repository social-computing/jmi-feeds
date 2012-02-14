<%@page import="com.socialcomputing.feeds.*"%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:fb="http://ogp.me/ns/fb#" lang="en" xml:lang="en">	
<%String feed = request.getParameter("feed");
if( feed == null) feed = "";
int numpage = 0;
String spage = request.getParameter("page");
if( spage != null) numpage = Integer.parseInt( spage);
java.util.List<Feed> feeds = null;
long feedsCount = 0;
String title = "Just Map It! Feeds";
String description = "Just Map It! Feeds lets you view and navigate your feeds thru an interactive map";
if( feed.length() == 0) {
    FeedManager feedManager = new FeedManager();
    feeds = feedManager.last( numpage*10, 10, "true");
    feedsCount = feedManager.count( "true");
    StringBuilder sbTitle = new StringBuilder( title);
    sbTitle.append(": ");
    StringBuilder sbDescription = new StringBuilder( description);
    sbDescription.append(": ");
    boolean first = true;
    for (Feed f : feeds) {
        java.net.URL u = new java.net.URL( f.getUrl());
        if( first) first = false;
        else {
            sbTitle.append(", ");
            sbDescription.append(", ");
        }
        String host = u.getHost();
        sbDescription.append( host);
        host = host.substring(0, host.lastIndexOf( '.'));
        int p = host.indexOf( '.');
        if( p!= -1)
            host = host.substring(p +1);
        sbTitle.append( host);
    }
    title = sbTitle.toString();
    description = sbDescription.toString();
}%><head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="content-language" content="en" />
<meta name="description" content="<%=description%>" />
<meta name="keywords" content="rss, netvibes, google, blogger, feeds, feed, map, cartography, visualization, social, blog, gadget, widget, social computing, category, representation, information" />
<meta name="author" content="Social Computing" /> 
<meta name="robots" content="all" /> 
<meta property="og:title" content="Just Map It! Feeds" />
<meta property="og:description" content="View and navigate your feeds thru an interactive map! by Social Computing" />
<meta property="og:image" content="http://feeds.just-map-it.com/images/thumbnail.png" />
<link rel="shortcut icon" href="http://feeds.just-map-it.com/favicon.ico" />
<jsp:include page="./head-header.jsp" />
<script type="text/javascript">
<%if( feed.length() > 0) {%>
  function ready() {
	  var map = document.getElementById("wps-feeds");
	  var titles = map.getArrayProperty( "$FEEDS_TITLES");
	  if( titles) {
	  	document.title = titles.join( ', ') + ' | Just Map It! Feeds - ';
		if( map.getProperty( "$analysisProfile") == "GlobalProfile") {
			document.getElementById("message").innerHTML = titles.join( ', ');
		}
	  }
	  var urls = map.getArrayProperty( "$FEEDS_URLS");
	  if( urls && urls.length == 1) {
		var data = {};
		data["url"] = urls[0];
		$.getJSON( "./rest/feeds/feed.json", data, function( feed){
			var date = new Date();
			if( !feed.thumbnail_date)
				feed.thumbnail_date = 0;
			var delta = date.getTime() - feed.thumbnail_date;
			if( delta > 7 * 24 * 3600 * 1000) {
				map.uploadAsImage( 'http://feeds.just-map-it.com/rest/feeds/feed/thumbnail.png', 'preview', 'image/png', 150, 100, true, data);
			}
		});
	  }
}
  function empty() {
	document.getElementById("message").innerHTML = "Sorry, the map is empty. Does the feed contains categories?";
  }
  function error( error) {
	document.getElementById("message").innerHTML = "Sorry, an error occured. Is this URL correct? <span class='hidden-message'>" + error + "</span>";
  }
  function JMIF_Navigate( url) {
 	 window.open( url, "_blank");
  }
  function JMIF_Focus( args)
  {
	var parameters = {};
	JMIF_CompleteParameters( parameters);
	parameters.entityId = args[0];
	parameters.feed = args[2];
	parameters.track = "";
	document.getElementById("wps-feeds").compute( parameters);
	document.getElementById("message").innerHTML = "<i>Focus on category:</i> " + args[1];
  }
  function JMIF_Center( args)
  {
	var parameters = {};
	JMIF_CompleteParameters( parameters);
	parameters.attributeId = args[0];
	parameters.feed = args[2];
	parameters.analysisProfile = "DiscoveryProfile";
	parameters.track = "";
	document.getElementById("wps-feeds").compute( parameters);
	document.getElementById("message").innerHTML = "<i>Centered on item:</i> " + args[1];
  }
function JMIF_CompleteParameters( parameters) {
	 parameters.allowDomain = "*";
	 //parameters.wpsserverurl = "http://localhost:8080/jmi-server";
     //parameters.feedsserverurl = "http://localhost:8080/feeds-web";
	 parameters.wpsserverurl = "http://server.just-map-it.com";
     parameters.feedsserverurl = "http://feeds.just-map-it.com";
	 parameters.wpsplanname = "Feeds";
	 parameters.site = "";
	 parameters.jsessionid = '<%=session.getId()%>';
} 
</script>
<!-- Enable Browser History by replacing useBrowserHistory tokens with two hyphens -->
<!-- BEGIN Browser History required section -->
<link rel="stylesheet" type="text/css" href="./client/history/history.css" />
<script type="text/javascript" src="./client/history/history.js"></script>
<!-- END Browser History required section -->  

<script type="text/javascript" src="./client/swfobject.js"></script>
<script type="text/javascript">
    var swfVersionStr = "10.0.0";
    var xiSwfUrlStr = "./client/playerProductInstall.swf";
    var flashvars = {};
	JMIF_CompleteParameters( flashvars);
    flashvars.analysisProfile = "GlobalProfile";
    flashvars.feed = "<%=java.net.URLEncoder.encode(feed, "UTF-8")%>";
    flashvars.track = "feed";
    var params = {};
    params.quality = "high";
    params.bgcolor = "#FFFFFF";
    params.allowscriptaccess = "always";
    params.allowfullscreen = "true";
    params.wmode = "transparent";
    var attributes = {};
    attributes.id = "wps-feeds";
    attributes.name = "wps-feeds";
    attributes.align = "middle";
    swfobject.embedSWF(
        "./client/jmi-flex-1.0-SNAPSHOT.swf", "flashContent", 
        "100%", "100%", 
        swfVersionStr, xiSwfUrlStr, 
        flashvars, params, attributes);
swfobject.createCSS("#flashContent", "display:block;text-align:left;");
<%}%>
</script>
<jsp:include page="./js/ga.js" /> 
</head>
<body>
<div id="fb-root"></div>
<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) {return;}
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/fr_FR/all.js#xfbml=1&appId=205005596217672";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>
<jsp:include page="./header.jsp" >
	<jsp:param name="feed" value="<%=feed%>" /> 
</jsp:include>

<!-- CONTENT -->
<div id="container" class="container_12">
<div id="topContent">
	<div id="formURL" class="grid_12">
		<p>Enter one or more URLs (comma separated)</p>
		<form method="get">
			<input type="text" class="champ" name="feed" title="URLs" value='<%=feed%>' />
			<input type="submit" value="Just Map It!" />
		</form>
		<p id="message"></p>
	</div>
</div>
<%if (feed.length() == 0) {%>
<div id="titreTopContent" class="grid_4"><h1>Last mapped feeds</h1></div>
<div id="miniMap" class="grid_12">
<%for (Feed f : feeds) {%><div class="vignette">
<div class="thumbnail">
<a title="Just Map It! Feed: <%=f.getUrl()%>" href='./?feed=<%=java.net.URLEncoder.encode(f.getUrl(),"UTF-8")%>'><img border="0" width="150" height="100" alt="<%=f.getTitle().replaceAll("\"","&quot;")%>" src="./rest/feeds/feed/thumbnail.png?url=<%=java.net.URLEncoder.encode(f.getUrl(),"UTF-8")%>" /></a>
<!--span class="play"/-->
</div><div class="thumbnail-title">
<h2><a href='./?feed=<%=java.net.URLEncoder.encode(f.getUrl(),"UTF-8")%>' title="<%=f.getTitle().replaceAll("\"","&quot;")%>"><%=f.getTitle().length()>60 ? f.getTitle().substring(0, 57).concat("...") : f.getTitle()%></a></h2>
</div></div><%}%></div>
<div class="clear"></div>
<div class="pagination"><ul>
<%long maxPages = Math.min((feedsCount / 10) + 1, 20);
for( long i = 0; i < maxPages; ++i) { %>
<li <%=(numpage==i? "class='active'": "")%>><a href=".<%=(i==0? "" : "/?page=" + i)%>"><%=i+1%></a></li>
<%} for( long i = maxPages; i < 20; ++i) { %>
<li class='disabled'><a ><%=i+1%></a></li>
<%}%></ul></div>
<div class="slogan" class="grid_12">
<div id="sep"></div>
<h2>Adding Just Map It! Feeds to your webpage is easy and free: <a title="Add Just Map It! Feeds to your webpage" href="./integrate.jsp">do it in 3 steps</a></h2>
You can also add Just Map It! Feeds to: <h3><a href="http://www.google.com/ig/adde?moduleurl=feeds.just-map-it.com/google/igoogle-social-computing-feeds.xml" title="Add Just Map It! Feeds to iGoogle" target="_blank">iGoogle</a></h3><h3><a href="http://eco.netvibes.com/widgets/470252/just-map-it-feeds" title="Add Just Map It! Feeds to Netvibes" target="_blank">Netvibes</a></h3><h3><a id="howtoblogger" href="./documentation.jsp" title="Add Just Map It! Feeds to Blogger" target="_blank">Blogger</a></h3>
</div>
<%} else {%>
<div id="flashContent">
    <p>
     	To view this page ensure that Adobe Flash Player version 10.0.0 or greater is installed. 
	</p>
	<script type="text/javascript"> 
	var pageHost = ((document.location.protocol == "https:") ? "https://" :	"http://"); 
	document.write("<a href='http://www.adobe.com/go/getflashplayer'><img src='" 
					+ pageHost + "www.adobe.com/images/shared/download_buttons/get_flash_player.gif' alt='Get Adobe Flash player' /></a>" ); 
	</script> 
 </div>
 <noscript>
     	<br/><br/><br/><p> 
     		Either scripts and active content are not permitted to run or Adobe Flash Player version 10.0.0 or greater is not installed.
     	</p>
        <a href="http://www.adobe.com/go/getflashplayer">
            <img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash Player" />
        </a>
</noscript>		
<%}%>
</div>
<jsp:include page="./footer.jsp" >
	<jsp:param name="feed" value="<%=feed%>" /> 
</jsp:include>
</body>
</html>
