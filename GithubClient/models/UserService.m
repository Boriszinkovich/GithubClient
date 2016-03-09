//
//  UserService.m
//  GithubClientTask
//
//  Created by User on 04.03.16.
//  Copyright © 2016 BZ. All rights reserved.
//
#define HOST_NAME_CONSTANT @"https://api.github.com/"

#import "UserService.h"

#import "BZExtensionsManager.h"
#import "Repository.h"
#import "Subscriber.h"

@interface UserService ()

@property (nonatomic, strong, nonnull) NSMutableDictionary *theServiceDictionary;

@end

static UserService *theUserService = nil;

@implementation UserService

#pragma mark - Class Methods (Public)

+ (UserService * _Nonnull)sharedInstance
{
    
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      theUserService = [[UserService alloc] initPrivate];
                  });
    
    return theUserService;
}

#pragma mark - Class Methods (Private)

#pragma mark - Init & Dealloc

- (instancetype)init
{
    abort();
    return [[self class] sharedInstance];
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self)
    {
        self.theServiceDictionary = [NSMutableDictionary new];
    }
    return self;
}

#pragma mark - Setters (Public)

#pragma mark - Getters (Public)

#pragma mark - Setters (Private)

#pragma mark - Getters (Private)

#pragma mark - Lifecycle

#pragma mark - Create Views & Variables

#pragma mark - Actions

#pragma mark - Gestures

#pragma mark - Delegates ()

#pragma mark - Methods (Public)

- (void)methodLoadAllRepositoriesWithPage:(NSUInteger)thePage
                                    count:(NSUInteger)theCount
                                  taskKey:(NSString * _Nonnull)theTaskKey
                               completion:(void(^ _Nonnull)(NSArray<Repository *> * _Nullable repositoriesArray, NSError * _Nullable error))theCompletionBlock
{
    if (!theTaskKey || !thePage || !theCount || !theCompletionBlock)
    {
        abort();
    }
    BZUrlSession *theSession;
    if (!self.theServiceDictionary[theTaskKey])
    {
        theSession = [BZUrlSession new];
        self.theServiceDictionary[theTaskKey] = theSession;
    }
    else
    {
        theSession = self.theServiceDictionary[theTaskKey];
    }
    NSString *theUrlString = [NSString stringWithFormat:@"%@repositories?per_page=%ld&page=%ld",HOST_NAME_CONSTANT,theCount,thePage];
    NSURL *theUrl = [NSURL URLWithString:theUrlString];
    [theSession methodStartTaskWithUrl:theUrl
                   withCompletionBlock:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
     {
         NSError *theError;
         if (!data)
         {
             theError = [NSError errorWithDomain:@"Domain" code:UserServiceErrorNoData userInfo:nil];
             theCompletionBlock(nil,theError);
             return;
         }
         if (error)
         {
             theError = [NSError errorWithDomain:error.domain code:UserServiceErrorWithError userInfo:error.userInfo];
             theCompletionBlock(nil,theError);
             return;
         }
         NSDictionary *theRepoDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:&error];
         if ([theRepoDictionary isKindOfClass:[NSDictionary class]])
         {
             if (theRepoDictionary[@"message"])
             {
                 theError = [NSError errorWithDomain:@"" code:UserServiceErrorTooMuchRequests userInfo:nil];
                 theCompletionBlock(nil,theError);
                 return;
             }
             abort();
         }
         NSArray *theRepoArray = (NSArray *)theRepoDictionary;
         NSMutableArray *theLoadedRepositoriesArray = [NSMutableArray new];
         for (NSDictionary *theCurrentDictionary in theRepoArray)
         {
             if (theLoadedRepositoriesArray.count == 99)
             {
                 
             }
             Repository *theCurrentRepository = [Repository new];
             [theCurrentRepository methodSetRepositoryWithDictionary:theCurrentDictionary];
             [theLoadedRepositoriesArray addObject:theCurrentRepository];
         }
         theCompletionBlock(theLoadedRepositoriesArray,theError);
     }];
}

