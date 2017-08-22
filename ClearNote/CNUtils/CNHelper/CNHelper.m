//
//  CNHelper.m
//  ClearNote
//
//  Created by Jitendra Agarwal on 26/11/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//

#import "CNHelper.h"
#import <UIKit/UIKitDefines.h>
@implementation CNHelper
@synthesize queueCount,queue,backgroundQueue;
+(CNHelper *)sharedInstance
{
    static CNHelper *sharedInstance_ = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance_ = [[CNHelper alloc] init];
        sharedInstance_.queue = [[NSOperationQueue alloc] init];
        [sharedInstance_.queue setMaxConcurrentOperationCount:1];
        sharedInstance_.backgroundQueue = dispatch_queue_create("SFQueue", NULL);
    });
    
    return sharedInstance_;
}
-(void)insertIntoQueue:(NSInvocationOperation *)_operation
{
    [self.queue addOperation:_operation];
    self.queueCount--;
    
    if(self.queueCount<1)
        self.queueCount = 1;
}

-(NSMutableArray*)convertUnpredictableResponse:(id)response forKey:(NSString*)key
{
    if ([response[key] isKindOfClass:[NSString class]]) {
        return [NSMutableArray array];
    }else if ([response[key] isKindOfClass:[NSDictionary class]]) {
        return [NSMutableArray arrayWithObject:response[key]];
    }else if ([response[key] isKindOfClass:[NSArray class]]) {
        return [NSMutableArray arrayWithArray:response[key]];
    }
    return nil;
}
#pragma mark- get Current Date
//-(NSString *)currDate
//{
//    NSDate* date = [NSDate date];
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
//    formatter.timeZone = destinationTimeZone;
//    [formatter setDateStyle:NSDateFormatterLongStyle];
//    [formatter setDateFormat:@"MM/dd/yyyy"];
//    NSString* dateString = [formatter stringFromDate:date];
//    return dateString;
//}
#pragma mark- get  Date
-(NSString *)dateFetch: (NSString *)pDate
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yy HH:mm:ss"];
    
    NSDateFormatter *formatterForCurrentDate = [[NSDateFormatter alloc]init];
    [formatterForCurrentDate setDateFormat:@"dd/MM/yy HH:mm:ss"];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [formatterForCurrentDate setTimeZone:gmt];
    
    NSDate *date = [formatterForCurrentDate dateFromString:pDate];
    [formatterForCurrentDate setDateFormat:@"dd/MM/yy"];
    NSString *formattedDate = [[formatterForCurrentDate stringFromDate:date]lowercaseString];
    return formattedDate;;
}

