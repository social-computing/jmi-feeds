<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">	
<head>
<title>Add Just Map It! Feeds to your webpage | Just Map It! Feeds</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="content-language" content="en" />
<meta name="description" content="Add Just Map It! Feeds to your webpage: it's easy and free, do it in 3 steps" />
<meta name="keywords" content="documentation, rss, atom, rdf, feeds, feed, map, integrate, visualization, preview, script, gadget, widget, free, easy" />
<meta name="author" content="Social Computing" /> 
<meta name="robots" content="all" /> 
<jsp:include page="./head-header.jsp" />
<jsp:include page="./js/ga.js" /> 
</head>
<body>
<%String feed = request.getParameter("feed");
if( feed==null) feed="";
String b = request.getParameter("b");
if( b==null) b = "yes";
String w = request.getParameter("w");
if( w==null || w.length() == 0) w = "500";
String h = request.getParameter("h");
if( h==null || h.length() == 0) h = "500";
%>
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
<div id="container" class="container_12">
<div id="topContent">
	<div id="titreTopContent" class="grid_12"><h1>Add it to your webpage</h1></div>
</div>
<div>&nbsp;</div>
<div id="integrate">
<table border="0">
<tr><td style="vertical-align:top;">
<div id="integrate">
	<h2>1 - Complete the form</h2>
	<form method="get">
	<table>
	<tr><td colspan="2">URL(s) (comma separated) *</td><td></td></tr>
	<tr><td></td><td><input type="text" name="feed" size="60" value="<%=feed%>"/></td></tr>
	<tr><td>Width *</td><td><input type="text" name="w" size="10" value="<%=w%>"/></td></tr>
	<tr><td>Height *</td><td><input type="text" name="h" size="10" value="<%=w%>"/></td></tr>
	<tr><td></td><td>* required</td></tr>
	<tr><td></td><td><input type="submit" value="Get code"/></td></tr>
	</table>	
	</form>
</div>
</td><td  style="vertical-align:top;">
<div id="preview" style="width:500px;height:330px">
	<h2>2 - Preview - 500 * 300px</h2>
	<script type="text/javascript" src="./int.jsp?url=<%=java.net.URLEncoder.encode(feed, "UTF-8")%>&m=message&w=500&h=300"></script>
</div>
</td></tr>
<tr><td colspan="2">
<div id="code">
	<h2>3 - Copy this code in your page</h2>
	<textarea name="code" readonly="readonly" style="width:100%">&lt;script type="text/javascript" src="http://feeds.just-map-it.com/int.jsp?url=<%=java.net.URLEncoder.encode(feed, "UTF-8")%>&amp;w=<%=w%>&amp;h=<%=h%>"&gt;&lt;/script&gt;</textarea> 
</div>
</td></tr>
</table>
</div>
</div>
<jsp:include page="./footer.jsp" >
	<jsp:param name="feed" value="<%=feed%>" /> 
</jsp:include>
</body>
</html>
