//
//  DetailNumberNewsView.m
//  DOLNumbers
//
//

#import "DetailNumberNewsView.h"
#import "DOLNumbersAppDelegate.h"
#import "DOLNewsWebView.h"


@implementation DetailNumberNewsView
@synthesize firstTitle,firstDetailText,secondTitle,secondDetailText,date;
@synthesize toolbar = _toolbar;


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    DOLNumbersAppDelegate *myAppDelegate =(DOLNumbersAppDelegate *) [[UIApplication sharedApplication] delegate];

   
   
    
	   if(buttonIndex == 0){
        
        myAppDelegate.webflag=0;
        DOLNewsWebView *dolNews=[[DOLNewsWebView alloc]init];
        [self.navigationController pushViewController:dolNews animated:YES];
        [dolNews release];
       }
        if(buttonIndex == 1){
            
             myAppDelegate.webflag=1;
            DOLNewsWebView *dolNews=[[DOLNewsWebView alloc]init];
            [self.navigationController pushViewController:dolNews animated:YES];
            [dolNews release];
        }
        
	
      
}

-(void)openWebLink{
   
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
															 delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open as PDF",@"Open in Safari",nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showFromToolbar:_toolbar];
	[actionSheet release];	
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (NSString *)flattenHTMLForPdfLink:(NSString *)html {
    
    NSScanner *thescanner;
    NSString *text = nil;
    NSString *text1 = nil;
    NSString *text2 = nil;
    
    
    thescanner = [NSScanner scannerWithString:html];
    [thescanner scanUpToString:@"a href=" intoString:&text1] ; 
    [thescanner scanUpToString:@">" intoString:&text2] ; 
    [thescanner scanUpToString:@"<" intoString:&text] ;
    NSString *escaped = [text stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    
    return escaped;
    
}
- (NSString *)flattenHTMLForSafariLink:(NSString *)html {
    
    NSScanner *thescanner;
    NSString *text = nil;
    NSString *text1 = nil;
    
    
    
    thescanner = [NSScanner scannerWithString:html];
    [thescanner scanUpToString:@"h4" intoString:&text1] ; 
    [thescanner scanUpToString:@"http" intoString:&text1] ; 
    [thescanner scanUpToString:@"htm" intoString:&text] ;
    
    NSString *escaped = [text stringByReplacingOccurrencesOfString:@"a href=" withString:@""];
    NSString *escaping1 = [escaped
                             stringByAppendingString:@"htm"];
 
    return escaping1;
    
}

- (NSString *)flattenHTMLForTitle:(NSString *)html {
    
    NSScanner *thescanner;
    NSString *text = nil;
    NSString *text1 = nil;
    NSString *text2 = nil;


    
    thescanner = [NSScanner scannerWithString:html];
    
   
        [thescanner scanUpToString:@"title" intoString:&text1] ; 
        [thescanner scanUpToString:@">" intoString:&text2] ; 

        [thescanner scanUpToString:@"<" intoString:&text] ;

        
        NSString *escaped = [text stringByReplacingOccurrencesOfString:@">" withString:@""];
        
      
    
    return escaped;
    
}
- (NSString *)flattenHTMLForSubTitle:(NSString *)html {
    
    NSScanner *thescanner;
    NSString *text = nil;
    NSString *text1 = nil;
    NSString *text2 = nil;
    
    
    
    thescanner = [NSScanner scannerWithString:html];
    
    
    
    
    [thescanner scanUpToString:@"subtitle" intoString:&text1] ; 
    [thescanner scanUpToString:@">" intoString:&text2] ; 
    
    [thescanner scanUpToString:@"<" intoString:&text] ;
    
    NSString *escaped = [text stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    
    
    return escaped;
    
}
- (NSString *)flattenHTMLForDate:(NSString *)html {
    
    NSScanner *thescanner;
    NSString *text = nil;
    NSString *text1 = nil;
    
    
    
    thescanner = [NSScanner scannerWithString:html];
    
        [thescanner scanUpToString:@"update" intoString:&text1] ; 
    
    [thescanner scanUpToString:@">" intoString:NULL] ; 
    
   

    
    [thescanner scanUpToString:@"<" intoString:&text] ;
    NSString *escaped = [text stringByReplacingOccurrencesOfString:@">" withString:@""];
    return escaped;
    
}

- (NSString *)flattenHTMLForTableTitle:(NSString *)html {
    
    NSScanner *thescanner;
    NSString *text = nil;
    NSString *text1 = nil;
    NSString *text2 = nil;
    NSString *text3 = nil;

    
    
    
    thescanner = [NSScanner scannerWithString:html];
    
   
    [thescanner scanUpToString:@"h4" intoString:&text1] ; 
    
    [thescanner scanUpToString:@"underline" intoString:&text2] ; 
    [thescanner scanUpToString:@">" intoString:&text3] ; [thescanner scanUpToString:@"<" intoString:&text] ;
    NSString *escaped = [text stringByReplacingOccurrencesOfString:@">" withString:@""];
    return escaped;
    
}

- (NSString *)flattenHTMLForDetailTableTitle:(NSString *)html {
    
    NSScanner *thescanner;
    NSString *text = nil;
    NSString *text1 = nil;
    NSString *text3 = nil;
    
    
    
    
    thescanner = [NSScanner scannerWithString:html];
    
    [thescanner scanUpToString:@"p style" intoString:&text1] ; 
    [thescanner scanUpToString:@">" intoString:&text3] ; 
    
    
        
    [thescanner scanUpToString:@"<" intoString:&text] ;
    
    
    NSString *escaped = [text stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    return escaped;
    
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    internalFlag=0;
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                     target:self action:@selector(openWebLink)];
     NSArray *items = [NSArray arrayWithObjects: actionButton,  nil];
     [self.toolbar setItems:items animated:NO];
    
    [firstDetailText setEditable: NO];
    [secondDetailText setEditable:NO];
    
    
    DOLNumbersAppDelegate *myAppDelegate =(DOLNumbersAppDelegate *) [[UIApplication sharedApplication] delegate];
   
    
    
        internalFlag=0;
     if (myAppDelegate.flag==0) {
        url = [NSURL URLWithString:@"http://www.bls.gov/include/govdelivery/cpi.rss"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSString *myString = [[NSString alloc] initWithData:data
                                                   encoding:NSASCIIStringEncoding];
        NSString *safarilink= [self flattenHTMLForSafariLink:myString];
        myAppDelegate.safarilink=safarilink;

        NSString *pdflink= [self flattenHTMLForPdfLink:myString];
        myAppDelegate.pdflink=pdflink;
         [myString release];
    }
    else if (myAppDelegate.flag==1) {
        url = [NSURL URLWithString:@"http://www.bls.gov/include/govdelivery/empsit.rss"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSString *myString = [[NSString alloc] initWithData:data
                                                   encoding:NSASCIIStringEncoding];
        NSString *safarilink= [self flattenHTMLForSafariLink:myString];
        myAppDelegate.safarilink=safarilink;
        NSString *pdflink= [self flattenHTMLForPdfLink:myString];
        myAppDelegate.pdflink=pdflink;
    }
 
    else if (myAppDelegate.flag==2) {
        url = [NSURL URLWithString:@"http://www.bls.gov/include/govdelivery/ppi.rss"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSString *myString = [[NSString alloc] initWithData:data
                                                   encoding:NSASCIIStringEncoding];
        NSString *safarilink= [self flattenHTMLForSafariLink:myString];
        myAppDelegate.safarilink=safarilink;
        NSString *pdflink= [self flattenHTMLForPdfLink:myString];
        myAppDelegate.pdflink=pdflink;
        [myString release];

    }
    else if (myAppDelegate.flag==3) {
        url = [NSURL URLWithString:@"http://www.bls.gov/include/govdelivery/prod2.rss"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSString *myString = [[NSString alloc] initWithData:data
                                                   encoding:NSASCIIStringEncoding];
        NSString *safarilink= [self flattenHTMLForSafariLink:myString];
        myAppDelegate.safarilink=safarilink;
        NSString *pdflink= [self flattenHTMLForPdfLink:myString];
        myAppDelegate.pdflink=pdflink;
        [myString release];

    }
    else if (myAppDelegate.flag==4) {
        url = [NSURL URLWithString:@"http://www.bls.gov/include/govdelivery/ximpim.rss"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSString *myString = [[NSString alloc] initWithData:data
                                                   encoding:NSASCIIStringEncoding];
        NSString *safarilink= [self flattenHTMLForSafariLink:myString];
        myAppDelegate.safarilink=safarilink;
        NSString *pdflink= [self flattenHTMLForPdfLink:myString];
        myAppDelegate.pdflink=pdflink;
        [myString release];

    }
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSString *myString = [[NSString alloc] initWithData:data
                                               encoding:NSASCIIStringEncoding];
   NSString *returntitle= [self flattenHTMLForTitle:myString];
    NSString *returnsubtitle= [self flattenHTMLForSubTitle:myString];
    NSString *returntabletitle = [NSString stringWithFormat:@"Long %C dash", 0x2014];
   returntabletitle= [self flattenHTMLForTableTitle:myString];
    NSString *rawData= [self flattenHTMLForDate:myString];
   

      NSRange timezone = NSMakeRange([rawData length] - 3, 3);
    NSString *cleanData = [rawData stringByReplacingOccurrencesOfString:@":" withString:@"" options:NSCaseInsensitiveSearch range:timezone ];
    // Get rid of the T also
    cleanData = [cleanData stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ssZZZ"];
    NSDate *result = [df dateFromString: cleanData]; 
    NSString *returndetailtabletitle= [self flattenHTMLForDetailTableTitle:myString];
    NSString *finaldate=[NSString stringWithFormat:@"%@", result];
    finaldate= [finaldate stringByReplacingOccurrencesOfString:@"+0000" withString:@" "];

    
    secondTitle.text=returnsubtitle;
    NSString *finalString = [returnsubtitle
                             stringByAppendingString:returntabletitle];
    NSString *finalString1 = [finalString
                              stringByAppendingString:returndetailtabletitle];
    
    
    firstTitle.numberOfLines=3;
    secondTitle.numberOfLines=4;
    date.numberOfLines=2;
    firstTitle.text=returntitle;
    date.text=finaldate;
    
    secondDetailText.text=finalString1;
           
    
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [firstTitle release];
    [date release];
    [secondTitle release];
    [firstDetailText release];
    [secondDetailText release];
    [_toolbar release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
