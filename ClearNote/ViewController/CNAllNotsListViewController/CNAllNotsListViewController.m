//
//  CNAllNotsListViewController.m
//  ClearNote
//
//  Created by Jitendra Agarwal on 27/11/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//
#import "CNAllNotsListViewController.h"
#import "CNCreateNewNoteViewController.h"
#import "CNTrashViewController.h"
#import "CNSettingsViewController.h"
#import "SWTableViewCell.h"
#import "MasterNote.h"
@interface CNAllNotsListViewController ()<SWTableViewCellDelegate,createNoteDelete,updateNoteDelete>
{
    NSMutableArray *arrAllNots;
    NSString * noteID;
    NSString *noteName;
    NSString *tempUserId;
    
    NSString *noteData;
    NSString *noteCreteDate;
    NSNumber *isDeleteValue;
    NSString *timeStamp;
    NSString *fileData;
    NSArray *actionButtonItems;
    UIImageView *ImageView;
    NSMutableArray *arrFetchData;
}
@end

@implementation CNAllNotsListViewController
{
    AppDelegate *appDel;
}

- (void)viewDidLoad
{   [super viewDidLoad];
  appDel = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    appDel.isUploadFromBacground = YES;

    arrAllNots = [[NSMutableArray alloc]init];
    [CNHelper sharedInstance].userLoginID = get_UserID(@"CNLoginID");
     [self intinalSetup];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)intinalSetup {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    [[UINavigationBar appearance]setShadowImage:[[UIImage alloc] init]];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"All Notes";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName: kDefaulColor,
       NSFontAttributeName:kFontRobotoRegular(16)}];
    UIBarButtonItem *newNoteBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewNoteAction)];
    ImageView = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"SynchronizationHeaderIconiPhone.png"]];
    
    UIButton *synchronizationBtn  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    synchronizationBtn.bounds = ImageView.bounds;
    [synchronizationBtn addSubview:ImageView];
    synchronizationBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -25);
    [synchronizationBtn addTarget:self action:@selector(synchronizationAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *synchronization = [[UIBarButtonItem alloc] initWithCustomView:synchronizationBtn];
    actionButtonItems = @[newNoteBtn, synchronization];
    [self.navigationItem setRightBarButtonItems:actionButtonItems animated:NO];
    UIBarButtonItem *settingBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SettingsHeaderIconiPhone.png"] style:UIBarButtonItemStylePlain target:self action:@selector(settingBtnAction)];
    self.navigationItem.leftBarButtonItem = settingBtn;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self loderStop:self.view];
    self.navigationItem.title = @"All Notes";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName: kDefaulColor,
       NSFontAttributeName:kFontRobotoRegular(16)}];
    
    if(Defaults_get_bool(kSortStatus))
    {
        // sort by Alphabet
        [self sortByDate];
    }
    else
    {
    [self sortByAlphabet];
 }
    [self.tblAllNotes setContentOffset:CGPointMake(0, 0) animated:YES];

    
}
//The date sort function//
NSComparisonResult dateEvent1SortDescending(MasterNote *event1, MasterNote *event2, void *context) {
    if([event1.isSynchoronization isEqualToNumber:[NSNumber numberWithInt:0]])
    {
        return [ [[CNHelper sharedInstance]getDateTimeWithTimestamp:event1.noteCreateDate] compare: [[CNHelper sharedInstance]getDateTimeWithTimestamp:event2.noteCreateDate]];
    }
    else
        return [event2.noteCreateDate compare:event1.noteCreateDate]; // descending order
}
#pragma mark- Button Action
- (void)settingBtnAction {
    dispatch_async(dispatch_get_main_queue(), ^{
        CNSettingsViewController * settingVC = (CNSettingsViewController *)[self .storyboard instantiateViewControllerWithIdentifier:@"CNSettingsViewController"];
        [self.navigationController pushViewController:settingVC animated:YES];
    });
}
#pragma mark-
#pragma mark-Animation
- (void)synchronizationAction {
   
       if(Defaults_get_bool(kBackgroundSync))
        Defaults_set_bool_BackgroundSync(kBackgroundSync, NO);
        if(Defaults_get_bool(kspinRotations))
        {
            
                if([self checkDataLocalDataBase])
                      {
                          ImageView.userInteractionEnabled = NO;
                            [appDel startMonitoringNetwork];
                          dispatch_async(dispatch_get_main_queue(), ^{
                              
                              CABasicAnimation* rotationAnimation;
                              rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
                              rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 1.9];
                              rotationAnimation.duration = 1;
                              rotationAnimation.cumulative = YES;
                              rotationAnimation.repeatCount = 1.7014116E+38;
                              [ImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
               
                            [self performSelector:@selector(StopAnimation) withObject:nil afterDelay:0.9];
                     
                          });
                      }
            else
            {
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                  
                       if(Defaults_get_bool(kSysncStatus))
                        {
                            Defaults_set_bool_BackgroundSync(kBackgroundSync, YES);
                        }
                    [self postDataforRequestId:Request_Refresh_All_NoteList];

                    
                });
                dispatch_async(dispatch_get_main_queue(), ^{
                    CABasicAnimation* rotationAnimation;
                    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
                    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 1.9];
                    rotationAnimation.duration = 1;
                    rotationAnimation.cumulative = YES;
                    rotationAnimation.repeatCount = 1.7014116E+38;
                    [ImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
                    appDel.isBackgroundSync = NO;

                  });
                
            }
        }
    
    else
    {
        [ImageView.layer removeAllAnimations];
        
    }
}
-(void)StopAnimation
{
    [ImageView.layer removeAllAnimations];
   Defaults_set_bool_BackgroundSync(kBackgroundSync, YES);

}
-(BOOL)checkDataLocalDataBase
{
    BOOL result = NO;
    arrFetchData =[[NSMutableArray alloc]init];
    
    arrFetchData = [CNDataHelper CNdBFetchBackSyncCreateNoteOfline:get_ValueByKye(kLoginID) entityName:@"CreateNoteOfline"];
    if(arrFetchData.count > 0)
    {
        result = YES;
    }
    [arrFetchData removeAllObjects];
    arrFetchData = [CNDataHelper CNdBFetchBackSyncCreateNoteOfline:get_ValueByKye(kLoginID) entityName:@"CreateTemporaryDelete"];
    if(arrFetchData.count > 0)
    {
         result = YES;
        
    }
    [arrFetchData removeAllObjects];

    arrFetchData = [CNDataHelper CNdBFetchBackSyncCreateNoteOfline:get_ValueByKye(kLoginID) entityName:@"CreateTemporaryDelete"];
    if(arrFetchData.count > 0)
    {
           result = YES;
    
    }
    [arrFetchData removeAllObjects];
    arrFetchData = [CNDataHelper CNdBFetchBackSyncCreateNoteOfline:get_ValueByKye(kLoginID) entityName:@"CreatePermanentDelete"];
    if(arrFetchData.count > 0)
    {
          result = YES;
    }
    [arrFetchData removeAllObjects];
    arrFetchData = [CNDataHelper CNdBFetchBackSyncCreateNoteOfline:get_ValueByKye(kLoginID) entityName:@"CreateRestoreOfline"];
    if(arrFetchData.count > 0)
    {
            result = YES;
    }
    [arrFetchData removeAllObjects];
    arrFetchData = [CNDataHelper CNdBFetchBackSyncCreateNoteOfline:get_ValueByKye(kLoginID) entityName:@"CreateNoteContentOffline"];
    if(arrFetchData.count > 0)
    {
     result = YES;
    }

    return result ;
    
}
- (void)addNewNoteAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CNCreateNewNoteViewController *creteNewNoteVC = (CNCreateNewNoteViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CNCreateNewNoteViewController"];
        creteNewNoteVC.delegete = self;
        [self.navigationController pushViewController:creteNewNoteVC animated:NO];
    });
}

