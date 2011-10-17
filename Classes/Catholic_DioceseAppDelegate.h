//
//  Catholic_DioceseAppDelegate.h
//  Catholic Diocese
//
//  Created by Jeff Geerling on 1/29/11.
//

#import <UIKit/UIKit.h>
@class ParishNavController;

@interface AppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	IBOutlet ParishNavController *parishNavController;
	
	NSMutableArray *parishData;

@private
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

- (void)saveAction;
- (void)putAllParishesIntoParishDataArray;
- (void)updateParishEventTimeData;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet ParishNavController *parishNavController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSMutableArray *parishData;

@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

@end
