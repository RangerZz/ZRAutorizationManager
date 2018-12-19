//
//  ZRAutorizationManager.m
//  ZRAuthorizationManager
//
//  Created by Ranger on 2018/12/13.
//  Copyright © 2018 Ranger. All rights reserved.
//

#import "ZRAutorizationManager.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <UserNotifications/UserNotifications.h>
#import <Contacts/Contacts.h>
#import <EventKit/EventKit.h>

#define ZRSafe_Block(_block_, ...) if (_block_) {_block_(__VA_ARGS__);}


@interface ZRAutorizationManager ()

@end


@implementation ZRAutorizationManager

+ (instancetype)manager {
    static ZRAutorizationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [ZRAutorizationManager new];
    });
    return manager;
}


+ (ZRAutorizationStatus)autorizationStatusForType:(ZRAutorizationType)type {
    return [[ZRAutorizationManager manager] _autorizationStatusForType:type];
}

+ (void)requestAuthorization:(ZRAutorizationType)type grantedBlock:(void (^)(BOOL))grantedBlock {
    [[ZRAutorizationManager manager] _requestAuthorization:type grantedBlock:grantedBlock mainThread:NO];
}

+ (void)requestAuthorization:(ZRAutorizationType)type mainThreadGrantedBlock:(void (^)(BOOL))grantedBlock {
    [[ZRAutorizationManager manager] _requestAuthorization:type grantedBlock:grantedBlock mainThread:YES];
}


#pragma mark - private

- (ZRAutorizationStatus)_autorizationStatusForType:(ZRAutorizationType)type {
    
    ZRAutorizationStatus status = ZRAutorizationStatusUnknow;
    switch (type) {
        case ZRAutorizationTypePhotoLibrary: {
            status = [self _statusWithSystemStatus:[PHPhotoLibrary authorizationStatus]];
        } break;
            
        case ZRAutorizationTypeCamera: {
            status =  [self _statusWithSystemStatus:[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]];
        } break;
            
        case ZRAutorizationTypeMicrophone: {
            status =  [self _statusWithSystemStatus:[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio]];
            
        } break;
            
        case ZRAutorizationTypePush: {
            
            dispatch_semaphore_t signal = dispatch_semaphore_create(0);
            
            __block ZRAutorizationStatus tempStatus = ZRAutorizationStatusUnknow;
            [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                
                UNAuthorizationStatus unStatus = settings.authorizationStatus;
                
                if (@available(iOS 12.0, *)) {
                    if (unStatus == UNAuthorizationStatusProvisional) {
                        tempStatus = ZRAutorizationStatusAuthorized;
                    }
                }
                
                if (unStatus == UNAuthorizationStatusNotDetermined) {
                    tempStatus = ZRAutorizationStatusNotDetermined;
                }else if (unStatus == UNAuthorizationStatusDenied) {
                    tempStatus = ZRAutorizationStatusDenied;
                }else if (unStatus == UNAuthorizationStatusAuthorized) {
                    tempStatus = ZRAutorizationStatusAuthorized;
                }
                dispatch_semaphore_signal(signal);
            }];
            
            dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
            status = tempStatus;
            
        } break;
            
        case ZRAutorizationTypeCalendar: {
            status =  [self _statusWithSystemStatus:[EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent]];
        } break;
            
        case ZRAutorizationTypeContacts: {
            status =  [self _statusWithSystemStatus:[CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts]];
        } break;
            
        default:
            status =  ZRAutorizationStatusUnknow;
            break;
    }
    return status;
}


- (ZRAutorizationStatus)_statusWithSystemStatus:(NSInteger)status {
    switch (status) {
        case 0:
            return ZRAutorizationStatusNotDetermined;
            break;
            
        case 1:
        case 2:
            return ZRAutorizationStatusDenied;
            break;
            
        case 3:
        case 4:
            return ZRAutorizationStatusAuthorized;
            break;
            
        default:
            return ZRAutorizationStatusUnknow;
            break;
    }
}

- (void)_requestAuthorization:(ZRAutorizationType)type grantedBlock:(void (^)(BOOL granted))grantedBlock mainThread:(BOOL)isMain {
    
    void(^repeatBlock)(BOOL granted) = ^(BOOL granted){
        if (granted) {
            if (isMain) {
                if ([NSThread isMainThread]) {
                    ZRSafe_Block(grantedBlock, YES);
                }
                else {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        ZRSafe_Block(grantedBlock, YES);
                    });
                }
            }
            else {
                ZRSafe_Block(grantedBlock,YES);
            }
        }
        else {
            if (isMain) {
                if ([NSThread isMainThread]) {
                    ZRSafe_Block(grantedBlock, NO);
                }
                else {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        ZRSafe_Block(grantedBlock, NO);
                    });
                }
            }
            else {
                ZRSafe_Block(grantedBlock,NO);
            }
        }
    };

    switch (type) {
        case ZRAutorizationTypePhotoLibrary: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                repeatBlock(status == PHAuthorizationStatusAuthorized);
            }];
        } break;
            
        case ZRAutorizationTypeCamera: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                repeatBlock(granted);
            }];
        } break;
            
        case ZRAutorizationTypeMicrophone: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                repeatBlock(granted);
            }];
        } break;
            
        case ZRAutorizationTypePush: {
            
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionSound |UNAuthorizationOptionBadge completionHandler:^(BOOL granted, NSError * _Nullable error) {
                repeatBlock(granted);
            }];
            

        } break;
            
        case ZRAutorizationTypeCalendar: {
            [[[EKEventStore alloc] init] requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
                repeatBlock(granted);
            }];
        } break;
            
        case ZRAutorizationTypeContacts: {
            [[[CNContactStore alloc] init] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                repeatBlock(granted);
            }];
        } break;
            
        default:
        break;
    }
}



@end
