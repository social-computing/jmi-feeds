package com.socialcomputing.feeds;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.DefaultValue;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.socialcomputing.feeds.utils.HibernateUtil;

@Path("/sites")
public class SiteManager {
    private static final Logger LOG = LoggerFactory.getLogger(SiteManager.class);

    @GET
    @Path("top.json")
    @Produces(MediaType.APPLICATION_JSON)
    public List<Site> topJson( @DefaultValue("0") @QueryParam("start") int start, @DefaultValue("-1") @QueryParam("max") int max) {
        return top( start, max);
    }
    
    @GET
    @Path("top.xml")
    @Produces(MediaType.APPLICATION_XML)
    public List<Site> topXml( @DefaultValue("0") @QueryParam("start") int start, @DefaultValue("-1") @QueryParam("max") int max) {
        return top( start, max);
    }
    
    public List<Site> top( int start, int max) {
        List<Site> sites = null;
        try {
            Session session = HibernateUtil.getSessionFactory().getCurrentSession();
            max = max == -1 ? 100 : Math.min( max, 1000);
            Query query = session.createQuery( "from Site as site order by site.count desc");
            query.setFirstResult( start);
            query.setMaxResults( max);
            sites = query.list();
            Response.ok();
        }
        catch (HibernateException e) {
            LOG.error(e.getMessage(), e);
            Response.status( HttpServletResponse.SC_BAD_REQUEST);
        }
        return sites;
    }
}
