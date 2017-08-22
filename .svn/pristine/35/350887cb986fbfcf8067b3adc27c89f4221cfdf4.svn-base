//
//  CnNoteDescriptionView.m
//  ClearNote
//
//  Created by Jitendra Agarwal on 19/01/16.
//  Copyright © 2016 Jitendra Agarwal. All rights reserved.
//

#import "CnNoteDescriptionView.h"

@implementation CnNoteDescriptionView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CnNoteDescriptionView" owner:self options:nil] firstObject];
        
    }
    return self;
}

- (IBAction)crossBtnAction:(id)sender {
    NSLog(@"%@",_txtNoteTitle.text);
    _txtNoteTitle.text = @"";
    [_txtNoteTitle becomeFirstResponder];
}

//-(void)changeButtonPostion:(BOOL)keyValue
//{
//    if(keyValue)
//     self.btnNoteTitleCross.contentEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, -5);
//    else
//      // self.btnNoteTitleCross.contentEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, -20);
//    self.btnNoteTitleCross.hidden = YES;
//}

@end
