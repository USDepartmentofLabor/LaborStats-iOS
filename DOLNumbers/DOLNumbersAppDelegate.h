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

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet NSString *newsText;
@property (nonatomic, retain) IBOutlet NSString *newsDetailText;
@property (nonatomic, retain) IBOutlet NSString *link;
@property (nonatomic, retain) IBOutlet NSString *pdflink;
@property (nonatomic, retain) IBOutlet NSString *safarilink;
@property(nonatomic)int flag;
@property(nonatomic)int webflag;


@end
