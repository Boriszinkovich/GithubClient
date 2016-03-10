//
//  BZSubscribersViewController.m
//  GithubClientTask
//
//  Created by User on 29.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "SubscribersVC.h"

#import "BZExtensionsManager.h"
#import "Repository.h"
#import "SubscriberCell.h"
#import "Subscriber.h"
#import "UserService.h"

@interface SubscribersVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, nonnull) NSURLSession *theMainNSUrlSession;
@property (nonatomic, strong, nonnull) NSURLSessionDataTask *theMainDataTask;
@property (nonatomic, strong, nonnull) NSMutableArray *theSubscribersArray;
@property (nonatomic, strong) UIRefreshControl *theMainRefreshControl;
@property (nonatomic, strong, nonnull) UITableView *theSubscribersTableView;
@property (nonatomic, strong, nonnull) UIActivityIndicatorView *theFooterIndicator;
@property (nonatomic, assign) NSInteger theCurrentLoadPage;
@property (nonatomic, assign) BOOL isCanBeLoadedMore;
@property (nonatomic, strong) Reachability *theInternetReachability;

@end

const NSInteger theSubscribersLoadsCount = 50;
const NSString *theSubscribersVCKey = @"theSubscribersVCKey";

@implementation SubscribersVC

#pragma mark - Class Methods (Public)

#pragma mark - Class Methods (Private)

#pragma mark - Init & Dealloc

#pragma mark - Setters (Public)

#pragma mark - Getters (Public)

#pragma mark - Setters (Private)

#pragma mark - Getters (Private)

#pragma mark - Lifecycle

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isFirstLoad)
    {
        [self createAllViews];


        [self methodLoadSubscribersWithPage:self.theCurrentLoadPage];
    }
}

- (void)dealloc
{
    [self.theInternetReachability stopNotifier];
}

#pragma mark - Create Views & Variables

