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

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

@end
