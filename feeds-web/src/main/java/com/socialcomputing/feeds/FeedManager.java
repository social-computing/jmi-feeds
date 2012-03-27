package com.socialcomputing.feeds;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.Consumes;
import javax.ws.rs.DefaultValue;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.UriInfo;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import sun.misc.BASE64Decoder;

import com.socialcomputing.feeds.utils.HibernateUtil;
import com.sun.jersey.api.Responses;
import com.sun.jersey.core.header.FormDataContentDisposition;
import com.sun.jersey.multipart.FormDataParam;


@Path("/feeds")
public class FeedManager {
    private static final String IMAGE_PREFIX = "data:image/png;base64,";
    private static final Logger LOG = LoggerFactory.getLogger(FeedManager.class);

    @GET
    @Path("count.json")
    @Produces(MediaType.APPLICATION_JSON)
    public long countJson( @DefaultValue("true") @QueryParam("success") String success) {
        return count( success);
    }
    
    public long count ( String success) {
        long count = 0;
        try {
            Session session = HibernateUtil.getSessionFactory().getCurrentSession();
            Query query = null;
            if( success == null || success.equals( "*")) {
                query = session.createQuery( "select count(*) from Feed");
            }
            else {
                query = session.createQuery( "select count(*) from Feed as feed where feed.success = :success");
                query.setBoolean( "success", success.equalsIgnoreCase( "true"));
            }
            count = ( Long)query.uniqueResult();
            Response.ok();
        }
        catch (HibernateException e) {
            LOG.error(e.getMessage(), e);
            Response.status( HttpServletResponse.SC_BAD_REQUEST);
        }
        return count;
    }
    
    @GET
    @Path("top.json")
    @Produces(MediaType.APPLICATION_JSON)
    public List<Feed> topJson( @DefaultValue("0") @QueryParam("start") int start, @DefaultValue("-1") @QueryParam("max") int max, @DefaultValue("true") @QueryParam("success") String success) {
        return top( start, max, success);
    }
    
    @GET
    @Path("top.xml")
    @Produces(MediaType.APPLICATION_XML)
    public List<Feed> topXml( @DefaultValue("0") @QueryParam("start") int start, @DefaultValue("-1") @QueryParam("max") int max, @DefaultValue("true") @QueryParam("success") String success) {
        return top( start, max, success);
    }
    
    public List<Feed> top( int start, int max, String success) {
        List<Feed> feeds = null;
        try {
            Session session = HibernateUtil.getSessionFactory().getCurrentSession();
            max = max == -1 ? 100 : Math.min( max, 1000);
            Query query = null;
            if( success == null || success.equals( "*")) {
                query = session.createQuery( "from Feed as feed order by feed.count desc");
            }
            else {
                query = session.createQuery( "from Feed as feed where feed.success = :success order by feed.count desc");
                query.setBoolean( "success", success.equalsIgnoreCase( "true"));
            }
            query.setFirstResult( start);
            query.setMaxResults( max);
            feeds = query.list();
            Response.ok();
        }
        catch (HibernateException e) {
            LOG.error(e.getMessage(), e);
            Response.status( HttpServletResponse.SC_BAD_REQUEST);
        }
        return feeds;
    }
    
    @GET
    @Path("last.json")
    @Produces(MediaType.APPLICATION_JSON)
    public List<Feed> lastJson( @DefaultValue("0") @QueryParam("start") int start, @DefaultValue("-1") @QueryParam("max") int max, @DefaultValue("true") @QueryParam("success") String success) {
        return last( start, max, success);
    }

    @GET
    @Path("last.xml")
    @Produces(MediaType.APPLICATION_XML)
    public List<Feed> lastXml( @DefaultValue("0") @QueryParam("start") int start, @DefaultValue("-1") @QueryParam("max") int max, @DefaultValue("true") @QueryParam("success") String success) {
        return last( start, max, success);
    }
    
