//
//  CTLocationManager.m
//  yili
//
//  Created by casa on 15/10/12.
//  Copyright © 2015年 Beauty Sight Network Technology Co.,Ltd. All rights reserved.
//

#import "CTLocationManager.h"

@interface CTLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, assign, readwrite) CTLocationManagerLocationResult locationResult;
@property (nonatomic, assign, readwrite) CTLocationManagerLocationServiceStatus locationStatus;
@property (nonatomic, copy, readwrite) CLLocation *currentLocation;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation CTLocationManager

+ (instancetype)sharedInstance
{
    static CTLocationManager *locationManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationManager = [[CTLocationManager alloc] init];
    });
    return locationManager;
}

- (void)startLocation
{
        /// 这里是个判断值，如果可以定位，就是非0，然后就是开始定位了，并将定位 result 设置为 正在定位
    if ([self checkLocationStatus]) {
        self.locationResult = CTLocationManagerLocationResultLocating;
        /// 调用系统定位方法开始定位
        [self.locationManager startUpdatingLocation];
    } else {
        [self failedLocationWithResultType:CTLocationManagerLocationResultFail statusType:self.locationStatus];
    }
}

/// 停止定位，最后还是调用系统的停止定位的方法
- (void)stopLocation
{
    if ([self checkLocationStatus]) {
        [self.locationManager stopUpdatingLocation];
    }
}

/// 先停止，后开启
- (void)restartLocation
{
    [self stopLocation];
    [self startLocation];
}

#pragma mark - CLLocationManagerDelegate
/// 定位到了就停止定位，将定位结果赋给自己
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [manager.location copy];
    NSLog(@"Current location is %@", self.currentLocation);
    [self stopLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //如果用户还没选择是否允许定位，则不认为是定位失败
    if (self.locationStatus == CTLocationManagerLocationServiceStatusNotDetermined) {
        return;
    }
    
    //如果正在定位中，那么也不会通知到外面
    if (self.locationResult == CTLocationManagerLocationResultLocating) {
        return;
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.locationStatus = CTLocationManagerLocationServiceStatusOK;
        [self restartLocation];
    } else {
        if (self.locationStatus != CTLocationManagerLocationServiceStatusNotDetermined) {
            [self failedLocationWithResultType:CTLocationManagerLocationResultDefault statusType:CTLocationManagerLocationServiceStatusNoAuthorization];
        } else {
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager startUpdatingLocation];
        }
    }
}

#pragma mark - private methods
- (void)failedLocationWithResultType:(CTLocationManagerLocationResult)result statusType:(CTLocationManagerLocationServiceStatus)status
{
    self.locationResult = result;
    self.locationStatus = status;
}

/// 判断是否可以定位，先判断是否开启了定位，再判断定位权限。如果失败了调用失败回调，将失败的结果和状态传入。 这里设置的是 state
/// 这里的 result 规则是 系统开启了定位，并且应用的用户允许运行时或一直定位或者，注意这里，或者用户没有不允许的时候， result 为 YES
- (BOOL)checkLocationStatus;
{
    BOOL result = NO;
    /// 判断系统是否允许定位,这个是判断定位是否打开
    BOOL serviceEnable = [self locationServiceEnabled];
    /// 这个是在定位打开的情况下，判断用户是否授权
    CTLocationManagerLocationServiceStatus authorizationStatus = [self locationServiceStatus];
    if (authorizationStatus == CTLocationManagerLocationServiceStatusOK && serviceEnable) {
        result = YES;
    }else if (authorizationStatus == CTLocationManagerLocationServiceStatusNotDetermined) {
        result = YES;
    }else{
        result = NO;
    }
    
    if (serviceEnable && result) {
        result = YES;
    }else{
        result = NO;
    }
    
    if (result == NO) {
        /// self.locatinStatus 就是上面的 authorizationStatus
        [self failedLocationWithResultType:CTLocationManagerLocationResultFail statusType:self.locationStatus];
    }
    
    return result;
}

/// 定位功能是否可用，调用的系统的定位判断方法，这还不涉及是否有权限。是手机是否开启了定位
- (BOOL)locationServiceEnabled
{
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationStatus = CTLocationManagerLocationServiceStatusOK;
        return YES;
    } else {
        self.locationStatus = CTLocationManagerLocationServiceStatusUnknownError;
        return NO;
    }
}

- (CTLocationManagerLocationServiceStatus)locationServiceStatus
{
    self.locationStatus = CTLocationManagerLocationServiceStatusUnknownError;
    BOOL serviceEnable = [CLLocationManager locationServicesEnabled];
    if (serviceEnable) {
        /// 手机开启了定位后，调用系统方法判断该应用关于定位的授权状态。譬如，用户未决定，关闭，运行时开启，一直开启。根据这些状态设置自己的状态。
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        switch (authorizationStatus) {
            case kCLAuthorizationStatusNotDetermined:
                self.locationStatus = CTLocationManagerLocationServiceStatusNotDetermined;
                break;
                
            case kCLAuthorizationStatusAuthorizedAlways :
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                self.locationStatus = CTLocationManagerLocationServiceStatusOK;
                break;
                
            case kCLAuthorizationStatusDenied:
                self.locationStatus = CTLocationManagerLocationServiceStatusNoAuthorization;
                break;
                
            default:
                break;
        }
    } else {
        self.locationStatus = CTLocationManagerLocationServiceStatusUnAvailable;
    }
    return self.locationStatus;
}

#pragma mark - getters and setters
/// 这个get 方法。 注意，这个是系统的方法
/// 设置系统定位的代理是自己，并且设置精确定位
- (CLLocationManager *)locationManager
{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}

@end
