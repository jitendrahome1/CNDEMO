//
//  AppDelegate.m
//  ClearNote
//
//  Created by Jitendra Agarwal on 26/11/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//

#import "AppDelegate.h"
#define DataModel @"ClearNote"
@interface AppDelegate ()
@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /*
     BundleIdentifier - in.co.indusnet.cfdemo
     BundleIdentifier new - com.ClearNote
     */
   [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber - 1;
    
    NSString *loginIDDefult = get_UserID(@"CNLoginID");
  //  loginIDDefult = @"";
    if(loginIDDefult .length > 0)
    {
        [self goToViewController:@"home"];
    }
 //   if(!Defaults_get_bool(kSysncStatus))    {
    // if(!Defaults_get_bool(kBackgroundSync))
    [self startMonitoringNetwork];
   // }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
      [self saveContext];
}
-(void)startMonitoringNetwork
{
    //--- Start Monitoring the AFNetworkReachabilityManager ---//
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];

    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        switch (status)
        {
            case AFNetworkReachabilityStatusNotReachable:
            case AFNetworkReachabilityStatusUnknown:
            {
                NSLog(@"Network not available");
                //  Post_Notification(kCHNoNetwork, nil);
                  Defaults_set_bool_syncRotations(kspinRotations, NO);
                
            }
                break;
                
            default:
            {
                NSLog(@"Network available");
                     Defaults_set_bool_syncRotations(kspinRotations, YES);
                // Post_Notification(kCHNetworkAvailable, nil);
                
                if(!Defaults_get_bool(kBackgroundSync))
                  {
              
                self.isUploadFromBacground = YES;
                [[CNAddBackgroundOparation sharedInstance] AddBackgroundProcess];
                  }
        }
                
                break;
        }
    }];
    

}

-(void)goToViewController:(NSString *)view{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    if ([view isEqualToString:@"home"]) {
        CNAllNotsListViewController *noteList = [storyBoard instantiateViewControllerWithIdentifier:@"CNAllNotsListViewController"];

   //  UINavigationController *navController =(UINavigationController *) self.window.rootViewController;
_navigationController = [[UINavigationController alloc] initWithRootViewController:noteList];
             [self.window makeKeyAndVisible];
               self.window.rootViewController=self.navigationController;
        
    // [navController pushViewController:noteList animated:YES];
        //  self.navigationController = [[UINavigationController alloc] initWithRootViewController:noteList];
        //  [self.window setRootViewController:self.navigationController];
        
        // [self.window makeKeyAndVisible];
    
        
    }
    else{
        CNWelcomeViewController *login = [storyBoard instantiateViewControllerWithIdentifier:@"CNWelcomeViewController"];
        
        _navigationController = [[UINavigationController alloc] initWithRootViewController:login];
        [self.window makeKeyAndVisible];
        self.window.rootViewController=self.navigationController;
        
//        UINavigationController *navController =(UINavigationController *) self.window.rootViewController;
//     
//        [navController pushViewController:login animated:YES];
        
    }

}
#pragma mark - Core Data stack
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "indusnet.KNWAllCollegeApp" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:DataModel withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ClearNote.sqlite"];
    
    NSLog(@"Core Data Create Assignment: %@",storeURL);
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}
- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
