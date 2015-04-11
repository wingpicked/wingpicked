/**
 * Created by joshuabell on 3/25/15.
 */
    var _ = require( 'underscore'),
    feedItem = require( 'cloud/model/feedItem' );


var processActivity = function( anActivity, reference, followingObjectIds ) {
    if ( anActivity.has( 'photoPair' ) ) {
        var photoPair = anActivity.get( 'photoPair' );
        var feedItemForPhotoPair = reference[ photoPair.id ];
        var photoPairUserObjectId = photoPair.user.id;
        var isCurrentUserFollowing = _.indexOf( followingObjectIds, photoPairUserObjectId ) != -1;
        if ( _.isUndefined( feedItemForPhotoPair ) ) {
            var aFeedItem = new feedItem.FeedItem( photoPair );
            aFeedItem.addActivity( anActivity );
            reference[ photoPair.id ] = aFeedItem;
            aFeedItem.isCurrentUserFollowing = isCurrentUserFollowing;
        } else {
            feedItemForPhotoPair.addActivity( anActivity );
            feedItemForPhotoPair.isCurrentUserFollowing = isCurrentUserFollowing;
        }
    }
};



var ExploreCalculator = function( likesPhotoOne, likesPhotoTwo, commentsPhotoOne, commentsPhotoTwo, followingActivities   ) {
    var feedItemForPhotosObjectId = {};
    var followingObjectIds = [];
    _.each( followingActivities, function( followingActivity ) {
        var followingUser = followingActivity.get( 'toUser' );
        followingObjectIds.push( followingUser.id );
    });

    _.each( likesPhotoOne, function( anActivity ) {
        processActivity( anActivity, feedItemForPhotosObjectId, followingObjectIds );
    });

    _.each( likesPhotoTwo, function( anActivity ) {
        processActivity( anActivity, feedItemForPhotosObjectId, followingObjectIds );
    });

    _.each( commentsPhotoOne, function( anActivity ) {
        processActivity( anActivity, feedItemForPhotosObjectId, followingObjectIds );
    });

    _.each( commentsPhotoTwo, function( anActivity ) {
        processActivity( anActivity, feedItemForPhotosObjectId, followingObjectIds );
    });

    var someFeedItems = _.values( feedItemForPhotosObjectId );
    this.feedItemsPayload = _.sortBy( someFeedItems, function( aFeedItem ) {
       return -aFeedItem.score;
    });

};

exports.ExploreCalculator = ExploreCalculator;