#pragma mark- User Define Function
-(void)reloadData
{
    if(Defaults_get_bool(kSortStatus))
    {
        [self sortByDate];
    }
    else{
        [self sortByAlphabet];
    }
//[self.tblAllNotes setContentOffset:CGPointMake(0, 0) animated:YES];

}
#pragma mark sort method
- (void)sortByAlphabet {
    [arrAllNots removeAllObjects];
    NSArray *arrResult = nil;
    arrResult = [CNDataHelper CNdBGetAllNoteWithUserID:[CNHelper sharedInstance].userLoginID isdeleValue:@"0"];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"noteName" ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
        NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch | NSNumericSearch | NSWidthInsensitiveSearch | NSForcedOrderingSearch | NSRegularExpressionSearch;
        NSRange string1Range = NSMakeRange(0, ((NSString *)obj1).length);
        return [(NSString *)obj1 compare: (NSString *)obj2 options: comparisonOptions range: string1Range locale: [NSLocale currentLocale]];
    }];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortByName, nil];
    arrResult = [NSArray arrayWithArray:[arrResult sortedArrayUsingDescriptors:sortDescriptors]];
    [arrAllNots addObjectsFromArray:arrResult];
    if (arrAllNots == nil || [arrAllNots count] == 0) {
        self.tblAllNotes.hidden = YES;
    }
    else
    {
        self.tblAllNotes.hidden = NO;
        [self.tblAllNotes reloadData];
    }
}

