
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




var photosPair = null; // photos object
var caption = ''; // string photoPair caption
var likesCountOne = 0;
var likesCountTwo = 0;
var commentsCountOne = 0;
var commentsCountTwo = 0;
var percentageLikedOne = 0;
var percentageLikedTwo = 0;
var username = '';
// var userFriendlyTimestamp = new Date(); determined on client
var userProfilePicture = null; // pffile
var photoUserLikes = PhotoUserLikes.NoPhotoLiked;

var comments = { commentsPhoto1: [], commentsPhoto2: [] };




var payload = function() {



};

var Activity = {



};

exports.payload = payload;