//
//  CNRegistrationViewController.h
//  ClearNote
//
//  Created by Jitendra Agarwal on 27/11/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//

#import "CNBaseViewController.h"
#import "CNHelper.h"
#import "CNAllNotsListViewController.h"
@interface CNRegistrationViewController : CNBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnNameCross;
@property (weak, nonatomic) IBOutlet UIButton *btnEmailCross;
@property (weak, nonatomic) IBOutlet UIButton *btnPasswordCross;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollBG;
@property (strong, nonatomic) IBOutlet UIView *viewBGBox;
@property (strong, nonatomic) IBOutlet UIButton *btnSignUp;

- (IBAction)actionCrossBack:(id)sender;
- (IBAction)actionSignUp:(id)sender;



@end
