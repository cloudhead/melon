$( document ).ready( function() {
    var path = window.location.pathname.toString();
            
    /* Specify routes */
    Router.map({ from: "/#/#/#/$", to: { posts: "/posts/$1-$2-$3-$4", 
                                         comments: "/comments/$1-$2-$3-$4" }, page: "single" },
               { from: "/#/#/#",   to: { posts: "/posts/archive/$1-$2-$3"},   page: "archives" },
               { from: "*",        to: { posts: "/posts/frontpage" },         page: "home" }); // default
               
    var route = Router.match( path );    

    if( route.page ) $("body").attr("id", route.page ); // Set the body id
    $.each( route.path, function( id, uri ) {
        Melon.get( uri, function( json ) {
            if( ! $.isArray( json ) ) json = [ json ]; // Convert to array
            $.each( json, function() { 
                Pages[ route.page ]( Melon.clone( id, this ), this ); 
            });
            Melon.cleanup( id );
        });
    });
});

var Pages = {
    home: function( selector, input )
    {
        selector.find("h1").wrapInner("<a href='" + input.uri + "'></a>");
    },
    single: function( selector, input ) {}
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
                $.each( to, function( k, v ) {
                    to[ k ] = path.replace( route, v );
                });
                return { path: to, page: page };              
            }
        }
        return false; // nothing was matched!
    },
    routes: []
};
var Melon = {
    get: function( path, callback ) 
    {
        $.getJSON( path + '.json', function( json ) {
            if( json.redirect ) {
                window.location = json.redirect;
            }
            else callback( json );
        });
    },
    mget: function( path, callback ) // Recursive get
    {
        var buffer = [], i = 0;
        if( arguments.length == 4 ) {
            i = arguments[ 2 ]; buffer = arguments[ 3 ];
        }
        
        if( i in path ) $.getJSON( path[ i ], function( json ) { 
            buffer[ i ] = json;
            Melon.get( path, callback, ++i, buffer ); 
        });
        else callback( buffer );
    },
    post: function( url, callback )
    {
        
    },
    clone: function( id, input )
    {
        var element = $("#" + id + " ul > li:first").clone().appendTo("#" + id + " ul").attr("id", input.id );
        
        for( var key in input ) { // $.each?
            element.find('.' + key ).html( input[ key ] );
        }
        return element;
    },
    cleanup: function( id )
    {
        return $("#" + id + " ul > li:first").remove();
    },
    action: function( caption, module, action, key )
    {
        return "<a href='/" + module + "/" + action + "/'>" + caption + "</a>";
    }
};



