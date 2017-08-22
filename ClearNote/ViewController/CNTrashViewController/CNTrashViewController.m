//
//  CNTrashViewController.m
//  ClearNote
//
//  Created by Jitendra Agarwal on 01/12/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//

#import "CNTrashViewController.h"
#import "CNTrashTableViewCell.h"
#import "CNAllNotsListViewController.h"
#import "SWTableViewCell.h"
@interface CNTrashViewController ()<SWTableViewCellDelegate>
{
    NSMutableArray *arrAllNots;
    NSString * noteID;
    NSString *noteName;
    NSString *tempUserId;
   
    NSString *fileData;
    NSString *noteCreteDate;
    NSNumber *isDeleteValue;
    NSString *timeStamp;
    UIBarButtonItem *btnEmpty;
}
@property (strong, nonatomic)  UIRefreshControl* refreshControl;
@end

@implementation CNTrashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self intinalSetup];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)intinalSetup
{
    arrAllNots = [[NSMutableArray alloc]init];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"Trash";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName: kDefaulColor,
       NSFontAttributeName:kFontRobotoRegular(16)}];
    
    btnEmpty = [[UIBarButtonItem alloc]initWithTitle:@"Empty" style:UIBarButtonItemStylePlain target:self action:@selector(btnEmptyAction)];
    [btnEmpty setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      kFontRobotoRegular(17), NSFontAttributeName,
                                      kDefaulColor, NSForegroundColorAttributeName,
                                      nil]
                            forState:UIControlStateNormal];
    
    NSArray *actionButtonItems = @[btnEmpty];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackHeaderIconiPhone.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    self.navigationItem.leftBarButtonItem = backBtn;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self tableSetUp];
}
#pragma mark- Button Action
-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- Empty Action
-(void)btnEmptyAction
{
    [UIAlertView showWithTitle:@"" message:@"Notes will be deleted forever" cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Delete"] withCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        if(buttonIndex == 1)
        {
            [self loderStart:self.view strLbl:@"Loading"];
                if(Defaults_get_bool(kManualySync))
            [self postDataforRequestId:Request_Empty_All_Notes];
            else
            [self offlinPostDataforRequestId:Request_Empty_All_Notes];
        }
    }];
}
#pragma mark- User Define Function
-(void)tableSetUp
{
    [arrAllNots removeAllObjects];
    NSArray *arrResult = [CNDataHelper CNdBGetAllNoteWithUserID:[CNHelper sharedInstance].userLoginID isdeleValue:@"1"];
    [arrAllNots addObjectsFromArray:arrResult];
    if (arrAllNots == nil || [arrAllNots count] == 0) {
        self.viewBGTable.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
    }
    else
    {
        self.viewBGTable.hidden = NO;
        [self.tblTrash reloadData];
    }
}
#pragma marks- Table view Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrAllNots.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cnAllNoteListTableCell";
    CNAllNoteListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UIFont * font = cell.lblNoteName.font;
    float newHeight,cellHeight,titleHeight,titleWidth,heightRow;
    cellHeight = self.tblTrash.rowHeight;
    titleWidth = cell.lblNoteName.frame.size.width;
    titleHeight = cell.lblNoteName.frame.size.height;
    heightRow = [cell getLabelSizeFortext:cell.lblNoteName.text forWidth:titleWidth WithFont:font].height;
    newHeight = cellHeight+heightRow-titleHeight;
    
    cell.lblNoteName.lineBreakMode = YES;
    cell.lblNoteName.lineBreakMode = NSLineBreakByWordWrapping;
    cell.lblNoteName.adjustsFontSizeToFitWidth = YES;
    cell.lblNoteName.numberOfLines = heightRow;
    [cell.lblNoteName updateConstraintsIfNeeded];
    [cell.lblNoteName setNeedsUpdateConstraints];
    [cell.lblNoteName  sizeToFit];
    if (newHeight<cellHeight)
    {
        newHeight=cellHeight;
    }
    
    return 66;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"cnTrashTableViewCell";
