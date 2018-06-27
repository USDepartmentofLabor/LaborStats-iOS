//
//  DOLNewsTable.m
//  DOLNumbers
//
//

#import "DOLNewsTable.h"



#import "DOLNumbersAppDelegate.h"
#import "DetailNumberNewsView.h"
#import "DetailEtaNumberView.h"
#import "Reachability.h"

#import "XMLReader.h"


@implementation DOLNewsTable




-(void)addLoadingScreen{
	loadingView = [LoadingView loadingViewInView:[self.view.window.subviews objectAtIndex:0]];
	
}

- (void)removeView{
    if(loadingView){
        [loadingView removeView];	
        loadingView = nil;
    }
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
}

-(void) removeLoadingScreen{
	[self performSelector:@selector(removeView)	withObject:nil afterDelay:1.0];	
}





-(void)refresh{
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
	{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"No Internet Connection"
                                                                       message:@"An Internet connection is required to access DOL Current Numbers. Please try again later."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else
    {
        
        
        [self performSelectorOnMainThread:@selector(addLoadingScreen) withObject:nil waitUntilDone:NO];
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self.tableView reloadData];
        [self removeLoadingScreen];
        
        
        
    }
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
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
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        refreshButton= [[UIBarButtonItem alloc]
                        initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
        
        self.navigationItem.rightBarButtonItem = refreshButton;
    }
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


//code ends
#pragma mark - View lifecycle


- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    

    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
	{
       
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"No Internet Connection"
                                                                       message:@"An Internet connection is required to access DOL Current Numbers. Please try again later."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
	}
    else
    {
        
        [self performSelectorOnMainThread:@selector(addLoadingScreen) withObject:nil waitUntilDone:NO];
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        
        [self.tableView reloadData];
        [self removeLoadingScreen];
        
        
        
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return 50;
    }
    else
    {
        return 30;
    }
    
}