-(NSString *)getDateTimeWithTimestamp: (NSString *)pTimestramp
{

    
    NSString * timeStampString =pTimestramp;
    NSTimeInterval _interval=[timeStampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yy HH:mm:ss"];
    
    NSDateFormatter *formatterForCurrentDate = [[NSDateFormatter alloc]init];
    [formatterForCurrentDate setDateFormat:@"dd/MM/yy HH:mm:ss"];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [formatterForCurrentDate setTimeZone:gmt];
    NSString *formattedDate = [formatterForCurrentDate stringFromDate:date];
    return formattedDate;
}

//#pragma mark- getDateString From Local Time
//-(NSString *)getDateStringFroLocalTime
//{
//    NSDate *currentDateInLocal = [NSDate date];
//    NSDateFormatter *dateFormatterTime = [[NSDateFormatter alloc] init];
////NSTimeZone *destinationTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//   // [dateFormatterTime setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
//// dateFormatterTime.timeZone = destinationTimeZone;
////    [dateFormatterTime setDateStyle:NSDateFormatterLongStyle];
//    [dateFormatterTime setDateFormat:@"dd/MM/yy hh:mm:ss"];
//    NSString *currentLocalDateAsStr = [dateFormatterTime stringFromDate:currentDateInLocal];
//    return currentLocalDateAsStr;
//}

-(NSString *)getDateStringFroLocalTime {
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yy HH:mm:ss"];
    NSString *currentDateString = [dateFormatter stringFromDate:[NSDate date]];
    NSDateFormatter *formatterForCurrentDate = [[NSDateFormatter alloc]init];
    [formatterForCurrentDate setDateFormat:@"dd/MM/yy HH:mm:ss"];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [formatterForCurrentDate setTimeZone:gmt];
    NSDate *currentDate1 = [formatterForCurrentDate dateFromString:currentDateString];
    NSString *currentLocalDateAsStr = [dateFormatter stringFromDate:currentDate1];
    return currentLocalDateAsStr;
}

-(NSString *)getDeviceID
{
    UIDevice *device = [UIDevice currentDevice];
    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    return currentDeviceId;
}
//#pragma mark- Convert date to time with am and pm
//-(NSString *)TimeAMPMWithData:(NSString *)pData
//{
//    NSDateFormatter *dateFormatterTime = [[NSDateFormatter alloc] init];
//    [dateFormatterTime setDateFormat:@"dd/mm/yy hh:mm:ss"];
//    NSDate *date = [dateFormatterTime dateFromString:pData];
//    [dateFormatterTime setDateFormat:@"hh:mma"];
//    NSString *formattedDate = [[dateFormatterTime stringFromDate:date]lowercaseString];
//    return formattedDate;
//    }

#pragma mark- Convert date to time with am and pm
-(NSString *)TimeAMPMWithData:(NSString *)pData
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yy HH:mm:ss"];
    NSDateFormatter *formatterForCurrentDate = [[NSDateFormatter alloc]init];
    [formatterForCurrentDate setDateFormat:@"dd/MM/yy HH:mm:ss"];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [formatterForCurrentDate setTimeZone:gmt];
    NSDate *date = [formatterForCurrentDate dateFromString:pData];
    [formatterForCurrentDate setDateFormat:@"hh:mma"];
    NSString *formattedDate = [[formatterForCurrentDate stringFromDate:date]lowercaseString];
    return formattedDate;
}
#pragma mark - get timestampStringFroLocalTime
-(NSString *)gettimestampStringFroLocalTime
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yy HH:mm:ss"];
    NSString *currentDateString = [dateFormatter stringFromDate:[NSDate date]];
    NSDateFormatter *formatterForCurrentDate = [[NSDateFormatter alloc]init];
    [formatterForCurrentDate setDateFormat:@"dd/MM/yy HH:mm:ss"];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
      [formatterForCurrentDate setTimeZone:gmt];
    NSDate *currentDate1 = [formatterForCurrentDate dateFromString:currentDateString];
    long long milliseconds = (long long)([currentDate1 timeIntervalSince1970]);
    NSString *strTimeStamp = [NSString stringWithFormat:@"%lld",milliseconds];
    return strTimeStamp;
    //  NSDateFormatter *dateFormatterTime = [[NSDateFormatter alloc] init];
    //  //  [dateFormatterTime setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    //    [dateFormatterTime setDateFormat:@"dd/MM/yy hh:mm:ss"];
    //   NSString *localTime = [self getDateStringFroLocalTime];    //get the local current time
    //    NSDate *objUTCDate  = [dateFormatterTime dateFromString:localTime];
    //    long long milliseconds = (long long)([objUTCDate timeIntervalSince1970]);
    //    NSString *strTimeStamp = [NSString stringWithFormat:@"%lld",milliseconds];
    //
    //    return strTimeStamp;
    }