- (void)createAllViews
{
    if (!self.isFirstLoad)
    {
        return;
    }
    self.isFirstLoad = NO;
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.theSubscribersArray = [NSMutableArray new];
    self.theCurrentLoadPage = 1;
    NSURLSessionConfiguration *theURLSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.theMainNSUrlSession = [NSURLSession sessionWithConfiguration:theURLSessionConfiguration];
    [self.theMainRefreshControl beginRefreshing];
    
    Reachability *theInternerReachability = [Reachability reachabilityForInternetConnection];
    self.theInternetReachability = theInternerReachability;
    
    weakify(self);
    theInternerReachability.reachableBlock = ^(Reachability *theReachability)
    {
        [BZExtensionsManager methodAsyncMainWithBlock:^
         {
             strongify(self);
             self.theCurrentLoadPage = 1;
             [self methodLoadSubscribersWithPage:self.theCurrentLoadPage];
         }];
    };
    
    theInternerReachability.unreachableBlock = ^(Reachability *theReachability)
    {
        [BZExtensionsManager methodAsyncMainWithBlock:^
         {
             strongify(self);
             [self methodAlertWithNoInternet];
             [self.theMainRefreshControl endRefreshing];
             [self.theFooterIndicator stopAnimating];
         }];
    };
    [theInternerReachability startNotifier];
    
    UIView *theTopView = [UIView new];
    [self.view addSubview:theTopView];
    theTopView.theHeight = 70;
    theTopView.theWidth = theTopView.superview.theWidth;
    theTopView.backgroundColor = [UIColor getColorWithHexString:@"F5F5F5"];
    {
        UIButton *theBackButton = [UIButton new];
        [theTopView addSubview:theBackButton];
        theBackButton.theMinX = 5;
        theBackButton.theMinY = 25;
        theBackButton.theWidth = 40;
        theBackButton.theHeight = 40;
        UIImage *theBackButtonImage = [UIImage imageNamed:@"backArrow"];
        [theBackButton setImage:[theBackButtonImage getImageScaledToSize:CGSizeMake(15, 25)]
                       forState:UIControlStateNormal];
        [theBackButton addTarget:self
                          action:@selector(actionBackButtonPressed:)
                forControlEvents:UIControlEventTouchDown];
        
        UILabel *theRepositoryNameLabel = [UILabel new];
        [theTopView addSubview:theRepositoryNameLabel];
        theRepositoryNameLabel.theMinY = 30;
        theRepositoryNameLabel.font = [UIFont boldSystemFontOfSize:22];
        theRepositoryNameLabel.text = self.theMainRepository.theNameString;
        [theRepositoryNameLabel sizeToFit];
        theRepositoryNameLabel.theWidth = 240;
        theRepositoryNameLabel.theCenterX = theRepositoryNameLabel.superview.theWidth/2;
        theRepositoryNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    UITableView *theSubscribersTableView = [UITableView new];
    self.theSubscribersTableView = theSubscribersTableView;
    theSubscribersTableView.delegate = self;
    theSubscribersTableView.dataSource = self;
    [self.view addSubview:theSubscribersTableView];
    theSubscribersTableView.theMinY = theTopView.theHeight;
    theSubscribersTableView.theWidth = theSubscribersTableView.superview.theWidth;
    theSubscribersTableView.theHeight = theSubscribersTableView.superview.theHeight - theSubscribersTableView.theMinY;
    theSubscribersTableView.allowsSelection = NO;
    
    UIRefreshControl *theMainRefreshControl = [UIRefreshControl new];
    self.theMainRefreshControl = theMainRefreshControl;
    [theSubscribersTableView addSubview:theMainRefreshControl];
    [theMainRefreshControl addTarget:self
                              action:@selector(actionRefreshDidChange:)
                    forControlEvents:UIControlEventValueChanged];
    
    UIActivityIndicatorView *theFooterIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.theFooterIndicator = theFooterIndicator;
    theFooterIndicator.theHeight = 40;
    theSubscribersTableView.tableFooterView = theFooterIndicator;
    theFooterIndicator.theWidth = self.view.theWidth;
}

#pragma mark - Actions

- (void)actionBackButtonPressed:(UIButton *)theButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionRefreshDidChange:(UIRefreshControl *)theRefreshControl
{
    if (!self.theInternetReachability.isReachable)
    {
        [self methodAlertWithNoInternet];
        [self.theMainRefreshControl endRefreshing];
        return;
    }
    self.theCurrentLoadPage = 1;
    [self methodLoadSubscribersWithPage:self.theCurrentLoadPage];
}

#pragma mark - Gestures

#pragma mark - Delegates (UITableViewDelegate, UITableViewDataSource)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.theSubscribersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *theBZSubscribersUITableViewCellIdentifier = @"theBZSubscribersUITableViewCellIdentifier";
    SubscriberCell *theCell = (SubscriberCell *)[tableView dequeueReusableCellWithIdentifier:theBZSubscribersUITableViewCellIdentifier];
    if (!theCell)
    {
        theCell = [[SubscriberCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:theBZSubscribersUITableViewCellIdentifier];
    }
    Subscriber *theSubscriber;
    theSubscriber = self.theSubscribersArray[indexPath.row];
    [theCell setTheSubscriber:theSubscriber];
    return theCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.theInternetReachability.isReachable)
    {
        return;
    }
    if ([self.theFooterIndicator isAnimating])
    {
        self.isCanBeLoadedMore = NO;
        return;
    }
    if (!self.isCanBeLoadedMore)
    {
        return;
    }
    
    if (self.theSubscribersArray.count && (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height - self.view.theHeight * 2)
    {
        if (self.theSubscribersArray.count < theSubscribersLoadsCount - 10)
        {
            return;
        }
        if (![self.theMainRefreshControl isRefreshing])
        {
            [self.theFooterIndicator startAnimating];
            self.theFooterIndicator.theHeight = 40;
            self.theSubscribersTableView.tableFooterView = self.theFooterIndicator;
            self.theCurrentLoadPage++;
            [self methodLoadSubscribersWithPage:self.theCurrentLoadPage];
        }
    }
}

#pragma mark - Methods (Public)

#pragma mark - Methods (Private)

- (void)methodLoadSubscribersWithPage:(NSUInteger)thePage
{
    UserService *theService = [UserService sharedInstance];
    weakify(self);
    [theService methodLoadSubscribersWithUrlString:self.theMainRepository.theSubscribersUrlString
                                              Page:thePage
                                             count:theSubscribersLoadsCount
                                           taskKey:theSubscribersVCKey.copy
                                        completion:^(NSArray<Subscriber *> * _Nullable repositoriesArray, NSError * _Nullable error)
     {
         strongify(self);
         [self methodUpdateInterfaceWithSubscribersArray:repositoriesArray page:thePage error:error];
     }];
}

- (void)methodAlertWithTooManySearch
{
    UIAlertController *theAlert = [UIAlertController alertControllerWithTitle:nil
                                                                      message:@"You searched too much. Try again later."
                                                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *theDefaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
    
    [theAlert addAction:theDefaultAction];
    [self presentViewController:theAlert animated:YES completion:nil];
}

- (void)methodAlertWithNoInternet
{
    UIAlertController *theAlert = [UIAlertController alertControllerWithTitle:@"No internet connection"
                                                                      message:@"Please, check you internet connection and continue searching"
                                                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *theDefaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
    
    [theAlert addAction:theDefaultAction];
    [self presentViewController:theAlert animated:YES completion:nil];
}

- (void)methodUpdateInterfaceWithSubscribersArray:(NSArray *)theSubscribersArray
                                             page:(NSUInteger)thePage
                                            error:(NSError *)theError
{
    if (theError)
    {
        if (theError.code < 1 || theError.code > UserServiceErrorEnumCount)
        {
            abort();
        }
        switch (theError.code)
        {
            case UserServiceErrorNoData:
            {
                
            }
                break;
            case UserServiceErrorTooMuchRequests:
            {
                weakify(self);
                [BZExtensionsManager methodAsyncMainWithBlock:^
                 {
                     strongify(self);
                     [self methodAlertWithTooManySearch];
                     [self.theFooterIndicator stopAnimating];
                     [self.theMainRefreshControl endRefreshing];
                 }];
            }
                break;
            case UserServiceErrorWithError:
            {
                
            }
                break;
        }
        return;
    }
    if (!theSubscribersArray.count)
    {
        self.isCanBeLoadedMore = NO;
        weakify(self);
        [BZExtensionsManager methodAsyncMainWithBlock:^
         {
             strongify(self);
             [self.theMainRefreshControl endRefreshing];
             [self.theFooterIndicator stopAnimating];
             self.theFooterIndicator.theHeight = 0;
             self.theSubscribersTableView.tableFooterView = self.theFooterIndicator;
         }];
        return;
    }
    weakify(self);
    [BZExtensionsManager methodAsyncMainWithBlock:^
     {
         strongify(self);
         if (thePage == 1)
         {
             [self.theSubscribersArray removeAllObjects];
             [self.theSubscribersTableView reloadData];
         }
         [self.theSubscribersTableView beginUpdates];
         NSIndexPath *theIndexPath;
         for(int i = 0; i < theSubscribersArray.count; i++)
         {
             theIndexPath = [NSIndexPath indexPathForRow: i + self.theSubscribersArray.count
                                               inSection:0];
             [self.theSubscribersTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:theIndexPath]
                                                        withRowAnimation:UITableViewRowAnimationAutomatic];
         }
         [self.theSubscribersArray addObjectsFromArray:theSubscribersArray];
         [self.theSubscribersTableView endUpdates];
         self.isCanBeLoadedMore = YES;
         if (thePage == 1)
         {
             [self.theSubscribersTableView setContentOffset:CGPointMake(0, self.theMainRefreshControl.theHeight) animated:YES];
         }
         [self.theFooterIndicator stopAnimating];
         [self.theMainRefreshControl endRefreshing];
         self.theFooterIndicator.theHeight = 0;
         self.theSubscribersTableView.tableFooterView = self.theFooterIndicator;
     }];
}

#pragma mark - Standard Methods

@end






























