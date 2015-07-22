

function notificationQueryWithType( user, type ) {
    var Activity = Parse.Object.extend( 'Activity' );
    var notificatioQuery = new Parse.Query( Activity );
    notificatioQuery.include( 'photoPair' );
    notificatioQuery.include( 'fromUser' );
    notificatioQuery.include( 'toUser' );
    notificatioQuery.limit( 100 );
    notificatioQuery.equalTo( 'toUser', user );
    //notificatioQuery.equalTo( 'notificationViewed', false );
    notificatioQuery.equalTo( 'isArchiveReady', false );
    notificatioQuery.equalTo( 'type', type );
    notificatioQuery.descending( 'createdAt' );
    return notificatioQuery;
}

function removeResultsOriginallyFromUser( aQuery, fromUser ) {
    aQuery.notEqualTo( 'fromUser', fromUser );
}

var queryForNotificationsWithUser = function( aUser, feedItem ) {

    var followQuery = notificationQueryWithType( aUser, feedItem.ActivityType.Follow );
    var commentsOnPhoto1 = notificationQueryWithType( aUser,  feedItem.ActivityType.CommentImageOne );
    var commentsOnPhoto2 = notificationQueryWithType( aUser, feedItem.ActivityType.CommentImageTwo );
    var likeOnPhoto1 = notificationQueryWithType( aUser, feedItem.ActivityType.LikeImageOne );
    var likeOnPhoto2 = notificationQueryWithType( aUser, feedItem.ActivityType.LikeImageTwo );
    removeResultsOriginallyFromUser( commentsOnPhoto1, aUser );
    removeResultsOriginallyFromUser( commentsOnPhoto2, aUser );
    removeResultsOriginallyFromUser( likeOnPhoto1, aUser );
    removeResultsOriginallyFromUser( likeOnPhoto2, aUser );
    return Parse.Query.or( followQuery, commentsOnPhoto1, commentsOnPhoto2, likeOnPhoto1, likeOnPhoto2 );
};


var ProfileInfo = function() {
    this.postsCount = 0;
    this.followersCount = 0;
    this.followingCount = 0;
    this.isFollowing = false;

    this.posts = []; // PFUSer
    this.followers = []; // PFUSer
    this.following = []; // PFUSer
    this.notifications = []; // Activity
};

exports.ProfileInfo = ProfileInfo;
exports.queryForNotificationsWithUser = queryForNotificationsWithUser;
    