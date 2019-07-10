//
//  PostCell.h
//  instagram
//
//  Created by kfullen on 7/9/19.
//  Copyright © 2019 kfullen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@property (strong,nonatomic) Post *post;

@end

NS_ASSUME_NONNULL_END
