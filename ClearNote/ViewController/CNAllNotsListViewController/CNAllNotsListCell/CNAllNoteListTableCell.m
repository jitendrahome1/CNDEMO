//
//  CNAllNoteListTableCell.m
//  ClearNote
//
//  Created by Jitendra Agarwal on 27/11/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//

#import "CNAllNoteListTableCell.h"

@implementation CNAllNoteListTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(CGSize)getLabelSizeFortext:(NSString *)text forWidth:(float)width WithFont:(UIFont *)font
{
    
    CGSize constraint = CGSizeMake(width, MAXFLOAT);
    CGRect height  = [text boundingRectWithSize:constraint options:(NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingTruncatesLastVisibleLine) attributes:@{NSFontAttributeName:font} context:nil];
    
    return height.size;
}

@end
