//
//  CNSettingsViewController.m
//  ClearNote
//
//  Created by Jitendra Agarwal on 30/11/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//
#import "CNSettingsViewController.h"
#import "CNSettingTableViewCell.h"
#import "CNWelcomeViewController.h"
@interface CNSettingsViewController ()
{
    BOOL sortStatus;
    UIButton *buttonLogoutColor;

}

@end
@implementation CNSettingsViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    appDel = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    appDel.isUploadFromBacground = YES;
    [self.tblSetting registerNib:[UINib nibWithNibName:@"CNSettingTableViewCell" bundle:nil] forCellReuseIdentifier:@"CNSettingTableViewCell"];
   // [self intinalSegementSetup];
    [self intinalSetup];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [buttonLogoutColor setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName: kDefaulColor,
       NSFontAttributeName:kFontRobotoRegular(16)}];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)intinalSetup
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.lblUserEmail.text = get_UserID(@"CNLoginEmail");
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    [[UINavigationBar appearance]setShadowImage:[[UIImage alloc] init]];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"Settings";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName: kDefaulColor,
       NSFontAttributeName:kFontRobotoRegular(16)}];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    [doneBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                     kFontRobotoRegular(17), NSFontAttributeName,
                                     kDefaulColor, NSForegroundColorAttributeName,
                                     nil]
                           forState:UIControlStateNormal];
    NSArray *actionButtonItems = @[doneBtn];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    self.navigationItem.hidesBackButton = YES;
}
-(void)intinalSegementSetup
{
    [self.tblSetting reloadData];
}
#pragma mark-
#pragma Mark- button Actions
-(void)doneAction
{
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)backBtnAction
{
    self.navigationItem.title = @"";
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnTrashAction:(id)sender {
    CNTrashViewController *trashVC = (CNTrashViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CNTrashViewController"];
    [self.navigationController pushViewController:trashVC animated:YES];
    
}
- (void)btnChnagePasswordAction:(id)sender {
    CNChangePasswordViewController *chnagePassVC = (CNChangePasswordViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CNChangePasswordViewController"];
    [self.navigationController pushViewController:chnagePassVC animated:YES];
}
- (void)btnLogOut:(id)sender {
    UIButton * btn = (UIButton *)sender;
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [UIAlertView showWithTitle:@"Sign Out" message:@"Are you sure?" cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Sign out"] withCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if(buttonIndex == 1)
        {
            Defaults_remove_object(kUserName); //clear out user Info from defaults (needed for direct Login)
            Defaults_remove_object(kLoginID);
            Defaults_remove_object(kEmail);
           // chnage 4- 2-2016
            Defaults_set_bool_syncRotations(kspinRotations, YES);
            //end
            //   Defaults_remove_object(kTimeStamp); //testing
            [appDel goToViewController:@""];
        }
        else
        {
             [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }];
}

- (void)longPress:(UILongPressGestureRecognizer*)gesture {
    buttonLogoutColor = (UIButton *)[gesture view];
    if ( gesture.state == UIGestureRecognizerStateEnded )
    {
        [buttonLogoutColor setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
        [UIAlertView showWithTitle:@"Sign Out" message:@"Are you sure?" cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Sign out"] withCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if(buttonIndex == 1)
            {
                Defaults_remove_object(kUserName); //clear out user Info from defaults (needed for direct Login)
                Defaults_remove_object(kLoginID);
                Defaults_remove_object(kEmail);
                //   Defaults_remove_object(kTimeStamp); //testing
                [appDel goToViewController:@""];
            }
            else
            {
                [buttonLogoutColor setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }];

    
    }
}
#pragma mark- segement action
// Oder Sorting
-(void)actionOderSort:(UISegmentedControl *)sender
{
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    [CNHelper sharedInstance].segementSortIndexValue = selectedSegment;
    if (selectedSegment == 0) {
        Defaults_set_bool_sort(kSortStatus, YES);
    }
    else{
        NSLog(@"action 1");
        Defaults_set_bool_sort(kSortStatus, NO);
    }
}
//sync Action
-(void)actionOnOff:(UISegmentedControl *)sender
{
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    if (selectedSegment == 0) {
        Defaults_set_bool_onoff(kSysncStatus, NO);// On
        Defaults_set_bool_manual_SyncStatus(kManualySync, YES);
        
       // Defaults_set_bool_BackgroundSync(kBackgroundSync, NO);
       
                Defaults_set_bool_BackgroundSync(kBackgroundSync, NO); // auto sync
        // appDel.isBackgroundSync = NO;
        [appDel startMonitoringNetwork];
        
    }
    else{
     // [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
     //   appDel.isBackgroundSync = YES;
        Defaults_set_bool_manual_SyncStatus(kManualySync, NO);
        Defaults_set_bool_onoff(kSysncStatus, YES);
           // Defaults_set_bool_BackgroundSync(kBackgroundSync, YES);
        Defaults_set_bool_BackgroundSync(kBackgroundSync, YES);  // not sync
        [appDel startMonitoringNetwork];
         // off
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id superCell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    CNSettingTableViewCell *cell = (CNSettingTableViewCell*)superCell;
    return  cell.frame.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"CNSettingTableViewCell";
    CNSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.btnTrash.layer.cornerRadius = 5.0;
    cell.btnTrash.layer.borderWidth = 1;
    cell.btnTrash.layer.borderColor = [UIColor colorWithRed:66/255.0 green:133/255.0 blue:244/255.0 alpha:1].CGColor;
    cell.btnChangePassword.layer.cornerRadius = 5.0;
    cell.btnChangePassword.layer.borderWidth = 1;
    cell.btnChangePassword.layer.borderColor = [UIColor colorWithRed:66/255.0 green:133/255.0 blue:244/255.0 alpha:1].CGColor;
    cell.imgUserAccount.layer.cornerRadius = 5.0;
    cell.imgUserAccount.layer.borderWidth = 1;
    cell.imgUserAccount.layer.borderColor = [UIColor colorWithRed:66/255.0 green:133/255.0 blue:244/255.0 alpha:1].CGColor;
    [cell.btnTrash addTarget:self action:@selector(btnTrashAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnChangePassword addTarget:self action:@selector(btnChnagePasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [cell.btnSignOut addGestureRecognizer:longPress];
    [cell.btnSignOut addTarget:self action:@selector(btnLogOut:) forControlEvents:UIControlEventTouchUpInside];
    [cell.segmentedSort addTarget:self action:@selector(actionOderSort:) forControlEvents:UIControlEventValueChanged];
    [cell.segmentedSync addTarget:self action:@selector(actionOnOff:) forControlEvents:UIControlEventValueChanged];
    NSLog(@"%@",get_UserEmail(kEmail));
    cell.lblUserLoginEmail.text = get_UserEmail(kEmail);
    if(Defaults_get_bool(kSortStatus))
    {
        cell.segmentedSort.selectedSegmentIndex = 0;  // defult
    }
    else
    {
        cell.segmentedSort.selectedSegmentIndex = 1;
    }
    if(!Defaults_get_bool(kSysncStatus))
    {
        cell.segmentedSync.selectedSegmentIndex = 0; // defult
    }
    else
    {
        cell.segmentedSync.selectedSegmentIndex = 1;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    }

@end
