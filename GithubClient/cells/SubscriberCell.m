//
//  BZSubscriberTableViewCell.m
//  GithubClientTask
//
//  Created by User on 01.03.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "SubscriberCell.h"

#import "BZExtensionsManager.h"
#import "Subscriber.h"

@interface SubscriberCell ()

@property (nonatomic, strong, nonnull) BZUrlSession *theUrlSession;

@end

@implementation SubscriberCell

#pragma mark - Class Methods (Public)

#pragma mark - Class Methods (Private)

#pragma mark - Init & Dealloc

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self methodInitBZSubscribersCell];
    }
    return self;
}

- (void)methodInitBZSubscribersCell
{
    if (!self.isFirstLoad)
    {
        return;
    }
    self.isFirstLoad = NO;
    self.theUrlSession = [BZUrlSession new];
    
    UIImageView *theAvatarImageView = [UIImageView new];
    self.theAvatarImageView = theAvatarImageView;
    [self.contentView addSubview:theAvatarImageView];
    
    theAvatarImageView.theMinX = 15;
    theAvatarImageView.theMinY = 10;
    theAvatarImageView.theHeight = 40;
    theAvatarImageView.theWidth = 40;
    theAvatarImageView.layer.cornerRadius = 10;

    double theLabelsWidth = 230;
    
    UILabel *theNameLabel = [UILabel new];
    self.theNameLabel = theNameLabel;
    [self.contentView addSubview:theNameLabel];
    
    theNameLabel.theMinY = 20;
    theNameLabel.theMinX = theAvatarImageView.theMaxX + 10;
    theNameLabel.theWidth = theLabelsWidth;
    theNameLabel.font = [UIFont systemFontOfSize:19];
    
}

#pragma mark - Setters (Public)

- (void)setTheSubscriber:(Subscriber * _Nonnull)theSubscriber
{
    if (!theSubscriber)
    {
        abort();
    }
    _theSubscriber = theSubscriber;
    
    double theLabelsWidth = 180;
    UILabel *theNameLabel = self.theNameLabel;
    
    theNameLabel.text = theSubscriber.theNameString;
    theNameLabel.theWidth = theLabelsWidth;
    [theNameLabel sizeToFit];
    theNameLabel.theWidth = theLabelsWidth;
    //    NSString *theAvatarUrlString = theSubscriber.theAvatarUrlString;
    //    [self.theAvatarImageView methodSetImageWithNSURL:[NSURL URLWithString:theAvatarUrlString]
    //                                   withPlaceholderImage:[UIImage imageNamed:@"white_image"]];
    self.theAvatarImageView.image = [UIImage imageNamed:@"white_image"];
    
    NSString *theAvatarUrlString = [NSString stringWithFormat:@"%@?s=40",theSubscriber.theAvatarUrlString];
    [self.theUrlSession methodStartTaskWithUrl:[NSURL URLWithString:theAvatarUrlString] withCompletionBlock:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
     {
         if (!data)
         {
             return;
         }
         if (error)
         {
             return;
         }
         @weakify(self);
         [BZExtensionsManager methodAsyncMainWithBlock:^
          {
              @strongify(self);
              self.theAvatarImageView.image = [UIImage imageWithData:data];
          }];
     }];
}

#pragma mark - Getters (Public)

#pragma mark - Setters (Private)

#pragma mark - Getters (Private)

#pragma mark - Lifecycle

#pragma mark - Create Views & Variables

#pragma mark - Actions

#pragma mark - Gestures

#pragma mark - Delegates ()

#pragma mark - Methods (Public)

#pragma mark - Methods (Private)

#pragma mark - Standard Methods

@end






























