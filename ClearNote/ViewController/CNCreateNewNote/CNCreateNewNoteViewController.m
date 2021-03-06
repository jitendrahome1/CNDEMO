//
//  CNCreateNewNoteViewController.m
//  ClearNote
//
//  Created by Jitendra Agarwal on 01/12/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//

#import "CNCreateNewNoteViewController.h"

@interface CNCreateNewNoteViewController ()<UITextViewDelegate>
{
    UIBarButtonItem *backBtn;
    NSString *timeStampDate;
    NSString *strDate;
    UIBarButtonItem *keyApperBtn;
    BOOL kyeboardStatus;
    UIBarButtonItem *shareBtn;
    NSArray *actionButtonItems;
    UIImageView *ImageView;
    NSString *strTextView;
    NSMutableArray *arrFetchData;
}
@end
@implementation CNCreateNewNoteViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    arrFetchData = [[NSMutableArray alloc]init];
    _txtNoteWrtingView.delegate = self;
    [self.txtNoteWrtingView setUserInteractionEnabled:YES];
    _btnTitleCorss.hidden = YES;
    [self intinalSetup];
    [self keyBordSetup];
    [self buttonIntinalSetup];
    [self NavigationButtonSetup];
    [self.txtNoteWrtingView setUserInteractionEnabled:NO];
    [self.txtNoteTitle becomeFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)intinalSetup
{
    [self.txtNoteTitle setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    UITapGestureRecognizer *_gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:_gestureRecognizer];
    UITapGestureRecognizer *_gestureTextViewRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewKyeShow:)];
    [self.viewDiscBG addGestureRecognizer:_gestureTextViewRecognizer];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
    backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ArrowNotsiPhone.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    self.navigationItem.leftBarButtonItem = backBtn;
    [[UINavigationBar appearance]setShadowImage:[[UIImage alloc] init]];
}
#pragma mark- navbar button action
-(void)shareBtnAction {
    NSString * message = strTextView;
    NSArray * Items;
    if([self trim:message].length==0)
    {
        message = @"";
        Items = @[message];
    }
    else
    {
        Items = @[message];
    }
    
    
    //Open activity view controller
    UIActivityViewController *ActivityView = [[UIActivityViewController alloc]
                                              initWithActivityItems:Items
                                              applicationActivities:nil] ;
    [ActivityView setExcludedActivityTypes:
     @[UIActivityTypeAssignToContact,
       UIActivityTypeCopyToPasteboard,
       // UIActivityTypePostToTwitter,
       UIActivityTypeCopyToPasteboard,
       UIActivityTypePostToWeibo,
       UIActivityTypeMessage,
       //UIActivityTypePostToFacebook,
       UIActivityTypePostToFlickr,
       UIActivityTypePostToVimeo,
       UIActivityTypeAirDrop,
       UIActivityTypePostToTencentWeibo,
       UIActivityTypeSaveToCameraRoll,
       UIActivityTypeAddToReadingList
       ]];
    [self presentViewController:ActivityView animated:YES completion:nil];
    ActivityView.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        // When completed flag is YES, user performed specific activity
        
        //[ActivityView setCompletionHandler:^(NSString *activityType, BOOL completed) {
        
        NSLog(@"%@",activityType);
        if (completed) {
            //            UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Share successfully " message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //            [Alert show];
            
        }
        else {
            NSLog(@"canceled");
        }
        
    };
    
}

