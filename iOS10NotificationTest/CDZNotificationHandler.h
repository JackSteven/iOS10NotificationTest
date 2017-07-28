//
//  CDZNotificationHandler.h
//  iOS10NotificationTest
//
//  Created by Nemocdz on 2017/6/30.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

typedef NS_ENUM(NSUInteger, CDZActionType) {
    CDZCallDriverAction,
    CDZSendMessageAction,
    CDZCancelOrderAction,
};

static NSString *CDZTripCategory = @"tripCategory";

FOUNDATION_EXPORT NSString *CDZNotificationActionIdentifer(CDZActionType type);
FOUNDATION_EXPORT CDZActionType CDZNotificationActionType(NSString *identifer);

@interface CDZNotificationHandler : NSObject<UNUserNotificationCenterDelegate>

@end
