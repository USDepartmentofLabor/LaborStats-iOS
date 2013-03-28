//
//  DOLNewsTable.h
//  DOLNumbers
//
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"


@interface DOLNewsTable : UITableViewController  {

     LoadingView *loadingView;
    UIBarButtonItem	*refreshButton;
    UIActivityIndicatorView  *spinner;
        
    }
       
  
    
- (NSString *)flattenHTMLForSubTitle:(NSString *)html;
    
    
    
    @end

