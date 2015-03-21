

function notificationQueryWithType( type ) {
    var Activity = Parse.Object.extend( 'Activity' );
    var notificatioQuery = new Parse.Query( Activity );
    notificatioQuery.include( 'photoPair' );
    notificatioQuery.include( 'fromUser' );
    notificatioQuery.include( 'toUser' );
    notificatioQuery.limit( MAX_QUERY_LIMIT );
    notificatioQuery.equalTo( 'toUser', aUser );
    notificatioQuery.equalTo( 'notificationViewed', false );
    notificatioQuery.equalTo( 'isArchiveReady', false );
    notificatioQuery.equalTo( 'type', type );
    return notificatioQuery;
}

var queryForNotificationsWithUser = function( aUser, feedItem ) {

    var followQuery = notificationQueryWithType( feedItem.ActivityType.Follow );
    var commentsOnPhoto1 = notificationQueryWithType( feedItem.ActivityType.CommentImageOne );
    var commentsOnPhoto2 = notificationQueryWithType( feedItem.ActivityType.CommentImageTwo );
    var likeOnPhoto1 = notificationQueryWithType( feedItem.ActivityType.LikeImageOne );
    var likeOnPhoto2 = notificationQueryWithType( feedItem.ActivityType.LikeImageTwo );
    return Parse.Query.or( followQuery, commentsOnPhoto1, commentsOnPhoto2, likeOnPhoto1, likeOnPhoto2 );
};


var ProfileInfo = function() {
    this.postsCount = 0;
    this.followersCount = 0; 
    this.isFollowing = 0;

    this.posts = []; // PFUSer
    this.followers = []; // PFUSer
    this.following = []; // PFUSer
    this.notifications = []; // Activity
};

exports.ProfileInfo = ProfileInfo;
exports.queryForNotificationsWithUser = queryForNotificationsWithUser;
    