- (void)sortByDate {
    // sort by date
    [arrAllNots removeAllObjects];
    NSArray *arrResult = nil;
    arrResult = [CNDataHelper CNdBGetAllNoteWithUserID:[CNHelper sharedInstance].userLoginID isdeleValue:@"0"];
    [arrAllNots addObjectsFromArray:arrResult];
    if (arrAllNots == nil || [arrAllNots count] == 0) {
        self.tblAllNotes.hidden = YES;
    }
    else
    {   self.tblAllNotes.hidden = NO;

        [self.tblAllNotes reloadData];
    }
}
-(NSString *)getDateTimeValue:(MasterNote *)_objMasterList
{
    NSString *date = nil;
    NSString *time = nil;
    NSString *dateTime = nil;
    NSString *isSysnc = [NSString stringWithFormat:@"%@",_objMasterList.isSynchoronization];

    if([isSysnc isEqualToString:@"0"])
    {   NSString* strTimestamp = [[CNHelper sharedInstance]timestampTodate:_objMasterList.timestamp];
        date = [[CNHelper sharedInstance]dateFetch:strTimestamp];
        time = [[CNHelper sharedInstance]TimeAMPMWithData:strTimestamp];
    }
    else
    {//chnage 4 - 2 -2016
        NSString* strTimestamp = [[CNHelper sharedInstance]timestampTodate:_objMasterList.timestamp];
        date = [[CNHelper sharedInstance]dateFetch:strTimestamp];
        time = [[CNHelper sharedInstance]TimeAMPMWithData:strTimestamp];
        //end
//        date = [[CNHelper sharedInstance]dateFetch:_objMasterList.noteCreateDate];
//        time = [[CNHelper sharedInstance]TimeAMPMWithData:_objMasterList.noteCreateDate];
    }
   dateTime = [NSString stringWithFormat:@"%@ , %@",date, time];

    return dateTime;

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"cnAllNoteListTableCell";
    CNAllNoteListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
   MasterNote *_objMasterList = [arrAllNots objectAtIndex:indexPath.row];
cell.lblNoteName.text = _objMasterList.noteName;
cell.lblNoteDateTime.text = [self getDateTimeValue:_objMasterList];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {[self.tblAllNotes deleteRowsAtIndexPaths:[[NSArray alloc]initWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"       " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        MasterNote * _noteOBJ = [arrAllNots objectAtIndex:indexPath.row];
                                        noteID = _noteOBJ.noteCreateID;
                                        noteName = _noteOBJ.noteName;
                                        tempUserId = _noteOBJ.tempUserId;
                                        
                                        // chnage 23-2-2016
                                        //noteID = _noteOBJ.fileData;
                                        noteCreteDate = _noteOBJ.noteCreateDate;
                                        isDeleteValue =    [NSNumber numberWithInt:1];
                                        noteData = _noteOBJ.fileData;
                                        timeStamp = _noteOBJ.timestamp;
                                        fileData = _noteOBJ.fileData;
                                        
                                        
                                        if(Defaults_get_bool(kManualySync))
                                        [self postDataforRequestId:Request_Move_Trash_Note];
                                        else
                                        [self offlinPostDataforRequestId:Request_Move_Trash_Note];
                                    }];
    button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TrashiPhone"]];
    return @[button];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MasterNote *_objMaster = [arrAllNots objectAtIndex:indexPath.row];
    CNNoteDescriptionViewController *discVC = (CNNoteDescriptionViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CNNoteDescriptionViewController"];
    discVC.objMaster = _objMaster;
    discVC.arrTotalNotes = arrAllNots;
    discVC.pageIndex = (NSInteger )indexPath.row;
    discVC.delegate = self;
    [self.navigationController pushViewController:discVC animated:NO];

}
#pragma mark-
#pragma mark- Crete note Deletegae and Update note Delegete
-(void)didFinishedCreatedNote:(BOOL)success
{
    if(success)
        [self reloadData];
}
-(void)didFinishedUpdateNote:(BOOL)success
{
    if(success)
        [self reloadData];
}
// APi Call
#pragma mark -
#pragma mark Handel Response
-(void)postDataforRequestId:(int) requestId
{
    NSString *currentTimestamp = nil;
    currentTimestamp = [[CNHelper sharedInstance]gettimestampStringFroLocalTime];
    if(requestId == Request_Move_Trash_Note)
    {
        if ([[AFNetworkReachabilityManager sharedManager] isReachable])
        {
            // 1 store to local database
            //2 Then update to server.
            [CNDataHelper localMoveToTrashWithUserID:[CNHelper sharedInstance].userLoginID  noteCreateID:noteID isDeleted:[NSString stringWithFormat:@"%@",isDeleteValue]noteName:noteName tempUserId:tempUserId noteCreateDate:noteCreteDate isSynchoronization:@"0"];
                [self reloadData];
            
             //  if(!Defaults_get_bool(kSysncStatus))
               
                     [[CNRequestController sharedInstance]CNRequestMoveToTrashWithUserID:[CNHelper sharedInstance].userLoginID noteID:noteID currentTimestamp:currentTimestamp success:^(id responseDict) {
                if (responseDict != (id)[NSNull null])
                {
                    [self notifyRequesterWithData:responseDict forRequest:Request_Move_Trash_Note];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];
           
            
        }
        else
        {// is net is not working
            [CNDataHelper CNdBMoveTrashWithUserID:[CNHelper sharedInstance].userLoginID noteCreateID:noteID isDeleted:@"1" noteName:noteName tempUserId:tempUserId noteCreateDate:noteCreteDate fileData:fileData timeStamp:timeStamp isSynchoronization:@"0"];
            [self reloadData];
            // [self tableSetUp];
        }
        
    }
    
    else if(requestId == Request_Refresh_All_NoteList)
    {
        NSString *timestamp = get_ValueByKye(kTimeStamp);
        NSString *currentTimestamp = [[CNHelper sharedInstance]gettimestampStringFroLocalTime];
        
        if ([[AFNetworkReachabilityManager sharedManager] isReachable])
        {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                
                [[CNRequestController sharedInstance]CNRequestGetAllNoteListWithUserID:get_UserID(kLoginID) timestamp:timestamp currentTimestamp:currentTimestamp DeviceID:get_ValueByKye(kCurrentDeviceID)  success:^(id responseDict) {
                


                    
                    NSLog(@" All List -> %@",responseDict);
                    if (responseDict != (id)[NSNull null])
                    {
                        [self notifyRequesterWithData:responseDict forRequest:Request_Refresh_All_NoteList];
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self loderStop:self.view];
                    [ImageView.layer removeAllAnimations];
                    [self reloadData];
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self loderStop:self.view];
                    //  [ImageView.layer removeAllAnimations];
                });
                
            });
        }
        else
        {
            [ImageView.layer removeAllAnimations];
            [self loderStop:self.view];
            [self reloadData];
            // net is not working
        }
    }
}

-(void)notifyRequesterWithData:(id) responseData forRequest:(int) requestId
{
    NSString *message = nil;
    NSString *code = responseData[@"ResponseCode"];
    message = responseData[@"ResponseDetails"];
    if(requestId == Request_Move_Trash_Note)
    {
        if([code isEqualToString:@"200"])
        {
            
            [CNDataHelper localMoveToTrashWithUserID:[CNHelper sharedInstance].userLoginID  noteCreateID:responseData[@"noteId"] isDeleted:responseData[@"isDeleted"]noteName:noteName tempUserId:tempUserId noteCreateDate:noteCreteDate isSynchoronization:responseData[@"isSynchronise"]];

        //[self reloadData];
           
        }
        else if([code isEqualToString:@"201"])
        {
            [self loderStop:self.view];
            NSLog(@"Unknow data Error");
        }
    }
    else if(requestId == Request_Refresh_All_NoteList)
    {
        NSString *message = nil;
        NSString *code = responseData[@"ResponseCode"];
        message = responseData[@"ResponseDetails"];
        if([code isEqualToString:@"200"])
        {   [self loderStop:self.view];
            [ImageView.layer removeAllAnimations];
            Set_TimeStamp(kTimeStamp, responseData[@"TimeStamp"]);
            NSArray *arrNoteList = responseData[@"noteList"];
            if (!(arrNoteList == nil || [arrNoteList count] == 0)) {
                
                for(NSDictionary *dict in arrNoteList)
                {
                    [CNDataHelper CNdBNoteAlredyExistWithUserId:[CNHelper sharedInstance].userLoginID noteCreateID:dict[@"noteId"] noteTitle:dict[@"noteName"] isDeleted:dict[@"isDeleted"] content:dict[@"content"] noteCreateDate:dict[@"noteModifiedDate"]  isSynchoronization:dict[@"isSynchronise"]];
                    // [self tableSetUp];
                    
                }
                [self reloadData];
                // [self tableSetUp];
                
            }
            else
            { [ImageView.layer removeAllAnimations];
                [self loderStop:self.view];
                [self reloadData];
                
            }
        }
        else if([code isEqualToString:@"201"])
        {
            [ImageView.layer removeAllAnimations];
            [self loderStop:self.view];
            
            [self reloadData];
            
            Set_TimeStamp(kTimeStamp, responseData[@"TimeStamp"]);
        }
    }
    

}

#pragma mark-
#pragma mark-local database work.
-(void)offlinPostDataforRequestId:(int) requestId
{
    if(requestId == Request_Move_Trash_Note)
    {
  
        
        [CNDataHelper CNdBMoveTrashWithUserID:[CNHelper sharedInstance].userLoginID noteCreateID:noteID isDeleted:@"1" noteName:noteName tempUserId:tempUserId noteCreateDate:noteCreteDate fileData:fileData timeStamp:timeStamp isSynchoronization:@"0"];
        
        
        [self reloadData];
        
    }
    
}


@end