    public List<Feed> last( int start, int max, String success) {
        List<Feed> feeds = null;
        try {
            Session session = HibernateUtil.getSessionFactory().getCurrentSession();
            max = max == -1 ? 100 : Math.min( max, 1000);
            Query query = null;
            if( success == null || success.equals( "*")) {
                query = session.createQuery( "from Feed as feed order by feed.updated desc");
            }
            else {
                query = session.createQuery( "from Feed as feed where feed.success = :success order by feed.updated desc");
                query.setBoolean( "success", success.equalsIgnoreCase( "true"));
            }
            query.setFirstResult( start);
            query.setMaxResults( max);
            feeds = query.list();
            Response.ok();
        }
        catch (HibernateException e) {
            LOG.error(e.getMessage(), e);
            Response.status( HttpServletResponse.SC_BAD_REQUEST);
        }
        return feeds;
    }

    @GET
    @Path("feed.json")
    @Produces(MediaType.APPLICATION_JSON)
    public Feed feedJson(  @QueryParam("url") String url) {
        return feed( url);
    }
    
    @GET
    @Path("feed.xml")
    @Produces(MediaType.APPLICATION_XML)
    public Feed feedXml( @QueryParam("url") String url) {
        return feed( url);
    }
    
    public Feed feed( String url) {
        Feed feed = null;
        try {
            if( url != null) {
                Session session = HibernateUtil.getSessionFactory().getCurrentSession();
                url = url.trim();
                feed = (Feed) session.get(Feed.class, url);
                Response.ok();
            }
            else
                Response.status( Responses.NOT_FOUND);
        }
        catch (HibernateException e) {
            LOG.error(e.getMessage(), e);
            Response.status( HttpServletResponse.SC_BAD_REQUEST);
        }
        return feed;
    }
    
    @GET
    @Path("/feed/thumbnail.png")
    @Produces( "image/png") 
    public Response getThumbnail( @QueryParam("url") String url) {
        Feed feed = feed( url); 
        if( feed != null) {
            return Response.ok( feed.getThumbnail()).build();
        }
        else
            Response.status( Responses.NOT_FOUND);
        return null;
    }
    
    @POST
    @Path("/feed/thumbnail.png")
    @Consumes( MediaType.APPLICATION_FORM_URLENCODED) 
    public void putThumbnail2( 
                   @Context UriInfo uriInfo,
                   @FormParam("url") String url,
                   @FormParam("filedata") String data,
                   @FormParam("width") int width,
                   @FormParam("height") int height,
                   @FormParam("mime") String mime
                   ) {
        Feed feed = feed( url); 
        try {
            if( feed != null) {
                Session session = HibernateUtil.getSessionFactory().getCurrentSession();
                if( data.startsWith(IMAGE_PREFIX)) {
                    BASE64Decoder decoder = new BASE64Decoder();
                    feed.setThumbnail( decoder.decodeBuffer(data.substring(IMAGE_PREFIX.length())));
                }
                else 
                    feed.setThumbnail( data.getBytes());
                feed.setThumbnail_date( new Date());
                feed.setThumbnail_height( height);
                feed.setThumbnail_width( width);
                feed.setThumbnail_mime( mime);
                session.update( feed);
            }
            else
                Response.status( Responses.NOT_FOUND);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    @Deprecated
    @POST
    @Path("/feed/thumbnail.png")
    @Consumes( MediaType.MULTIPART_FORM_DATA) 
    public void putThumbnail( 
                   @FormDataParam("url") String url,
                   @FormDataParam("filedata") InputStream uploadedInputStream,
                   @FormDataParam("filedata") FormDataContentDisposition fileDetail,
                   @FormDataParam("width") int width,
                   @FormDataParam("width") int height,
                   @FormDataParam("width") String mime
                   ) {
        Feed feed = feed( url); 
        try {
            if( feed != null) {
                Session session = HibernateUtil.getSessionFactory().getCurrentSession();
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                int b;
                    b = uploadedInputStream.read();
                while( b != -1) {
                    baos.write( b);
                    b = uploadedInputStream.read();
                }
                feed.setThumbnail( baos.toByteArray());
                feed.setThumbnail_date( new Date());
                feed.setThumbnail_height( height);
                feed.setThumbnail_width( width);
                feed.setThumbnail_mime( mime);
                session.update( feed);
            }
            else
                Response.status( Responses.NOT_FOUND);
        }
        catch (IOException e) {
            e.printStackTrace();
        }
    }
}