//    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
//    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    CNTrashTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    MasterNote *_objMasterList = [arrAllNots objectAtIndex:indexPath.row];
    cell.lblNoteTitle.text = _objMasterList.noteName;
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        
        [self.tblTrash deleteRowsAtIndexPaths:[[NSArray alloc]initWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"       " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        _noteOBJ = [arrAllNots objectAtIndex:indexPath.row];
                                        noteID = _noteOBJ.noteCreateID;
                                        noteName = _noteOBJ.noteName;
                                        tempUserId = _noteOBJ.tempUserId;
                                        
                                        fileData = _noteOBJ.fileData;
                                        isDeleteValue = [NSNumber numberWithInt:-1];
                                        noteCreteDate = _noteOBJ.noteCreateDate;
                                        timeStamp = _noteOBJ.timestamp;
                                        
                                        
                                        //[arrAllNots removeObjectAtIndex:indexPath.row];
                                        if(Defaults_get_bool(kManualySync))
                                        [self postDataforRequestId:Request_Delete_Note];
                                        else
                                        [self offlinPostDataforRequestId:Request_Delete_Note];
                                    }];
    button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"DeleteiPhone"]];
    UITableViewRowAction *button2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"       " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                     {
                                         _noteOBJ = [arrAllNots objectAtIndex:indexPath.row];
                                         noteID = _noteOBJ.noteCreateID;
                                         noteName = _noteOBJ.noteName;
                                         tempUserId = _noteOBJ.tempUserId;
                                         
                                         fileData = _noteOBJ.fileData;
                                      isDeleteValue = [NSNumber numberWithInt:0];
                                         noteCreteDate = _noteOBJ.noteCreateDate;
                                         timeStamp = _noteOBJ.timestamp;
                                         
                                         
                                         //[arrAllNots removeObjectAtIndex:indexPath.row];
                                           if(Defaults_get_bool(kManualySync))
                                         [self postDataforRequestId:Request_Restore_Note];
                                         else
                                             [self offlinPostDataforRequestId:Request_Restore_Note];
                                         }];
    button2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RestoreiPhone"]]; //arbitrary color
    return @[button,button2];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
// APi Call
#pragma mark -
#pragma mark APi Handel Response
-(void)postDataforRequestId:(int) requestId
{
    NSString *currentTimestamp = [[CNHelper sharedInstance]gettimestampStringFroLocalTime];
    if(requestId == Request_Delete_Note)
    {
        
        if ([[AFNetworkReachabilityManager sharedManager] isReachable])
        {
            
            [CNDataHelper localPermanentlyDeleteWithUserID:[CNHelper sharedInstance].userLoginID noteCreateID:noteID isDeleted:@"-1" noteName:noteName tempUserId:tempUserId noteCreateDate:noteCreteDate isSynchoronization:@"0"];
                [self tableSetUp];
            
           [[CNRequestController sharedInstance]CNRequestDeleteNoteWithUserID:[CNHelper sharedInstance].userLoginID noteID:noteID currentTimestamp:currentTimestamp success:^(id responseDict) {
                [self notifyRequesterWithData:responseDict forRequest:Request_Delete_Note];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            }];
        }
        
        else
        { // net is not working
            [self loderStop:self.view];
        
            [CNDataHelper CNdBDeleteNotePermanentlyWithuserID:[CNHelper sharedInstance].userLoginID noteCreateID:noteID noteName:noteName noteCreateDate:noteCreteDate fileData:fileData timeStamp:timeStamp tempUserId:tempUserId isSynchoronization:@"0"];
            [self tableSetUp];
        }
        
    }
    else if(requestId == Request_Restore_Note)
    {
   
        
        if ([[AFNetworkReachabilityManager sharedManager] isReachable])
        {
            [CNDataHelper localRestoreNoteWithUserID:[CNHelper sharedInstance].userLoginID noteCreateID:noteID isDeleted:@"0" noteName:noteName tempUserId:tempUserId noteCreateDate:noteCreteDate isSynchoronization:@"0"];
            [self tableSetUp];
            
    [[CNRequestController sharedInstance]CNRequestRestoreNoteWithUserID:[CNHelper sharedInstance].userLoginID noteID:noteID currentTimestamp:currentTimestamp  success:^(id responseDict) {
                [self notifyRequesterWithData:responseDict forRequest:Request_Restore_Note];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [self loderStop:self.view];

            }];
        }
        
        else
        {    [self loderStop:self.view];
             [CNDataHelper CNdBRestoreNoteWithUserID:[CNHelper sharedInstance].userLoginID noteCreateID:noteID isDeleted:[NSString stringWithFormat:@"%@",isDeleteValue] noteName:noteName noteCreateDate:noteCreteDate fileData:fileData timeStamp:timeStamp tempUserId:tempUserId isSynchoronization:@"0"];
            [self tableSetUp];
        }
        
        
    }
    else if(requestId == Request_Empty_All_Notes)
    {
        [self loderStop:self.view];
        if ([[AFNetworkReachabilityManager sharedManager] isReachable])
        {
            for(int i= 0; i<arrAllNots.count; i++)
            {
                MasterNote *_objMasterNote = [arrAllNots objectAtIndex:i];
                
                [CNDataHelper localEmptyALLPermanentlyDeleteWithUserID:[CNHelper sharedInstance].userLoginID noteCreateID:_objMasterNote.noteCreateID isDeleted:@"-1" noteName:_objMasterNote.noteName tempUserId:_objMasterNote.tempUserId isSynchoronization:@"0"];
                
            }
            [self tableSetUp];
            
            [[CNRequestController sharedInstance]CNRequestDeleteNoteWithUserID:[CNHelper sharedInstance].userLoginID noteID:@"0" currentTimestamp:currentTimestamp success:^(id responseDict) {
                  
                    [self notifyRequesterWithData:responseDict forRequest:Request_Empty_All_Notes];
                
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                }];
            }
        else
        {   // net is not working
            [self loderStop:self.view];
            for(int i= 0; i<arrAllNots.count; i++)
            {
                MasterNote *_objMasterNote = [arrAllNots objectAtIndex:i];
                [CNDataHelper CNdBDeleteNotePermanentlyWithuserID:[CNHelper sharedInstance].userLoginID noteCreateID:_objMasterNote.noteCreateID noteName:_objMasterNote.noteName noteCreateDate:_objMasterNote.noteCreateDate fileData:_objMasterNote.fileData timeStamp:_objMasterNote.timestamp tempUserId:_objMasterNote.tempUserId isSynchoronization:@"0"];
            }
            [self tableSetUp];
        }
        
    }
}
-(void)notifyRequesterWithData:(id) responseData forRequest:(int) requestId
{
    NSString *message = nil;
    NSString *code = responseData[@"ResponseCode"];
    message = responseData[@"ResponseDetails"];
    if(requestId == Request_Delete_Note)
    {
        
        if([code isEqualToString:@"200"])
        {
            
            [CNDataHelper localPermanentlyDeleteWithUserID:[CNHelper sharedInstance].userLoginID noteCreateID:responseData[@"noteId"] isDeleted:@"-1" noteName:noteName tempUserId:tempUserId noteCreateDate:noteCreteDate isSynchoronization:responseData[@"isSynchronise"]];
            
            [self tableSetUp];
        }
        else
        {
            NSLog(@"Error");
        }
    }
    else if(requestId == Request_Restore_Note)
    {
        if([code isEqualToString:@"200"])
        {
            [CNDataHelper localRestoreNoteWithUserID:[CNHelper sharedInstance].userLoginID noteCreateID:responseData[@"noteId"] isDeleted:responseData[@"isDeleted"] noteName:noteName tempUserId:tempUserId noteCreateDate:noteCreteDate isSynchoronization:responseData[@"isSynchronise"]];
        }
        else
        {
            NSLog(@"Error");
        }
        
    }
    else if(requestId == Request_Empty_All_Notes)
    {
        [self loderStop:self.view];
[CNDataHelper localFlashOutAllRecordsMasterNote:@"MasterNote" userID:[CNHelper sharedInstance].userLoginID];
        
    }
    
     else if(requestId == Request_Agian_Create_Note)
     {
         NSLog(@"%@ Resumr",responseData);
         if([code isEqualToString:@"200"])
         {
             // chnage 25-2-2016
               NSString * newCreateTime = [[CNHelper sharedInstance]gettimestampStringFroLocalTime];
            [CNDataHelper CNCreteAgainNotewithUserID:[CNHelper sharedInstance].userLoginID noteCreateID:responseData[@"noteId"] noteTitle:responseData[@"Notetitle"] isDeleted:responseData[@"isDeleted"] content:responseData[@"content"] noteCreateDate:newCreateTime isSynchoronization:responseData[@"isSynchronise"] tempNoteID:timeStamp ];
             [self tableSetUp];
             
         }

         
     }
    
}

