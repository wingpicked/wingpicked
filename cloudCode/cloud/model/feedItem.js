
var _ = require( 'underscore' );

var ActivityType = {
	CommentImageOne: 0,
	CommentImageTwo: 1,
	LikeImageOne: 2,
	LikeImageTwo: 3,
	Follow: 4,
	Join: 5 
};

var PhotoUserLikes = {
    NoPhotoLiked : 0,
    FirstPhotoLiked : 1,
    SecondPhotoLiked : 2
};


var calculateLikePercentages = function() {
	var totalLikes = this.likesCountOne + this.likesCountTwo;
	if ( totalLikes > 0 ) {
		this.percentageLikedOne = ((this.likesCountOne * 1.0) / totalLikes ) * 100;
		this.percentageLikedTwo = ((this.likesCountTwo * 1.0) / totalLikes ) * 100;
	}
};


var addLikeActivity = function( anActivity ) {
	var activityType = anActivity.get( 'type' );
	if ( _.isEqual( activityType, ActivityType.LikeImageOne ) ) {
		this.likesCountOne = this.likesCountOne + 1;
		if ( anActivity.has( 'fromUser' ) ) {
			var fromUser = anActivity.get( 'fromUser' );
			var currentUser = Parse.User.current();
			if ( _.isEqual( fromUser.id, currentUser.id) ) {
				this.photoUserLikes = PhotoUserLikes.FirstPhotoLiked;
			}
		} 
	} else if ( _.isEqual( activityType, ActivityType.LikeImageTwo ) ) {
		this.likesCountTwo = this.likesCountTwo + 1;
		if ( anActivity.has( 'fromUser' ) ) {
			var fromUserTwo = anActivity.get( 'fromUser' );
			var currentUserTwo = Parse.User.current();
			if ( _.isEqual( fromUserTwo.id, currentUserTwo.id) ) {
				this.photoUserLikes = PhotoUserLikes.SecondPhotoLiked;
			}
		} 
	} else {
		console.error( 'tried to add like activity to FeedItem but activity was not of Like type' );
	}

	this.calculateLikePercentages();
};


var addCommentActivity = function( anActivity ) {
	var activityType = anActivity.get( 'type' );
	if ( _.isEqual( activityType, ActivityType.CommentImageOne ) ) {
		this.comments.commentsPhoto1.push( anActivity );
		this.commentsCountOne = this.comments.commentsPhoto1.length;
	} else if ( _.isEqual( activityType, ActivityType.CommentImageTwo ) ) {
		this.comments.commentsPhoto2.push( anActivity );
		this.commentsCountTwo = this.comments.commentsPhoto2.length;
	} else {
		console.error( 'tried to add a comment to FeedItem but activity was not a comment type' );
	}
 
};


var addActivity = function( anActivity ) {
	var activityType = anActivity.get( 'type' );
	if ( _.isEqual( activityType, ActivityType.CommentImageOne ) || _.isEqual( activityType, ActivityType.CommentImageTwo ) ) {
		this.addCommentActivity( anActivity );
		this.score = this.score + 1;
	} else if ( _.isEqual( activityType, ActivityType.LikeImageOne ) || _.isEqual( activityType, ActivityType.LikeImageTwo ) ) {
		this.addLikeActivity( anActivity );
		this.score = this.score + 5;
	} else {
		console.error( 'tried to add activity to FeedItem that was not a comment or like type' );
	}
};


var FeedItem = function( aPhotoPair ) {
	this.photoPair = aPhotoPair; // photos object
	this.caption = this.photoPair.has( 'caption' ) ? this.photoPair.get( 'caption' ) : ''; // string photoPair caption
	this.likesCountOne = 0;
	this.likesCountTwo = 0;
	this.commentsCountOne = 0;
	this.commentsCountTwo = 0;
	this.percentageLikedOne = 0.0;
	this.percentageLikedTwo = 0.0;
	this.score = 0;
	this.userLikesPhoto = PhotoUserLikes.NoPhotoLiked;
	this.username = aPhotoPair.has( 'user' ) ? aPhotoPair.get( 'user' ).getUsername() : '';

	// var userFriendlyTimestamp = new Date(); determined on client
	this.userProfilePicture = null; // pffile
	this.photoUserLikes = PhotoUserLikes.NoPhotoLiked;

	this.comments = { commentsPhoto1: [], commentsPhoto2: [] }; // array contain Activity objects

	this.addActivity = addActivity;
	this.addLikeActivity = addLikeActivity;
	this.addCommentActivity = addCommentActivity;
	this.calculateLikePercentages = calculateLikePercentages;
	// this.payload = payload;

};

exports.FeedItem = FeedItem;
exports.ActivityType = ActivityType;



