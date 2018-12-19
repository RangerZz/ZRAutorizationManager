# ZRAutorizationManager
iOS常见的权限状态和请求授权
ZRAutorizationManager封装了iOS开发中常用的相册,相机,麦克风推送,日历,联系人,定位等权限的状态和主动请求授权,一行代码搞定繁琐的权限状态和请求过程.

-------

### 授权状态
```
typedef NS_ENUM(NSUInteger, ZRAutorizationStatus) {
    ZRAutorizationStatusNotDetermined,// 用户还未选择是否允许授权 可以代表第一次询问
    ZRAutorizationStatusDenied,// 拒绝授权 包括 Restricted & Denied
    ZRAutorizationStatusAuthorized,// 已授权
    
    ZRAutorizationStatusUnknow,// 未知状态
};
```
### 获取授权状态
```
+ (ZRAutorizationStatus)autorizationStatusForType:(ZRAutorizationType)type;
```
### 主动请求授权
* 请求授权后结果的回调是系统API回调的线程,一般不是主线程

```
+ (void)requestAuthorization:(ZRAutorizationType)type grantedBlock:(void (^)(BOOL granted))grantedBlock;
```
* 请求授权后结果的回调是主线程

```
+ (void)requestAuthorization:(ZRAutorizationType)type mainThreadGrantedBlock:(void (^)(BOOL granted))grantedBlock;
```

#### Tips
* 由于定位权限API的特殊性,只建议参考`ZRAutorizationLocationManager`的调用方式,不建议直接使用'ZRAutorizationLocationManager',最好在需要的地方自己实现对应代码.

-------
欢迎建议交流提issue
