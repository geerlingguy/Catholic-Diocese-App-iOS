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

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, strong) IBOutlet ParishNavController *parishNavController;

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSMutableArray *parishData;

@property (weak, nonatomic, readonly) NSString *applicationDocumentsDirectory;

@end
