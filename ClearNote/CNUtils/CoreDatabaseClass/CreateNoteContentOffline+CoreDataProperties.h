//
//  CreateNoteContentOffline+CoreDataProperties.h
//  ClearNote
//
//  Created by Jitendra Agarwal on 04/12/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CreateNoteContentOffline.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateNoteContentOffline (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSNumber *isSynchoronization;
@property (nullable, nonatomic, retain) NSString *noteCreateID;
@property (nullable, nonatomic, retain) NSString *tempUserId;
@property (nullable, nonatomic, retain) NSString *userID;
@property (nullable, nonatomic, retain) NSString *noteName;
@property (nullable, nonatomic, retain) NSString *timestamp;
@property (nullable, nonatomic, retain) NSNumber *isdeleted;
@property (nullable, nonatomic, retain) NSString *noteCreateDate;

@end

NS_ASSUME_NONNULL_END
