//
//  CNCreateNewNoteViewController.h
//  ClearNote
//
//  Created by Jitendra Agarwal on 01/12/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//
#import <Foundation/Foundation.h>
@protocol createNoteDelete <NSObject>

@optional
-(void)didFinishedCreatedNote:(BOOL)success;
@end
#import "CNBaseViewController.h"
#import "CNHelper.h"
#import "UIAlertView+Block.h"
@interface CNCreateNewNoteViewController : CNBaseViewController
{
       AppDelegate *appDel;
}

@property (weak, nonatomic) IBOutlet UIView *viewBG;
@property (weak, nonatomic) IBOutlet UIView *viewDiscBG;
@property (weak, nonatomic) IBOutlet UITextField *txtNoteTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceHolder;
@property (weak, nonatomic) IBOutlet UITextView *txtNoteWrtingView;
@property (weak, nonatomic) IBOutlet UIButton *btnTitleCorss;
@property(nonatomic,weak)id <createNoteDelete> delegete;

@end
