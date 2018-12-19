//
//  ZRAutorizationLocationManager.m
//  ZRAuthorizationManager
//
//  Created by Ranger on 2018/12/17.
//  Copyright © 2018 Ranger. All rights reserved.
//

#import "ZRAutorizationLocationManager.h"

@interface ZRAutorizationLocationManager ()

@property (nonatomic, strong, readwrite) CLLocationManager *locationManager;

@end

@implementation ZRAutorizationLocationManager


+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static ZRAutorizationLocationManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [ZRAutorizationLocationManager new];
    });
    return manager;
}

+ (CLAuthorizationStatus)autorizationStatus {
    return [CLLocationManager authorizationStatus];
}


+ (void)requestAuthorizationAlwaysOrWhenInUse:(BOOL)always {
    [[ZRAutorizationLocationManager manager] _requestAuthorizationAlwaysOrWhenInUse:always];
}

- (void)_requestAuthorizationAlwaysOrWhenInUse:(BOOL)always{
    if (always) {
        [self.locationManager requestAlwaysAuthorization];
    }
    else {
        [self.locationManager requestWhenInUseAuthorization];
    }
}


- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

@end
