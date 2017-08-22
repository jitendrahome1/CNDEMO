//
//  CNCustomAlert.h
//  ClearNote
//
//  Created by Jitendra Agarwal on 16/12/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol CNCustomAlertDelegte <NSObject>
@optional
-(void)donePopupText;
@end
@interface CNCustomAlert : UIView
@property (weak, nonatomic) IBOutlet UIView *viewBox;
@property (weak, nonatomic) IBOutlet UILabel *lblAlertMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnOk;
@property (nonatomic,strong) id<CNCustomAlertDelegte> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageBG;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constantHight;

+ (instancetype)instantiateFromNib;
@end
