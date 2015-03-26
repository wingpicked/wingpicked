/**
 * Created by joshuabell on 3/25/15.
 */
    var _ = require( 'underscore'),
    feedItem = require( 'cloud/model/feedItem' );


var processActivity = function( anActivity, reference ) {
    if ( anActivity.has( 'photoPair' ) ) {
        var photoPair = anActivity.get( 'photoPair' );
        var feedItemForPhotoPair = reference[ photoPair.id ];
        if ( _.isUndefined( feedItemForPhotoPair ) ) {
            var aFeedItem = new feedItem.FeedItem( photoPair );
            aFeedItem.addActivity( anActivity );
            reference[ photoPair.id ] = aFeedItem;
        } else {
            feedItemForPhotoPair.addActivity( anActivity );
        }
    }
};



var ExploreCalculator = function( likesPhotoOne, likesPhotoTwo, commentsPhotoOne, commentsPhotoTwo   ) {
    var feedItemForPhotosObjectId = {};

    this.processActivity = processActivity;
    _.each( likesPhotoOne, function( anActivity ) {
        processActivity( anActivity, feedItemForPhotosObjectId );
    });

    _.each( likesPhotoTwo, function( anActivity ) {
        processActivity( anActivity, feedItemForPhotosObjectId );
    });

    _.each( commentsPhotoOne, function( anActivity ) {
        processActivity( anActivity, feedItemForPhotosObjectId );
    });

    _.each( commentsPhotoTwo, function( anActivity ) {
        processActivity( anActivity, feedItemForPhotosObjectId );
    });

    var someFeedItems = _.values( feedItemForPhotosObjectId );
    this.feedItemsPayload = _.sortBy( someFeedItems, function( aFeedItem ) {
       return -aFeedItem.score;
    });

};

exports.ExploreCalculator = ExploreCalculator;
