//
//  HomeFeedViewController.m
//  instagram
//
//  Created by kfullen on 7/8/19.
//  Copyright © 2019 kfullen. All rights reserved.
//

#import "HomeFeedViewController.h"
#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import "PostCell.h"
#import "Post.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"

@interface HomeFeedViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *composeButton;
@property (weak, nonatomic) IBOutlet UITableView *postsTableView;
@property (strong,nonatomic) NSArray *posts;
@property (strong,nonatomic) UIImage *passedImage;

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.postsTableView.dataSource = self;
    self.postsTableView.delegate = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    [self fetchPosts];
    
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.postsTableView insertSubview:refreshControl atIndex:0];
    
}
- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        appDelegate.window.rootViewController = loginViewController;
    }];
}
- (IBAction)takePhoto:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    self.passedImage = originalImage;
    NSLog(@"Image passed!");
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"feedToComposeSegue" sender:self];
}

- (void)fetchPosts {
    // construct query
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Post"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery includeKey:@"image"];
    [postQuery includeKey:@"caption"];
    postQuery.limit = 20;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            // do something with the data fetched
            self.posts = posts;
            NSLog(@"Fetched posts successfully");
            
            // reload data
            [self.postsTableView reloadData];
        }
        else {
            // handle error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    PostCell *cell = [self.postsTableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *post = self.posts[indexPath.row];
    NSLog(@"post: %@",post);
    cell.post = post;
    
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    // construct query
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Post"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery includeKey:@"image"];
    [postQuery includeKey:@"caption"];
    postQuery.limit = 20;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            // do something with the data fetched
            self.posts = posts;
            NSLog(@"Refreshed posts successfully");
            [refreshControl endRefreshing];
            
            // reload data
            [self.postsTableView reloadData];
        }
        else {
            // handle error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"feedToComposeSegue"]) {
    // Get the new view controller using [segue destinationViewController].
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeViewController = (ComposeViewController*)navigationController.topViewController;
    
        // Pass the selected object to the new view controller.
        composeViewController.passedImage = self.passedImage;
    }
    else {
        // Get the new view controller using [segue destinationViewController].
        UITableViewCell *tappedCell = sender; //grabs id of cell
        NSIndexPath *indexPath = [self.postsTableView indexPathForCell:tappedCell]; // grabs index of cell in table view
        Post *post = self.posts[indexPath.row]; //grabs post from array of posts using index
        DetailsViewController *detailsController = [segue destinationViewController];
        
        // Pass the selected object to the new view controller.
        detailsController.post = post;
    }
}

@end
