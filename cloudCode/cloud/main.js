
var _ = require( 'underscore' ),
	feedItem = require( 'cloud/model/feedItem' );


var itemsPerPage = 10;
var MAX_QUERY_LIMIT = 1000; 

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
            var payload = { photoPairs: feedPhotos, activities: someActivities };
            response.success( payload );
        }, function( error ) {
            response.error( { error: error } );
        });
 
    }, function( error ) {
        response.eror( error );
    });
     
});

Parse.Cloud.define( "getFeedItemsForPage2", function( request, response ) {
	var getPage = request.params.page;
	var Photos = Parse.Object.extend( 'Photos' );
	var query = new Parse.Query( Photos );
	query.include( 'user' );	
	query.descending( 'createdAt' );
	query.limit( itemsPerPage );
	query.skip( itemsPerPage * getPage );
	var photosPromise = query.find();
	photosPromise.then( function( feedPhotos ) {
		var Activity = Parse.Object.extend( 'Activity' );
		var activityQuery = new Parse.Query( Activity );
		activityQuery.include( 'photoPair' );
		activityQuery.include( 'fromUser' );
		activityQuery.include( 'toUser' );
		activityQuery.limit( MAX_QUERY_LIMIT );
		activityQuery.containedIn( 'photoPair', feedPhotos );
		var activityPromise = activityQuery.find();
		activityPromise.then( function( someActivities ) {		
			var feedItemValuesForPhotoPairObjectId = {};
			_.each( feedPhotos, function( aPhotoPair) {
				var aFeedItem = new feedItem.FeedItem( aPhotoPair );
				feedItemValuesForPhotoPairObjectId[ aPhotoPair.id ] = aFeedItem;
			});

			_.each( someActivities, function( anActivity ) {
				if ( anActivity.has( 'photoPair' ) ) {
					var photoPair = anActivity.get( 'photoPair' );
					var aFeedItem = feedItemValuesForPhotoPairObjectId[ photoPair.id ];
					aFeedItem.addActivity( anActivity );
				}
			});
			var payload = { feedItems: _.values( feedItemValuesForPhotoPairObjectId ) };
			response.success( payload );
		}, function( error ) {
			response.error( { error: error } );
		});

	}, function( error ) {
		response.eror( error );
	});
	
});

// Parse.CLoud.define( "")
