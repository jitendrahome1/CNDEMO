//
//  CNAddBackgroundOparation.h
//  ClearNote
//
//  Created by Jitendra Agarwal on 02/12/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "CNHelper.h"
#import "CNBackgroundSync.h"
@interface CNAddBackgroundOparation : NSObject
+(CNAddBackgroundOparation *)sharedInstance;
-(void)AddBackgroundProcess;
@end
