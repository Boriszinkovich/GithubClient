//
//  ViewController.m
//  GithubClientTask
//
//  Created by User on 29.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "MainVC.h"

#import "BZExtensionsManager.h"
#import "Repository.h"
#import "RepositoriesCell.h"
#import "SubscribersVC.h"
#import "UserService.h"

@interface MainVC () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, nonnull) UITextField *theSearchField;
@property (nonatomic, strong, nonnull) UITableView *theRepoTableView;
@property (nonatomic, strong, nonnull) NSMutableArray *theRepositoriesArray;
@property (nonatomic, strong, nonnull) NSURLSession *theMainNSUrlSession;
@property (nonatomic, strong, nonnull) NSURLSessionDataTask *theMainDataTask;
@property (nonatomic, assign) NSInteger theCurrentLoadPage;
@property (nonatomic, strong) UIRefreshControl* theMainRefreshControl;
@property (nonatomic, strong, nonnull) UIActivityIndicatorView *theFooterIndicator;
@property (nonatomic, assign) NSInteger theCurrentTotalRepositoriesNumber;
@property (nonatomic, strong) Reachability *theInternetReachability;

@end

const NSInteger theLoadsCount = 50;
const NSString *theMainVCKey = @"theMainVCKey";

@implementation MainVC

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
        [self methodLoadWithChanges];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
    
    self.theRepositoriesArray = [NSMutableArray new];
    self.theCurrentLoadPage = 1;
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    self.theMainNSUrlSession = [NSURLSession sessionWithConfiguration:config];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionReachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    Reachability *theInternerReachability = [Reachability reachabilityForInternetConnection];
    self.theInternetReachability = theInternerReachability;
    @weakify(self);
    theInternerReachability.reachableBlock = ^(Reachability *theReachability)
    {
        [BZExtensionsManager methodAsyncMainWithBlock:^
        {
            @strongify(self);
            self.theCurrentLoadPage = 1;
            [self methodLoadWithChanges];
        }];
    };
    theInternerReachability.unreachableBlock = ^(Reachability *theReachability)
    {
        @weakify(self);
        [BZExtensionsManager methodAsyncMainWithBlock:^
         {
             @strongify(self);
             [self methodAlertWithNoInternet];
             [self.theMainRefreshControl endRefreshing];
             [self.theFooterIndicator stopAnimating];
         }];
    };
    [theInternerReachability startNotifier];
    
    UIView *theTopView = [UIView new];
    [self.view addSubview:theTopView];
    theTopView.theHeight = 125;
    theTopView.theWidth = theTopView.superview.theWidth;
    
    theTopView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    {
        UIImageView *theImageView = [UIImageView new];
        [theTopView addSubview:theImageView];
        theImageView.theWidth = 40;
        theImageView.theHeight = 40;
        theImageView.theMinY = 30;
        theImageView.theMinX = 15;
        theImageView.image = [UIImage getImageNamed:@"github_icon"];
        
        
        UILabel *theGithubLabel = [UILabel new];
        [theTopView addSubview:theGithubLabel];
        theGithubLabel.theMinY = 35;
        theGithubLabel.theMinX = 125;
        theGithubLabel.text = @"GitHub";
        theGithubLabel.font = [UIFont boldSystemFontOfSize:22];
        [theGithubLabel sizeToFit];
        
        UITextField *theSearchField = [UITextField new];
        theSearchField.delegate = self;
        self.theSearchField = theSearchField;
        [theTopView addSubview:theSearchField];
        theSearchField.theMinX = 15;
        theSearchField.theMinY = 80;
        theSearchField.theHeight = 30;
        theSearchField.theWidth = self.view.theWidth - 30;
        theSearchField.backgroundColor = [UIColor whiteColor];
        theSearchField.placeholder = @"Find Repositories";
        theSearchField.textAlignment = NSTextAlignmentCenter;
        theSearchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        theSearchField.autocorrectionType = UITextAutocorrectionTypeNo;
        theSearchField.layer.cornerRadius = 15;
        theSearchField.returnKeyType = UIReturnKeySearch;
        {
            UIView *theLeftView = [UIView new];
            theSearchField.leftView = theLeftView;
            theLeftView.theWidth = 10;
            theLeftView.theHeight = theLeftView.superview.theHeight;
            theLeftView.backgroundColor = theSearchField.backgroundColor;
            theSearchField.leftViewMode = UITextFieldViewModeNever;
        }
        
        [theSearchField addTarget:self action:@selector(actionSearchTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    UITableView *theTableView = [UITableView new];
    theTableView.delegate = self;
    theTableView.dataSource = self;
    self.theRepoTableView = theTableView;
    [self.view addSubview:theTableView];
    theTableView.theMinY = theTopView.theHeight;
    theTableView.theWidth = theTableView.superview.theWidth;
    theTableView.theHeight = theTableView.superview.theHeight - theTableView.theMinY;
    
    UIRefreshControl *theMainRefreshControl = [UIRefreshControl new];
    self.theMainRefreshControl = theMainRefreshControl;
    [theTableView addSubview:theMainRefreshControl];
    [theMainRefreshControl addTarget:self action:@selector(actionRefreshDidChange:) forControlEvents:UIControlEventValueChanged];
    
    UIActivityIndicatorView *theFooterIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.theFooterIndicator = theFooterIndicator;
    theFooterIndicator.theHeight = 40;
    theTableView.tableFooterView = theFooterIndicator;
    theFooterIndicator.theWidth = self.view.theWidth;
}

#pragma mark - Actions

- (void)actionSearchTextDidChange:(UITextField *)theTextField
{
    [self methodLoadWithChanges];
}

- (void)actionRefreshDidChange:(UIRefreshControl *)refreshControl
{
    if (!self.theInternetReachability.isReachable)
    {
        [self methodAlertWithNoInternet];
        [self.theMainRefreshControl endRefreshing];
        return;
    }
    if ([self.theFooterIndicator isAnimating])
    {
        [self.theFooterIndicator stopAnimating];
    }
    [self methodLoadWithChanges];
}

#pragma mark - Gestures

#pragma mark - Delegates (UITableViewDelegate, UITableViewDataSource)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.theInternetReachability.isReachable)
    {
        [self methodAlertWithNoInternet];
        return;
    }
    
    Repository *theChosedRepository;
    
    theChosedRepository = self.theRepositoriesArray[indexPath.row];
    SubscribersVC *theSubscribersViewController = [SubscribersVC new];
    theSubscribersViewController.theMainRepository = theChosedRepository;
    [self.navigationController pushViewController:theSubscribersViewController animated:YES];
    [self.theRepoTableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.theRepositoriesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *theBZRepositoriesUITableViewCellIdentifier = @"theBZRepositoriesUITableViewCellIdentifier";
    RepositoriesCell *theCell = (RepositoriesCell *)[tableView dequeueReusableCellWithIdentifier:theBZRepositoriesUITableViewCellIdentifier];
    if (theCell == nil)
    {
        theCell = [[RepositoriesCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:theBZRepositoriesUITableViewCellIdentifier];
    }
    Repository *theRepository;

    theRepository = self.theRepositoriesArray[indexPath.row];
    [theCell setTheRepository:theRepository];
    
    return theCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Repository *theRepository;
    theRepository = self.theRepositoriesArray[indexPath.row];

    double theLabelsWidth = 180;
    double theCellHeight = 0;
    
    UILabel *theNameLabel = [UILabel new];
    theNameLabel.theWidth = theLabelsWidth;
    theNameLabel.numberOfLines = 0;
    theNameLabel.text = theRepository.theNameString;
    theNameLabel.font = [UIFont systemFontOfSize:19];
    [theNameLabel sizeToFit];
    
    UILabel *theDescriptionLabel = [UILabel new];
    theDescriptionLabel.theWidth = theLabelsWidth;
    theDescriptionLabel.numberOfLines = 0;
    theDescriptionLabel.text = theRepository.theDescriptionString;
    theDescriptionLabel.font = [UIFont systemFontOfSize:14];
    [theDescriptionLabel sizeToFit];
    
    theCellHeight = 40 + theNameLabel.theHeight + theDescriptionLabel.theHeight;
    if (theCellHeight < 80)
    {
        theCellHeight = 80;
    }
    
    return theCellHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.theInternetReachability.isReachable)
    {
        return;
    }
    if ([self.theFooterIndicator isAnimating])
    {
        return;
    }
    // in https://api.github.com/repositories method per_page and page params dont work
    if ([self.theSearchField.text isEqual:@""])
    {
        return;
    }
    if (self.theCurrentTotalRepositoriesNumber < self.theCurrentLoadPage * theLoadsCount)
    {
        return;
    }
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height - 10)
    {
        if (![self.theMainRefreshControl isRefreshing])
        {
            [self.theFooterIndicator startAnimating];
            self.theFooterIndicator.theHeight = 40;
            self.theRepoTableView.tableFooterView = self.theFooterIndicator;
            [self methodLoadWithScroll];
        }
    }
}

#pragma mark - Delegates (UITextFieldDelegate)

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.textAlignment = NSTextAlignmentLeft;
    textField.leftViewMode = UITextFieldViewModeAlways;
    [textField becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (isEqual(textField.text, @""))
    {
        textField.textAlignment = NSTextAlignmentCenter;
        textField.leftViewMode = UITextFieldViewModeNever;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Methods (Public)

#pragma mark - Methods (Private)

- (void)methodLoadWithChanges
{
    if (!self.theInternetReachability.isReachable)
    {
        [self methodAlertWithNoInternet];
        return;
    }
    if (![self.theMainRefreshControl isRefreshing])
    {
        [self.theRepoTableView setContentOffset:CGPointMake(0, - self.theMainRefreshControl.theHeight) animated:YES];
        [self.theMainRefreshControl beginRefreshing];
    }
    self.theCurrentLoadPage = 1;
    [self.theFooterIndicator stopAnimating];
    UserService *theUserService = [UserService sharedInstance];
    if (isEqual(self.theSearchField.text, @""))
    {
        @weakify(self);
        [theUserService methodLoadAllRepositoriesWithPage:1 count:100 taskKey:theMainVCKey.copy completion:^(NSArray<Repository *> * _Nullable repositoriesArray, NSError * _Nullable error)
         {
             @strongify(self);
             [self methodUpdateInterfaceWithRepoArray:repositoriesArray
                                           totalCount:repositoriesArray.count
                                                 page:1
                                                error:error];
         }];
        return;
    }
    @weakify(self);
    [theUserService methodLoadRepositoriesWithSearchString:self.theSearchField.text
                                                      page:self.theCurrentLoadPage
                                                     count:theLoadsCount
                                                   taskKey:theMainVCKey.copy
                                                completion:^(NSArray<Repository *> * _Nullable theRepositoriesArray, NSInteger theTotalCount, NSError * _Nullable error)
    {
        @strongify(self);
        [self methodUpdateInterfaceWithRepoArray:theRepositoriesArray
                                      totalCount:theTotalCount
                                            page:self.theCurrentLoadPage
                                           error:error];
    }];
}

- (void)methodLoadWithScroll
{
    if (!self.theInternetReachability.isReachable)
    {
        [self methodAlertWithNoInternet];
        return;
    }
    if (self.theCurrentTotalRepositoriesNumber < self.theCurrentLoadPage * theLoadsCount)
    {
        return;
    }
    self.theCurrentLoadPage += 1;
    UserService *theUserService = [UserService sharedInstance];
    if (isEqual(self.theSearchField.text, @""))
    {
        @weakify(self);
        [theUserService methodLoadAllRepositoriesWithPage:1 count:100 taskKey:theMainVCKey.copy completion:^(NSArray<Repository *> * _Nullable repositoriesArray, NSError * _Nullable error)
         {
             @strongify(self);
             [self methodUpdateInterfaceWithRepoArray:repositoriesArray
                                           totalCount:repositoriesArray.count
                                                 page:1
                                                error:error];
         }];
        return;
    }
    @weakify(self);
    [theUserService methodLoadRepositoriesWithSearchString:self.theSearchField.text
                                                      page:self.theCurrentLoadPage
                                                     count:theLoadsCount
                                                   taskKey:theMainVCKey.copy
                                                completion:^(NSArray<Repository *> * _Nullable theRepositoriesArray, NSInteger theTotalCount, NSError * _Nullable error)
     {
         @strongify(self);
         [self methodUpdateInterfaceWithRepoArray:theRepositoriesArray
                                       totalCount:theTotalCount
                                             page:self.theCurrentLoadPage
                                            error:error];
     }];
}

- (void)methodAlertWithTooManySearch
{
    UIAlertController *theAlert = [UIAlertController alertControllerWithTitle:nil
                                                                      message:@"You searched too much. Try again later."
                                                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *theDefaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {}];
    
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
                                                             handler:^(UIAlertAction * action) {}];
    
    [theAlert addAction:theDefaultAction];
    [self presentViewController:theAlert animated:YES completion:nil];
}

- (void)methodUpdateInterfaceWithRepoArray:(NSArray *)theRepoArray
                                totalCount:(NSUInteger)theTotalCount
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
                @weakify(self);
                [BZExtensionsManager methodAsyncMainWithBlock:^
                {
                    @strongify(self);
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
    self.theCurrentTotalRepositoriesNumber = theTotalCount;
    @weakify(self);
    [BZExtensionsManager methodAsyncMainWithBlock:^
     {
         @strongify(self);
         if (thePage == 1)
         {
             [self.theRepositoriesArray removeAllObjects];
             [self.theRepoTableView reloadData];
         }
         [self.theRepoTableView beginUpdates];
         NSIndexPath *theIndexPath;
         for(int i = 0; i < theRepoArray.count; i++)
         {
             theIndexPath = [NSIndexPath indexPathForRow: i + self.theRepositoriesArray.count
                                               inSection:0];
             [self.theRepoTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:theIndexPath]
                                                 withRowAnimation:UITableViewRowAnimationAutomatic];
         }
         [self.theRepositoriesArray addObjectsFromArray:theRepoArray];
         [self.theRepoTableView endUpdates];
         [self.theFooterIndicator stopAnimating];
         self.theFooterIndicator.theHeight = 0;
         self.theRepoTableView.tableFooterView = self.theFooterIndicator;
         if ([self.theMainRefreshControl isRefreshing])
         {
             if (thePage == 1)
             {
                 [self.theRepoTableView setContentOffset:CGPointMake(0, 0) animated:YES];
             }
             [self.theMainRefreshControl endRefreshing];
         }
     }];
}

#pragma mark - Standard Methods

@end






























