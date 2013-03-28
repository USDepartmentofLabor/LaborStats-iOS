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
@property(nonatomic,retain)IBOutlet UILabel *firstTitle;
@property(nonatomic,retain)IBOutlet UILabel *date;
@property(nonatomic,retain)IBOutlet UILabel *secondTitle;
@property(nonatomic,retain)IBOutlet UITextView *firstDetailText;
@property(nonatomic,retain)IBOutlet UITextView *secondDetailText;
@property (nonatomic, retain) IBOutlet UIToolbar * toolbar;

@end
