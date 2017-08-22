//
//  CNWelcomeViewController.m
//  ClearNote
//
//  Created by Jitendra Agarwal on 27/11/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//

#import "CNWelcomeViewController.h"
#import "CNRegistrationViewController.h"
#import "CNLoginViewController.h"
@interface CNWelcomeViewController ()

@end

@implementation CNWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
[[UIApplication sharedApplication] setStatusBarHidden:YES];
[self.navigationController setNavigationBarHidden:YES];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
#pragma mark- Button Action
- (IBAction)actionSignWithAccount:(id)sender
{

    CNLoginViewController *loginVC = (CNLoginViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"CNLoginViewController"];
  // [self presentViewController:loginVC animated:YES completion:nil];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
    //[self.navigationController pushViewController:loginVC animated:YES];
  
}
- (IBAction)actionSignWithEmail:(id)sender
{
    CNRegistrationViewController *registrationVC = (CNRegistrationViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"CNRegistrationViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:registrationVC];
   [self.navigationController presentViewController:navigationController animated:YES completion:nil];
    // [self presentViewController:registrationVC animated:YES completion:nil];
    //[self.navigationController pushViewController:registrationVC animated:YES];

}
@end
