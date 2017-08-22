//
//  CNTrashViewController.h
//  ClearNote
//
//  Created by Jitendra Agarwal on 01/12/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//

#import "CNBaseViewController.h"
#import "CNHelper.h"
#import "CNAllNoteListTableCell.h"
#import "UIAlertView+Block.h"
@interface CNTrashViewController : CNBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tblTrash;
@property (weak, nonatomic) IBOutlet UIView *viewBGTable;
@property(nonatomic,strong) MasterNote * noteOBJ;

@end
