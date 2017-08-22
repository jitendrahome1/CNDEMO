//
//  CNCustomAlert.m
//  ClearNote
//
//  Created by Jitendra Agarwal on 16/12/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//

#import "CNCustomAlert.h"

@implementation CNCustomAlert

@synthesize delegate;
-(instancetype)init{
    self=[super init];
    
    return self;
}
+ (instancetype)instantiateFromNib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"CNCustomAlert" owner:nil options:nil];

    return [views firstObject];
}
- (IBAction)okAction:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
    [self removeFromSuperview];
    } completion:^(BOOL finished) {
        
        if(delegate)
        {[delegate donePopupText];
            delegate = nil;
        }
    }];
}

@end
