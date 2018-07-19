//
//  GraphicViewController.h
//  Currency stats
//
//  Created by Alex Chekodanov on 12.07.2018.
//  Copyright © 2018 MERA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface GraphicViewController : UIViewController
@property (nonatomic) NSInteger numOfPartitions;
@property (strong,nonatomic) NSString *chosedCurrency;
@property (strong, nonatomic) NSArray *chosedDate;

@property (strong, nonatomic) UNMutableNotificationContent *localNotification;

@end
