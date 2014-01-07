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

@property(nonatomic,strong)IBOutlet UILabel *firstTitle;
@property(nonatomic,strong)IBOutlet UILabel *date;
@property(nonatomic,strong)IBOutlet UILabel *secondTitle;
@property(nonatomic,strong)IBOutlet UITextView *firstDetailText;
@property(nonatomic,strong)IBOutlet UITextView *secondDetailText;
@property (nonatomic, strong) IBOutlet UIToolbar * toolbar;

@end
