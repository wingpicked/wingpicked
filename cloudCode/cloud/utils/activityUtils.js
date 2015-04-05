/**
 * Created by joshuabell on 3/25/15.
 */

var moment = require( 'moment' );


function exploreQueryWithType( aType ) {
    var currentMoment = moment();
    var sevenDaysAgo = currentMoment.day( -7 );

    var Activity = Parse.Object.extend( 'Activity' );
    var activityQuery = new Parse.Query( Activity );
    activityQuery.include( 'photoPair' );
    activityQuery.include( 'photoPair.user' );
    activityQuery.include( 'photoPair.photoOne' );
    activityQuery.include( 'photoPair.photoTwo' );
    activityQuery.limit( 1000 );
    activityQuery.greaterThan( 'createdAt', sevenDaysAgo.toDate() );
    activityQuery.descending( 'createdAt' );
    activityQuery.equalTo( 'type', aType );
    return activityQuery;
};


var queryForExploreActivities = function( activityType ) {
    var likeImageOneQuery = exploreQueryWithType( activityType.LikeImageOne );
    var likeImageTwoQuery = exploreQueryWithType( activityType.LikeImageTwo );
    var commentImageOneQuery = exploreQueryWithType( activityType.CommentImageOne );
    var commentImageTwoQuery = exploreQueryWithType( activityType.CommentImageTwo );
    return Parse.Promise.when( likeImageOneQuery.find(), likeImageTwoQuery.find(), commentImageOneQuery.find(), commentImageTwoQuery.find()  );
};

exports.queryForExploreActivities = queryForExploreActivities;

