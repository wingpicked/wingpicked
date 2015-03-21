
var _ = require( 'underscore' ),
	feedItem = require( 'cloud/model/feedItem' ),
	profileInfo = require( 'cloud/model/profileInfo' );


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
        response.error( error );
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
		response.error( error );
	});
	
});


Parse.Cloud.define( "fetchProfileInfo", function( request, response ) {
	var userObjectId = request.params.userObjectId;
	var profileInfo = new profileInfo.ProfileInfo();
    var Photos = Parse.Object.extend( 'Photos' );
	var query = new Parse.Query( Photos );
	query.include( 'user' );	
	query.descending( 'createdAt' );
	query.limit( itemsPerPage );
	var mockUser = new Parse.User();
	mockUser.id = userObjectId;
	query.equalTo( 'user', userObjectId );
	var Activity = Parse.Object.extend( 'Activity' );
	var photosPromise = query.find();
	photosPromise.then( function( feedPhotos ) {
		var feedPhotoPairsPromise = new Parse.Promise();
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

			var profileItems = _.values( feedItemValuesForPhotoPairObjectId );
			feedPhotoPairsPromise.resolve( profileItems );
		}, function( error ) {
			feedPhotoPairsPromise.reject( { error: error } );
		});

		return feedPhotoPairsPromise;
	}).then( function( profileItems ) {
		profileInfo.posts = profileItems;
		var followingQuery = new Parse.Query( Activity );
		followingQuery.include( 'photoPair' );
		followingQuery.include( 'fromUser' );
		followingQuery.include( 'toUser' );
		followingQuery.limit( MAX_QUERY_LIMIT );
		followingQuery.equalTo( 'fromUser', mockUser );
		followingQuery.equalTo( 'type', feedItem.ActivityType.Follow );

		var followersQuery = new Parse.Query( Activity );
		followersQuery.include( 'photoPair' );
		followersQuery.include( 'fromUser' );
		followersQuery.include( 'toUser' );
		followersQuery.limit( MAX_QUERY_LIMIT );
		followersQuery.equalTo( 'toUser', mockUser );
		followersQuery.equalTo( 'type', feedItem.ActivityType.Follow );

		return Parse.Query.or( followingQuery, followersQuery ).find();
	}).then( function( followEventActivities ) {
		// add follow events
		_.each( followEventActivities, function( aFollowEvent ) {
			if ( aFollowEvent.has( 'fromUser' ) && aFollowEvent.has( 'toUser' ) ) {
				var fromUser = aFollowEvent.get( 'fromUser' );
				var toUser = aFollowEvent.get( 'toUser' );
				if ( _.isEqual( fromUser.id, userObjectId ) ) {
					profileInfo.following.push( toUser );
				} else if ( _.isEqual( toUser.id, userObjectId ) ) {
					profileInfo.followers.push( fromUser );
				}
			}
		});

		// get notifications
		var allNotificationsQuery = profileInfo.queryForNotificationsWithUser( mockUser, feedItem );
		return allNotificationsQuery.find();
	}).then( function( allNotificationsForUser ) {
		if ( 0 < allNotificationsForUser.length ) {
			var notificationsSortedByCreatedDate = _.sortBy(allNotificationsForUser, function (aNotification) {
				return -(aNotification.createdAt.getTime() );
			});

			profileInfo.notifications = notificationsSortedByCreatedDate
		}

		response.success( { profileInfo: profileInfo } );
	}, function( error ) {
		response.error( error );
	});

});