- (void)methodLoadRepositoriesWithSearchString:(NSString * _Nonnull)theSearchString
                                          page:(NSUInteger)thePage
                                         count:(NSUInteger)theCount
                                       taskKey:(NSString * _Nonnull)theTaskKey
                                    completion:(void (^ _Nonnull)(NSArray<Repository *> * _Nullable theRepositoriesArray, NSInteger theTotalCount, NSError * _Nullable error))theCompletionBlock
{
    if (!theTaskKey || !theCompletionBlock || !thePage || !theCount)
    {
        abort();
    }
    BZUrlSession *theSession;
    if (!self.theServiceDictionary[theTaskKey])
    {
        theSession = [BZUrlSession new];
        self.theServiceDictionary[theTaskKey] = theSession;
    }
    else
    {
        theSession = self.theServiceDictionary[theTaskKey];
    }
    NSString *theUrlString = [NSString stringWithFormat:@"%@search/repositories?q=%@&per_page=%ld&page=%ld",HOST_NAME_CONSTANT,theSearchString,theCount,thePage];
    NSURL *theUrl = [NSURL URLWithString:theUrlString];
    [theSession methodStartTaskWithUrl:theUrl
                   withCompletionBlock:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
     {
         NSError *theError;
         if (!data)
         {
             theError = [NSError errorWithDomain:@"Domain" code:UserServiceErrorNoData userInfo:nil];
             theCompletionBlock(nil, 0, theError);
             return;
         }
         if (error)
         {
             theError = [NSError errorWithDomain:error.domain code:UserServiceErrorWithError userInfo:error.userInfo];
             theCompletionBlock(nil, 0, theError);
             return;
         }
         NSDictionary *theRepoDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:&error];
         if ([theRepoDictionary isKindOfClass:[NSDictionary class]])
         {
             if (theRepoDictionary[@"message"])
             {
                 theError = [NSError errorWithDomain:@"" code:UserServiceErrorTooMuchRequests userInfo:nil];
                 theCompletionBlock(nil,0,theError);
                 return;
             }
         }
         NSInteger theTotalCount = 0;
         if (theRepoDictionary[@"total_count"])
         {
             NSString *theRepoTotalNumberString = [NSString stringWithFormat:@"%@",theRepoDictionary[@"total_count"]];
             theTotalCount = [theRepoTotalNumberString integerValue];
         }
         if (!theRepoDictionary[@"items"])
         {
             theError = [NSError errorWithDomain:@"Domain" code:UserServiceErrorNoData userInfo:nil];
             theCompletionBlock(nil, theTotalCount, theError);
             return;
         }
         NSArray *theRepoArray = theRepoDictionary[@"items"];
         NSMutableArray *theLoadedRepositoriesArray = [NSMutableArray new];
         for (NSDictionary *theCurrentDictionary in theRepoArray)
         {
             Repository *theCurrentRepository = [Repository new];
             [theCurrentRepository methodSetRepositoryWithDictionary:theCurrentDictionary];
             [theLoadedRepositoriesArray addObject:theCurrentRepository];
         }
         theCompletionBlock(theLoadedRepositoriesArray,theTotalCount,theError);
     }];
}

- (void)methodLoadSubscribersWithUrlString:(NSString * _Nonnull)theUrlString
                                      Page:(NSUInteger)thePage
                                     count:(NSUInteger)theCount
                                   taskKey:(NSString * _Nonnull)theTaskKey
                                completion:(void (^ _Nonnull)(NSArray<Subscriber *> * _Nullable repositoriesArray, NSError * _Nullable error))theCompletionBlock;
{
    if (!theTaskKey || !theCompletionBlock || !thePage || !theCount || !theUrlString)
    {
        abort();
    }
    BZUrlSession *theSession;
    if (!self.theServiceDictionary[theTaskKey])
    {
        theSession = [BZUrlSession new];
        [self.theServiceDictionary setObject:theSession forKey:theTaskKey];
    }
    else
    {
        theSession = self.theServiceDictionary[theTaskKey];
    }
    NSString *theLoadUrlString = [NSString stringWithFormat:@"%@?per_page=%ld&page=%ld",theUrlString,(long)theCount,thePage];
    NSURL *theNSURL = [NSURL URLWithString:theLoadUrlString];
    [theSession methodStartTaskWithUrl:theNSURL withCompletionBlock:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        NSError *theError;
        if (!data)
        {
            theError = [NSError errorWithDomain:@"Domain" code:UserServiceErrorNoData userInfo:nil];
            theCompletionBlock(nil, theError);
            return;
        }
        if (error)
        {
            theError = [NSError errorWithDomain:error.domain code:UserServiceErrorWithError userInfo:error.userInfo];
            theCompletionBlock(nil, theError);
            return;
        }
        NSDictionary *theSubscribersDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                 options:kNilOptions
                                                                                   error:&error];
        if ([theSubscribersDictionary isKindOfClass:[NSDictionary class]])
        {
            if (theSubscribersDictionary[@"message"])
            {
                theError = [NSError errorWithDomain:@"" code:UserServiceErrorTooMuchRequests userInfo:nil];
                theCompletionBlock(nil, theError);
                return;
            }
        }
        
        NSArray *theSubscribersArray = (NSArray *)theSubscribersDictionary;
//            theWeakSelf.isCanBeLoadedMore = NO;
        NSMutableArray *theLoadedSubscribersArray = [NSMutableArray new];
        for (NSDictionary *theCurrentDictionary in theSubscribersArray)
        {
            Subscriber *theCurrentSubscriber = [Subscriber new];
            [theCurrentSubscriber methodSetSubscriberWithDictionary:theCurrentDictionary];
            [theLoadedSubscribersArray addObject:theCurrentSubscriber];
        }
        theCompletionBlock(theLoadedSubscribersArray, theError);
    }];


}

#pragma mark - Methods (Private)

#pragma mark - Standard Methods

@end






























