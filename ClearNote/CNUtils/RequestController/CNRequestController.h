//
//  CNRequestController.h
//  ClearNote
//
//  Created by Jitendra Agarwal on 01/12/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import <Foundation/Foundation.h>
#import "CNDataHelper.h"
#import "CNHelper.h"
@interface CNRequestController : AFHTTPRequestOperationManager


-(void)CNRequestAuthenticateUserWithEmail:(NSString *)email password:(NSString *)password success: (void(^)(id responseDict))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;
-(void)CNRequestRegistrationWithEmail:(NSString *)email password:(NSString *)password userName:(NSString *)userName success: (void(^)(id responseDict))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;
-(void)CNRequestChnagePasswordWithUserID:(NSString *)userID oldPassword:(NSString *)password newPassword:(NSString *)newPassword success: (void(^)(id responseDict))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;
-(void)CNRequestCreateNoteWithUserID:(NSString *)userID noteTitle:(NSString *)noteTitle content:(NSString *)content createDateTime:(NSString *)createDateTime isDeleted:(NSString *)isDeleted isSynchronise: (NSString *)isSynchronise success: (void(^)(id responseDict))success  failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(CNRequestController *)sharedInstance;
//-(void)CNRequestGetAllNoteListWithUserID:(NSString *)userID timestamp:(NSString *)timestamp currentTimestamp:(NSString *)currentTimestamp success: (void(^)(id responseDict))success  failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)CNRequestGetAllNoteListWithUserID:(NSString *)userID timestamp:(NSString *)timestamp currentTimestamp:(NSString *)currentTimestamp DeviceID:(NSString *)DeviceID success: (void(^)(id responseDict))success  failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)CNRequestMoveToTrashWithUserID:(NSString *)userID noteID:(NSString *)noteID currentTimestamp:(NSString *)currentTimestamp success: (void(^)(id responseDict))success  failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;
-(void)CNRequestRestoreNoteWithUserID:(NSString *)userID noteID:(NSString *)noteID currentTimestamp:(NSString *)currentTimestamp success: (void(^)(id responseDict))success  failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;
-(void)CNRequestDeleteNoteWithUserID:(NSString *)userID noteID:(NSString *)noteID currentTimestamp:(NSString *)currentTimestamp success: (void(^)(id responseDict))success  failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;
-(void)CNRequestWriteAndEditWithUserID:(NSString *)userID noteID:(NSString *)noteID content:(NSString *)content noteTitle:(NSString *)noteTitle currentTimestamp:(NSString *)currentTimestamp success: (void(^)(id responseDict))success  failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;
-(void)CNRequestForgotPasswordWithEmail:(NSString *)email success: (void(^)(id responseDict))success  failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
