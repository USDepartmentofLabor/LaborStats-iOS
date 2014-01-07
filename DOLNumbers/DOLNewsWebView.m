//
//  DOLNewsWebView.m
//  DOLNumbers
//
//

#import "DOLNewsWebView.h"
#import "DOLNumbersAppDelegate.h"



@implementation DOLNewsWebView
@synthesize webView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        

                   }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    

  
    DOLNumbersAppDelegate *myAppDelegate =(DOLNumbersAppDelegate *) [[UIApplication sharedApplication] delegate];
    NSString *urlAddress;
       
    if (myAppDelegate.webflag==0) {
         urlAddress= myAppDelegate.pdflink;
    }
    else if(myAppDelegate.webflag==1)
    {
    urlAddress= myAppDelegate.safarilink;
    }
    else
    {
    urlAddress= myAppDelegate.link;
    }
    
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [webView loadRequest:requestObj];
    [self.view addSubview:webView];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
