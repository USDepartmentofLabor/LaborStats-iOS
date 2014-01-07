//
//  DetailEtaNumberView.h
//  DOLNumbers
//
//  Created by jeswanth B. Reddy on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailEtaNumberView : UIViewController<UIActionSheetDelegate> {
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
