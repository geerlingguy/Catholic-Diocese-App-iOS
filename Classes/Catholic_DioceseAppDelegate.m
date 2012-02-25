//
//  Catholic_DioceseAppDelegate.m
//  Catholic Diocese
//
//  Created by Jeff Geerling on 1/29/11.
//

#import "Catholic_DioceseAppDelegate.h"
#import "ParishNavController.h"
#import "Parish.h"
#import "ParishEvents.h"
#import "CHCSV.h"

@implementation AppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize parishNavController;
@synthesize parishData;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    /**
     * Override point for customization after application launch.
     */
	
	// Load up the parish data array.
	[self putAllParishesIntoParishDataArray];
	
    // Add the tab bar controller's view to the window and display.
    [self.window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /**
     * Sent when the application is about to move from active to inactive state.
     * This can occur for certain types of temporary interruptions (such as an
     * incoming phone call or SMS message) or when the user quits the
     * application and it begins the transition to the background state.
     * Use this method to pause ongoing tasks, disable timers, and throttle down
     * OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /**
     * Use this method to release shared resources, save user data, invalidate
     * timers, and store enough application state information to restore your
     * application to its current state in case it is terminated later. If your
     * application supports background execution, called instead of
     * applicationWillTerminate: when the user quits.
     */
	[self saveAction];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /**
     * Called as part of  transition from the background to the inactive state:
     * here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /**
     * Restart any tasks that were paused (or not yet started) while the
     * application was inactive. If the application was previously in the
     * background, optionally refresh the user interface.
     */
	
	// Retrieve last parish data refresh time (if this is the first time the app
    // is being launched, then we'll get nil). I've commented this out for now,
    // but this is one way you can synchronize parish data from your website.
//	NSDate *parishDataLastRefreshDate = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"parishDataLastRefreshed"];
//	int seconds = -(int)[parishDataLastRefreshDate timeIntervalSinceNow];
//	
//	// @config - Amount of time between parish data refresh.
//	if (seconds > 7776000 || parishDataLastRefreshDate == nil) { // 7776000 seconds = 90 days, or if this is the first time app's launched.
//		// Update the parish event data from the CSV file on archstl.org in the bacground.
//		[self performSelectorInBackground:@selector(updateParishEventTimeData) withObject:nil];
//	}
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /**
     * Called when the application is about to terminate. See also
     * applicationDidEnterBackground:.
     */

	[self saveAction];
}

- (void)saveAction {
    /**
     * Performs the save action for the application, which is to send the save:
     * message to the application's managed object context.
     */

    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }
}


#pragma mark Core Data stack

- (NSManagedObjectContext *) managedObjectContext {
    /**
     * Returns the managed object context for the application. If the context
     * doesn't already exist, it is created and bound to the persistent store
     * coordinator for the application.
     */

    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    /**
     * Returns the managed object model for the application. If the model
     * doesn't already exist, it is created from the application's model.
     */

    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"ParishData" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    /**
     * Returns the persistent store coordinator for the application. If the
     * coordinator doesn't already exist, it is created and the application's
     * store added to it.
     */

    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }

    // @config - Path to the parish data file (SQLite database)
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"ParishData.sqlite"];
	
	/**
	 * Set up the store. Provide a pre-populated default store with all the
     * parish info inside.
	 */
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"ParishData" ofType:@"sqlite"];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}
	
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];	
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
	
	NSError *error;
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1); // Fail
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark Application's Documents directory

