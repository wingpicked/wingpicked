
var _ = require( 'underscore' ),
	feedItem = require( 'cloud/model/feedItem' ),
	profileInfoUtils = require( 'cloud/model/profileInfo' ),
	userUtils = require( 'cloud/utils/userUtils'),
	activityUtils = require( 'cloud/utils/activityUtils'),
	exploreCalculator = require( 'cloud/utils/exploreCalculator' );


var itemsPerPage = 10;
var MAX_QUERY_LIMIT = 1000; 

Parse.Cloud.define( "getFeedItemsForPageV3", function( request, response ) {
	var getPage = request.params.page;
	var followingQuery = userUtils.queryWithFollowingActivities( request.user, feedItem.ActivityType.Follow );
	var followingPromise = followingQuery.find();
	followingPromise.then( function( followingActivities ) {
		var followingUsers = [request.user];
		_.each(followingActivities, function (aFollowActivity) {
			if (aFollowActivity.has('toUser')) {
				var followingUser = aFollowActivity.get('toUser');
				followingUsers.push(followingUser);
			}
		});

		var Photos = Parse.Object.extend('PhotoPair');
		var query = new Parse.Query(Photos);
		query.include('user');
		query.include( 'photoOne' );
		query.include( 'photoTwo' );
		query.descending('createdAt');
		query.limit(itemsPerPage);
		query.containedIn('user', followingUsers);
		query.skip(itemsPerPage * getPage);
		return query.find();
	}).then( function( feedPhotos ) {
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


Parse.Cloud.define( 'fetchExploreInfo', function( request, response ) {
	var activityPromise = activityUtils.queryForExploreActivities( feedItem.ActivityType );
	activityPromise.then( function( likesPhotoOne, likesPhotoTwo, commentsPhotoOne, commentsPhotoTwo ) {
	var exploreCalculated = new exploreCalculator.ExploreCalculator( likesPhotoOne, likesPhotoTwo, commentsPhotoOne, commentsPhotoTwo );
		var payload = { feedItems: exploreCalculated.feedItemsPayload };
		response.success( payload );
	}, function( error ) {
		response.error( error );
	});
});

Parse.Cloud.define( "fetchProfileInfo", function( request, response ) {
	var currentUser = request.user;
	var queryWithFollowingAndFollowers = userUtils.queryWithFollowingAndFollowers( currentUser, feedItem.ActivityType.Follow );
	var followersAndFollowing = queryWithFollowingAndFollowers.find();
	var userObjectId = request.params.userObjectId;
	var profileInfo = new profileInfoUtils.ProfileInfo();
	var scopedVars = {};
	var Activity = Parse.Object.extend('Activity');
	var mockUser = new Parse.User();
	mockUser.id = userObjectId;
	followersAndFollowing.then( function( followersAndFollowing ) {
		scopedVars.followersAndFollowing = followersAndFollowing;
		var Photos = Parse.Object.extend('PhotoPair');
		var query = new Parse.Query(Photos);
		query.include('user');
		query.include( 'photoOne' );
		query.include( 'photoTwo' );
		query.descending('createdAt');
		query.limit(itemsPerPage);
		query.equalTo('user', mockUser);
		return query.find();
	}).then( function( feedPhotos ) {
		var feedPhotoPairsPromise = new Parse.Promise();
		var activityQuery = new Parse.Query( Activity );
		activityQuery.include( 'photoPair' );
		activityQuery.include( 'fromUser' );
		activityQuery.include( 'toUser' );
		activityQuery.equalTo( 'isArchiveReady', false );
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
		profileInfo.postsCount = profileItems.length;
		var followingQuery = new Parse.Query( Activity );
		followingQuery.include( 'photoPair' );
		followingQuery.include( 'fromUser' );
		followingQuery.include( 'toUser' );
		followingQuery.limit( MAX_QUERY_LIMIT );
		followingQuery.equalTo( 'fromUser', mockUser );
		followingQuery.equalTo( 'type', feedItem.ActivityType.Follow );
		followingQuery.equalTo( 'isArchiveReady', false );

		var followersQuery = new Parse.Query( Activity );
		followersQuery.include( 'photoPair' );
		followersQuery.include( 'fromUser' );
		followersQuery.include( 'toUser' );
		followersQuery.limit( MAX_QUERY_LIMIT );
		followersQuery.equalTo( 'toUser', mockUser );
		followersQuery.equalTo( 'type', feedItem.ActivityType.Follow );
		followersQuery.equalTo( 'isArchiveReady', false );

		return Parse.Query.or( followingQuery, followersQuery ).find();
	}).then( function( followEventActivities ) {
		// add follow events
		var currentUserObjectId = request.user.id;
		_.each( followEventActivities, function( aFollowEvent ) {
			if ( aFollowEvent.has( 'fromUser' ) && aFollowEvent.has( 'toUser' ) ) {
				var fromUser = aFollowEvent.get( 'fromUser' );
				var toUser = aFollowEvent.get( 'toUser' );
				if ( _.isEqual( fromUser.id, userObjectId ) ) {
					var isFollowing = userUtils.isFollowingUserWithFollowActivities( toUser, scopedVars.followersAndFollowing );
					var userDictionary = { user: toUser, isFollowing: isFollowing };
					profileInfo.following.push( userDictionary );
				} else if ( _.isEqual( toUser.id, userObjectId ) ) {
					var isFollowing = userUtils.isFollowingUserWithFollowActivities( fromUser, scopedVars.followersAndFollowing );
					var userDictionary = { user: fromUser, isFollowing: isFollowing };
					profileInfo.followers.push( userDictionary );
					if ( _.isEqual(currentUserObjectId, fromUser.id ) ) {
						profileInfo.isFollowing = true;
					}
				}
			}
		});

		profileInfo.followingCount = profileInfo.following.length;
		profileInfo.followersCount = profileInfo.followers.length;

		// get notifications
		var allNotificationsQuery = profileInfoUtils.queryForNotificationsWithUser( mockUser, feedItem );
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