#pragma mark-
#pragma mark-local database work.
-(void)offlinPostDataforRequestId:(int) requestId
{  [self loderStop:self.view];
    if(requestId == Request_Delete_Note)
    {

        [CNDataHelper CNdBDeleteNotePermanentlyWithuserID:[CNHelper sharedInstance].userLoginID noteCreateID:noteID noteName:noteName noteCreateDate:noteCreteDate fileData:fileData timeStamp:timeStamp tempUserId:tempUserId isSynchoronization:@"0"];
        [self tableSetUp];
    }
    else if(requestId == Request_Restore_Note)
    {
        [CNDataHelper CNdBRestoreNoteWithUserID:[CNHelper sharedInstance].userLoginID noteCreateID:noteID isDeleted:[NSString stringWithFormat:@"%@",isDeleteValue] noteName:noteName noteCreateDate:noteCreteDate fileData:fileData timeStamp:timeStamp tempUserId:tempUserId isSynchoronization:@"0"];
        
        [self tableSetUp];
    }
    else if(requestId == Request_Empty_All_Notes)
    {
        for(int i= 0; i<arrAllNots.count; i++)
        {
            MasterNote *_objMasterNote = [arrAllNots objectAtIndex:i];
            
            
            [CNDataHelper CNdBDeleteNotePermanentlyWithuserID:[CNHelper sharedInstance].userLoginID noteCreateID:_objMasterNote.noteCreateID noteName:_objMasterNote.noteName noteCreateDate:_objMasterNote.noteCreateDate fileData:_objMasterNote.fileData timeStamp:_objMasterNote.timestamp tempUserId:_objMasterNote.tempUserId isSynchoronization:@"0"];

        }
        [self tableSetUp];
    }
    
}

@end
