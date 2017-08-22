//
//  CreateRestoreOfline+CoreDataProperties.h
//  ClearNote
//
//  Created by Jitendra Agarwal on 03/12/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CreateRestoreOfline.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateRestoreOfline (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *isdeleted;
@property (nullable, nonatomic, retain) NSNumber *isSynchoronization;
@property (nullable, nonatomic, retain) NSString *noteCreateID;
@property (nullable, nonatomic, retain) NSString *noteName;
@property (nullable, nonatomic, retain) NSString *tempUserId;
@property (nullable, nonatomic, retain) NSString *userID;
@property (nullable, nonatomic, retain) NSString *fileData;
@property (nullable, nonatomic, retain) NSString *noteCreateDate;
@property (nullable, nonatomic, retain) NSString *timestamp;

@end

NS_ASSUME_NONNULL_END