#pragma mark-
#pragma NavigationBar Setup
-(void)NavigationButtonSetup {
    [self SettingtUpBarButtonItemOnly];
}
-(void)SettingtUpBarButtonItemOnly {
    [self SettingtUpBarButtonItems];
    [self.navigationItem setRightBarButtonItems:nil animated:NO];
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    button.contentEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, -40);
    [button setImage:[UIImage imageNamed:@"ShareHeaderIconiPhone.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    shareBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:shareBtn animated:NO];
}
-(void)SettingtUpBarButtonItems {
    UIButton *shareButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    shareButton.contentEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, -20);
    [shareButton setImage:[UIImage imageNamed:@"ShareHeaderIconiPhone.png"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *share_Btn = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    
    ImageView = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"KeyboardHeaderIconiPhone.png"]];
    UIButton *keyboardHideButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    keyboardHideButton.bounds = ImageView.bounds;
    [keyboardHideButton addSubview:ImageView];
    keyboardHideButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -25);
    
    [keyboardHideButton addTarget:self action:@selector(keyApperBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *keyApper_Btn = [[UIBarButtonItem alloc] initWithCustomView:keyboardHideButton];
    actionButtonItems = @[keyApper_Btn,share_Btn];
    [self.navigationItem setRightBarButtonItems:actionButtonItems animated:NO];
}

-(BOOL)crossBtnHideUnhide:(NSString *)pStr
{
    BOOL result;
    if(pStr.length == 0)
        result = NO;
    else
        result = YES;
    return result;
}
#pragma mark-
#pragma Button Action
-(void)keyApperBtnAction
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 1.9];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1.7014116E+38;
    [ImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    if(kyeboardStatus)
    {
        [self.view endEditing:YES];
        kyeboardStatus = NO;
    }
    else
    {
        [self.txtNoteTitle becomeFirstResponder];
        kyeboardStatus = YES;
    }
}
-(void)backBtnAction
{
    [self.view endEditing:YES];
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    
    
    if(![self ValidateFields])
    {
        [self loderStop:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        if(Defaults_get_bool(kManualySync))
        {
            [self loderStart:self.view strLbl:@"Loading"];
            [self postDataforRequestId:Request_Create_New_Note];
        }
        else
        {
            [self loderStop:self.view];
            [self offlinPostDataforRequestId:Request_Create_New_Note];
        }
        return;
    }
}

-(void)buttonIntinalSetup
{
    [self updateTextLabelsWithText:self.txtNoteTitle.text  textField:self.txtNoteTitle];
    [self.btnTitleCorss addTarget:self action:@selector(btnCrossAction:) forControlEvents:UIControlEventTouchUpInside];
}
// This function hide all cross button.
-(void)hideCrossBtn
{
    [self.btnTitleCorss setHidden:YES];
}
-(void)btnCrossAction:(UIButton *)sender
{
    self.txtNoteTitle.text = @"";
    [self updateTextLabelsWithText:self.txtNoteTitle.text  textField:self.txtNoteTitle];
    [self.txtNoteTitle becomeFirstResponder];
}
#pragma mark-
#pragma mark- key bord setup
-(void)keyBordSetup
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    self.btnTitleCorss.contentEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, -5);
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, -4.0);
    _txtNoteWrtingView.scrollIndicatorInsets = contentInsets;
    [_txtNoteWrtingView setContentInset:contentInsets];
    if(kyeboardStatus)
    {
        //kyeboardStatus = NO;
    }
    else
    {
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
        [self fadeAnimations];  // start animations
        [self.navigationItem setRightBarButtonItems:actionButtonItems animated:NO];
        kyeboardStatus = YES;
    }
}
-(void)fadeAnimations
{
    [ImageView setAlpha:0];
    [UIImageView beginAnimations:NULL context:nil];
    [UIImageView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIImageView setAnimationDuration:0.3];
    [ImageView setAlpha:1];
    [UIImageView commitAnimations];
}
-(void)keyboardWillHide:(NSNotification *)note
{
    self.btnTitleCorss.contentEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, -20);
    _txtNoteWrtingView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -4.0);
    [_txtNoteWrtingView setContentInset:UIEdgeInsetsMake(0, 0, 0, -0.0)];
    [self.navigationItem setRightBarButtonItems:nil animated:NO];
    [self.navigationItem setRightBarButtonItem:shareBtn animated:NO];
    [self textFieldDidBeginEditing:self.txtNoteTitle];
    kyeboardStatus = NO;
}
#pragma text field delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{   if (textField == self.txtNoteTitle)
    
    [textField resignFirstResponder];
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.lblPlaceHolder setHidden:YES];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([self trim:strTextView].length==0)
        [self.lblPlaceHolder setHidden:NO];
    else
        [self.lblPlaceHolder setHidden:YES];
    
}
#pragma mark- Text View Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    strTextView = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if(strTextView.length<=0)
        [self.lblPlaceHolder setHidden:NO];
    else
        [self.lblPlaceHolder setHidden:YES];
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString {
    if (textField.text) {
        textField.text = [textField.text stringByReplacingCharactersInRange:range withString:replacementString];
        [self updateTextLabelsWithText: textField.text textField:textField];
    }
    return NO;
}
-(void)updateTextLabelsWithText:(NSString *)string textField:(UITextField *)textField
{
    if([string length] > 0 && textField == self.txtNoteTitle)
    {
        self.btnTitleCorss.hidden = NO;
    }
    else
    {
        self.btnTitleCorss.hidden = YES;
    }
}
#pragma user define function
- (void)dismissKeyboard:(UITapGestureRecognizer*)sender
{
    [self.view endEditing:YES];
}
- (void)textViewKyeShow:(UITapGestureRecognizer*)sender
{
    NSLog(@"%@",self.txtNoteWrtingView.text);
    if([self.txtNoteWrtingView.text length] == 0)
    {
        [self.lblPlaceHolder setHidden:YES];
        [self.txtNoteWrtingView setUserInteractionEnabled:YES];
        [self.txtNoteWrtingView becomeFirstResponder];
    }
    else
    {  //[self.lblPlaceHolder setHidden:YES];
        //chnage 4-2-2016
        [self.lblPlaceHolder setHidden:YES];
        //end
    }
}
#pragma mark-  userDefine function
#pragma mark-  ValidateFields
-(BOOL)ValidateFields
{
    BOOL result = YES;
    if([[self trim:self.txtNoteTitle.text]length] == 0 && [[self trim:self.txtNoteWrtingView.text]length] == 0)
    {
        result = NO;
    }
    else if([[self trim:self.txtNoteTitle.text]length] == 0)
    {
        self.txtNoteTitle.text = @"Note";
        return YES;
    }
    else if([[self trim:self.txtNoteWrtingView.text]length] == 0)
    {
        strTextView = @"";
        return YES;
    }
    return result;
}
#pragma mark -
#pragma mark  Api Handel Response
-(void)postDataforRequestId:(int) requestId
{
    timeStampDate = [[CNHelper sharedInstance]gettimestampStringFroLocalTime];
    
    if(requestId == Request_Create_New_Note)
    {
        
        if ([[AFNetworkReachabilityManager sharedManager] isReachable])
        {
            // 1 store to local database
            //2 Then update to server.
            [CNDataHelper localCreateNewNotewithUserID:[CNHelper sharedInstance].userLoginID noteCreateID:@"" noteTitle:_txtNoteTitle.text isDeleted:@"0" content:strTextView noteCreateDate:timeStampDate isSynchoronization:@"0" tempNoteID:timeStampDate];
            [self loderStop:self.view];
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                
                [[CNRequestController sharedInstance]CNRequestCreateNoteWithUserID:[CNHelper sharedInstance].userLoginID noteTitle:_txtNoteTitle.text content:strTextView createDateTime:timeStampDate isDeleted:@"0" isSynchronise:@"0" success:^(id responseDict) {
                    if (responseDict != (id)[NSNull null])
                    {
                        [self notifyRequesterWithData:responseDict forRequest:Request_Create_New_Note];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self loderStop:self.view];
                }];
            });
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self loderStop:self.view];
                [self.navigationController popViewControllerAnimated:YES];
                });
            }
        else
        { // net is note working
            [CNDataHelper CNdBCreateNewNotewithUserID:[CNHelper sharedInstance].userLoginID noteCreateID:@"" noteTitle:_txtNoteTitle.text isDeleted:@"0" content:strTextView noteCreateDate:timeStampDate isSynchoronization:@"0" tempNoteID:timeStampDate];
            [self loderStop:self.view];
            NSLog(@"backBtnAction");
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(void)notifyRequesterWithData:(id) responseData forRequest:(int) requestId
{
    // NSString *timeStamp = [[CNHelper sharedInstance]gettimestampStringFroLocalTime];
    if(requestId == Request_Create_New_Note)
    {
        NSString *message = nil;
        NSString *code = responseData[@"ResponseCode"];
        message = responseData[@"ResponseDetails"];
        if([code isEqualToString:@"200"])
        {
            [self loderStop:self.view];
            
            [CNDataHelper LocalDataBaseUpdateInBackgroundSync:get_ValueByKye(kLoginID) noteID:responseData[@"noteId"] noteName:responseData[@"Notetitle"] isDeleted:responseData[@"isDeleted"] isSynchoronization:responseData[@"isSynchronise"] fileData:responseData[@"content"] dateTime:timeStampDate tempUserId:timeStampDate keyUpdate:@"master"];
            
            
        }
        //  [self.delegete didFinishedCreatedNote:YES];
    }
}

#pragma mark-
#pragma mark-local database work.
-(void)offlinPostDataforRequestId:(int) requestId
{    //timeStampDate = nil;
    if(requestId == Request_Create_New_Note)
    {
        timeStampDate = [[CNHelper sharedInstance]gettimestampStringFroLocalTime];
        [CNDataHelper CNdBCreateNewNotewithUserID:[CNHelper sharedInstance].userLoginID noteCreateID:@"" noteTitle:_txtNoteTitle.text isDeleted:@"0" content:strTextView noteCreateDate:timeStampDate isSynchoronization:@"0" tempNoteID:timeStampDate];
        [self loderStop:self.view];
        NSLog(@"backBtnAction");
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
@end
