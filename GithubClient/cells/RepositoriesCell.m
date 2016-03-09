//
//  BZRepositoriesUITableViewCell.m
//  GithubClientTask
//
//  Created by User on 29.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "RepositoriesCell.h"

#import "BZExtensionsManager.h"
#import "Repository.h"

@interface RepositoriesCell ()

@property (nonatomic, strong, nonnull) BZUrlSession *theUrlSession;

@end

@implementation RepositoriesCell

#pragma mark - Class Methods (Public)

#pragma mark - Class Methods (Private)

#pragma mark - Init & Dealloc

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self methodInitBZRepositoriesCell];
    }
    return self;
}

- (void)methodInitBZRepositoriesCell
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
    theAvatarImageView.theMinY = 15;
    theAvatarImageView.theHeight = 40;
    theAvatarImageView.theWidth = 40;
    
    theAvatarImageView.layer.cornerRadius = 10;
    
    double theLabelsWidth = 180;
    
    UILabel *theNameLabel = [UILabel new];
    self.theNameLabel = theNameLabel;
    [self.contentView addSubview:theNameLabel];
    
    theNameLabel.theMinY = 15;
    theNameLabel.theMinX = theAvatarImageView.theMaxX + 10;
    theNameLabel.theWidth = theLabelsWidth;
    theNameLabel.numberOfLines = 0;
    theNameLabel.font = [UIFont systemFontOfSize:19];
    
    UILabel *theDescriptionLabel = [UILabel new];
    self.theDescriptionLabel = theDescriptionLabel;
    [self.contentView addSubview:theDescriptionLabel];
    
    theDescriptionLabel.theWidth = theLabelsWidth;
    theDescriptionLabel.theMinX = theAvatarImageView.theMaxX + 10;
    theDescriptionLabel.font = [UIFont systemFontOfSize:14];
    theDescriptionLabel.numberOfLines = 0;
    
    UIImageView *theForksImageView = [UIImageView new];
    [self.contentView addSubview:theForksImageView];
    theForksImageView.theMinY = 15;
    theForksImageView.theWidth = 30;
    theForksImageView.theHeight = 30;
    theForksImageView.theMaxX = self.theWidth - 15;
    
    theForksImageView.image = [UIImage imageNamed:@"github_fork"];
    
    UILabel *theForksCountLabel = [UILabel new];
    self.theForksCountLabel = theForksCountLabel;
    [self.contentView addSubview:theForksCountLabel];
    
    theForksCountLabel.theMinY = theForksImageView.theMaxY + 10;
    theForksCountLabel.theWidth = theForksImageView.theWidth + 10;
    theForksCountLabel.theHeight = 10;
    theForksCountLabel.theCenterX = theForksImageView.theCenterX;
    theForksCountLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - Setters (Public)

- (void)setTheRepository:(Repository * _Nonnull)theRepository
{
    if (!theRepository)
    {
        abort();
    }
    _theRepository = theRepository;
    
    double theLabelsWidth = 180;
    UILabel *theNameLabel = self.theNameLabel;
    theNameLabel.text = theRepository.theNameString;
    theNameLabel.theWidth = theLabelsWidth;
    [theNameLabel sizeToFit];
    theNameLabel.theWidth = theLabelsWidth;
    
    UILabel *theDescriptionLabel = self.theDescriptionLabel;
    theDescriptionLabel.text = theRepository.theDescriptionString;
    theDescriptionLabel.theWidth = theLabelsWidth;
    theDescriptionLabel.theMinY = self.theNameLabel.theMaxY + 10;
    [theDescriptionLabel sizeToFit];
    theDescriptionLabel.theWidth = theLabelsWidth;
    
    UILabel *theForksCountLabel = self.theForksCountLabel;
    theForksCountLabel.text = theRepository.theForksCountString;
    [theForksCountLabel sizeToFit];
    theForksCountLabel.theWidth = 40;
    
    self.theAvatarImageView.image = [UIImage imageNamed:@"white_image"];
    
    NSString *theAvatarUrlString = [NSString stringWithFormat:@"%@?s=40",theRepository.theAvatarUrlString];
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






























