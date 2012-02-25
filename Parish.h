//
//  Parish.h
//  Catholic Diocese
//
//  Created by Jeff Geerling on 2/6/11.
//

#import <CoreData/CoreData.h>


@interface Parish :  NSManagedObject  
{
}

@property (nonatomic, strong) NSNumber * parishLatitude;
@property (nonatomic, strong) NSNumber * parishLongitude;
@property (nonatomic, strong) NSString * parishName;
@property (nonatomic, strong) NSNumber * parishNumber;
@property (nonatomic, strong) NSString * parishArchdiocesanURL;
@property (nonatomic, strong) NSString * parishStreetAddress;
@property (nonatomic, strong) NSString * parishCity;
@property (nonatomic, strong) NSString * parishZipCode;
@property (nonatomic, strong) NSString * parishState;


@end
