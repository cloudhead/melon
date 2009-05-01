var Melon = {
    get: function( url, callback ) 
    {
        var buffer = [], i = 0;
        
        if( arguments.length == 4 ) {
            i = arguments[ 2 ]; buffer = arguments[ 3 ];
        }
        
        if( i in url ) $.getJSON( url[ i ], function( json ) { 
            buffer[ i ] = json;
            Melon.get( url, callback, ++i, buffer ); 
        });
        else callback( buffer );
    }
};

$( document ).ready( function() {
    var Path = {
        s: window.location.pathname.toString(),
        id: window.location.pathname.replace(/\//g, '-').replace(/^-/, '')
    };
            
    /* Specify routes */
    Router.map({ from: "/#/#/#/$", to: ["/posts/$1-$2-$3-$4", 
                                        "/comments/$1-$2-$3-$4"], page: "single" },
               { from: "/#/#/#",   to: "/posts/archive/$1-$2-$3" },
               { from: "/",        to: "/posts/frontpage", page: "home"},
               { from: "/auth",    to: "/login" },
               { from: "/*",       to: "/posts/frontpage" });
               
    var route = Router.match( Path.s );    
    
    Melon.get( route.path, function( json ) {
        if( route.page ) $("body").attr("id", route.page ); // Set the body id
        if( json.length == 1 ) json = json[ 0 ];        
        Pages[ route.page ]( json );
    });
    
    // for( var i = 0; i < route.path.length; i++ ) {
    //         $.getJSON( route.path[i], function(json) {
    //             Pages[ route.]
    //         });
    //     }
});
function clone( name, input )
{
    var element = $("#" + name + " ul > li:first").clone().appendTo("#" + name + " ul");
    element.attr("id", input.id);
          
          for( var key in input ) {
              element.find('.' + key ).html( input[ key ] );
          }
          return element;
}
var Pages = {
    home: function( input )
    {
        for( var i = 0; i < input.length; i++ ) {
           /* 2009-24-12-the-article => 2009/24/12/the-article */
           var date  = input[ i ].id.slice( 0, 11 ).replace( /-/g, '/');
           var title = input[ i ].id.slice( 11 );
       
           clone("posts", input );
           post( input[ i ] ).find("h1").wrapInner("<a href='/" + date + title + "'></a>");
       }
       $("#posts ul > li:first").remove();
    },
    single: function( input )
    {
        var posts = input[ 0 ];
        var comments = input[ 1 ];
                
        /* Posts */
        clone( "posts", posts );

        /* Comments */
        for( var i = 0; i < comments.length; i++ ) {
            var comment = clone("comments", comments);
         }
         $("#comments ul > li:first").remove(); // automate this
         $("#posts ul > li:first").remove();    //
    }
};
var Router = {
    map: function() 
    {
        for( var i = 0; i < arguments.length; i++ ) {
            Router.routes.push( arguments[ i ] ); // Add route to array
        }
    },
    match: function( path ) 
    {        
        /* Loop through routes */
        for( var i = 0; i < Router.routes.length; i++ ) { 
            /* Construct regex from route */ 
            var page = Router.routes[ i ].page;
            var to = Router.routes[ i ].to;
            var route = new RegExp( "^\\/?" +
                                    Router.routes[ i ].from.toString().
                                    replace(/#/g, "([0-9]+)").
                                    replace(/\$/g, "([a-z_\\-]+)").
                                    replace(/\*/g, "(.+)").
                                    replace(/\//g, "\\/") + 
                                    "\\/?$");
                                    
            if( path.match( route ) ) {
                if( $.isArray( to ) ) {
                    to = to.map( function( s ) { 
                        return path.replace( route, s ) + ".json"; 
                    });
                }
                else {
                    to = [ path.replace( route, to ) + ".json"];
                }
                return { path: to, page: page };              
            }
        }
        return false; // If nothing matched, we return false
    }
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

