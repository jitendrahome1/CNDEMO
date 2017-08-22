//
//  CNNoteDescriptionViewController.h
//  ClearNote
//
//  Created by Jitendra Agarwal on 04/12/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//
#import <Foundation/Foundation.h>
@protocol updateNoteDelete <NSObject>
@optional
-(void)didFinishedUpdateNote:(BOOL)success;
@end
#import "CNBaseViewController.h"
#import "CNHelper.h"
#import "MasterNote.h"
#import "UIAlertView+Block.h"
@interface CNNoteDescriptionViewController : CNBaseViewController<UIScrollViewDelegate>
{
       IBOutlet UITextField *activeField;
}
@property(nonatomic,strong)MasterNote *objMaster;
@property (weak, nonatomic) IBOutlet UIView *viewBG;
@property (weak, nonatomic) IBOutlet UITextView *txtWritingArea;
@property (weak, nonatomic) IBOutlet UILabel *lblWordCount;
@property (weak, nonatomic) IBOutlet UIButton *btnTrash;
@property (weak, nonatomic) IBOutlet UIView *viewTextAreaBG;
@property (weak, nonatomic) IBOutlet UITextField *txtNoteTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnNoteTitleCross;
@property (weak, nonatomic) IBOutlet UILabel *lblTapNote;
@property (strong, nonatomic) IBOutlet NSMutableArray *arrTotalNotes;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewBG;
@property(nonatomic,weak)id <updateNoteDelete> delegate;
@property(nonatomic)NSInteger pageIndex;
@property(nonatomic)NSInteger tampIndex;



@end
