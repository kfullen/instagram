//
//  PostCell.m
//  instagram
//
//  Created by kfullen on 7/9/19.
//  Copyright © 2019 kfullen. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(Post *)post {
    _post = post;
    PFFileObject *image = post.image;
    [image getDataInBackgroundWithBlock:^(NSData * data, NSError * error) {
        if (!error) {
            NSLog(@"Displaying photo");
            UIImage *imageToLoad = [UIImage imageWithData:data];
            [self.postImageView setImage:imageToLoad];
        }
        else {
            NSLog(@"%@",error.localizedDescription);
        }
       
    }];
    
    self.captionLabel.text = post.caption;
    self.usernameLabel.text = post.author.username;
}

@end
