//
//  Users+CoreDataProperties.h
//  ClearNote
//
//  Created by Jitendra Agarwal on 01/12/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Users.h"

NS_ASSUME_NONNULL_BEGIN

@interface Users (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userID;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *userPassword;
@property (nullable, nonatomic, retain) NSString *userName;
@end

NS_ASSUME_NONNULL_END
