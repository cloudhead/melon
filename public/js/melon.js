function action( caption, controller, action, key )
{
    var id = key ? "id='" + key + "'" : '';
    return "<a class='" + controller + ' ' + action + "' " + id + " href='#'>" + caption + "</a>";
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
$( document ).ready( function() {
   var path = window.location.pathname;
   if( path == "/") {
       $("#comments").hide();
       $.getJSON("/m/posts/frontpage", function( posts ) {
   	       for( var i in posts ) {
  	           $("#posts ul > li:first").clone().appendTo("#posts ul");
  	           post( posts[ i ] ).find("h1").wrapInner("<a href='/" + posts[ i ].id + "'></a>");
   	       }
       });
   } else {
       /* Posts */
       $.getJSON("/posts" + path + ".json", function( json ) {
           post( json );
       });
       /* Comments */
       $.getJSON("/comments" + path + ".json", function( comments ) {
           for( var i in comments ) {
   	            $("#comments ul > li:first").clone().appentTo("#comments ul");
   	            comment = $("#comments ul > li:last");
   	            
   	            for( var key in comments[ i ] ) {
   	                comment.find('.' + key ).html( comments[ i ][ key ] );
   	            }
   	       }
       });      
       $("#comments").show();
   }
});