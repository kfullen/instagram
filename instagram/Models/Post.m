//
//  Post.m
//  instagram
//
//  Created by kfullen on 7/9/19.
//  Copyright © 2019 kfullen. All rights reserved.
//

#import "Post.h"

@implementation Post

@dynamic postID;
@dynamic userID;
@dynamic caption;
@dynamic image;
@dynamic author;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) postUserImage: (UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.caption = caption;
    
    int likes = 0;
    newPost.likes = [NSString stringWithFormat:@"%d likes",likes];
    
    [newPost saveInBackgroundWithBlock: completion];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}
@end
