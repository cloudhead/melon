$( document ).ready( function() {
    $.path = {
        s: window.location.pathname.toString(),
        id: window.location.pathname.replace(/\//g,'-').replace(/^-/, '')
    };
    
    /* Specify routes */
    Router.map({ from: "/#/#/#/$", to: "$1-$2-$3-$4.json" },
               { from: "/#/#/#",   to: "/posts/archive/$1-$2-$3" },
               { from: "/",        to: "/posts/frontpage", id: "home"},
               { from: "/auth",    to: "/login" },
               { from: "/*",       to: "/posts/frontpage" });
        
   /* Landing page */
   if( $.path.s == "/") {
       $("#comments").hide();
       $.getJSON("/posts/frontpage.json", function( posts ) {
   	       for( var i = 0; i < posts.length; i++ ) {
   	           /* 2009-24-12-the-article => 2009/24/12/the-article */
               var date = posts[ i ].id.slice( 0, 11 ).replace( /-/g, '/');
               var title = posts[ i ].id.slice( 11 );
               
  	           $("#posts ul > li:first").clone().appendTo("#posts ul");  	           
  	           post( posts[ i ] ).find("h1").wrapInner("<a href='/" + 
  	           date + title + "'></a>");
   	       }
   	       $("#posts ul > li:first").remove();
       });
   } 
   else {
       /* Posts */
       $.getJSON("/posts/" + $.path.id + ".json", function( json ) {
           post( json );
       });
       /* Comments */
       $.getJSON("/comments/" + $.path.id + ".json", function( comments ) {
           for( var i = 0; i < comments.length; i++ ) {
   	            $("#comments ul > li:first").clone().appentTo("#comments ul").addClass("comment");
   	            comment = $("#comments ul > li:last");
   	            
   	            for( var key in comments[ i ] ) {
   	                comment.find('.' + key ).html( comments[ i ][ key ] );
   	            }
   	       }
       });      
       $("#comments").show();
   }
});

var Router = {
    map: function() {
        for( var i = 0; i < arguments.length; i++ ) {
            Router.routes.push( arguments[ i ] ); // Add route to array
        }
    },
    match: function( path ) {        
        /* Loop through routes */
        for( var i = 0; i < Router.routes.length; i++ ) { 
            /* Construct regex from route */ 
            var id = Router.routes[ i ].id;       
            var route = new RegExp( "^\\/?" +
                                    Router.routes[ i ].from.toString().
                                    replace(/#/g, "([0-9]+)").
                                    replace(/\$/g, "([a-z_\\-]+)").
                                    replace(/\*/g, "(.+)").
                                    replace(/\//g, "\\/") + 
                                    "\\/?$");
                                    
            if( path.match( route ) ) {
                if( id ) $("body").attr("id", id ); // Set the body id
                return path.replace( route, Router.routes[ i ].to );
            }
        }
        return false; // If nothing matched, we return false
    },
    routes: []
};

function action( caption, controller, action, key )
{
    return "<a href='/" + controller + "/" + action + "/'>" + caption + "</a>";
}
function post( data )
{
    var post = $("#posts ul > li:last");
    
    for( var key in data ) {
        post.find('.' + key ).html( data[ key ] );
    }
    return post;
}

$.postJSON = function(url, data, callback) {
	$.post(url, data, callback, "json");
};

Array.prototype.map = function ( fn )
{
    var a = [];
    for( var i = 0; i < this.length; i++ ) {
        a[ i ] = fn( this[ i ] );
    }
    return a;
};
Array.prototype.compact = function()
{
    var len = this.length >>> 0;
    var res = new Array();
    
    for( var i = 0; i < len; i++ ) {
        if( i in this ) {
            if( this[ i ] != "") res.push( this[ i ] );
        }
    }
    return res;
};