- (NSString *)applicationDocumentsDirectory {
    /**
     * Returns the path to the application's documents directory.
     */

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


#pragma mark Parish Information - Retrieve and Refresh

- (void)putAllParishesIntoParishDataArray {
	/**
	 * Get parish information, put each parishInfo dict into parishData array.
	 */

	// Set managed object context
	if (managedObjectContext == nil) 
	{ 
        managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
	}

	// Set up array
	parishData = [[NSMutableArray alloc] init];
	
	// Get parish data from Core Data store
	NSManagedObjectContext *context = [self managedObjectContext];
	NSError *error;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"Parish" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	for (Parish *info in fetchedObjects) {
		
		// Set up dictionary to store parish name and parish number inside...
		NSDictionary *record = [NSDictionary dictionaryWithObjectsAndKeys:
								info.parishName,@"parishName",
								info.parishNumber,@"parishNumber",
								info.parishStreetAddress,@"parishStreetAddress",
								info.parishCity,@"parishCity",
								info.parishState,@"parishState",
								info.parishZipCode,@"parishZipCode",
								info.parishLatitude,@"parishLatitude",
								info.parishLongitude,@"parishLongitude",
								info.parishArchdiocesanURL,@"parishArchdiocesanURL",
								nil];
		
		[parishData addObject:record];
	}
	
	// Sort the parishes in alphabetical order...
	NSSortDescriptor *alphaDesc = [[NSSortDescriptor alloc] initWithKey:@"parishName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
	[parishData sortUsingDescriptors:[NSMutableArray arrayWithObjects:alphaDesc, nil]];	
	alphaDesc = nil;
	
}

- (void)updateParishEventTimeData {
    /**
     * Updates parish sacrament time data.
     *
     * Basically, this method wipes out all current parish data in the Core Data
     * database, and then imports each row from the sacrament-times.csv file into
     * Core Data. We should not delete anything until we've verified the integrity
     * of the downloaded sacrament-times.csv file.
     *
     * Parish data is available at the following URL, as a CSV file:
     * http://www.example.org/sacrament-times.csv
     *
     * CSV columns: Z_ENT, Z_OPT, parishNumber, eventTypeKey, eventDay, eventStart,
     * eventEnd, eventLanguage, eventLocation
     */

    @autoreleasepool {
	// Retrieve the parish data from our CSV file on the server.
	// @config - URL to csv file containing parish event time data.
		NSString *csv = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.example.com/sacrament-times.csv"] encoding:NSASCIIStringEncoding error:nil];
		
		// Check if the CSV file has data.
		if ([csv length] != 0) {
			// If there is data in the downloaded CSV file, first delete all
            // parish events.
			NSManagedObjectContext *context = [self managedObjectContext];
			NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
			[fetchRequest setEntity:[NSEntityDescription entityForName:@"ParishEvents" inManagedObjectContext:context]];
			NSArray *result = [context executeFetchRequest:fetchRequest error:nil];
			for (id parishEventToDelete in result) {
				[context deleteObject:parishEventToDelete];
			}
			
			// Save all the deleted stuff...
			[self saveAction];
			
			// Then, repopulate the parish event core data database from the CSV file.
			NSMutableArray *rows = [NSMutableArray arrayWithContentsOfCSVString:csv encoding:NSUTF8StringEncoding error:nil];
			[rows removeObjectAtIndex:0]; // Remove header row.
			[rows removeLastObject]; // Remove footer row.
			ParishEvents *parishEvent;
			for (NSArray *eventRow in rows) {
				parishEvent = (ParishEvents *)[NSEntityDescription insertNewObjectForEntityForName:@"ParishEvents" inManagedObjectContext:context];
				[parishEvent setValue:[NSNumber numberWithInt:[[eventRow objectAtIndex:2] intValue]] forKey:@"parishNumber"];
				[parishEvent setValue:[NSNumber numberWithInt:[[eventRow objectAtIndex:3] intValue]] forKey:@"eventTypeKey"];
				[parishEvent setValue:[eventRow objectAtIndex:4] forKey:@"eventDay"];
				[parishEvent setValue:[eventRow objectAtIndex:5] forKey:@"eventStart"];
				[parishEvent setValue:[eventRow objectAtIndex:6] forKey:@"eventEnd"];
				[parishEvent setValue:[eventRow objectAtIndex:7] forKey:@"eventLanguage"];
				[parishEvent setValue:[eventRow objectAtIndex:8] forKey:@"eventLocation"];
				[self saveAction];
			}
		}
		
		// Update the parishDataLastRefreshed timestamp (do this only after all the data has been updated).
		NSDate *timeNow = [NSDate date];
		[[NSUserDefaults standardUserDefaults] setObject:timeNow forKey:@"parishDataLastRefreshed"];
	
	}
}


#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /**
     * Free up as much memory as possible by purging cached data objects that
     * can be recreated (or reloaded from disk) later.
     */
}


@end
