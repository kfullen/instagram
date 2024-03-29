//
//  DetailsViewController.m
//  instagram
//
//  Created by kfullen on 7/10/19.
//  Copyright © 2019 kfullen. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *detailsImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // post image is a PFFileObject, have to convert to UIImage
    PFFileObject *image = self.post.image;
    [image getDataInBackgroundWithBlock:^(NSData * data, NSError * error) {
        if (!error) {
            NSLog(@"Displaying photo");
            UIImage *imageToLoad = [UIImage imageWithData:data];
            [self.detailsImageView setImage:imageToLoad];
        }
        else {
            NSLog(@"%@",error.localizedDescription);
        }
        
    }];
    
    // set other views
    self.captionLabel.text = self.post.caption;
    self.usernameLabel.text = self.post.author.username;
    self.likesLabel.text = self.post.likes;
    
    NSDate *createdAt = self.post.createdAt;
    NSString *timestamp = [createdAt timeAgoSinceNow];
    self.timestampLabel.text = timestamp;
    
    [self.timestampLabel sizeToFit];
    [self.captionLabel sizeToFit];
    [self.usernameLabel sizeToFit];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
