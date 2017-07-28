//
//  AppDelegate.m
//  iOS10NotificationTest
//
//  Created by Nemocdz on 2017/6/29.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import "AppDelegate.h"
#import "CDZNotificationHandler.h"

@interface AppDelegate ()
@property (nonatomic, strong) UNNotificationCategory *tripCategory;
@property (nonatomic, strong) CDZNotificationHandler *handler;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.handler = [CDZNotificationHandler.alloc init];
    [UNUserNotificationCenter currentNotificationCenter].delegate = self.handler;//具体实现是handler实现
    [[UNUserNotificationCenter currentNotificationCenter]setNotificationCategories:[NSSet setWithObject:self.tripCategory]];//注册对应按钮动作组
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString *deviceTokenString = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (deviceTokenString) {
        [[NSUserDefaults standardUserDefaults] setObject:deviceTokenString forKey:@"tokenStr"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSLog(@"Token is:%@",deviceTokenString);
}


- (UNNotificationCategory *)tripCategory{
    if (!_tripCategory) {
        UNNotificationAction *callAction = [UNNotificationAction actionWithIdentifier:CDZNotificationActionIdentifer(CDZCallDriverAction) title:@"打电话" options:UNNotificationActionOptionForeground];
        UNTextInputNotificationAction *sendMessageAction = [UNTextInputNotificationAction actionWithIdentifier:CDZNotificationActionIdentifer(CDZSendMessageAction) title:@"发消息" options:UNNotificationActionOptionNone];
        UNNotificationAction *cancelOrderAction = [UNNotificationAction actionWithIdentifier:CDZNotificationActionIdentifer(CDZCancelOrderAction) title:@"删除订单" options:UNNotificationActionOptionDestructive];
        _tripCategory = [UNNotificationCategory categoryWithIdentifier:CDZTripCategory actions:@[callAction,sendMessageAction,cancelOrderAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];//将组和动作关联起来
    }
    return _tripCategory;
}


@end
