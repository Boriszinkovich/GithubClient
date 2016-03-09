//
//  BZSubscriberTableViewCell.h
//  GithubClientTask
//
//  Created by User on 01.03.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Subscriber;
@interface SubscriberCell : UITableViewCell

@property (nonatomic, strong, nonnull) Subscriber *theSubscriber;
@property (nonatomic, strong, nonnull) UIImageView *theAvatarImageView;
@property (nonatomic, strong, nonnull) UILabel *theNameLabel;

@end






























