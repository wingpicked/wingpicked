
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
		query.equalTo( 'isArchiveReady', false );
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
		activityQuery.equalTo( 'isArchiveReady', false );
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

			var items = _.values( feedItemValuesForPhotoPairObjectId );
			_.invoke( items, 'truncateCommentsToThree' );
			var payload = { feedItems: items };
			response.success( payload );
		}, function( error ) {
			response.error( { error: error } );
		});

	}, function( error ) {
		response.error( error );
	});

});


Parse.Cloud.define( 'fetchExploreInfo', function( request, response ) {
	var Activity = Parse.Object.extend( 'Activity' );
	var followingQuery = new Parse.Query( Activity );
	followingQuery.include( 'photoPair' );
	followingQuery.include( 'photoPair.user' );
	followingQuery.include( 'fromUser' );
	followingQuery.include( 'toUser' );
	followingQuery.limit( 1000 );
	followingQuery.equalTo( 'fromUser', request.user );
	followingQuery.equalTo( 'isArchiveReady', false );
	followingQuery.equalTo( 'type', feedItem.ActivityType.Follow );
	var followingPromise = followingQuery.find();
	followingPromise.then( function( followingActivities ) {
		var activityPromise = activityUtils.queryForExploreActivities( feedItem.ActivityType );
		activityPromise.then( function( likesPhotoOne, likesPhotoTwo, commentsPhotoOne, commentsPhotoTwo ) {
			var exploreCalculated = new exploreCalculator.ExploreCalculator(likesPhotoOne, likesPhotoTwo, commentsPhotoOne, commentsPhotoTwo, followingActivities);
			var payload = {feedItems: exploreCalculated.feedItemsPayload};
			response.success(payload);
		}, function( error ) {
			response.error( error );
		});
	}, function( error ) {
		response.error( error );
	});
});


Parse.Cloud.define( 'photoPairLikes', function( request, response ) {
	var photoPairObjectId = request.params.photoPairObjectId;
	var likesPhotoIdentifier = request.params.likesPhotoIdentifier;

	var PhotoPair = Parse.Object.extend( 'PhotoPair' );
	var mockPhotoPair = new PhotoPair();
	mockPhotoPair.id = photoPairObjectId;

	var Activity = Parse.Object.extend( 'Activity' );
	var likesQuery = new Parse.Query( Activity );
	likesQuery.include( 'photoPair' );
	likesQuery.include( 'photoPair.user' );
	likesQuery.include( 'fromUser' );
	likesQuery.include( 'toUser' );
	likesQuery.limit( 1000 );
	likesQuery.equalTo( 'photoPair', mockPhotoPair );
	likesQuery.equalTo( 'isArchiveReady', false );
	likesQuery.equalTo( 'type', likesPhotoIdentifier );
	var likesPromise = likesQuery.find();
	likesPromise.then( function( likeActivities ) {
		var payload = { likes: likeActivities };
		response.success(payload);
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
		query.equalTo( 'user', mockUser);
		query.equalTo( 'isArchiveReady', false );
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

			var followingObjectIds = [];
			_.each( scopedVars.followersAndFollowing, function(aFollowerOrFollowing) {
				var fromUser = aFollowerOrFollowing.get( 'fromUser' );
				if ( fromUser.id = currentUser.id ) {
					var followingUserObjectId = aFollowerOrFollowing.get( 'toUser' );
					followingObjectIds.push( followingUserObjectId );
				}
			});

			var feedItemValuesForPhotoPairObjectId = {};
			_.each( feedPhotos, function( aPhotoPair) {
				var aFeedItem = new feedItem.FeedItem( aPhotoPair );
				var photoPairUserObjectId = aPhotoPair.get('user').id;
				var isCurrentUserFollowing = _.indexOf( followingObjectIds, photoPairUserObjectId ) != -1;
				aFeedItem.isCurrentUserFollowing = isCurrentUserFollowing;
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



Parse.Cloud.define( 'removeFeedItem', function( request, response ) {
	var photoPairObjectId = request.params.photoPairObjectId;
	var PhotoPair = Parse.Object.extend( 'PhotoPair' );
	var mockPhotoPair = new PhotoPair();
	mockPhotoPair.id = photoPairObjectId;

	var Activity = Parse.Object.extend( 'Activity' );
	var activityQuery = new Parse.Query( Activity );
	activityQuery.include( 'photoPair' );
	activityQuery.equalTo( 'photoPair', mockPhotoPair );
	activityQuery.equalTo( 'isArchiveReady', false );
	activityQuery.limit( MAX_QUERY_LIMIT );
	var activityQueryPromise = activityQuery.find();
	activityQueryPromise.then( function( activityItems ) {
		_.each( activityItems, function( activityItem ) {
			activityItem.set( 'isArchiveReady', true );
		});

		mockPhotoPair.set( 'isArchiveReady', true );
		activityItems.push( mockPhotoPair );
		return Parse.Object.saveAll( activityItems );
	}).then( function( savedItems ) {
		response.success({});
	}, function( error ) {
		response.error( error );
	});
});

Parse.Cloud.define( 'usersWithSearchTerms', function( request, response ) {
	var searchTerms = request.params.searchTerms;
	var whenPromises = [];
	_.each( searchTerms, function( aSearchTerm ) {
		var userFirstNameQuery = new Query(Parse.User);
		userFirstNameQuery.limit(50);
		userFirstNameQuery.contains('firstName', aSearchTerm);
		whenPromises.push( userFirstNameQuery.find() );

		var userLastNameQuery = new Query(Parse.User);
		userLastNameQuery.limit(50);
		userLastNameQuery.contains('lastName', aSearchTerm);
		whenPromises.push( userLastNameQuery.find() );
	});

	var allResults = Parse.Promise.when( whenPromise );
	allResults.then( function() {
		var results = Array.prototype.slice.call(arguments);
		var uniqueUsers = {};
		_.each( results, function( someUsers ) {
			_.each( someUsers, function( aUser ) {
				var isUserUnique = !_.has( uniqueUsers, someUser.id );
				if ( isUserUnique ) {
					uniqueUsers[ someUser.id ] = someUser;
				}
			});
		});

		var users = _.values(uniqueUsers);
		var payload = { users: users };
		response.success(payload);
	}, function(error) {
		response.error( error );
	});
});




