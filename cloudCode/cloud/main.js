
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
var itemsPerPage = 10;
var MAX_QUERY_LIMIT = 1000; 
var ActivityType = {CommentImageOne: 0,
					CommentImageTwo: 1,
					LikeImageOne: 2,
					LikeImageTwo: 3,
					Follow: 4,
					Join: 5 
				};

Parse.Cloud.define("getFeedItemsForPage", function(request, response) {
	var getPage = request.params.page;
	var Photos = Parse.Object.extend( 'Photos' );
	var query = new Parse.Query( Photos );
	query.descending( 'createdAt' );
	query.limit( itemsPerPage );
	query.skip( itemsPerPage * getPage );
	var photosPromise = query.find();
	photosPromise.then( function( feedPhotos ) {
		var Activity = Parse.Object.extend( 'Activity' );
		var activityQuery = new Parse.Query( Activity );
		activityQuery.limit( MAX_QUERY_LIMIT );
		activityQuery.containedIn( 'photoPair', feedPhotos );
		var activityPromise = activityQuery.find();
		activityPromise.then( function( someActivities ) {		
			var newsFeedItemValuesForPhotoPairObjectId = {};
			_.each( someActivities, function( anActivity ) {

			})

			var payload = { photoPairs: feedPhotos, activities: someActivities };
			response.success( payload );
		}, function( error ) {
			response.error( { error: error } );
		});

	}, function( error ) {
		response.eror( error );
	});
	
});

// Parse.CLoud.define( "")
