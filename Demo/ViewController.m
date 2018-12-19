//
//  ViewController.m
//  ZRAuthorizationManager
//
//  Created by Ranger on 2018/12/13.
//  Copyright © 2018 Ranger. All rights reserved.
//

#import "ViewController.h"
#import "ZRAutorizationManager.h"
#import "ZRAutorizationLocationManager.h"

@interface ViewController ()<CLLocationManagerDelegate>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ZRAutorizationLocationManager manager].locationManager.delegate = self;
}

#pragma mark - 授权状态
- (IBAction)photoLibraryStatusClick:(id)sender {
    ZRAutorizationStatus status = [ZRAutorizationManager autorizationStatusForType:ZRAutorizationTypePhotoLibrary];
    [self showAlertWithTitle:@"相册" message:[self messageForStatus:status]];
}

- (IBAction)cameraStatusClick:(id)sender {
    ZRAutorizationStatus status = [ZRAutorizationManager autorizationStatusForType:ZRAutorizationTypeCamera];
    [self showAlertWithTitle:@"相机" message:[self messageForStatus:status]];
}

- (IBAction)microphoneStatusClick:(id)sender {
    ZRAutorizationStatus status = [ZRAutorizationManager autorizationStatusForType:ZRAutorizationTypeMicrophone];
    [self showAlertWithTitle:@"麦克风" message:[self messageForStatus:status]];
}

- (IBAction)pushStatusClick:(id)sender {
    ZRAutorizationStatus status = [ZRAutorizationManager autorizationStatusForType:ZRAutorizationTypePush];
    [self showAlertWithTitle:@"推送" message:[self messageForStatus:status]];
}

- (IBAction)locationStatusClick:(id)sender {
    CLAuthorizationStatus status = [ZRAutorizationLocationManager autorizationStatus];
    NSString *msg;
    if (status == kCLAuthorizationStatusNotDetermined) {
        msg = @"还未选择是否授权";
    }
    else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        msg = @"已拒绝授权";
    }
    else {
        msg = @"已授权";
    }
    [self showAlertWithTitle:@"定位" message:msg];
}

- (IBAction)calendarStatusClick:(id)sender {
    ZRAutorizationStatus status = [ZRAutorizationManager autorizationStatusForType:ZRAutorizationTypeCalendar];
    [self showAlertWithTitle:@"日历" message:[self messageForStatus:status]];
}

- (IBAction)contactsStatusClick:(id)sender {
    ZRAutorizationStatus status = [ZRAutorizationManager autorizationStatusForType:ZRAutorizationTypeContacts];
    [self showAlertWithTitle:@"联系人" message:[self messageForStatus:status]];
}


- (NSString *)messageForStatus:(ZRAutorizationStatus)status {
    if (status == ZRAutorizationStatusNotDetermined) {
        return @"还未选择是否授权";
    }
    else if (status == ZRAutorizationStatusDenied) {
        return @"已拒绝授权";
    }
    else if (status == ZRAutorizationStatusAuthorized) {
        return @"已授权";
    }
    else {
        return @"状态未知";
    }
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];

    }];
    
    [alert addAction:cancelAction];
    [alert addAction:settingAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}



#pragma mark - 获取授权

- (IBAction)requestPhotoLibraryClick:(id)sender {
    [ZRAutorizationManager requestAuthorization:ZRAutorizationTypePhotoLibrary mainThreadGrantedBlock:^(BOOL granted) {
        if (!granted) {
            [self showAlertWithTitle:@"需要相册授权" message:@"请在设置中允许访问相册"];
        }
    }];
}


- (IBAction)requestCalendarClick:(id)sender {
    [ZRAutorizationManager requestAuthorization:ZRAutorizationTypeCalendar mainThreadGrantedBlock:^(BOOL granted) {
        if (!granted) {
            [self showAlertWithTitle:@"需要日历授权" message:@"请在设置中允许访问日历"];
        }
    }];
}

- (IBAction)requestContactsClick:(id)sender {
    [ZRAutorizationManager requestAuthorization:ZRAutorizationTypeContacts mainThreadGrantedBlock:^(BOOL granted) {
        if (!granted) {
            [self showAlertWithTitle:@"需要通讯录授权" message:@"请在设置中允许访问通讯录"];
        }
    }];
}

- (IBAction)requestLocationClick:(id)sender {
    [ZRAutorizationLocationManager requestAuthorizationAlwaysOrWhenInUse:NO];
}

- (IBAction)requestCameraClick:(id)sender {
    [ZRAutorizationManager requestAuthorization:ZRAutorizationTypeCamera mainThreadGrantedBlock:^(BOOL granted) {
        if (!granted) {
            [self showAlertWithTitle:@"需要相机授权" message:@"请在设置中允许访问相机"];
        }
    }];
}


- (IBAction)requestPushClick:(id)sender {
    [ZRAutorizationManager requestAuthorization:ZRAutorizationTypePush mainThreadGrantedBlock:^(BOOL granted) {
        if (!granted) {
            [self showAlertWithTitle:@"需要推送授权" message:@"请在设置中允许推送"];
        }
    }];
}

- (IBAction)requestMicrophoneClick:(id)sender {
    [ZRAutorizationManager requestAuthorization:ZRAutorizationTypeMicrophone mainThreadGrantedBlock:^(BOOL granted) {
        if (!granted) {
            [self showAlertWithTitle:@"需要麦克风授权" message:@"请在设置中允许访问麦克风"];
        }
    }];
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
        [self showAlertWithTitle:@"需要定位授权" message:@"请在设置中允许定位"];
    }
}

@end
