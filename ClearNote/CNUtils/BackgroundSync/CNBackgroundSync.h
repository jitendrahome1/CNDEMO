//
//  CNBackgroundSync.h
//  ClearNote
//
//  Created by Jitendra Agarwal on 02/12/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "CNHelper.h"
@interface CNBackgroundSync : NSObject
+(CNBackgroundSync *)sharedInstance;

-(void)StartProcess:(id)Message;
@end
