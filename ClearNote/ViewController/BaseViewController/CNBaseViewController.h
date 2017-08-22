//
//  CNBaseViewController.h
//  ClearNote
//
//  Created by Jitendra Agarwal on 27/11/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ProgressHUD.h"
#import "RTSpinKitView.h"
@interface CNBaseViewController : UIViewController


- (BOOL)validateEmail: (NSString *) candidate;
-(NSString*)trim:(NSString*)string;

-(void) showMessage:(NSString*)message withTitle:(NSString *)title;
-(void)showMessgeWithAutoDismiss:(NSString*)message withTitle:(NSString *)title;
-(void)loderStart:(UIView *)tergetView strLbl:(NSString *)strLbl;
-(void)loderStop:(UIView *)tergetView;
@end
