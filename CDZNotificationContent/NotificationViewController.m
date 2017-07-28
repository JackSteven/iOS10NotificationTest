//
//  NotificationViewController.m
//  CDZNotificationContent
//
//  Created by Nemocdz on 2017/6/29.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>


typedef NS_ENUM(NSUInteger, CDZActionType) {
    CDZCallDriverAction,
    CDZSendMessageAction,
    CDZCancelOrderAction,
};

static NSString *CDZTripCategory = @"tripCategory";

NSString *CDZNotificationActionIdentifer(CDZActionType type){
    return [CDZTripCategory stringByAppendingString:[NSString stringWithFormat:@"%ld",type]];
}

CDZActionType CDZNotificationActionType(NSString *identifer){
    return [[identifer substringFromIndex:identifer.length - 1] integerValue];
}



@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    // Do any required interface initialization here.
}

- (void)didReceiveNotification:(UNNotification *)notification {
    self.view.backgroundColor = [UIColor purpleColor];
    self.label.text = notification.request.content.body;
}


- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption option))completion{
    switch (CDZNotificationActionType(response.actionIdentifier)) {
        case CDZCallDriverAction:
            self.view.backgroundColor = [UIColor yellowColor];
            completion(UNNotificationContentExtensionResponseOptionDismissAndForwardAction);
            break;
        case CDZSendMessageAction:
            self.view.backgroundColor = [UIColor redColor];
            completion(UNNotificationContentExtensionResponseOptionDismissAndForwardAction);
            break;
            
        case CDZCancelOrderAction:
            self.view.backgroundColor = [UIColor blueColor];
            completion(UNNotificationContentExtensionResponseOptionDismissAndForwardAction);
            break;
    }
    
}



@end
