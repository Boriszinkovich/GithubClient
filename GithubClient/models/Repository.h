//
//  BZRepository.h
//  GithubClientTask
//
//  Created by User on 29.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Repository : NSObject

@property (nonatomic, strong, nullable, readonly) NSString *theNameString;
@property (nonatomic, strong, nullable, readonly) NSString *theDescriptionString;
@property (nonatomic, strong, nullable, readonly) NSString *theAvatarUrlString;
@property (nonatomic, strong, nullable, readonly) NSString *theForksCountString;
@property (nonatomic, strong, nullable, readonly) NSString *theSubscribersCountString;
@property (nonatomic, strong, nullable, readonly) NSString *theSubscribersUrlString;

- (void)methodSetRepositoryWithDictionary:(NSDictionary * _Nonnull)theRepositoryDictionary;

@end






























