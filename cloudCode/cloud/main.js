
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
var itemsPerPage = 10;
Parse.Cloud.define("getFeedItemsForPage", function(request, response) {
	var getPage = request.params.page;
	var Photos = Parse.Object.extend( 'Photos' );
	var query = new Parse.Query( Photos );
	query.descending( 'createdAt' );
	query.limit( itemsPerPage );
	query.skip( itemsPerPage * getPage );
	var photosPromise = query.find();
	photosPromise.then( function( feedItems ) {
		
		response.success(feedItems);
	}, function( error ) {
		response.eror( error );
	});
	
});

// Parse.CLoud.define( "")
