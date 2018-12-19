//
//  ZRAutorizationLocationManager.h
//  ZRAuthorizationManager
//
//  Created by Ranger on 2018/12/17.
//  Copyright © 2018 Ranger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZRAutorizationLocationManager : NSObject

@property (nonatomic, strong, readonly) CLLocationManager *locationManager;

+ (instancetype)manager;


+ (CLAuthorizationStatus)autorizationStatus;

+ (void)requestAuthorizationAlwaysOrWhenInUse:(BOOL)always;


@end

NS_ASSUME_NONNULL_END
