//
//  DetailsViewController.h
//  instagram
//
//  Created by kfullen on 7/10/19.
//  Copyright © 2019 kfullen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "DateTools.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (strong, nonatomic) Post *post;
@end

NS_ASSUME_NONNULL_END
