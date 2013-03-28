//
//  DetailEtaNumberView.m
//  DOLNumbers
//
//  Created by jeswanth B. Reddy on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailEtaNumberView.h"
#import "DOLNumbersAppDelegate.h"
#import "DOLNewsWebView.h"


@implementation DetailEtaNumberView
@synthesize firstTitle,firstDetailText,secondTitle,secondDetailText,date;
@synthesize toolbar = _toolbar;


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    DOLNumbersAppDelegate *myAppDelegate =(DOLNumbersAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if(buttonIndex==0)
    {
        myAppDelegate.webflag=2;
        DOLNewsWebView *dolNews=[[DOLNewsWebView alloc]init];
        [self.navigationController pushViewController:dolNews animated:YES];
        [dolNews release];
    }
    
}

-(void)openWebLink{
    
        internalFlag=1;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari",nil];
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





#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                     target:self action:@selector(openWebLink)];
    NSArray *items = [NSArray arrayWithObjects: actionButton,  nil];
    [self.toolbar setItems:items animated:NO];
    
    [firstDetailText setEditable: NO];
    [secondDetailText setEditable:NO];
    
    
    DOLNumbersAppDelegate *myAppDelegate =(DOLNumbersAppDelegate *) [[UIApplication sharedApplication] delegate];
   
        internalFlag=1;
        firstTitle.numberOfLines=3;
        firstTitle.text=myAppDelegate.newsText;
        
        secondDetailText.text=myAppDelegate.newsDetailText;
        

        
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