-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) ]; 
    UIImageView *imgView;
    UILabel *label1;

        
        if (section==0) {
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 4, 44, 44)]; 
            
        }
        else
        {
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 61, 21)]; 
            
        }
        label1=[[UILabel alloc]initWithFrame:CGRectMake(60, -0, 300 , 60)];
        label1.numberOfLines=2;
        label1.backgroundColor=[UIColor clearColor];
        view.backgroundColor=[UIColor clearColor];
        
        switch (section) {
            case 0:
            {
                imgView.image = [UIImage imageNamed:@"dol.png"];
                label1.numberOfLines=3;
                label1.text=@" Employment and Training Administration";
             
                //Accesibility
                label1.isAccessibilityElement = YES;
              //  label1.accessibilityTraits = UIAccessibilityTraitImage;
                label1.accessibilityLabel = NSLocalizedString(@"Employment and Training Administration heading",@"Employment and Training Administration");
                break;
            }
            case 1:
            {
                label1=[[UILabel alloc]initWithFrame:CGRectMake(60, -18, 300 , 60)];
                label1.backgroundColor=[UIColor clearColor];
                imgView.image = [UIImage imageNamed:@"bls.png"];
                label1.text=@"    Bureau of Labor Statistics";
                label1.isAccessibilityElement = YES;
               // label1.accessibilityTraits = UIAccessibilityTraitImage;
                label1.accessibilityLabel = NSLocalizedString(@"Bureau of Labor Statistics heading",@"Employment and Training Administration");
                break;
            }
                
            default:
                break;
                
     
        
        
    }
    
    
    [view addSubview:imgView];
    [view addSubview:label1];
    
    return view;
    
    
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
        return 2;
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
        
        if(section==0){
            return 1;
        }
        
        else
        {
            return 5;
        }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"rssItemCell"];
	if(nil == cell){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"rssItemCell"];
	}
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
    
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
	{
//        UIAlertView *myAlert = [[UIAlertController alloc]
//                                initWithTitle:@"No Internet Connection" message:@"An Internet connection is required to access DOL News Releases. Please try again later."
//                                delegate:self
//                                cancelButtonTitle:@"Ok"
//                                otherButtonTitles:nil];
//        [myAlert show];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"No Internet Connection"
                                                                       message:@"An Internet connection is required to access DOL News Releases. Please try again later."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
	} 
    else
    {
       if (indexPath.section==0) 
       {
  
 
        
               cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
               
               NSString *str = @"https://www.dol.gov/rss/news-ui.xml";
               
               
               NSURL *url = [NSURL URLWithString:str];
               NSURLRequest *request = [NSURLRequest requestWithURL:url];
               NSURLResponse *response = NULL;
               NSError *error = NULL;
               
//               NSURLSession *session = [NSURLSession sharedSession];
//               [[session dataTaskWithURL:[NSURL URLWithString:londonWeatherUrl]
//                       completionHandler:^(NSData *data,
//                                           NSURLResponse *response,
//                                           NSError *error) {
//                           // handle response
//
//                       }] resume];
               NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
               
               NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
               
               NSError *errXml = NULL;
               
               NSDictionary *dict = [XMLReader dictionaryForXMLString:responseString error:&errXml];
               
               
               
               //NSLog(@"%@",[[[dict objectForKey:@"rss"]objectForKey:@"channel"]objectForKey:@"item"]);
               cell.detailTextLabel.numberOfLines=3;
           
           NSLog(@"%@", [[[dict objectForKey:@"rss"] objectForKey:@"channel"] objectForKey:@"item"]);
               
               DOLNumbersAppDelegate *myAppDelegate =(DOLNumbersAppDelegate *) [[UIApplication sharedApplication] delegate];
               
//           myAppDelegate.newsText=[[[[[dict objectForKey:@"rss"] objectForKey:@"channel"] objectForKey:@"item"] objectForKey:@"title"] objectForKey:@"text"];
//           myAppDelegate.newsDetailText=[[[[[dict objectForKey:@"rss"]objectForKey:@"channel"]objectForKey:@"item"]objectForKey:@"description"]objectForKey:@"text"];
//           myAppDelegate.link=[[[[[dict objectForKey:@"rss"]objectForKey:@"channel"]objectForKey:@"item"]objectForKey:@"link"]objectForKey:@"text"];
//           cell.textLabel.text=[[[[[dict objectForKey:@"rss"]objectForKey:@"channel"]objectForKey:@"item"]objectForKey:@"title"]objectForKey:@"text"];
//           cell.detailTextLabel.text=[[[[[dict objectForKey:@"rss"]objectForKey:@"channel"]objectForKey:@"item"]objectForKey:@"description"]objectForKey:@"text"];

           myAppDelegate.newsText=[[[[dict objectForKey:@"rss"] objectForKey:@"channel"] objectForKey:@"item"] objectForKey:@"title"];
           myAppDelegate.newsDetailText=[[[[dict objectForKey:@"rss"]objectForKey:@"channel"]objectForKey:@"item"]objectForKey:@"description"];
           myAppDelegate.link=[[[[dict objectForKey:@"rss"]objectForKey:@"channel"]objectForKey:@"item"]objectForKey:@"link"];
           cell.textLabel.text=[[[[dict objectForKey:@"rss"]objectForKey:@"channel"]objectForKey:@"item"]objectForKey:@"title"];
           cell.detailTextLabel.text=[[[[dict objectForKey:@"rss"]objectForKey:@"channel"]objectForKey:@"item"]objectForKey:@"description"];
           
           
               
        }
        else
        {
        if(indexPath.row==0)
        {
            
            NSURL *url = [NSURL URLWithString:@"https://www.bls.gov/include/govdelivery/cpi.rss"];
            
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            cell.detailTextLabel.numberOfLines=3;
            cell.textLabel.text = @"CPI - Consumer Price Index";
            cell.detailTextLabel.text = [self flattenHTMLForSubTitle:myString];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            
            //               
            
            
        }
        else if(indexPath.row==1)
        {
            NSURL *url = [NSURL URLWithString:@"https://www.bls.gov/include/govdelivery/empsit.rss"];
            
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            cell.detailTextLabel.numberOfLines=3;
            cell.textLabel.text = @"EMPSIT - Employment Situation";
            cell.detailTextLabel.text = [self flattenHTMLForSubTitle:myString];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        else if(indexPath.row==2)
        {
            
            NSURL *url = [NSURL URLWithString:@"https://www.bls.gov/include/govdelivery/ppi.rss"];
            
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSString *myString = [[NSString alloc] initWithData:data
                                                       encoding:NSASCIIStringEncoding];        
            cell.detailTextLabel.numberOfLines=3;
            cell.textLabel.text = @"PPI - Producer Price Index";
            cell.detailTextLabel.text = [self flattenHTMLForSubTitle:myString];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            
            
        }
        else if(indexPath.row==3)     {
            NSURL *url = [NSURL URLWithString:@"https://www.bls.gov/include/govdelivery/prod2.rss"];
            
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            cell.detailTextLabel.numberOfLines=3;
            cell.textLabel.text = @"PROD2 - Productivity and Costs";
            cell.detailTextLabel.text =[self flattenHTMLForSubTitle:myString];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            
            
            
        }
        else if(indexPath.row==4)
        {
            NSURL *url = [NSURL URLWithString:@"https://www.bls.gov/include/govdelivery/ximpim.rss"];
            
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            cell.detailTextLabel.numberOfLines=3;
            cell.textLabel.text = @"XIMPIM - U.S. Import and Export Price Indexes";
            cell.detailTextLabel.text = [self flattenHTMLForSubTitle:myString];;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            
        }
        }
           }
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"No Internet Connection"
                                                                       message:@"An Internet connection is required to access DOL News Releases. Please try again later."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } 
    else
    {
        
	
        switch (indexPath.section) {
            case 0:
            {
                DetailEtaNumberView    *detail=[[DetailEtaNumberView alloc]init];
                [self.navigationController pushViewController:detail animated:YES];

            }
                break;
            case 1:
                
            {            
            
                 
                    if(indexPath.row==0)
                    {
                        DOLNumbersAppDelegate *myAppDelegate =(DOLNumbersAppDelegate *) [[UIApplication sharedApplication] delegate];
                        
                        myAppDelegate.flag=0;
                        DetailNumberNewsView *detail=[[DetailNumberNewsView alloc]init];
                        [self.navigationController pushViewController:detail animated:YES];
                    }
                    else if(indexPath.row==1)
                    {
                        DOLNumbersAppDelegate *myAppDelegate =(DOLNumbersAppDelegate *) [[UIApplication sharedApplication] delegate];
                        
                        myAppDelegate.flag=1;
                        DetailNumberNewsView *detail=[[DetailNumberNewsView alloc]init];
                        [self.navigationController pushViewController:detail animated:YES];
                        
                    }
                    else if(indexPath.row==2)
                    {
                        DOLNumbersAppDelegate *myAppDelegate =(DOLNumbersAppDelegate *) [[UIApplication sharedApplication] delegate];
                        
                        myAppDelegate.flag=2;
                        
                        DetailNumberNewsView *detail=[[DetailNumberNewsView alloc]init];
                        [self.navigationController pushViewController:detail animated:YES];
                        
                        
                    }
                    else if(indexPath.row==3)
                    {
                        DOLNumbersAppDelegate *myAppDelegate =(DOLNumbersAppDelegate *) [[UIApplication sharedApplication] delegate];
                        
                        myAppDelegate.flag=3;
                        
                        DetailNumberNewsView *detail=[[DetailNumberNewsView alloc]init];
                        [self.navigationController pushViewController:detail animated:YES];
                        
                        
                        
                        
                    }
                    else if(indexPath.row==4)
                    {
                        DOLNumbersAppDelegate *myAppDelegate =(DOLNumbersAppDelegate *) [[UIApplication sharedApplication] delegate];
                        
                        myAppDelegate.flag=4;
                        
                        DetailNumberNewsView *detail=[[DetailNumberNewsView alloc]init];
                        [self.navigationController pushViewController:detail animated:YES];
                        
                        
                    }
                 
                }

                
                
            
        
            default:
                break;
                
                
                
        }
    }  
    
}


@end

