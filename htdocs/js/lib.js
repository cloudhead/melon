Array.prototype.map = function( fn )
{
    var a = [];
    for( var i = 0; i < this.length; i++ ) {
        if( i in this ) a.push( fn( this[ i ] ) );
    }
    return a;
};
Array.prototype.compact = function()
{
    var a = [];
    for( var i = 0; i < this.length; i++ ) {
        if( i in this ) 
            if( this[ i ] != "" ) a.push( this[ i ] );
    }
    return a;
};
String.prototype.map = function( fn )
{
    return fn( this );
};

$.postJSON = function( url, data, callback ) {
	$.post(url, data, callback, "json");
};