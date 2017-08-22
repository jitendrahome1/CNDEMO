//
//  CNForgotPasswordViewController.m
//  ClearNote
//
//  Created by Jitendra Agarwal on 14/12/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//

#import "CNForgotPasswordViewController.h"
#import "CNLoginViewController.h"
@interface CNForgotPasswordViewController ()<CNCustomAlertDelegte>
{
    BOOL IsBack;
}

@end
@implementation CNForgotPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    self.scrollViewBG.scrollEnabled = NO;
    self.btnReset.layer.cornerRadius = 3.0;
    [self intinalSetup];
    [self buttonIntinalSetup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  }
-(void)intinalSetup
{
    UITapGestureRecognizer *_gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:_gestureRecognizer];
    [self.txtEmail setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
   
}

//-(void)viewWillDisappear:(BOOL)animated  {
//    
//    //---removes the notifications for keyboard---
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self.txtEmail becomeFirstResponder];
   }
-(void)buttonIntinalSetup
{
    [self hideCrossBtn];
    [self.btnEmailCross addTarget:self action:@selector(btnCrossAction:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark- button action
- (IBAction)actionCrossBack:(id)sender {
  //  [self.view endEditing:NO];
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)actionResetpassword:(id)sender {
    [self.txtEmail resignFirstResponder];
    self.btnReset.userInteractionEnabled = NO;
    if(![self ValidateFields])
    {
        return;
    }
   // [self loderStart:self.view strLbl:@"Loading"];
    [self postDataforRequestId:Request_Reset_Password];
}
-(void)donePopupText
{
    if(IsBack)
    {
        [self loderStop:self.view];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self loderStop:self.view];
    }
}
# pragma mark-
#pragma mark- Custom Alert Show
-(void)showAlertPopup:(NSString *)titlle
{
    self.btnReset.userInteractionEnabled = YES;
    alertViewCustom = [CNCustomAlert instantiateFromNib];
    alertViewCustom.viewBox.layer.cornerRadius = 3.0f;
    alertViewCustom.delegate = self;
    alertViewCustom.lblAlertMessage.font = [UIFont fontWithName:@"Futura-Light" size:18];
    alertViewCustom.lblAlertMessage.text = titlle;
    if(IS_IPHONE_4 || IS_IPHONE_4s)
    alertViewCustom.constantHight.constant = self.btnReset.frame.origin.y+98;
    else
    alertViewCustom.constantHight.constant = self.btnReset.frame.origin.y+98;
    [self.view addSubview:alertViewCustom];
    [alertViewCustom setFrame:self.view.frame];
}
#pragma mark-  userDefine function
#pragma mark-  ValidateFields
-(BOOL)ValidateFields
{
    BOOL result = YES;
    if([[self trim:self.txtEmail.text]length] == 0)
    {
        [self showMessage:@"Please enter your email address" withTitle:@""];
        result = NO;
    }
    
    else if(![self validateEmail:self.txtEmail.text])
    {
        NSLog(@"%@",self.txtEmail.text);
        [self showMessage:@"Please enter your email address" withTitle:@""];
        result = NO;
    }
     self.btnReset.userInteractionEnabled = YES;
    return result;
}
-(void)hideCrossBtn
{
    [self.btnEmailCross setHidden:YES];
}
-(void)btnCrossAction:(UIButton *)sender
{
    self.txtEmail.text = @"";
    [self updateTextLabelsWithText:self.txtEmail.text  textField:self.txtEmail];
}
#pragma text field delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{   if (textField == self.txtEmail)
    [textField resignFirstResponder];
    [self actionResetpassword:nil];
    return YES;
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
    if([string length] > 0 && textField == self.txtEmail)
    {
        self.btnEmailCross.hidden = NO;
    }
    else
    {
        self.btnEmailCross.hidden = YES;
    }
}
#pragma user define function
- (void)dismissKeyboard:(UITapGestureRecognizer*)sender
{
    [self.view endEditing:YES];
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if([UIScreen mainScreen].bounds.size.height >= 667)
    {
        self.scrollViewBG.scrollEnabled = NO;
        
    }
    else if([UIScreen mainScreen].bounds.size.height >= 568)
    {
        self.scrollViewBG.scrollEnabled = NO;
        [self.scrollViewBG setContentOffset:CGPointMake(0,60) animated:YES];
    }
    else
    {
        self.scrollViewBG.scrollEnabled = NO;
        [self.scrollViewBG setContentOffset:CGPointMake(0,75) animated:YES];
    }
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    self.scrollViewBG.scrollEnabled = NO;
    self.scrollViewBG.contentInset = UIEdgeInsetsMake(0, 0, 0,0 );
    self.scrollViewBG.contentOffset = CGPointMake(0, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    self.scrollViewBG.contentInset = UIEdgeInsetsMake(-30,0,40,0);
}
#pragma mark -API
#pragma mark Handel Response
-(void)postDataforRequestId:(int) requestId
{
    if(requestId == Request_Reset_Password)
    {
        if ([[AFNetworkReachabilityManager sharedManager] isReachable])
        {
            
            [[CNRequestController sharedInstance]CNRequestForgotPasswordWithEmail:_txtEmail.text success:^(id responseDict) {
                if (responseDict != (id)[NSNull null])
                {  [self loderStop:self.view];
                    [self notifyRequesterWithData:responseDict forRequest:Request_Reset_Password];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    self.btnReset.userInteractionEnabled = YES;
                [self loderStop:self.view];
            }];
        }
        
        else
        {
                self.btnReset.userInteractionEnabled = YES;
            [self loderStop:self.view];
            [self showMessage:OflineMessge withTitle:@""];
        }
    }
}
-(void)notifyRequesterWithData:(id) responseData forRequest:(int) requestId
{
    if(requestId == Request_Reset_Password)
    {
        NSString *message = nil;
        NSString *code = responseData[@"ResponseCode"];
        message = responseData[@"ResponseDetails"];
        if([code isEqualToString:@"200"])
        {  IsBack = YES;
                self.btnReset.userInteractionEnabled = NO;
            [self loderStop:self.view];
            [self.txtEmail resignFirstResponder];
            [CNDataHelper removeAllRecordsFromTable:@"Users"];
            [self showAlertPopup:@"We've sent you an email with a link to reset your password."];
            
        }
        else if([code isEqualToString:@"201"])
        {   IsBack = NO;
                self.btnReset.userInteractionEnabled = NO;
            [self loderStop:self.view];
            [self showAlertPopup:message];
        }
    }
}
@end
