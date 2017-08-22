//
//  UIAlertView+Block.h
//  AxisCCA
//
//  Created by Rupam Mitra on 17/06/15.
//  Copyright (c) 2015 Indusnet Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Block)

+(instancetype)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray withCompletion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completion;
@property (strong, nonatomic) void(^tapHandler)(UIAlertView *alertView, NSInteger buttonIndex);

@end
