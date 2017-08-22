//
//  CNLoginViewController.m
//  ClearNote
//
//  Created by Jitendra Agarwal on 27/11/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//

#import "CNLoginViewController.h"
#import "CNForgotPasswordViewController.h"
#import "CNAllNotsListViewController.h"
@interface CNLoginViewController ()
{
    IBOutlet UITextField *activeField;
}
@end
@implementation CNLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnSignIn.layer.cornerRadius = 3.0;
    self.scrollBG.scrollEnabled = NO;
 

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [self intinalSetup];
    [self buttonIntinalSetup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



-(void)intinalSetup
{
    [self.navigationController setNavigationBarHidden:YES];
    UITapGestureRecognizer *_gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:_gestureRecognizer];
    [self.txtEmail setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtPassword setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
 }
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.view endEditing:NO];
       [self.txtEmail becomeFirstResponder];
 
    

}
#pragma mark- button Action
- (IBAction)actionCrossBack:(id)sender {
     [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)actionLogin:(id)sender {
    [self.view endEditing:YES];
       [self loderStop:self.view];
    //self.btnSignIn.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    //[self loderStart:self.view strLbl:@"Loading"];
    if(![self ValidateFields])
    {
            self.view.userInteractionEnabled = YES;
        return;
    }
    [self postDataforRequestId:Request_User_Login];
    
}
- (IBAction)actionForgetPassword:(id)sender
{
    //[self.view endEditing:YES];
    CNForgotPasswordViewController *forgotVC = (CNForgotPasswordViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CNForgotPasswordViewController"];
    [self.view endEditing:YES];
   
    //[self.navigationController pushViewController:forgotVC animated:YES];
    [self presentViewController:forgotVC animated:YES completion:nil];
    
}
-(void)buttonIntinalSetup
{
    [self hideCrossBtn];
    [self.btnEmailCross addTarget:self action:@selector(btnCrossAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPasswordCross addTarget:self action:@selector(btnCrossAction:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma text field delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{   if (textField == self.txtEmail) {
    //[textField resignFirstResponder];
    [self.txtPassword becomeFirstResponder];
}
    if(textField==self.txtPassword)
    {
        //[textField resignFirstResponder];
        [self actionLogin:nil];
    }
   // [textField resignFirstResponder];
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
    if([string length] > 0 && textField == self.txtEmail)
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
#pragma user define function
- (void)dismissKeyboard:(UITapGestureRecognizer*)sender
{
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    self.scrollBG.contentInset = UIEdgeInsetsMake(0,0,100,0);
    
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
    if([[self trim:self.txtPassword.text]length] == 0)
    {
        [self showMessage:@"Please enter your password" withTitle:@""];
        result = NO;
    }
    else if(![self validateEmail:self.txtEmail.text])
    {
        NSLog(@"%@",self.txtEmail.text);
        [self showMessage:@"Please enter a valid email address" withTitle:@""];
        result = NO;
        
    }

    return result;
}
// This function hide all cross button.
-(void)hideCrossBtn
{
    [self.btnEmailCross setHidden:YES];
    [self.btnPasswordCross setHidden:YES];
}
//This function action for all cross button
-(void)btnCrossAction:(UIButton *)sender
{
    if(sender.tag ==101)
    {
        self.txtEmail.text = @"";
        [self updateTextLabelsWithText:self.txtEmail.text  textField:self.txtEmail];
    }
    else if(sender.tag ==102)
    {
        self.txtPassword.text = @"";
        [self updateTextLabelsWithText:self.txtPassword.text textField:self.txtPassword];
    }
}

#pragma mark -Api
#pragma mark Handel Response
-(void)postDataforRequestId:(int) requestId
{
     [self loderStop:self.view];

    if(requestId == Request_User_Login)
    {
        [self loderStart:self.view strLbl:@"Loading"];
        
        if ([[AFNetworkReachabilityManager sharedManager] isReachable])
        {
            [[CNRequestController sharedInstance]CNRequestAuthenticateUserWithEmail:_txtEmail.text password:_txtPassword.text success:^(id responseDict) {
                NSLog(@"%@",responseDict);
                
                if (responseDict != (id)[NSNull null])
                {
                    [self notifyRequesterWithData:responseDict forRequest:Request_User_Login];
                }
                
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              self.view.userInteractionEnabled = YES;
            [self loderStop:self.view];
                
                [self showMessage:OflineMessge withTitle:AlertTitle];
                
            }];
            
        }
        else // if net is not woking.
        {   self.view.userInteractionEnabled = YES;
          
            [self loderStop:self.view];
            [self showMessage:OflineMessge withTitle:AlertTitle];

           // [self offlinAuthenticateWithEmail:_txtEmail.text password:_txtPassword.text requestId:Request_User_Login];
        }
    }
    else if(requestId == Request_Fetch_All_NoteList)
    {
        if ([[AFNetworkReachabilityManager sharedManager] isReachable])
        {
            NSString *currentTimestamp = [[CNHelper sharedInstance]gettimestampStringFroLocalTime];
            [[CNRequestController sharedInstance]CNRequestGetAllNoteListWithUserID:[CNHelper sharedInstance].userLoginID timestamp:@"0" currentTimestamp:currentTimestamp DeviceID:get_ValueByKye(kCurrentDeviceID) success:^(id responseDict) {
                
                if ([responseDict isKindOfClass:[NSArray class]]){
                    CNAllNotsListViewController *allNoteListVC = (CNAllNotsListViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"CNAllNotsListViewController"];
                    [self loderStop:self.view];
                    [self. navigationController pushViewController:allNoteListVC animated:YES];
                    
                }
                else if (responseDict != (id)[NSNull null])
                {
                    [self notifyRequesterWithData:responseDict forRequest:Request_Fetch_All_NoteList];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             self.view.userInteractionEnabled = YES;
                [self loderStop:self.view];
            }];
        }
        else // if net is note working
        {
               self.view.userInteractionEnabled = YES;
            [self loderStop:self.view];
        }
    }
    
}
-(void)notifyRequesterWithData:(id) responseData forRequest:(int) requestId
{
[self loderStop:self.view];
    NSString *message = nil;
    NSString *code = responseData[@"ResponseCode"];
    message = responseData[@"ResponseDetails"];
    if(requestId == Request_User_Login)
    {
        if([code isEqualToString:@"200"])
        {
            NSString *currentDeviceID = [[CNHelper  sharedInstance]getDeviceID];
            Set_DeviceID(kCurrentDeviceID, currentDeviceID);

            NSArray * items = nil;
            Set_UserEmail(kEmail, responseData[@"emailId"]);
            Set_UserID(kLoginID, responseData[@"userId"]);
            Set_UserName(kUserName, responseData[@"userName"]);
            Defaults_set_bool_sort(kSortStatus, YES);
        //    Defaults_set_bool_manual_SyncStatus(kManualySync, YES);
            
            //Defaults_set_bool_onoff(kSysncStatus, NO);
          
            
            Defaults_set_bool_manual_SyncStatus(kManualySync, NO);
            Defaults_set_bool_onoff(kSysncStatus, YES);
            
            Defaults_set_bool_BackgroundSync(kBackgroundSync, YES); // not sync
          
           // Defaults_set_bool_BackgroundSync(kBackgroundSync, NO); // sync automatic
            items = [CNDataHelper CNdBFetchDefultNoteName];
            if(items.count==0 || !items)
            {
                [CNDataHelper CNdBInsertDefultNoteName:[NSNumber numberWithInt:0]];
            }
            // store the details in local database
            [CNHelper sharedInstance].userLoginID = responseData[@"userId"];
            [CNHelper sharedInstance].userName = responseData[@"userName"];
            [CNHelper sharedInstance].userLoginEmail = responseData[@"emailId"];
            NSArray * arrResult  = [CNDataHelper CNdBAuthenticateUser:self.txtEmail.text userPassword:_txtPassword.text];
            if(arrResult.count == 0 || !arrResult)
            {
                [[CNHelper sharedInstance]flushOutLocalDatabase];
                [CNDataHelper CNdBInsertUserDetailsWithUserID:responseData[@"userId"] userName:responseData[@"userName"]  userPassword:responseData[@"password"]  email:responseData[@"emailId"] ];
                [self postDataforRequestId:Request_Fetch_All_NoteList];
            }
            else
            {
                 CNAllNotsListViewController *allNoteListVC = (CNAllNotsListViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"CNAllNotsListViewController"];
                CATransition* transition = [CATransition animation];
                transition.duration = 0.3;
                transition.type = kCATransitionReveal;
                transition.subtype = kCATransitionFromBottom;
                [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
                [self.navigationController pushViewController:allNoteListVC animated:NO];
                
            
            }
        }
        else if([code isEqualToString:@"202"])
        {
            [self loderStop:self.view];
            self.view.userInteractionEnabled = YES;
            [self showMessage:@"Invalid email or password" withTitle:@""];
        }
        
    }
    else if(requestId == Request_Fetch_All_NoteList)
    {
        [self loderStop:self.view];
          NSString *code = responseData[@"ResponseCode"];
        message = responseData[@"ResponseDetails"];
        NSLog(@"%@",responseData);
        if([code isEqualToString:@"200"])
        {
            NSArray *arrNoteList = responseData[@"noteList"];
            Set_TimeStamp(kTimeStamp, responseData[@"TimeStamp"]);
            [CNHelper sharedInstance].noteListTimeStamp =  responseData[@"TimeStamp"];
            if(!(arrNoteList == nil) || [arrNoteList count] == 0)
            {
                for(NSDictionary *dict in arrNoteList)
                {

                    
                    // chnage 4-2-2016
                    [CNDataHelper CNdBCreateNewNotewithUserID:[CNHelper sharedInstance].userLoginID noteCreateID:dict[@"noteId"] noteTitle:dict[@"noteName"] isDeleted:dict[@"isDeleted"] content:dict[@"content"] noteCreateDate:dict[@"noteModifiedDate"]  isSynchoronization:dict[@"isSynchronise"]tempNoteID:get_UserID(kTimeStamp) ];
                    //end
                    
                }
                [self loderStop:self.view];
                CNAllNotsListViewController *allNoteListVC = (CNAllNotsListViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"CNAllNotsListViewController"];
                
                CATransition* transition = [CATransition animation];
                transition.duration = 0.3;
                transition.type = kCATransitionReveal;
                transition.subtype = kCATransitionFromBottom;
                [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
                [self.navigationController pushViewController:allNoteListVC animated:NO];

                
               // [self. navigationController pushViewController:allNoteListVC animated:YES];
            }
        }
        else if([code isEqualToString:@"201"])
        {
            [self loderStop:self.view];
            Set_TimeStamp(kTimeStamp, responseData[@"TimeStamp"]);
            CNAllNotsListViewController *allNoteListVC = (CNAllNotsListViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"CNAllNotsListViewController"];
            
            CATransition* transition = [CATransition animation];
            transition.duration = 0.3;
            transition.type = kCATransitionReveal;
            transition.subtype = kCATransitionFromBottom;
            [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
            [self.navigationController pushViewController:allNoteListVC animated:NO];
            
            
            // [self. navigationController pushViewController:allNoteListVC animated:YES];
        }
    }
}
-(void)offlinAuthenticateWithEmail:(NSString *)email password:(NSString *)password requestId:(int) requestId
{
       self.view.userInteractionEnabled = YES;
    //NSArray * arrResult = nil;
    if(requestId == Request_User_Login)
    {
        NSArray * arrResult  = [CNDataHelper CNdBAuthenticateUser:self.txtEmail.text userPassword:_txtPassword.text];
        if(arrResult.count == 0 || !arrResult)
        {
            [self loderStop:self.view];
            [self showMessage:@"Invalid email or password" withTitle:@""];
        }
        else
        {
            Users * objUserDetils = [arrResult objectAtIndex:0];
            Set_UserEmail(@"CNLoginEmail", self.txtEmail.text);
            NSString *userLoginID = objUserDetils.userID;
            Set_UserID(@"CNLoginID", userLoginID);
            Defaults_set_bool_sort(kSortStatus, YES);
            //Defaults_set_bool_onoff(kSysncStatus, YES);// chnage
        //    Defaults_set_bool_onoff(kSysncStatus, NO);
            // chnage 25-2-2016
            Defaults_set_bool_onoff(kSysncStatus, YES);

            CNAllNotsListViewController *allNoteListVC = (CNAllNotsListViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"CNAllNotsListViewController"];
            [self loderStop:self.view];
            CATransition* transition = [CATransition animation];
            transition.duration = 0.3;
            transition.type = kCATransitionReveal;
            transition.subtype = kCATransitionFromBottom;
            [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
            [self.navigationController pushViewController:allNoteListVC animated:NO];
            
            // [self. navigationController pushViewController:allNoteListVC animated:YES];
            [CNHelper sharedInstance].userLoginID = userLoginID;
        }
    }
}
@end
