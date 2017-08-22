//
//  CNSettingTableViewCell.h
//  ClearNote
//
//  Created by Jitendra Agarwal on 18/12/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CNSettingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnTrash;
@property (weak, nonatomic) IBOutlet UIButton *btnChangePassword;
@property (weak, nonatomic) IBOutlet UIButton *btnSignOut;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedSort;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedSync;
@property (weak, nonatomic) IBOutlet UILabel *lblUserLoginEmail;
@property (strong, nonatomic) IBOutlet UIImageView *imgUserAccount;

@end
