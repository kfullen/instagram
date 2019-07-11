//
//  ComposeViewController.m
//  instagram
//
//  Created by kfullen on 7/9/19.
//  Copyright © 2019 kfullen. All rights reserved.
//

#import "ComposeViewController.h"
#import "Post.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UITextField *captionTextField;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.postImageView.image = self.passedImage;
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}



- (IBAction)didTapShare:(id)sender {
    CGSize size = CGSizeMake(400, 400);
    UIImage *resizedImage = [self resizeImage:self.passedImage withSize:size];
    for (int i=0; i<20; i++) {
        [Post postUserImage:resizedImage withCaption:self.captionTextField.text withCompletion:^(BOOL succeeded, NSError *_Nullable error){
            if (succeeded){
                NSLog(@"User successfully posted");
            }
            else {
                 NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
    [self dismissViewControllerAnimated:true completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
