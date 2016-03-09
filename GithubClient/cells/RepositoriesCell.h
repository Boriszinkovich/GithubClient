//
//  BZRepositoriesUITableViewCell.h
//  GithubClientTask
//
//  Created by User on 29.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Repository;
@interface RepositoriesCell : UITableViewCell

@property (nonatomic, strong, nonnull) Repository *theRepository;
@property (nonatomic, strong, nonnull) UILabel *theNameLabel;
@property (nonatomic, strong, nonnull) UILabel *theDescriptionLabel;
@property (nonatomic, strong, nonnull) UIImageView *theAvatarImageView;
@property (nonatomic, strong, nonnull) UILabel *theForksCountLabel;

@end






























