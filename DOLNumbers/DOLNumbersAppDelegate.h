//
//  DOLNumbersAppDelegate.h
//  DOLNumbers
//
//

#import <UIKit/UIKit.h>

@interface DOLNumbersAppDelegate : NSObject <UIApplicationDelegate> {

    NSString *newsText;
    NSString *newsDetailText;
    NSString *link;
    int flag;
    NSString *pdflink;
    NSString *safarilink;
    int webflag;


}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, strong) IBOutlet NSString *newsText;
@property (nonatomic, strong) IBOutlet NSString *newsDetailText;
@property (nonatomic, strong) IBOutlet NSString *link;
@property (nonatomic, strong) IBOutlet NSString *pdflink;
@property (nonatomic, strong) IBOutlet NSString *safarilink;
@property(nonatomic)int flag;
@property(nonatomic)int webflag;


@end
