




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
    