//
//  DOLNumbersAppDelegate.m
//  DOLNumbers
//
//

#import "DOLNumbersAppDelegate.h"
#import "DOLNewsTable.h"
#import "DOLNumberTable.h"
#import "Reachability.h"


@implementation DOLNumbersAppDelegate


@synthesize window=_window;
@synthesize tabBarController=_tabBarController;
@synthesize newsText,newsDetailText,link,flag,safarilink,pdflink,webflag;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
       
    UITabBarController *tabBar = [[UITabBarController alloc] init];
    
    DOLNumberTable *dolNumTableController = [[DOLNumberTable alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navig= [[UINavigationController alloc] initWithRootViewController:dolNumTableController];
    dolNumTableController.title = @"DOL Numbers";
    
    DOLNewsTable *newsLetter = [[DOLNewsTable alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navigNews= [[UINavigationController alloc] initWithRootViewController:newsLetter];
    newsLetter.title = @"News Releases";
    
    
    dolNumTableController.tabBarItem.image = [UIImage imageNamed:@"numbers.png"];
    newsLetter.tabBarItem.image = [UIImage imageNamed:@"news.png"];

    tabBar.viewControllers = [NSArray arrayWithObjects:navig, navigNews, nil];
    
    self.window.rootViewController = tabBar;
    [self.window makeKeyAndVisible];
    return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [newsText release];
    [newsDetailText release];
    [link release];
    [pdflink release];
    [safarilink release];
    [super dealloc];
}

@end
