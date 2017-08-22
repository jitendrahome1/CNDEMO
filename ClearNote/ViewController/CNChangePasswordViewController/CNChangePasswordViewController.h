//
//  CNChangePasswordViewController.h
//  ClearNote
//
//  Created by Jitendra Agarwal on 27/11/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//

#import "CNBaseViewController.h"
#import "CNHelper.h"
@interface CNChangePasswordViewController : CNBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *txtCurrentPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnCurrtPasswordCross;
@property (weak, nonatomic) IBOutlet UIButton *btnNewPasswordCross;
@property (weak, nonatomic) IBOutlet UIButton *btnConfmPasswordCross;
@property (strong, nonatomic) IBOutlet UIView *ViewBGBox;

- (IBAction)actionCrossBack:(id)sender;
- (IBAction)actionSave:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollBG;

@end
