//
//  ViewController.m
//  iOS10NotificationTest
//
//  Created by Nemocdz on 2017/6/29.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "CDZNotificationHandler.h"

@interface ViewController ()
- (IBAction)requestAuthButton:(UIButton *)sender;
- (IBAction)sendCustomMessage:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *textFiels;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)requestAuthButton:(UIButton *)sender {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenStr"];
    NSLog(@"%@",token);
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            [[UIApplication sharedApplication] registerForRemoteNotifications];
            NSLog(@"Allow Notification");
        }
    }];
    
}

- (IBAction)sendCustomMessage:(UIButton *)sender {
    NSString *sameIdentifer = @"aa";
    UNMutableNotificationContent *content = [UNMutableNotificationContent.alloc init];
    content.title = @"Test";
    content.body = @"状态A";
    content.subtitle = self.textFiels.text;
    
    // Set category to use customized UI
    content.categoryIdentifier = CDZTripCategory;
    //content.threadIdentifier = @"aa";
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:3 repeats:NO];
    
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:[UNNotificationRequest requestWithIdentifier:sameIdentifer content:content trigger:trigger] withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    
    trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        content.body = @"状态B";
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:[UNNotificationRequest requestWithIdentifier:sameIdentifer content:content trigger:trigger] withCompletionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@",error);
            }
        }];
    });

    
}


@end
