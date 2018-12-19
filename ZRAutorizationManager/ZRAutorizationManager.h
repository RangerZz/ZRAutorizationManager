//
//  ZRAutorizationManager.h
//  ZRAuthorizationManager
//
//  Created by Ranger on 2018/12/13.
//  Copyright © 2018 Ranger. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, ZRAutorizationType) {
    ZRAutorizationTypePhotoLibrary API_AVAILABLE(ios(8.0)),
    ZRAutorizationTypeCamera API_AVAILABLE(ios(7.0)),
    ZRAutorizationTypeMicrophone API_AVAILABLE(ios(7.0)),
    ZRAutorizationTypePush API_AVAILABLE(ios(10.0)),
    ZRAutorizationTypeCalendar API_AVAILABLE(ios(6.0)),
    ZRAutorizationTypeContacts API_AVAILABLE(ios(9.0)),
//    ZRAutorizationTypeLocation API_AVAILABLE(ios(4.2)),
};

typedef NS_ENUM(NSUInteger, ZRAutorizationStatus) {
    ZRAutorizationStatusNotDetermined,// 用户还未选择是否允许授权 可以代表第一次询问
    ZRAutorizationStatusDenied,// 拒绝授权 包括 Restricted & Denied
    ZRAutorizationStatusAuthorized,// 已授权
    
    ZRAutorizationStatusUnknow,// 未知状态
};

NS_ASSUME_NONNULL_BEGIN

@interface ZRAutorizationManager : NSObject

+ (ZRAutorizationStatus)autorizationStatusForType:(ZRAutorizationType)type;

+ (void)requestAuthorization:(ZRAutorizationType)type grantedBlock:(void (^)(BOOL granted))grantedBlock;

+ (void)requestAuthorization:(ZRAutorizationType)type mainThreadGrantedBlock:(void (^)(BOOL granted))grantedBlock;


@end

NS_ASSUME_NONNULL_END
