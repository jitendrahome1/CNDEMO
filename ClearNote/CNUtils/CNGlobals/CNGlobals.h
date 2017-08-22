//
//  CNGlobals.h
//  ClearNote
//
//  Created by Jitendra Agarwal on 01/12/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNGlobals : NSObject
#define Request_User_Login 1
#define Request_User_Registration 2
#define Request_Change_Password 3
#define Request_Create_New_Note 4
#define Request_Fetch_All_NoteList 5
#define Request_Move_Trash_Note 6
#define Request_Restore_Note 7
#define Request_Delete_Note 9
#define Request_Update_Note_Contant 10
#define Request_Empty_All_Notes 11
#define Request_Reset_Password 12
#define Request_Refresh_All_NoteList 13
#define Request_Move_Trash_Note_Back 14
#define Request_Agian_Create_Note 15



//////////////////////////////////////////////////////////////////////////////////////////////////////
#define kDeviceTokken        @"devicetoken"
#define kVersionNumber      @"version_number"
#define kDeviceType            @"devicetype"
#define AlertTitle                  @""
#define OflineMessge          @"Check your connection and try again"
#define PasswordChangeMessge          @"Your password has been changed successfully"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#define kEmail @"CNLoginEmail"
#define kLoginID @"CNLoginID"
#define kCurrentDeviceID @"CurrenrDeviceID"

#define kUserName @"CNUserName"
#define kTimeStamp @"CNTimeStamp"
#define kSortStatus @"CNSort"
#define kSysncStatus @"CNSysnic"
#define kManualySync @"CNManualySync"
#define kspinRotations @"CNRotations"
#define kBackgroundSync @"CNBackgroundSync"
extern NSString * const CNWebServiceBaseURL;
extern NSString * const APIKey;
@end
