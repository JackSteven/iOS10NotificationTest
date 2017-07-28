//
//  CDZNotificationHandler.m
//  iOS10NotificationTest
//
//  Created by Nemocdz on 2017/6/30.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import "CDZNotificationHandler.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

NSString *CDZNotificationActionIdentifer(CDZActionType type){
    return [CDZTripCategory stringByAppendingString:[NSString stringWithFormat:@"%ld",type]];
}

CDZActionType CDZNotificationActionType(NSString *identifer){
    return [[identifer substringFromIndex:identifer.length - 1] integerValue];
}



@implementation CDZNotificationHandler

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    BOOL isRemote = NO;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        isRemote = YES;
    }
    UILocalNotification *localNotification;//转换
    
    if (!isRemote && [[UIApplication sharedApplication].delegate respondsToSelector:@selector(application:didReceiveLocalNotification:)]) {
        [[UIApplication sharedApplication].delegate application:[UIApplication sharedApplication] didReceiveLocalNotification:localNotification];
    }
    else if (isRemote) {
        if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)]) {
            [[UIApplication sharedApplication].delegate application:[UIApplication sharedApplication] didReceiveRemoteNotification:notification.request.content.userInfo fetchCompletionHandler:^(UIBackgroundFetchResult result) {}];
        }
        else if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(application:didReceiveRemoteNotification:)]){
            [[UIApplication sharedApplication].delegate application:[UIApplication sharedApplication] didReceiveRemoteNotification:notification.request.content.userInfo];
        }
    }
    
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);//收到消息，但为推送前可以进行定制
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    BOOL isRemote = NO;
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        isRemote = YES;
    }
    
    UILocalNotification *localNotification;//转换

    
    if ([response.actionIdentifier isEqualToString:UNNotificationDefaultActionIdentifier] || [response.actionIdentifier isEqualToString:UNNotificationDismissActionIdentifier]) {
        if (!isRemote && [[UIApplication sharedApplication].delegate respondsToSelector:@selector(application:didReceiveLocalNotification:)]) {
            [[UIApplication sharedApplication].delegate application:[UIApplication sharedApplication] didReceiveLocalNotification:localNotification];
        }
        else if (isRemote) {
            if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)]) {
                [[UIApplication sharedApplication].delegate application:[UIApplication sharedApplication] didReceiveRemoteNotification:response.notification.request.content.userInfo fetchCompletionHandler:^(UIBackgroundFetchResult result) {}];
            }
            else if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(application:didReceiveRemoteNotification:)]){
                [[UIApplication sharedApplication].delegate application:[UIApplication sharedApplication] didReceiveRemoteNotification:response.notification.request.content.userInfo];
            }
        }
    }
    else{
        if (!isRemote) {
            if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(application:handleActionWithIdentifier:forLocalNotification:withResponseInfo:completionHandler:)]) {
                [[UIApplication sharedApplication].delegate application:[UIApplication sharedApplication] handleActionWithIdentifier:response.actionIdentifier forLocalNotification:localNotification withResponseInfo:@{} completionHandler:^{}];
            }
            else if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(application:handleActionWithIdentifier:forLocalNotification:completionHandler:)]){
                [[UIApplication sharedApplication].delegate application:[UIApplication sharedApplication] handleActionWithIdentifier:response.actionIdentifier forLocalNotification:localNotification completionHandler:^{}];
            }
        }
        else{
            if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(application:handleActionWithIdentifier:forRemoteNotification:withResponseInfo:completionHandler:)]) {
                [[UIApplication sharedApplication].delegate application:[UIApplication sharedApplication] handleActionWithIdentifier:response.actionIdentifier forRemoteNotification:response.notification.request.content.userInfo withResponseInfo:@{} completionHandler:^{}];
            }
            else if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(application:handleActionWithIdentifier:forRemoteNotification:completionHandler:)]){
                [[UIApplication sharedApplication].delegate application:[UIApplication sharedApplication] handleActionWithIdentifier:response.actionIdentifier forRemoteNotification:response.notification.request.content.userInfo completionHandler:^{}];
            }
            
        }
    }

    
    
    
    
    //根据消息的回应跳回主app后进行的处理（比如按钮）
    if (![response.notification.request.content.categoryIdentifier isEqualToString:CDZTripCategory]) {
        return;
    }
    
    
    
    switch (CDZNotificationActionType(response.actionIdentifier)) {
        case CDZCallDriverAction:
            NSLog(@"呼叫");
            break;
        case CDZSendMessageAction:
            NSLog(@"发送");
            break;
        case CDZCancelOrderAction:
            NSLog(@"取消");
            break;
    }
    completionHandler();
}

@end
