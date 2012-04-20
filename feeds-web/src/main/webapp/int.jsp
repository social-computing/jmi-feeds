<%response.setContentType("text/javascript");%>
<jsp:include page="./jmi-client/jmi-client.js" /> 
var d = new Date();
var breadcrumbid = "message" + d.getTime();
var mapid = "map" + d.getTime();
document.write( '<link rel="stylesheet" type="text/css" href="http://feeds.just-map-it.com/jmi-client/css/jmi-client.css" />');
document.write( "<div id='" + breadcrumbid + "'>&nbsp;</div>");
document.write( "<div id='" + mapid + "' style='width:<%=request.getParameter("w")%>px;height:<%=request.getParameter("h")%>px'></div>");
var JMIbreadcrumbTitles = { shortTitle: '', longTitle: '' };
function JMIF_breadcrumbTitlesFunc(event) {
	if( event.type === JMI.Map.event.EMPTY) {
		return {shortTitle: 'Sorry, the map is empty. Does the feed contains categories?', longTitle: 'Sorry, the map is empty. Does the feed contains categories?'};
	}
	if( event.type === JMI.Map.event.ERROR) {
		return {shortTitle: 'Sorry, an error occured. Is this URL correct?', longTitle: 'Sorry, an error occured. Error: ' + event.message};
	}
	return JMIbreadcrumbTitles;
}
function JMIF_CompleteParameters( parameters) {
     parameters.feedsserverurl = "http://feeds.just-map-it.com";
	 parameters.map = "Feeds";
	 parameters.track = "site";
	 parameters.site = window.location.href;
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
	JMIbreadcrumbTitles.shortTitle = "Focus";
	JMIbreadcrumbTitles.longTitle = "Focus on category: " + args[1];
	map.compute( parameters);
}
function JMIF_Center( map, args)
{
	var parameters = {};
	JMIF_CompleteParameters( parameters);
	parameters.attributeId = args[0];
	parameters.feed = args[2];
	parameters.analysisProfile = "DiscoveryProfile";
	JMIbreadcrumbTitles.shortTitle = "Centered";
	JMIbreadcrumbTitles.longTitle = "Centered on item: " + args[1];
	map.compute( parameters);
}
<%if(request.getParameter("url") != null && request.getParameter("url").length()>0){ %>
	var parameters = {};
	JMIF_CompleteParameters( parameters);
	parameters.analysisProfile = "GlobalProfile";
	parameters.feed = "<%=request.getParameter("url")%>";
	parameters.track = "feed";
	var map = JMI.Map({
				parent: mapid, 
				clientUrl: 'http://feeds.just-map-it.com/jmi-client/'
			});
	map.addEventListener(JMI.Map.event.READY, function(event) {
		  var titles = event.map.getProperty( "$FEEDS_TITLES");
		  if( titles) {
			if( event.map.getProperty( "$analysisProfile") == "GlobalProfile") {
				JMIbreadcrumbTitles.shortTitle = "Initial map";
				JMIbreadcrumbTitles.longTitle = titles.join( ', ');
			}
		  }
	} );
	map.addEventListener(JMI.Map.event.ACTION, function(event) {
		window[event.fn](event.map, event.args);
	} );
	var breadcrumb = new JMI.extensions.Breadcrumb(breadcrumbid,map,{'namingFunc':JMIF_breadcrumbTitlesFunc,'thumbnail':{}});
	new JMI.extensions.Slideshow(map);
	map.compute( parameters);
<%} %>