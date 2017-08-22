//
//  CNChangePasswordViewController.m
//  ClearNote
//
//  Created by Jitendra Agarwal on 27/11/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//

#import "CNChangePasswordViewController.h"
#import "CNCreateNewNoteViewController.h"
@interface CNChangePasswordViewController ()
{
    IBOutlet UITextField *activeField;
}

@end
@implementation CNChangePasswordViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollBG.scrollEnabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [self.txtCurrentPassword becomeFirstResponder];
    
    
    [self intinalSetup];
    [self buttonIntinalSetup];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
-(void)intinalSetup
{
    
    UITapGestureRecognizer *_gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:_gestureRecognizer];
    [self.txtCurrentPassword setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtNewPassword setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtConfirmPassword setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)buttonIntinalSetup
{
    [self hideCrossBtn];
    [self.btnCurrtPasswordCross addTarget:self action:@selector(btnCrossAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnNewPasswordCross addTarget:self action:@selector(btnCrossAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnConfmPasswordCross addTarget:self action:@selector(btnCrossAction:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark- button Action
- (IBAction)actionCrossBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionSave:(id)sender
{
    [self.view endEditing:YES];
    if(![self ValidateFields])
    {
        return;
    }
    [self loderStart:self.view strLbl:@"Loading"];
    [self postDataforRequestId:Request_Change_Password];
}
#pragma text field delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtCurrentPassword) {
    //    [textField resignFirstResponder];
        [self.txtNewPassword becomeFirstResponder];
    }
    if (textField == self.txtNewPassword) {
      //  [textField resignFirstResponder];
        [self.txtConfirmPassword becomeFirstResponder];
    }
    if(textField==self.txtConfirmPassword)
    {
      //  [textField resignFirstResponder];
        [self actionSave:nil];
    }
    [textField resignFirstResponder];
    return YES;
}
#pragma user define function
- (void)dismissKeyboard:(UITapGestureRecognizer*)sender
{
    [self.view endEditing:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString {
    NSString *currentString;
    if (textField.text) {
        currentString = [textField.text stringByReplacingCharactersInRange:range withString:replacementString];
        if([currentString length] > 0)
        {
            [self updateTextLabelsWithText: [self trim:currentString] textField:textField];
        }
        else
        {
            textField.text = @"";
            [self updateTextLabelsWithText: [self trim:currentString] textField:textField];
        }
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if([UIScreen mainScreen].bounds.size.height >= 568)
    {
        self.scrollBG.scrollEnabled = NO;
        
    }
    else
    {
        [self.scrollBG setContentOffset:CGPointMake(0,60) animated:YES];
        }
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.scrollBG.scrollEnabled = NO;
    self.scrollBG.contentInset = UIEdgeInsetsMake(0, 0, 0,0 );
    self.scrollBG.contentOffset = CGPointMake(0, 0);
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    self.scrollBG.contentInset = UIEdgeInsetsMake(0,0,50,0);
    
}
-(void)updateTextLabelsWithText:(NSString *)string textField:(UITextField *)textField
{
    if([string length] > 0 && textField == self.txtCurrentPassword)
    {
        self.btnCurrtPasswordCross.hidden = NO;
    }
    else if(![string length] > 0 && textField == self.txtCurrentPassword)
    {
        self.btnCurrtPasswordCross.hidden = YES;
    }
    else if([string length] > 0 && textField == self.txtNewPassword)
    {
        self.btnNewPasswordCross.hidden = NO;
    }
    else if(![string length] > 0 && textField == self.txtNewPassword)
    {
        self.btnNewPasswordCross.hidden = YES;
    }
    else if([string length] > 0 && textField == self.txtConfirmPassword)
    {
        self.btnConfmPasswordCross.hidden = NO;
    }
    else if(![string length] > 0 && textField == self.txtConfirmPassword)
    {
        self.btnConfmPasswordCross.hidden = YES;
    }
}
#pragma mark-  userDefine function
#pragma mark-  ValidateFields
-(BOOL)ValidateFields
{
    BOOL result = YES;
    if([[self trim:self.txtCurrentPassword.text]length] == 0)
    {
        [self showMessage:@"Please enter current password" withTitle:@""];
        result = NO;
    }
    else if([[self trim:self.txtNewPassword.text]length] == 0)
    {
        [self showMessage:@"Please enter a new password. Use at least five characters." withTitle:@""];
        result = NO;
    }
    
    else if([[self trim:self.txtNewPassword.text]length] < 5)
    {
        [self showMessage:@"Password is too short. Use at least five characters." withTitle:@""];
        result = NO;
    }
    else if([[self trim:self.txtConfirmPassword.text]length] == 0)
    {
        [self showMessage:@"The new passwords do not match." withTitle:@""];
        result = NO;
    }
    else if(![self.txtNewPassword.text isEqual:self.txtConfirmPassword.text])
    {
        [self showMessage:@"The new passwords do not match." withTitle:@""];
        result = NO;
        
    }
    else if([self.txtCurrentPassword.text isEqual:self.txtNewPassword.text])
    {
        [self showMessage:@"The new password must be different from the current password." withTitle:@""];
        result = NO;
        
    }
    
    return result;
}
// This function hide all cross button.
-(void)hideCrossBtn
{
    [self.btnCurrtPasswordCross setHidden:YES];
    [self.btnNewPasswordCross setHidden:YES];
    [self.btnConfmPasswordCross setHidden:YES];
}
//This function acttionm for all cross button
-(void)btnCrossAction:(UIButton *)sender
{
    if(sender.tag==101)
    {
        self.txtCurrentPassword.text = @"";
        [self updateTextLabelsWithText:   self.txtCurrentPassword.text textField:   self.txtCurrentPassword];
    }
    else if(sender.tag ==102)
    {
        self.txtNewPassword.text = @"";
        [self updateTextLabelsWithText:self.txtNewPassword.text textField: self.txtNewPassword];
    }
    else if(sender.tag ==103)
    {
        self.txtConfirmPassword.text = @"";
        [self updateTextLabelsWithText:self.txtConfirmPassword.text textField:self.txtConfirmPassword];
    }
}

#pragma mark -
#pragma mark Handel Response
-(void)postDataforRequestId:(int) requestId
{
    NSLog(@"%@",[CNHelper sharedInstance].userLoginID);
    if(requestId == Request_Change_Password)
    {
        if ([[AFNetworkReachabilityManager sharedManager] isReachable])
        {
            [[CNRequestController sharedInstance]CNRequestChnagePasswordWithUserID:[CNHelper sharedInstance].userLoginID oldPassword:_txtCurrentPassword.text newPassword:_txtNewPassword.text success:^(id responseDict) {
                
                if (responseDict != (id)[NSNull null])
                {
                    [self notifyRequesterWithData:responseDict forRequest:Request_Change_Password];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self loderStop:self.view];
                [self showMessage:OflineMessge withTitle:AlertTitle];
            }];
        }
        else
        {
            [self loderStop:self.view];
            [self showMessage:OflineMessge withTitle:AlertTitle];
        }
    }
}
-(void)notifyRequesterWithData:(id) responseData forRequest:(int) requestId
{
    if(requestId == Request_Change_Password)
    {
        [self loderStop:self.view];
        NSString *message = nil;
        NSString *code = responseData[@"ResponseCode"];
        message = responseData[@"ResponseDetails"];
        if([code isEqualToString:@"200"])
        {
            [CNDataHelper CNdBInsertUserDetailsWithUserID:[CNHelper sharedInstance].userLoginID userName:[CNHelper sharedInstance].userName userPassword:_txtNewPassword.text email:[CNHelper sharedInstance].userLoginEmail];
            //  [self showMessage:message withTitle:AlertTitle];
            
            [UIAlertView showWithTitle:@"" message:message cancelButtonTitle:nil otherButtonTitles:@[@"OK"] withCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if(buttonIndex == 0)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
            
        }
        else
        {
            [self showMessage:message withTitle:AlertTitle];
            
        }
    }
}
@end
