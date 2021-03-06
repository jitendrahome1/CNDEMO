//
//  CNHelper.h
//  ClearNote
//
//  Created by Jitendra Agarwal on 26/11/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CNGlobals.h"
#import "CNRequestController.h"
@interface CNHelper : NSObject
#define ADD_QUEUE_INTERVAL 0.5
#define kToastViewTag               5415
#define kNetworkToastViewTag        5416

#define kDefaulColor [UIColor colorWithRed:63.0f/255.0f green:133.0f/255.0f blue:244.0f/255.0f alpha:1.0]
#define kFontFutura(X) [UIFont fontWithName:@"Futura" size:X]
#define kFontRobotoRegular(X) [UIFont fontWithName:@"Roboto-Regular" size:X]

#define Set_DeviceID(key, object) \
[[NSUserDefaults standardUserDefaults] setObject:object forKey:key]; \
[[NSUserDefaults standardUserDefaults] synchronize]; \

#define Set_UserEmail(key, object) \
[[NSUserDefaults standardUserDefaults] setObject:object forKey:key]; \
[[NSUserDefaults standardUserDefaults] synchronize]; \

#define Set_UserID(key, object) \
[[NSUserDefaults standardUserDefaults] setObject:object forKey:key]; \
[[NSUserDefaults standardUserDefaults] synchronize]; \

#define Set_TimeStamp(key, object) \
[[NSUserDefaults standardUserDefaults] setObject:object forKey:key]; \
[[NSUserDefaults standardUserDefaults] synchronize]; \

#define Set_UserName(key, object) \
[[NSUserDefaults standardUserDefaults] setObject:object forKey:key]; \
[[NSUserDefaults standardUserDefaults] synchronize]; \

#define Defaults_get_bool(key)[[NSUserDefaults standardUserDefaults] boolForKey:key]

#define get_UserEmail(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define get_UserID(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

#define get_ValueByKye(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

#define Defaults_remove_object(key) [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]

#define Defaults_set_bool_sort(key, value) \
[[NSUserDefaults standardUserDefaults] setBool:value forKey:key];\
[[NSUserDefaults standardUserDefaults] synchronize]; \

#define Defaults_set_bool_onoff(key, value) \
[[NSUserDefaults standardUserDefaults] setBool:value forKey:key];\
[[NSUserDefaults standardUserDefaults] synchronize]; \

#define Defaults_set_bool_BackgroundSync(key, value) \
[[NSUserDefaults standardUserDefaults] setBool:value forKey:key];\
[[NSUserDefaults standardUserDefaults] synchronize]; \

#define Defaults_set_bool_manual_SyncStatus(key, value) \
[[NSUserDefaults standardUserDefaults] setBool:value forKey:key];\
[[NSUserDefaults standardUserDefaults] synchronize]; \

#define Defaults_set_bool_syncRotations(key, value) \
[[NSUserDefaults standardUserDefaults] setBool:value forKey:key];\
[[NSUserDefaults standardUserDefaults] synchronize]; \


#define IS_IPHONE_4 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 480)
#define IS_IPHONE_4s ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 480)
#define IS_IPHONE_5 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 568)
#define IS_IPHONE_5s ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 568)

#define SYSTEM_VERSION      [[[UIDevice currentDevice] systemVersion] floatValue]

@property (nonatomic, readwrite) int queueCount;
@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) dispatch_queue_t backgroundQueue;
@property (strong, nonatomic) NSString *userLoginID;
@property (strong, nonatomic) NSString *userLoginEmail;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *noteListTimeStamp;
@property (assign, nonatomic) NSInteger  segementSortIndexValue;
@property (assign, nonatomic) NSInteger segementOnOfftIndexValue;
@property (nonatomic,assign) BOOL segementBoolvalue;
/////Dunamic base URL
@property(nonatomic,strong)NSString *CNBaseURL;

+(CNHelper *)sharedInstance;
-(void)insertIntoQueue:(NSInvocationOperation *)_operation;
-(void)addNoNetworkViewOverView:(UIView *)inview OriginY:(CGFloat)originy WithText:(NSString *)toastText;
-(NSMutableArray*)convertUnpredictableResponse:(id)response forKey:(NSString*)key;
-(NSString *)gettimestampStringFroLocalTime;
-(NSString *)getDateStringFroLocalTime;
-(NSString *)TimeAMPMWithData:(NSString *)pData;
-(NSString *)timestampTodate:(NSString *)timestamp;
-(NSString *)dateFetch: (NSString *)pDate;
-(void)flushOutLocalDatabase;
-(void)replaceTempidWithNoteID:(NSString *)userID noteID:(NSString *)noteID tempUserId:(NSString *)tempUserId;
-(NSString *)getDateTimeWithTimestamp: (NSString *)pTimestramp;
-(NSString *)getDeviceID;
@end
