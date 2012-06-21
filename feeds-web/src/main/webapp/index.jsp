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
String description = "Just Map It! Feeds lets you view and navigate your feeds thru an interactive HTML5 map";
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
<meta name="keywords" content="HTML5, canvas, javascript, rss, netvibes, google, blogger, feeds, feed, map, cartography, visualization, social, blog, gadget, widget, social computing, category, representation, information" />
<meta name="author" content="Social Computing" /> 
<meta name="robots" content="all" /> 
<meta name="viewport" content="target- densitydpi=device-dpi, width=device-width, user-scalable=no"/>
<meta property="og:title" content="Just Map It! Feeds" />
<meta property="og:description" content="View and navigate your feeds thru an interactive map! by Social Computing" />
<meta property="og:image" content="http://feeds.just-map-it.com/images/thumbnail.png" />
<link rel="shortcut icon" href="http://feeds.just-map-it.com/favicon.ico" />
<jsp:include page="./head-header.jsp" />
<link rel="stylesheet" type="text/css" href="./jmi-client/css/jmi-client.css" />
<script type="text/javascript" src="./jmi-client/jmi-client.js"></script>
<script type="text/javascript">
var breadcrumbTitles = { shortTitle: '', longTitle: '' };
function JMIF_breadcrumbTitlesFunc(event) {
	if( event.type === JMI.Map.event.EMPTY) {
		return {shortTitle: 'Sorry, the map is empty. Does the feed contains categories?', longTitle: 'Sorry, the map is empty. Does the feed contains categories?'};
	}
	if( event.type === JMI.Map.event.ERROR) {
		if(event.track) {
			return {shortTitle: 'Sorry, an error occured. Is this URL correct? <br/>If this URL is a good one and you want to know more about that error, please <a title="Fill the form" href="http://www.just-map-it.com/p/report.html?track='+ event.track +'" target="_blank">fill this form</a>', longTitle: 'Sorry, an error occured. Error: ' + event.message};
		}
		else {
			return {shortTitle: 'Sorry, an error occured. ' + event.message, longTitle: 'Sorry, an error occured. ' + event.message};
		}
	}
	return breadcrumbTitles;
}
function JMIF_CompleteParameters( parameters) {
     //parameters.feedsserverurl = "http://localhost:8080/feeds-web";
     parameters.feedsserverurl = "http://feeds.just-map-it.com";
	 parameters.map = "Feeds";
	 parameters.site = "";
	 parameters.jsessionid = '<%=session.getId()%>';
} 
function JMIF_Navigate( map, url) {
	 window.open( url, "_blank");
}
function JMIF_Focus( map, args)
{
	var parameters = {};
	JMIF_CompleteParameters( parameters);
	parameters.entityId = args[0];
	parameters.feed = args[2];
	parameters.track = "";
	breadcrumbTitles.shortTitle = "Focus";
	breadcrumbTitles.longTitle = "Focus on category: " + args[1];
	map.compute( parameters);
}
function JMIF_Center( map, args)
{
	var parameters = {};
	JMIF_CompleteParameters( parameters);
	parameters.attributeId = args[0];
	parameters.feed = args[2];
	parameters.analysisProfile = "DiscoveryProfile";
	parameters.track = "";
	breadcrumbTitles.shortTitle = "Centered";
	breadcrumbTitles.longTitle = "Centered on item: " + args[1];
	map.compute( parameters);
}
<%if( feed.length() > 0) {%>
$(document).ready(function() {
	var parameters = {};
	JMIF_CompleteParameters( parameters);
	parameters.analysisProfile = "GlobalProfile";
	parameters.feed = "<%=feed%>";
	parameters.track = "feed";
	var map = JMI.Map({
				parent: 'map', 
				//server: 'http://localhost:8080/jmi-server/', 
				clientUrl: './jmi-client/'
				//client: JMI.Map.SWF
			});
	map.addEventListener(JMI.Map.event.READY, function(event) {
		  var titles = event.map.getProperty( "$FEEDS_TITLES");
		  if( titles) {
		  	document.title = titles.join( ', ') + ' | Just Map It! Feeds - ';
			if( event.map.getProperty( "$analysisProfile") == "GlobalProfile") {
				breadcrumbTitles.shortTitle = "Initial map";
				breadcrumbTitles.longTitle = titles.join( ', ');
			}
		  }
		  var urls = event.map.getProperty( "$FEEDS_URLS");
		  if( urls && urls.length == 1) {
			var data = {};
			data.url = urls[0];
			$.getJSON( "./rest/feeds/feed.json", data, function( feed){
				var date = new Date();
				if( !feed.thumbnail_date)
					feed.thumbnail_date = 0;
				var delta = date.getTime() - feed.thumbnail_date;
				if( delta > 7 * 24 * 3600 * 1000) {
					$.post(
						  //'http://feeds.just-map-it.com/rest/feeds/feed/thumbnail.png',
						  parameters.feedsserverurl + '/rest/feeds/feed/thumbnail.png',
						  {url:urls[0],width:150,height:100,mime:'image/png',filedata: event.map.getImage('image/png', 150, 100, true)}
					);
				}
			});
		  }
	} );
	map.addEventListener(JMI.Map.event.ACTION, function(event) {
		window[event.fn](event.map, event.args);
	} );
	map.addEventListener(JMI.Map.event.EMPTY, function(event) {
	} );
	map.addEventListener(JMI.Map.event.ERROR, function(event) {
	} );
	new JMI.extensions.Breadcrumb('breadcrumb',map,{'namingFunc':JMIF_breadcrumbTitlesFunc,'thumbnail':{}});
	new JMI.extensions.Slideshow(map);
	map.compute( parameters);
});
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
		<!-- p id="message"></p-->
		<div id="breadcrumb">&nbsp;</div>
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
<div id="map"></div>
<%}%>
</div>
<jsp:include page="./footer.jsp" >
	<jsp:param name="feed" value="<%=feed%>" /> 
</jsp:include>
</body>
</html>
