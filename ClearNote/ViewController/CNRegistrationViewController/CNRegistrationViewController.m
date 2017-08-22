//
//  CNRegistrationViewController.m
//  ClearNote
//
//  Created by Jitendra Agarwal on 27/11/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//

#import "CNRegistrationViewController.h"

@interface CNRegistrationViewController ()
{
    IBOutlet UITextField *activeField;
}
@end
@implementation CNRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnSignUp.layer.cornerRadius = 3.0;

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
        [self.txtName becomeFirstResponder];
    [self intinalSetup];
    [self buttonIntinalSetup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)intinalSetup
{ [self.navigationController setNavigationBarHidden:YES];
    UITapGestureRecognizer *_gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:_gestureRecognizer];
    [self.txtName setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtEmail setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtPassword setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
}
-(void)buttonIntinalSetup
{
    [self hideCrossBtn];
    [self.btnNameCross addTarget:self action:@selector(btnCrossAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnEmailCross addTarget:self action:@selector(btnCrossAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPasswordCross addTarget:self action:@selector(btnCrossAction:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark- button Action
- (IBAction)actionCrossBack:(id)sender {
       [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionSignUp:(id)sender {
    [self.view endEditing:YES];
    [self loderStop:self.view];
    self.btnSignUp.userInteractionEnabled = NO;
    if(![self ValidateFields])
    {
        return;
    }
    [self postDataforRequestId:Request_User_Registration];
}
#pragma text field delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtName) {
       // [textField resignFirstResponder];
        [self.txtEmail becomeFirstResponder];
    }
    if (textField == self.txtEmail) {
       // [textField resignFirstResponder];
        [self.txtPassword becomeFirstResponder];
    }
    if(textField==self.txtPassword)
    {
       // [textField resignFirstResponder];
        [self actionSignUp:nil];
    }
    [textField resignFirstResponder];
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
-(void)updateTextLabelsWithText:(NSString *)string textField:(UITextField *)textField
{
    if([string length] > 0 && textField == self.txtName)
    {
        self.btnNameCross.hidden = NO;
    }
    else if(![string length] > 0 && textField == self.txtName)
    {
        self.btnNameCross.hidden = YES;
    }
    else if([string length] > 0 && textField == self.txtEmail)
    {
        self.btnEmailCross.hidden = NO;
    }
    else if(![string length] > 0 && textField == self.txtEmail)
    {
        self.btnEmailCross.hidden = YES;
    }
    else if([string length] > 0 && textField == self.txtPassword)
    {
        self.btnPasswordCross.hidden = NO;
    }
    else if(![string length] > 0 && textField == self.txtPassword)
    {
        self.btnPasswordCross.hidden = YES;
    }
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if([UIScreen mainScreen].bounds.size.height >= 667)
    {
        self.scrollBG.scrollEnabled = NO;
        
    }
    else if([UIScreen mainScreen].bounds.size.height >= 568)
    {
        self.scrollBG.scrollEnabled = NO;
        [self.scrollBG setContentOffset:CGPointMake(0,60) animated:YES];
    }
    else
    {
        self.scrollBG.scrollEnabled = YES;
        [self.scrollBG setContentOffset:CGPointMake(0,75) animated:YES];
    }
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.scrollBG.scrollEnabled = NO;
    self.scrollBG.contentInset = UIEdgeInsetsMake(0, 0, 0,0 );
    self.scrollBG.contentOffset = CGPointMake(0, 0);
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    self.scrollBG.contentInset = UIEdgeInsetsMake(0,0,100,0);
    }
#pragma user define function
- (void)dismissKeyboard:(UITapGestureRecognizer*)sender
{
    [self.view endEditing:YES];
}
#pragma mark-  userDefine function
#pragma mark-  ValidateFields
-(BOOL)ValidateFields
{
    BOOL result = YES;
    if([[self trim:self.txtName.text]length] == 0)
    {
        [self showMessage:@"Please enter a name" withTitle:@""];
        result = NO;
    }
    else if([[self trim:self.txtEmail.text]length] == 0)
    {
        [self showMessage:@"Please enter a valid email address" withTitle:@""];
        result = NO;
    }
    else if([[self trim:self.txtPassword.text]length] == 0)
    {
        [self showMessage:@"Please enter a password. Use at least five characters." withTitle:@""];
        result = NO;
    }
    else if(![self validateEmail:self.txtEmail.text])
    {
        NSLog(@"%@",self.txtEmail.text);
        [self showMessage:@"Please enter a valid email address" withTitle:@""];
        result = NO;
        
    }
    else if([[self trim:self.txtPassword.text]length] < 5)
    {
        [self showMessage:@"Password is too short. Use at least five characters." withTitle:@""];
        result = NO;
    }
     self.btnSignUp.userInteractionEnabled = YES;
    return result;
}
// This function hide all cross button.
-(void)hideCrossBtn
{   [self.btnNameCross setHidden:YES];
    [self.btnEmailCross setHidden:YES];
    [self.btnPasswordCross setHidden:YES];
}
//This function acttionm for all cross button
-(void)btnCrossAction:(UIButton *)sender
{
    if(sender.tag==101)
    {
        self.txtName.text = @"";
        [self updateTextLabelsWithText:self.txtName.text textField:self.txtName];
    }
    else if(sender.tag ==102)
    {
        self.txtEmail.text = @"";
        [self updateTextLabelsWithText:self.txtEmail.text textField:self.txtEmail];
    }
    else if(sender.tag ==103)
    {
        self.txtPassword.text = @"";
        [self updateTextLabelsWithText: self.txtPassword.text textField: self.txtPassword];
    }
}
#pragma mark -
#pragma mark Handel Response
-(void)postDataforRequestId:(int) requestId
{
    if(requestId == Request_User_Registration)
    {
     
        if ([[AFNetworkReachabilityManager sharedManager] isReachable])
        {
               [self loderStart:self.view strLbl:@"Loading"];
            [[CNRequestController sharedInstance]CNRequestRegistrationWithEmail:_txtEmail.text password:_txtPassword.text userName:_txtName.text success:^(id responseDict) {
                if (responseDict != (id)[NSNull null])
                {
                            [self loderStop:self.view];
                    [self notifyRequesterWithData:responseDict forRequest:Request_User_Registration];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                self.btnSignUp.userInteractionEnabled = YES;
                [self loderStop:self.view];
                [self showMessage:OflineMessge withTitle:AlertTitle];
            }];
        }
        else
        {   self.btnSignUp.userInteractionEnabled = YES;
            // net is not working
            [self loderStop:self.view];
            [self showMessage:OflineMessge withTitle:AlertTitle];
        }
        
    }
}
-(void)notifyRequesterWithData:(id) responseData forRequest:(int) requestId
{
    if(requestId == Request_User_Registration)
    {
        [self loderStop:self.view];
        
        NSString *message = nil;
        NSString *code = responseData[@"ResponseCode"];
        message = responseData[@"ResponseDetails"];
        if([code isEqualToString:@"200"])
        {
            self.btnSignUp.userInteractionEnabled = YES;
            // store the details in local database
            [CNDataHelper CNdBInsertUserDetailsWithUserID:responseData[@"userId"] userName:responseData[@"userName"]  userPassword:responseData[@"password"]  email:responseData[@"emailId"] ];
            Set_UserEmail(@"CNLoginEmail", responseData[@"emailId"]);
            Set_UserID(@"CNLoginID", responseData[@"userId"]);
            Set_UserName(@"CNUserName", responseData[@"userName"]);
            Defaults_set_bool_sort(kSortStatus, YES);
         //   Defaults_set_bool_onoff(kSysncStatus, NO);
            Defaults_set_bool_onoff(kSysncStatus, YES);
            Defaults_set_bool_manual_SyncStatus(kManualySync, NO);
            Defaults_set_bool_BackgroundSync(kBackgroundSync, YES);// not sync
            NSString *timeStamp = [[CNHelper sharedInstance]gettimestampStringFroLocalTime];
            Set_TimeStamp(kTimeStamp,timeStamp);
            NSString *currentDeviceID = [[CNHelper  sharedInstance]getDeviceID];
            Set_DeviceID(kCurrentDeviceID, currentDeviceID);
          
            [CNHelper sharedInstance].userLoginID = responseData[@"userId"];
            [CNHelper sharedInstance].userName = responseData[@"userName"];
            [CNHelper sharedInstance].userLoginEmail = responseData[@"emailId"];
            CNAllNotsListViewController *allNoteListVC = (CNAllNotsListViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"CNAllNotsListViewController"];
            [self loderStop:self.view];
            CATransition* transition = [CATransition animation];
            transition.duration = 0.3;
            transition.type = kCATransitionReveal;
            transition.subtype = kCATransitionFromBottom;
            [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
            [self.navigationController pushViewController:allNoteListVC animated:NO];
            //[self. navigationController pushViewController:allNoteListVC animated:YES];
        }
        else if([code isEqualToString:@"201"])

        {
            self.btnSignUp.userInteractionEnabled = YES;
            [self loderStop:self.view];
            message = @"This email is already in use";
            [self showMessage:message withTitle:AlertTitle];
        }
    }
}
@end