-(NSString *)timestampTodate:(NSString *)timestamp
{
   NSString * timeStampString =timestamp;
     NSTimeInterval _interval=[timeStampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yy HH:mm:ss"];
   
    NSDateFormatter *formatterForCurrentDate = [[NSDateFormatter alloc]init];
    [formatterForCurrentDate setDateFormat:@"dd/MM/yy HH:mm:ss"];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [formatterForCurrentDate setTimeZone:gmt];
    NSString *formattedDate = [formatterForCurrentDate stringFromDate:date];
    return formattedDate;
}
-(void)flushOutLocalDatabase
{
    [CNDataHelper removeAllRecordsFromTable:@"Users"];
    [CNDataHelper removeAllRecordsFromTable:@"MasterNote"];
    [CNDataHelper removeAllRecordsFromTable:@"CreateNoteOfline"];
    [CNDataHelper removeAllRecordsFromTable:@"CreateTemporaryDelete"];
    [CNDataHelper removeAllRecordsFromTable:@"CreateRestoreOfline"];
    [CNDataHelper removeAllRecordsFromTable:@"CreatePermanentDelete"];
    [CNDataHelper removeAllRecordsFromTable:@"CreateNoteContentOffline"];
}
#pragma mark- update note id with tempUserID
-(void)replaceTempidWithNoteID:(NSString *)userID noteID:(NSString *)noteID tempUserId:(NSString *)tempUserId 
{
    [CNDataHelper CNdBreplaceTempUserIdWithNoteId:userID tempNoteid:tempUserId noteID:noteID tableName:@"CreateNoteContentOffline"];
    [CNDataHelper CNdBreplaceTempUserIdWithNoteId:userID tempNoteid:tempUserId noteID:noteID tableName:@"CreateTemporaryDelete"];
    [CNDataHelper CNdBreplaceTempUserIdWithNoteId:userID tempNoteid:tempUserId noteID:noteID tableName:@"CreateRestoreOfline"];
}

-(void)addNoNetworkViewOverView:(UIView *)inview OriginY:(CGFloat)originy WithText:(NSString *)toastText
{
    UIView *view=(UIView *)[inview viewWithTag:kNetworkToastViewTag];
    if (!view) {
        UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, originy, inview.frame.size.width, originy>0?0:40)];
        view.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        view.backgroundColor=[UIColor blackColor];
        view.tag=kNetworkToastViewTag;
        UILabel *lblNoNetwork=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, view.frame.size.width-40, originy>0?0:40)];
        [lblNoNetwork setBackgroundColor:[UIColor clearColor]];
        lblNoNetwork.numberOfLines=0;
        [lblNoNetwork setTextAlignment:NSTextAlignmentCenter];
        lblNoNetwork.tag=122;
        [lblNoNetwork setFont:[UIFont fontWithName:@"Helvetica" size:16]];
        [lblNoNetwork setTextColor:[UIColor whiteColor]];
        [lblNoNetwork setText:toastText];
        [view addSubview:lblNoNetwork];
        [inview addSubview:view];
        if (originy>0) {
            
            [UIView animateWithDuration:0.3 delay:0.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
                view.frame = CGRectMake(0, originy, inview.frame.size.width, 40);
                lblNoNetwork.frame = CGRectMake(10, 0, view.frame.size.width-40, 40);
            }completion:^(BOOL finished) {
            }];
        }
        else
        {
            [view.layer removeAllAnimations];
            CATransition *transition = [CATransition animation];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromBottom;
            transition.duration = 0.3f;
            [view.layer addAnimation:transition forKey:nil];
        }
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self removeNoNetworkView:inview];
//        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeNoNetworkView:inview];
        });
        
    }
    
}
-(void)removeNoNetworkView:(UIView *)inview
{
    __block UIView *view=(UIView *)[inview viewWithTag:kNetworkToastViewTag];
    if (view) {
        if (view.frame.origin.y>0) {
            UILabel *lbl=(UILabel *)[view viewWithTag:122];
            
            [UIView animateWithDuration:0.3 delay:0.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
                view.frame = CGRectMake(0, view.frame.origin.y, view.frame.size.width, 0);
                lbl.frame = CGRectMake(10, 0, view.frame.size.width-40, 0);
            }completion:^(BOOL finished) {
            }];
        }
        
        else
        {
            [view.layer removeAllAnimations];
            CATransition *transition = [CATransition animation];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromTop;
            transition.duration = 0.3f;
            [view.layer addAnimation:transition forKey:nil];
            view.hidden=YES;
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [view.layer removeAllAnimations];
            [view removeFromSuperview];
            view = nil;
        });
        
        
    }
}
//Method for bounce annimation

-(void)addSubviewWithBounce_OnTheView:(UIView*)OnView AnnimatedView:(UIView*)theView
{
    theView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    [UIView animateWithDuration:0.3/1 animations:^{
        theView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/1 animations:^{
            theView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/1 animations:^{
                theView.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}
@end
