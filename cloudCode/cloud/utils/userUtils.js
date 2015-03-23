/**
 * Created by joshuabell on 3/22/15.
 */
var _ = require( 'underscore' );


var queryWithFollowingActivities = function( aUser, type ) {
    var Activity = Parse.Object.extend( 'Activity' );
    var notificatioQuery = new Parse.Query( Activity );
    notificatioQuery.include( 'photoPair' );
    notificatioQuery.include( 'fromUser' );
    notificatioQuery.include( 'toUser' );
    notificatioQuery.limit( 1000 );
    notificatioQuery.equalTo( 'fromUser', aUser );
    notificatioQuery.equalTo( 'notificationViewed', false );
    notificatioQuery.equalTo( 'isArchiveReady', false );
    notificatioQuery.equalTo( 'type', type );
    return notificatioQuery;
};


var queryWithFollowerActivities = function( aUser, type ) {
    var Activity = Parse.Object.extend( 'Activity' );
    var notificatioQuery = new Parse.Query( Activity );
    notificatioQuery.include( 'photoPair' );
    notificatioQuery.include( 'fromUser' );
    notificatioQuery.include( 'toUser' );
    notificatioQuery.limit( 1000 );
    notificatioQuery.equalTo( 'toUser', aUser );
    notificatioQuery.equalTo( 'notificationViewed', false );
    notificatioQuery.equalTo( 'isArchiveReady', false );
    notificatioQuery.equalTo( 'type', type );
    return notificatioQuery;
};


var queryWithFollowingAndFollowers = function( aUser, type ) {
    return Parse.Query.or( queryWithFollowerActivities( aUser, type ), queryWithFollowingActivities( aUser, type ) );
};

var isFollowingUserWithFollowActivities = function( aUser, followActivities ) {
    var isFollowingUser = false;
    _.each( followActivities, function( aFollowActivity ) {
        if ( aFollowActivity.has( 'toUser' ) ) {
            var followCandidate = aFollowActivity.get( 'toUser' );
            if( _.isEqual( followCandidate.id, aUser.id ) ) {
                isFollowingUser = true;
            }
        }
    });

    return isFollowingUser;
};

var isFollowerUserWithFollowActivities = function( aUser, followActivities ) {
    var isFollowingUser = false;
    _.each( followActivities, function( aFollowActivity ) {
        if ( aFollowActivity.has( 'fromUser' ) ) {
            var followCandidate = aFollowActivity.get( 'fromUser' );
            if( _.isEqual( followCandidate.id, aUser.id ) ) {
                isFollowingUser = true;
            }
        }
    });

    return isFollowingUser;
};


exports.queryWithFollowingActivities = queryWithFollowingActivities;
exports.queryWithFollowerActivities = queryWithFollowerActivities;
exports.queryWithFollowingAndFollowers = queryWithFollowingAndFollowers;

exports.isFollowingUserWithFollowActivities = isFollowingUserWithFollowActivities;
exports.isFollowerUserWithFollowActivities = isFollowerUserWithFollowActivities;

