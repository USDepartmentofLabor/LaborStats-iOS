//
//  DetailNumberNewsView.h
//  DOLNumbers
//
//

#import <UIKit/UIKit.h>


@interface DetailNumberNewsView : UIViewController <UIActionSheetDelegate>{
    IBOutlet UILabel *firstTitle;
    IBOutlet UILabel *date;
    IBOutlet UILabel *secondTitle;
    
    
    NSURL *url;
    UIToolbar * _toolbar;
    int internalFlag;

    IBOutlet UITextView *firstDetailText;
    IBOutlet UITextView *secondDetailText;

    
}

@property(nonatomic,retain)IBOutlet UILabel *firstTitle;
@property(nonatomic,retain)IBOutlet UILabel *date;
@property(nonatomic,retain)IBOutlet UILabel *secondTitle;
@property(nonatomic,retain)IBOutlet UITextView *firstDetailText;
@property(nonatomic,retain)IBOutlet UITextView *secondDetailText;
@property (nonatomic, retain) IBOutlet UIToolbar * toolbar;

@end
