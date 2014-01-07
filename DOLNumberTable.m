//
//  DOLNumberTable.m
//  DOLNumbers
//
//



#import "DOLNumberTable.h"
#import "DetailNumberNewsView.h"
#import "Reachability.h"

@implementation DOLNumberTable

@synthesize blsNumbers, blsIndexes,  etaNumbers,etaIndexes, selectedArrayForBlsNumbers, selectedArrayForEtaNumbers,val;
@synthesize selectedImage, unselectedImage, inPseudoEditMode;
@synthesize dataRequest,arrayOfResults,displayweek,holderArray1,holderArray;

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
		UIAlertView *myAlert = [[UIAlertView alloc]
								initWithTitle:@"No Internet Connection" message:@"An Internet connection is required to access DOL Current Numbers. Please try again later."
								delegate:self
								cancelButtonTitle:@"Ok"
								otherButtonTitles:nil];
		[myAlert show];
	} 
    else
    {
        
        
        [self performSelectorOnMainThread:@selector(addLoadingScreen) withObject:nil waitUntilDone:NO];
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
          flag=0;
         day=0;
        finalDay1=0;
          [self ifNoValuesInETAArray];
        
        
        
        [self.tableView reloadData];
        [self removeLoadingScreen];
        
        
        
    }
   
    
}
-(void)closeAnimation{
    
    [spinner stopAnimating];
    [spinner removeFromSuperview];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    day=0;
    finalDay1=0;
    
}

-(void)saveToUserDefaultsEta:(NSMutableArray*)myArray{
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults){
        [standardUserDefaults setObject:myArray forKey:@"MyArrayeta"];
        [standardUserDefaults synchronize];
    }
    
}

-(NSMutableArray*)retrieveFromUserDefaultsEta{
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults){
        val = (NSMutableArray*)[standardUserDefaults arrayForKey:@"MyArrayeta"];
    }
    
    return val;
    
}


-(void)saveToUserDefaults:(NSMutableArray*)myArray{
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults){
        [standardUserDefaults setObject:myArray forKey:@"MyArray"];
        [standardUserDefaults synchronize];
    }
    
}

-(NSMutableArray*)retrieveFromUserDefaults{
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults){
        val = (NSMutableArray*)[standardUserDefaults arrayForKey:@"MyArray"];
    }
    

    return val;
    
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

- (void)dealloc
{
    
    
     ;
    
    
    
    
    
    
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

-(void)doneEditing{
    
     
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int myIntValue = [prefs integerForKey: @"intValueKey"];
    

    doneEditButton = [[UIBarButtonItem alloc]
                      initWithTitle:NSLocalizedString(@"Edit", @"")
                      style:UIBarButtonItemStyleDone
                      target:self
                      action:@selector(editOptions)];
    
    self.navigationItem.leftBarButtonItem = doneEditButton;
    
	NSMutableArray *rowsToBeDeletedInEta = [[NSMutableArray alloc] init];
    NSMutableArray *rowsToBeDeletedInBls = [[NSMutableArray alloc] init];
    NSMutableArray *indexPathsInEta = [[NSMutableArray alloc] init];
    NSMutableArray *indexPathsInBls = [[NSMutableArray alloc] init];


    int EtaIndex = 0;
    int BlsIndex = 0;
    int countbls=0;
    int counteta=0;

    
	for(int i=0; i<[self numberOfSectionsInTableView:self.tableView]; i++){
        if(i == 0){
            for (NSNumber *rowSelected in selectedArrayForEtaNumbers){
                if ([rowSelected boolValue]){
                    
                    [rowsToBeDeletedInEta addObject:[etaNumbers objectAtIndex:EtaIndex]];
                    NSUInteger pathSource[2] = {0, EtaIndex};
                    
                    NSIndexPath *path = [NSIndexPath indexPathWithIndexes:pathSource length:2];
                    path=[NSIndexPath indexPathForRow:EtaIndex inSection:0];
                    [indexPathsInEta addObject:path];
                    counteta++;
                }		
                EtaIndex++;
            }
            
                for (id value in rowsToBeDeletedInBls){
                    [etaNumbers removeObject:value];
                }
                
                
                
          
               holderArray1 = [self retrieveFromUserDefaultsEta];
                
                
                if([holderArray1 count] > 0){
                    [etaNumbers removeAllObjects];
                    [etaNumbers addObjectsFromArray:holderArray1];
                }
                else
                {
                   
                }
            
            
            
            [self populateSelectedArrayForEta];
            [self saveToUserDefaultsEta:etaNumbers];
            inPseudoEditMode = NO;
            [self.tableView reloadData];
            
        } else {
            for (NSNumber *rowSelected in selectedArrayForBlsNumbers)
            {
                if ([rowSelected boolValue])
                {
                    
                    [rowsToBeDeletedInBls addObject:[blsNumbers objectAtIndex:BlsIndex]];
                    NSUInteger pathSource[2] = {0, BlsIndex};
                    NSIndexPath *path = [NSIndexPath indexPathWithIndexes:pathSource length:2];
                    path=[NSIndexPath indexPathForRow:BlsIndex inSection:1];
                    countbls++;
                    [indexPathsInBls addObject:path];
                }		
                BlsIndex++;
            }
            
            if([rowsToBeDeletedInBls count] != [blsNumbers count]){
                for (id value in rowsToBeDeletedInBls){
                    [blsNumbers removeObject:value];
                }
                
                [self.tableView  deleteRowsAtIndexPaths:indexPathsInBls withRowAnimation:UITableViewRowAnimationFade];
            } else {
                holderArray = [self retrieveFromUserDefaults];
                
                                
                
                if([holderArray count] > 0){
                    [blsNumbers removeAllObjects];
                    [blsNumbers addObjectsFromArray:holderArray];
                }
                
            }
            
            
            
            
            [self populateSelectedArrayForBls];
            inPseudoEditMode = NO;
            [self saveToUserDefaults:blsNumbers];
            
            
             numberOfSections=myIntValue;
            [self.tableView reloadData];
            
 
        }
        
        
    }
    if(countbls==9 && counteta!=1)
    {
        
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setInteger:1 forKey: @"intValueKey"];
        [prefs synchronize];
        
        
        

        numberOfSections=1;
        [self.tableView reloadData];

        
        
    }
    else if(countbls!=9 && counteta==1)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setInteger:2 forKey: @"intValueKey"];
        [prefs synchronize];
       
        numberOfSections=2;
        [self.tableView reloadData];

        
    }
    else if(countbls==9 && counteta==1)
    {

    }
    else if(countbls!=9 && counteta!=1)
    {
        numberOfSections=0;
        [self.tableView reloadData];
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs setInteger:0 forKey: @"intValueKey"];
                [prefs synchronize];
    }
    accesbilityflag=0;
 
    
}
+ (NSDate*)dateFromUnixDate:(double)unixdate 
{
    NSTimeInterval unixDate = unixdate / 1000.0;
    return [NSDate dateWithTimeIntervalSince1970:unixDate];
}

-(void)editOptions{
    numberOfSections=0;
    accesbilityflag=1;
    [self.tableView reloadData];
    doneEditButton= [[UIBarButtonItem alloc]
                     initWithTitle:NSLocalizedString(@"Done", @"")
                     style:UIBarButtonItemStyleDone
                     target:self
                     action:@selector(doneEditing)];
    
    self.navigationItem.leftBarButtonItem = doneEditButton;
    inPseudoEditMode = YES;
    
    self.blsNumbers = [NSMutableArray arrayWithObjects:@"Consumer Price Index (CPI):",@"Unemployment Rate:",@"Payroll Employment:",@"Average Hourly Earnings:",@"Producer Price Index (PPI):",@"Employment Cost Index (ECI):", @"Productivity:",@"U.S. Import Price Index:",@"U.S. Export Price Index:",nil]; 
    
    self.etaNumbers = [NSMutableArray arrayWithObjects:@"Unemployment Insurance Initial Claims",nil];
    
    [self populateSelectedArrayForBls];
    [self populateSelectedArrayForEta];
    
	[self.tableView reloadData];
}

-(void)populateSelectedArrayForBls {
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[blsNumbers count]];
	for (int i=0; i < [blsNumbers count]; i++){
		[array addObject:[NSNumber numberWithBool:YES]];
    }
	self.selectedArrayForBlsNumbers = array;
    
}

- (void)populateSelectedArrayForEta{
    
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[etaNumbers count]];
	for (int i=0; i < [etaNumbers count]; i++){
		[array addObject:[NSNumber numberWithBool:YES]];
    }
	self.selectedArrayForEtaNumbers = array;
}



-(void)ifNoValuesInETAArray
{

    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDate *date = [NSDate date];
    NSDateComponents *comps = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
                                     fromDate:date];
    NSDate *today = [cal dateFromComponents:comps];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    if (finalDay1==0) {
        [components setDay:day];
        self.navigationItem.rightBarButtonItem.enabled = NO;


    }
    else
    {
    [components setDay:finalDay1];
    }
    NSDate *yesterday = [cal dateByAddingComponents:components toDate:today options:0];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    [df setDateFormat:@" dd MMMM, yyyy"];
    NSString *currentweek = [dateFormatter stringFromDate:yesterday];
    
    NSDictionary *arguments = [NSDictionary dictionaryWithObject: [NSString stringWithFormat:@"week eq datetime'%@T00:00:00'",currentweek] forKey:@"filter"];
    
    [dataRequest callAPIMethod:@"Statistics/OUI_InitialClaims/unemploymentInsuranceInitialClaims" withArguments:arguments andTimeOut:60];
    
    
}
-(void)ifNoValuesInCpiArray
{
    NSDictionary *arguments = [NSDictionary dictionaryWithObject: [NSString stringWithFormat:@"(year eq %i)and (period eq %i)",year,month] forKey:@"filter"];
    
    [dataRequest callAPIMethod:@"statistics/BLS_Numbers/consumerPriceIndex1MonthChange" withArguments:arguments andTimeOut:60];
    
}

-(void)ifNoValuesInURArray
{
    NSDictionary *arguments = [NSDictionary dictionaryWithObject: [NSString stringWithFormat:@"(year eq %i)and (period eq %i)",year,month] forKey:@"filter"];
    
    [dataRequest callAPIMethod:@"statistics/BLS_Numbers/unemploymentRate" withArguments:arguments andTimeOut:60];
    
    
}
-(void)ifNoValuesInPEArray
{
    NSDictionary *arguments = [NSDictionary dictionaryWithObject: [NSString stringWithFormat:@"(year eq %i)and (period eq %i)",year,month] forKey:@"filter"];
    
    [dataRequest callAPIMethod:@"statistics/BLS_Numbers/payrollEmployment1MonthNetChange" withArguments:arguments andTimeOut:60];
    
    
}
-(void)ifNoValuesInAHEArray
{
    NSDictionary *arguments = [NSDictionary dictionaryWithObject: [NSString stringWithFormat:@"(year eq %i)and (period eq %i)",year,month] forKey:@"filter"];
    
    [dataRequest callAPIMethod:@"statistics/BLS_Numbers/averageHourlyEarnings1MonthNetChange" withArguments:arguments andTimeOut:60];
    
    
}
-(void)ifNoValuesInPPIArray
{
    NSDictionary *arguments = [NSDictionary dictionaryWithObject: [NSString stringWithFormat:@"(year eq %i)and (period eq %i)",year,month] forKey:@"filter"];
    
    [dataRequest callAPIMethod:@"statistics/BLS_Numbers/producerPriceIndex1MonthChange" withArguments:arguments andTimeOut:60];
    
    
}
-(void)ifNoValuesInUSIArray
{
    NSDictionary *arguments = [NSDictionary dictionaryWithObject: [NSString stringWithFormat:@"(year eq %i)and (period eq %i)",year,month] forKey:@"filter"];
    
    [dataRequest callAPIMethod:@"statistics/BLS_Numbers/importPriceIndex1MonthChange" withArguments:arguments andTimeOut:60];
    
    
}
-(void)ifNoValuesInUSEArray
{
    NSDictionary *arguments = [NSDictionary dictionaryWithObject: [NSString stringWithFormat:@"(year eq %i)and (period eq %i)",year,month] forKey:@"filter"];
    
    [dataRequest callAPIMethod:@"statistics/BLS_Numbers/exportPriceIndex1MonthChange" withArguments:arguments andTimeOut:60];
    
    
}
-(void)ifNoValuesInECIQtrArray
{
    
    NSDictionary *arguments = [NSDictionary dictionaryWithObject: [NSString stringWithFormat:@"(year eq %i)and (period eq %i)",year,qtr] forKey:@"filter"];
    
    [dataRequest callAPIMethod:@"statistics/BLS_Numbers/employmentCostIndex" withArguments:arguments andTimeOut:60];
    
}
-(void)ifNoValuesInPROQtrArray
{


    NSString *qtrString=[NSString stringWithFormat:@"Q0%i",qtr];
    self.navigationItem.rightBarButtonItem.enabled =YES;

    NSDictionary *arguments = [NSDictionary dictionaryWithObject: [NSString stringWithFormat:@"(year eq %i)and (period eq '%@')",year,qtrString] forKey:@"filter"];
    
    [dataRequest callAPIMethod:@"statistics/BLS_Numbers/productivity" withArguments:arguments andTimeOut:60];
}

//code ends
#pragma mark - View lifecycle

- (NSDate*) getDateFromJSON:(NSString *)dateString
{
    int startPos = [dateString rangeOfString:@"("].location+1;
    int endPos = [dateString rangeOfString:@")"].location;
    NSRange range = NSMakeRange(startPos,endPos-startPos);
    unsigned long long milliseconds = [[dateString substringWithRange:range] longLongValue];
    NSTimeInterval interval = milliseconds/1000;
    return [NSDate dateWithTimeIntervalSince1970:interval];
}
- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    
    finalDay1=0;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int myIntValue = [prefs integerForKey: @"intValueKey"];
    numberOfSections=myIntValue;
    blsNumbers = [self retrieveFromUserDefaults];
    etaNumbers=[self retrieveFromUserDefaultsEta];
    
    if ([blsNumbers count]==0) {
         self.blsNumbers = [NSMutableArray arrayWithObjects:@"Consumer Price Index (CPI):",@"Unemployment Rate:",@"Payroll Employment:",@"Average Hourly Earnings:",@"Producer Price Index (PPI):",@"Employment Cost Index (ECI):", @"Productivity:",@"U.S. Import Price Index:",@"U.S. Export Price Index:",nil]; 
    }
    
    
    self.blsIndexes = [NSMutableArray arrayWithObjects:nil];
    
    if ([etaNumbers count]==0) {
         self.etaNumbers = [NSMutableArray arrayWithObjects:@"Unemployment Insurance Initial Claims",nil];
    }
    
    self.etaNumbers = [NSMutableArray arrayWithObjects:@"Unemployment Insurance Initial Claims",nil];
    self.etaIndexes = [NSMutableArray arrayWithObjects:@"398,000 in the week ending July 23,2011",nil];
    
    
	self.inPseudoEditMode = NO;
    
    flag=0;
    self.selectedImage = [UIImage imageNamed:@"selected.png"];
	self.unselectedImage = [UIImage imageNamed:@"unselected.png"];
    
    [self populateSelectedArrayForBls];
    [self populateSelectedArrayForEta];
    
    doneEditButton = [[UIBarButtonItem alloc]
                      initWithTitle:NSLocalizedString(@"Edit", @"")
                      style:UIBarButtonItemStyleDone
                      target:self
                      action:@selector(editOptions)];
    self.navigationItem.leftBarButtonItem = doneEditButton;
    
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy"];
    year = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    
    [dateFormatter setDateFormat:@"MM"];
    month = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    
    qtr=4;
    day=0;

    
    
    self.title = @"Current Numbers";
    
    //Create Context object
    //This object will store the URL and authorization information
    GOVDataContext *context = [[GOVDataContext alloc] initWithAPIKey:API_KEY Host:API_HOST SharedSecret:API_SECRET APIURL:API_URL];
    
    //Instantiate a new request
    dataRequest = [[GOVDataRequest alloc]initWithContext:context];
    //Set self as delegate
    dataRequest.delegate = self;
    
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
	{
		UIAlertView *myAlert = [[UIAlertView alloc]
								initWithTitle:@"No Internet Connection" message:@"An Internet connection is required to access DOL Current Numbers. Please try again later."
								delegate:self
								cancelButtonTitle:@"Ok"
								otherButtonTitles:nil];
		[myAlert show];
	} 
    else
    {
        
        [self performSelectorOnMainThread:@selector(addLoadingScreen) withObject:nil waitUntilDone:NO];
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        [self ifNoValuesInETAArray];
        
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
    
    
    if (numberOfSections==2) {
        
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 17, 61, 21)];
        label1=[[UILabel alloc]initWithFrame:CGRectMake(60, -0, 300 , 60)];
        label1.numberOfLines=2;
        label1.backgroundColor=[UIColor clearColor];
        view.backgroundColor=[UIColor clearColor];
        
        label1=[[UILabel alloc]initWithFrame:CGRectMake(60, -0, 300 , 60)];
        label1.backgroundColor=[UIColor clearColor];
        imgView.image = [UIImage imageNamed:@"bls.png"];
        label1.text=@"    Bureau of Labor Statistics";
        label1.isAccessibilityElement = YES;
        label1.accessibilityTraits = UIAccessibilityTraitImage;
        label1.accessibilityLabel = NSLocalizedString(@"Bureau of Labor Statistics heading",@"Employment and Training Administration");

        
    }
    else
    {
   
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
           // label1.accessibilityTraits = UIAccessibilityTraitImage;
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
    
    
    }
    
    
    [view addSubview:imgView];
    [view addSubview:label1];
    
    return view;
    
    
    
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (numberOfSections==1) {
        
  
        
        return 1;

    }
    else if(numberOfSections==2)
    {

        return 1;

    }
        
    else 
        
    {
    return 2;
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(numberOfSections==2)
    {
        return [blsNumbers count];
        
    }
    else
    {
      
    if(section==0){
        return [etaNumbers count];
    }
    
    else
    {
        return [blsNumbers count];
    }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        
        label = [[UILabel alloc] initWithFrame:kLabelRect];
		label.tag = kCellLabelTag;
		[cell.contentView addSubview:label];	
        cell.detailTextLabel.backgroundColor=[UIColor clearColor];
		
		imageView = [[UIImageView alloc] initWithImage:unselectedImage];
		imageView.frame = CGRectMake(5.0, 6.0, 23.0, 23.0);
		[cell.contentView addSubview:imageView];
		imageView.hidden = !inPseudoEditMode;
		imageView.tag = kCellImageViewTag;
    }
    
    
    
    if(numberOfSections==2)
    {
        [UIView beginAnimations:@"cell shift" context:nil];
        label = (UILabel *)[cell.contentView viewWithTag:kCellLabelTag];
        
        label.text =  [blsNumbers objectAtIndex:indexPath.row];
        cell.detailTextLabel.numberOfLines=2;
        
        
        label.frame = (inPseudoEditMode) ? kLabelIndentedRect : kLabelRect;
        label.opaque = NO;
        imageView = (UIImageView *)[cell.contentView viewWithTag:kCellImageViewTag];
        
        NSNumber *selected = [selectedArrayForBlsNumbers objectAtIndex:[indexPath row]];
        imageView.image = ([selected boolValue]) ?  unselectedImage:selectedImage;
        imageView.hidden = !inPseudoEditMode;
        [UIView commitAnimations];
        
        
        
        if ([[blsNumbers objectAtIndex:indexPath.row] isEqual:@"Consumer Price Index (CPI):"])
        {
            
                        
            
            NSString *year1=[NSString stringWithFormat:@"%@", (NSString *)[cpiresult objectForKey:@"year"]];
            NSString *period=[NSString stringWithFormat:@"%@", (NSString *)[cpiresult objectForKey:@"period"]];
            
            NSString *type=[NSString stringWithFormat:@"%@", (NSString *)[cpiresult objectForKey:@"type"]] ;
            NSString *value=[NSString stringWithFormat:@"%@", (NSString *)[cpiresult objectForKey:@"value"]];
            
            
            NSString *finalStr;
            float stringFloat = [value floatValue];
            
            int periodValue= [period intValue];
            NSString *originalmonth;
            
            switch (periodValue) {
                case 1:
                    originalmonth=@"Jan";
                    break;
                case 2:
                    originalmonth=@"Feb";
                    break;
                case 3:
                    originalmonth=@"Mar";
                    break;
                case 4:
                    originalmonth=@"Apr";
                    break;
                case 5:
                    originalmonth=@"May";
                    break;
                case 6:
                    originalmonth=@"Jun";
                    break;
                case 7:
                    originalmonth=@"Jul";
                    break;
                case 8:
                    originalmonth=@"Aug";
                    break;
                case 9:
                    originalmonth=@"Sep";
                    break;
                case 10:
                    originalmonth=@"Oct";
                    break;
                case 11:
                    originalmonth=@"Nov";
                    break;
                case 12:
                    originalmonth=@"Dec";
                    break;
                    
                default:
                    originalmonth=@"month";
                    break;
            }
            
            
            
            if(![type isEqual:@"F"])
            {
                if(stringFloat>=0)
                {
                    finalStr=[NSString stringWithFormat:@"+%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                    
                }
                else
                {
                    finalStr=[NSString stringWithFormat:@"%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                }
                
            }
            else
            {
                if(stringFloat>=0)
                {
                    finalStr =[NSString stringWithFormat:@"+%g%% in %@ %@",stringFloat,originalmonth,year1];
                    
                }
                else
                {
                    finalStr =[NSString stringWithFormat:@"%g%% in %@ %@",stringFloat,originalmonth,year1];
                }                
            }
            if ([value isEqualToString:@"(null)"]) {
                cell.detailTextLabel.text=@"                                                                       Unable to load the data";
            }
            else
            {
                cell.detailTextLabel.text=[NSString stringWithFormat:@"                                                                                        %@",finalStr] ;
            }
            
            NSString *accStr=[NSString stringWithFormat:@"%@  %@", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
            cell.accessibilityLabel = NSLocalizedString(accStr,);
            
        }
        else if ([[blsNumbers objectAtIndex:indexPath.row] isEqual:@"Unemployment Rate:"] )
        {
            
            NSString *year1=[NSString stringWithFormat:@"%@", (NSString *)[urresult objectForKey:@"year"]];
            NSString *period=[NSString stringWithFormat:@"%@", (NSString *)[urresult objectForKey:@"period"]];
            
            NSString *type=[NSString stringWithFormat:@"%@", (NSString *)[urresult objectForKey:@"type"]] ;
            NSString *value=[NSString stringWithFormat:@"%@%%", (NSString *)[urresult objectForKey:@"value"]];
            NSString *finalStr;
            int periodValue= [period intValue];
            NSString *originalmonth;
            
            if ([value isEqual:@"(null)%"]) {
                cell.detailTextLabel.text=@"                                                                       Unable to load the data";
            }
            else
            {
                float stringFloat = [value floatValue];
                
                
                switch (periodValue) {
                    case 1:
                        originalmonth=@"Jan";
                        break;
                    case 2:
                        originalmonth=@"Feb";
                        break;
                    case 3:
                        originalmonth=@"Mar";
                        break;
                    case 4:
                        originalmonth=@"Apr";
                        break;
                    case 5:
                        originalmonth=@"May";
                        break;
                    case 6:
                        originalmonth=@"Jun";
                        break;
                    case 7:
                        originalmonth=@"Jul";
                        break;
                    case 8:
                        originalmonth=@"Aug";
                        break;
                    case 9:
                        originalmonth=@"Sep";
                        break;
                    case 10:
                        originalmonth=@"Oct";
                        break;
                    case 11:
                        originalmonth=@"Nov";
                        break;
                    case 12:
                        originalmonth=@"Dec";
                        break;
                        
                    default:
                        originalmonth=@"month";
                        break;
                }
                
                
                if(![type isEqual:@"F"])
                {
                    if(stringFloat>=0)
                    {
                        finalStr=[NSString stringWithFormat:@"%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                        
                    }
                    else
                    {
                        finalStr=[NSString stringWithFormat:@"%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                    }
                    
                }
                else
                {
                    if(stringFloat>=0)
                    {
                        finalStr =[NSString stringWithFormat:@"%g%% in %@ %@",stringFloat,originalmonth,year1];
                        
                    }
                    else
                    {
                        finalStr =[NSString stringWithFormat:@"%g%% in %@ %@",stringFloat,originalmonth,year1];
                    }                    
                }
                
                
                cell.detailTextLabel.text=[NSString stringWithFormat:@"                                                                                        %@",finalStr] ;
                NSString *accStr=[NSString stringWithFormat:@"%@  %@", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                cell.accessibilityLabel = NSLocalizedString(accStr,);
            }
            
        }
        else if ([[blsNumbers objectAtIndex:indexPath.row] isEqual:@"Payroll Employment:"])
        {
            
            NSString *year1=[NSString stringWithFormat:@"%@", (NSString *)[peresult objectForKey:@"year"]];
            NSString *period=[NSString stringWithFormat:@"%@", (NSString *)[peresult objectForKey:@"period"]];
            
            NSString *type=[NSString stringWithFormat:@"%@", (NSString *)[peresult objectForKey:@"type"]] ;
            NSString *value=[NSString stringWithFormat:@"%@", (NSString *)[peresult objectForKey:@"value"]];
            NSString *finalStr;
            
            
            
            float finalValue= [value floatValue];
            
            int periodValue= [period intValue];
            NSString *originalmonth;
            
            switch (periodValue) {
                case 1:
                    originalmonth=@"Jan";
                    break;
                case 2:
                    originalmonth=@"Feb";
                    break;
                case 3:
                    originalmonth=@"Mar";
                    break;
                case 4:
                    originalmonth=@"Apr";
                    break;
                case 5:
                    originalmonth=@"May";
                    break;
                case 6:
                    originalmonth=@"Jun";
                    break;
                case 7:
                    originalmonth=@"Jul";
                    break;
                case 8:
                    originalmonth=@"Aug";
                    break;
                case 9:
                    originalmonth=@"Sep";
                    break;
                case 10:
                    originalmonth=@"Oct";
                    break;
                case 11:
                    originalmonth=@"Nov";
                    break;
                case 12:
                    originalmonth=@"Dec";
                    break;
                    
                default:
                    originalmonth=@"month";
                    break;
            }
            
            if(![type isEqual:@"F"])
            {
                if(finalValue>=0)
                {
                    finalStr=[NSString stringWithFormat:@"+%g,000(%@) in %@ %@",finalValue,type,originalmonth,year1];
                    
                }
                else
                {
                    finalStr=[NSString stringWithFormat:@"%g,000(%@) in %@ %@",finalValue,type,originalmonth,year1];
                }
                
            }
            else
            {
                if(finalValue>=0)
                {
                    finalStr =[NSString stringWithFormat:@"+%g,000 in %@ %@",finalValue,originalmonth,year1];
                    
                }
                else
                {
                    finalStr =[NSString stringWithFormat:@"%g,000 in %@ %@",finalValue,originalmonth,year1];
                }                    
            }
            if ([value isEqualToString:@"(null)"]) {
                cell.detailTextLabel.text=@"                                                                       Unable to load the data";
            }
            else
            {
                cell.detailTextLabel.text=[NSString stringWithFormat:@"                                                                                        %@",finalStr] ;
            }
            NSString *accStr=[NSString stringWithFormat:@"%@  %@", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
            cell.accessibilityLabel = NSLocalizedString(accStr,);
            
            
        }
        else if ([[blsNumbers objectAtIndex:indexPath.row] isEqual:@"Average Hourly Earnings:"])
        {
            
            NSString *year1=[NSString stringWithFormat:@"%@", (NSString *)[aheresult objectForKey:@"year"]];
            NSString *period=[NSString stringWithFormat:@"%@", (NSString *)[aheresult objectForKey:@"period"]];
            
            NSString *type=[NSString stringWithFormat:@"%@", (NSString *)[aheresult objectForKey:@"type"]] ;
            NSString *value=[NSString stringWithFormat:@"%@", (NSString *)[aheresult objectForKey:@"value"]];
            NSString *finalStr;
            int periodValue= [period intValue];
            NSString *originalmonth;
            float stringFloat = [value floatValue];
            
            
            switch (periodValue) {
                case 1:
                    originalmonth=@"Jan";
                    break;
                case 2:
                    originalmonth=@"Feb";
                    break;
                case 3:
                    originalmonth=@"Mar";
                    break;
                case 4:
                    originalmonth=@"Apr";
                    break;
                case 5:
                    originalmonth=@"May";
                    break;
                case 6:
                    originalmonth=@"Jun";
                    break;
                case 7:
                    originalmonth=@"Jul";
                    break;
                case 8:
                    originalmonth=@"Aug";
                    break;
                case 9:
                    originalmonth=@"Sep";
                    break;
                case 10:
                    originalmonth=@"Oct";
                    break;
                case 11:
                    originalmonth=@"Nov";
                    break;
                case 12:
                    originalmonth=@"Dec";
                    break;
                    
                default:
                    originalmonth=@"month";
                    break;
            }
            
            
            if(![type isEqual:@"F"])
            {
                if(stringFloat>=0)
                {
                    finalStr=[NSString stringWithFormat:@"+$%.02f(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                    
                }
                else
                {
                    finalStr=[NSString stringWithFormat:@"$%.02f(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                }               
            }
            else
            {
                if(stringFloat>=0)
                {
                    finalStr =[NSString stringWithFormat:@"+$%.02f in %@ %@",stringFloat,originalmonth,year1];
                    
                }
                else
                {
                    finalStr =[NSString stringWithFormat:@"$%.02f in %@ %@",stringFloat,originalmonth,year1];
                }                
            }
            if ([value isEqualToString:@"(null)"]) {
                cell.detailTextLabel.text=@"                                                                       Unable to load the data";
            }
            else
            {
                cell.detailTextLabel.text=[NSString stringWithFormat:@"                                                                                        %@",finalStr] ;
            }
            NSString *accStr=[NSString stringWithFormat:@"%@  %@", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
            cell.accessibilityLabel = NSLocalizedString(accStr,);
        }    
        else if ([[blsNumbers objectAtIndex:indexPath.row] isEqual:@"Producer Price Index (PPI):"])
        {
            
            NSString *year1=[NSString stringWithFormat:@"%@", (NSString *)[ppiresult objectForKey:@"year"]];
            NSString *period=[NSString stringWithFormat:@"%@", (NSString *)[ppiresult objectForKey:@"period"]];
            
            NSString *type=[NSString stringWithFormat:@"%@", (NSString *)[ppiresult objectForKey:@"type"]] ;
            NSString *value=[NSString stringWithFormat:@"%@%%", (NSString *)[ppiresult objectForKey:@"value"]];
            NSString *finalStr;
            float stringFloat = [value floatValue];
            
            
            int periodValue= [period intValue];
            NSString *originalmonth;
            
            switch (periodValue) {
                case 1:
                    originalmonth=@"Jan";
                    break;
                case 2:
                    originalmonth=@"Feb";
                    break;
                case 3:
                    originalmonth=@"Mar";
                    break;
                case 4:
                    originalmonth=@"Apr";
                    break;
                case 5:
                    originalmonth=@"May";
                    break;
                case 6:
                    originalmonth=@"Jun";
                    break;
                case 7:
                    originalmonth=@"Jul";
                    break;
                case 8:
                    originalmonth=@"Aug";
                    break;
                case 9:
                    originalmonth=@"Sep";
                    break;
                case 10:
                    originalmonth=@"Oct";
                    break;
                case 11:
                    originalmonth=@"Nov";
                    break;
                case 12:
                    originalmonth=@"Dec";
                    break;
                    
                default:
                    originalmonth=@"month";
                    break;
            }
            
            if(![type isEqual:@"F"])
            {
                if(stringFloat>=0)
                {
                    finalStr=[NSString stringWithFormat:@"+%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                    
                }
                else
                {
                    finalStr=[NSString stringWithFormat:@"%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                }               
            }
            else
            {
                if(stringFloat>=0)
                {
                    finalStr =[NSString stringWithFormat:@"+%g%% in %@ %@",stringFloat,originalmonth,year1];
                    
                }
                else
                {
                    finalStr =[NSString stringWithFormat:@"%g%% in %@ %@",stringFloat,originalmonth,year1];
                }                
            }
            if ([value isEqualToString:@"(null)%"]) {
                cell.detailTextLabel.text=@"                                                                       Unable to load the data";
            }
            else
            {
                cell.detailTextLabel.text=[NSString stringWithFormat:@"                                                                                        %@",finalStr] ;
            }
            NSString *accStr=[NSString stringWithFormat:@"%@  %@", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
            cell.accessibilityLabel = NSLocalizedString(accStr,);            
        }
        else if ([[blsNumbers objectAtIndex:indexPath.row] isEqual:@"Employment Cost Index (ECI):"])
        {
            
            NSString *year1=[NSString stringWithFormat:@"%@", (NSString *)[eciresult objectForKey:@"year"]];
            NSString *period=[NSString stringWithFormat:@"%@", (NSString *)[eciresult objectForKey:@"period"]];
            
            NSString *type=[NSString stringWithFormat:@"%@", (NSString *)[eciresult objectForKey:@"type"]] ;
            NSString *value=[NSString stringWithFormat:@"%@%%", (NSString *)[eciresult objectForKey:@"value"]];
            NSString *finalStr;
            int periodValue= [period intValue];
            NSString *originalmonth;
            float stringFloat = [value floatValue];
            
            switch (periodValue) {
                case 1:
                    originalmonth=@"1st Qtr of";
                    break;
                case 2:
                    originalmonth=@"2nd Qtr of";
                    break;
                case 3:
                    originalmonth=@"3rd Qtr of";
                    break;
                case 4:
                    originalmonth=@"4th Qtr of";
                    break;
                    
                    
                default:
                    originalmonth=@"month";
                    break;
            }
            
            
            if(![type isEqual:@"F"])
            {
                if(stringFloat>=0)
                {
                    finalStr=[NSString stringWithFormat:@"+%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                    
                }
                else
                {
                    finalStr=[NSString stringWithFormat:@"%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                }                
            }
            else
            {
                if(stringFloat>=0)
                {
                    finalStr =[NSString stringWithFormat:@"+%g%% in %@ %@",stringFloat,originalmonth,year1];
                    
                }
                else
                {
                    finalStr =[NSString stringWithFormat:@"%g%% in %@ %@",stringFloat,originalmonth,year1];
                }                
            }
            if ([value isEqualToString:@"(null)%"]) {
                cell.detailTextLabel.text=@"                                                                       Unable to load the data";
            }
            else
            {
                cell.detailTextLabel.text=[NSString stringWithFormat:@"                                                                                        %@",finalStr] ;
            }
            NSString *accStr=[NSString stringWithFormat:@"%@  %@", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
            cell.accessibilityLabel = NSLocalizedString(accStr,);
            
        }
        else if ([[blsNumbers objectAtIndex:indexPath.row] isEqual:@"Productivity:"])
        {
            
            NSString *year1=[NSString stringWithFormat:@"%@", (NSString *)[proresult objectForKey:@"year"]];
            NSString *period=[NSString stringWithFormat:@"%@", (NSString *)[proresult objectForKey:@"period"]];
            
            NSString *type=[NSString stringWithFormat:@"%@", (NSString *)[proresult objectForKey:@"type"]] ;
            NSString *value=[NSString stringWithFormat:@"%@%%", (NSString *)[proresult objectForKey:@"value"]];
            NSString *finalStr;
            NSString *originalmonth;
            float stringFloat = [value floatValue];
            
            
            if([period isEqual:@"Q01"])
            {
                originalmonth=@"1st Qtr of";
                
            }
            else  if([period isEqual:@"Q02"])
            {
                originalmonth=@"2nd Qtr of";
                
                
            }
            else if([period isEqual:@"Q03"])
            {
                originalmonth=@"3rd Qtr of";
            }
            else if([period isEqual:@"Q04"])
            {
                originalmonth=@"4th Qtr of";
            }
            else
            {
                originalmonth=@"nothing";
                
            }
            
            if(![type isEqual:@"F"])
            {
                if(stringFloat>=0)
                {
                    finalStr=[NSString stringWithFormat:@"+%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                    
                }
                else
                {
                    finalStr=[NSString stringWithFormat:@"%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                }                
            }
            else
            {
                if(stringFloat>=0)
                {
                    finalStr =[NSString stringWithFormat:@"+%g%% in %@ %@",stringFloat,originalmonth,year1];
                    
                }
                else
                {
                    finalStr =[NSString stringWithFormat:@"%g%% in %@ %@",stringFloat,originalmonth,year1];
                }                
            }
            if ([value isEqualToString:@"(null)%"]) {
                cell.detailTextLabel.text=@"                                                                       Unable to load the data";
            }
            else
            {
                cell.detailTextLabel.text=[NSString stringWithFormat:@"                                                                                        %@",finalStr] ;
            }
            
            NSString *accStr=[NSString stringWithFormat:@"%@  %@", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
            cell.accessibilityLabel = NSLocalizedString(accStr,);
        }
        else if ([[blsNumbers objectAtIndex:indexPath.row] isEqual:@"U.S. Import Price Index:"])
        {
            
            NSString *year1=[NSString stringWithFormat:@"%@", (NSString *)[usiresult objectForKey:@"year"]];
            NSString *period=[NSString stringWithFormat:@"%@", (NSString *)[usiresult objectForKey:@"period"]];
            
            NSString *type=[NSString stringWithFormat:@"%@", (NSString *)[usiresult objectForKey:@"type"]] ;
            NSString *value=[NSString stringWithFormat:@"%@%%", (NSString *)[usiresult objectForKey:@"value"]];
            NSString *finalStr;
            int periodValue= [period intValue];
            NSString *originalmonth;
            float stringFloat = [value floatValue];
            
            switch (periodValue) {
                case 1:
                    originalmonth=@"Jan";
                    break;
                case 2:
                    originalmonth=@"Feb";
                    break;
                case 3:
                    originalmonth=@"Mar";
                    break;
                case 4:
                    originalmonth=@"Apr";
                    break;
                case 5:
                    originalmonth=@"May";
                    break;
                case 6:
                    originalmonth=@"Jun";
                    break;
                case 7:
                    originalmonth=@"Jul";
                    break;
                case 8:
                    originalmonth=@"Aug";
                    break;
                case 9:
                    originalmonth=@"Sep";
                    break;
                case 10:
                    originalmonth=@"Oct";
                    break;
                case 11:
                    originalmonth=@"Nov";
                    break;
                case 12:
                    originalmonth=@"Dec";
                    break;
                    
                default:
                    originalmonth=@"month";
                    break;
            }
            
            
            if(![type isEqual:@"F"])
            {
                if(stringFloat>=0)
                {
                    finalStr=[NSString stringWithFormat:@"+%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                    
                }
                else
                {
                    finalStr=[NSString stringWithFormat:@"%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                }                
            }
            else
            {
                if(stringFloat>=0)
                {
                    finalStr =[NSString stringWithFormat:@"+%g%% in %@ %@",stringFloat,originalmonth,year1];
                    
                }
                else
                {
                    finalStr =[NSString stringWithFormat:@"%g%% in %@ %@",stringFloat,originalmonth,year1];
                }                
            }
            if ([value isEqualToString:@"(null)%"]) {
                cell.detailTextLabel.text=@"                                                                       Unable to load the data";
            }
            else
            {
                cell.detailTextLabel.text=[NSString stringWithFormat:@"                                                                                        %@",finalStr] ;
            }
            NSString *accStr=[NSString stringWithFormat:@"%@  %@", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
            cell.accessibilityLabel = NSLocalizedString(accStr,);
            
        }
        else if ([[blsNumbers objectAtIndex:indexPath.row] isEqual:@"U.S. Export Price Index:"])
        {
            
            NSString *year1=[NSString stringWithFormat:@"%@", (NSString *)[useresult objectForKey:@"year"]];
            NSString *period=[NSString stringWithFormat:@"%@", (NSString *)[useresult objectForKey:@"period"]];
            
            NSString *type=[NSString stringWithFormat:@"%@", (NSString *)[useresult objectForKey:@"type"]] ;
            NSString *value=[NSString stringWithFormat:@"%@%%", (NSString *)[useresult objectForKey:@"value"]];
            NSString *finalStr;
            int periodValue= [period intValue];
            NSString *originalmonth;
            float stringFloat = [value floatValue];
            
            
            switch (periodValue) {
                case 1:
                    originalmonth=@"Jan";
                    break;
                case 2:
                    originalmonth=@"Feb";
                    break;
                case 3:
                    originalmonth=@"Mar";
                    break;
                case 4:
                    originalmonth=@"Apr";
                    break;
                case 5:
                    originalmonth=@"May";
                    break;
                case 6:
                    originalmonth=@"Jun";
                    break;
                case 7:
                    originalmonth=@"Jul";
                    break;
                case 8:
                    originalmonth=@"Aug";
                    break;
                case 9:
                    originalmonth=@"Sep";
                    break;
                case 10:
                    originalmonth=@"Oct";
                    break;
                case 11:
                    originalmonth=@"Nov";
                    break;
                case 12:
                    originalmonth=@"Dec";
                    break;
                    
                default:
                    originalmonth=@"month";
                    break;
            }
            
            if(![type isEqual:@"F"])
            {
                if(stringFloat>=0)
                {
                    finalStr=[NSString stringWithFormat:@"+%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                    
                }
                else
                {
                    finalStr=[NSString stringWithFormat:@"%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                }              
            }
            else
            {   
                if(stringFloat>=0)
                {
                    finalStr =[NSString stringWithFormat:@"+%g%% in %@ %@",stringFloat,originalmonth,year1];
                    
                }
                else
                {
                finalStr =[NSString stringWithFormat:@"%g%% in %@ %@",stringFloat,originalmonth,year1];
                }
                
            }
            if ([value isEqualToString:@"(null)%"]) {
                cell.detailTextLabel.text=@"                                                                       Unable to load the data";
            }
            else
            {
                cell.detailTextLabel.text=[NSString stringWithFormat:@"                                                                                        %@",finalStr] ;
            }
            NSString *accStr=[NSString stringWithFormat:@"%@  %@", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
            cell.accessibilityLabel = NSLocalizedString(accStr,);
            
        }
        
        
          
    }

    
    else
    {
        
        
    // Configure the cell...
        
    
    if(indexPath.section == 0){
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        
        NSDate *date = [NSDate date];
        NSDateComponents *comps = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
                                         fromDate:date];
        NSDate *today = [cal dateFromComponents:comps];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setDay:finalDay1];
        NSDate *yesterday = [cal dateByAddingComponents:components toDate:today options:0];
        
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        
        [df setDateFormat:@" dd MMMM, yyyy"];
        NSString *gbweek = [df stringFromDate:yesterday];
        
        
        
        
        
        NSString *ses=[NSString stringWithFormat:@"%@ in the week ending%@", (NSString *)[etaresult objectForKey:@"seasonallyAdjustedInitialClaims"],gbweek];
        NSString *test=[NSString stringWithFormat:@"%@", (NSString *)[etaresult objectForKey:@"seasonallyAdjustedInitialClaims"]];
        
        
        
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:etaNumbers forKey:@"etaNumbers"];
        [defaults synchronize];
        
        [UIView beginAnimations:@"cell shift" context:nil];
        label = (UILabel *)[cell.contentView viewWithTag:kCellLabelTag];
        
        cell.textLabel.text=@"";
        label.text = [[[NSUserDefaults standardUserDefaults]objectForKey:@"etaNumbers"] objectAtIndex:0];
        cell.detailTextLabel.numberOfLines=2;
        
        
        
        
        
        NSString *escaped = [test  stringByReplacingOccurrencesOfString:@"<" withString:@""];
        NSString *escaped1 = [escaped  stringByReplacingOccurrencesOfString:@">" withString:@""];
        NSString *escaped2 = [escaped1  stringByReplacingOccurrencesOfString:@"(" withString:@""];
        NSString *escaped3 = [escaped2  stringByReplacingOccurrencesOfString:@")" withString:@""];

        if([escaped3 isEqualToString:@"null"])
        {
            cell.detailTextLabel.text=@"                                                                       Unable to load the data";      
        }
        else
        {
            cell.detailTextLabel.text=[NSString stringWithFormat:@"                                                                             %@",ses] ;
        }
        NSString *accStr=[NSString stringWithFormat:@"%@  %@", [[[NSUserDefaults standardUserDefaults]objectForKey:@"etaNumbers"] objectAtIndex:0] ,ses];
        cell.accessibilityLabel = NSLocalizedString(accStr,);
        label.frame = (inPseudoEditMode) ? kLabelIndentedRect : kLabelRect;
        label.opaque = NO;
        
        NSNumber *rowSelected = [selectedArrayForEtaNumbers objectAtIndex:0];
        imageView = (UIImageView *)[cell.contentView viewWithTag:kCellImageViewTag];
        
        imageView.image =  ([rowSelected boolValue]) ?  unselectedImage:selectedImage;
        imageView.hidden = !inPseudoEditMode;
        [UIView commitAnimations];
        
        
        if (accesbilityflag==1) {
            
            
            
            if ([rowSelected boolValue]) {
                
                NSString *accStr=[NSString stringWithFormat:@"Switch button off %@ %@", [[[NSUserDefaults standardUserDefaults]objectForKey:@"etaNumbers"] objectAtIndex:0],ses];
                
                cell.accessibilityLabel = NSLocalizedString(accStr,);
                
                cell.accessibilityLabel = NSLocalizedString(accStr,);
                
            }
            
            else
                
            {
                
                NSString *accStr=[NSString stringWithFormat:@"switch button on %@ %@ selected ", [[[NSUserDefaults standardUserDefaults]objectForKey:@"etaNumbers"] objectAtIndex:0],ses];
                
                cell.accessibilityLabel = NSLocalizedString(accStr,);
                
            }
            
        }
        
        else
            
        {
            
            NSString *accStr=[NSString stringWithFormat:@"%@  %@", [[[NSUserDefaults standardUserDefaults]objectForKey:@"etaNumbers"] objectAtIndex:0] ,ses];
            
            cell.accessibilityLabel = NSLocalizedString(accStr,);
            
            
            
        }
        
        
        

        
        
    } else {
        numberOfSections=0;

        [UIView beginAnimations:@"cell shift" context:nil];
        label = (UILabel *)[cell.contentView viewWithTag:kCellLabelTag];
        
        label.text =  [blsNumbers objectAtIndex:indexPath.row];
        cell.detailTextLabel.numberOfLines=2;
        
        
        label.frame = (inPseudoEditMode) ? kLabelIndentedRect : kLabelRect;
        label.opaque = NO;
        imageView = (UIImageView *)[cell.contentView viewWithTag:kCellImageViewTag];
        
        NSNumber *selected = [selectedArrayForBlsNumbers objectAtIndex:[indexPath row]];
        imageView.image = ([selected boolValue]) ?  unselectedImage:selectedImage;
        imageView.hidden = !inPseudoEditMode;
        [UIView commitAnimations];
        
      
        
        if ([[blsNumbers objectAtIndex:indexPath.row] isEqual:@"Consumer Price Index (CPI):"])
        {
            
            
            
            
            NSString *year1=[NSString stringWithFormat:@"%@", (NSString *)[cpiresult objectForKey:@"year"]];
            NSString *period=[NSString stringWithFormat:@"%@", (NSString *)[cpiresult objectForKey:@"period"]];
            
            NSString *type=[NSString stringWithFormat:@"%@", (NSString *)[cpiresult objectForKey:@"type"]] ;
            NSString *value=[NSString stringWithFormat:@"%@", (NSString *)[cpiresult objectForKey:@"value"]];
            
            
            NSString *finalStr;
            float stringFloat = [value floatValue];
            
            int periodValue= [period intValue];
            NSString *originalmonth;
            
            switch (periodValue) {
                case 1:
                    originalmonth=@"Jan";
                    break;
                case 2:
                    originalmonth=@"Feb";
                    break;
                case 3:
                    originalmonth=@"Mar";
                    break;
                case 4:
                    originalmonth=@"Apr";
                    break;
                case 5:
                    originalmonth=@"May";
                    break;
                case 6:
                    originalmonth=@"Jun";
                    break;
                case 7:
                    originalmonth=@"Jul";
                    break;
                case 8:
                    originalmonth=@"Aug";
                    break;
                case 9:
                    originalmonth=@"Sep";
                    break;
                case 10:
                    originalmonth=@"Oct";
                    break;
                case 11:
                    originalmonth=@"Nov";
                    break;
                case 12:
                    originalmonth=@"Dec";
                    break;
                    
                default:
                    originalmonth=@"month";
                    break;
            }
            
            
            
            if(![type isEqual:@"F"])
            {
                if(stringFloat>=0)
                {
                    finalStr=[NSString stringWithFormat:@"+%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                    
                }
                else
                {
                    finalStr=[NSString stringWithFormat:@"%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                }               
            }
            else
            {
                if(stringFloat>=0)
                {
                    finalStr =[NSString stringWithFormat:@"+%g%% in %@ %@",stringFloat,originalmonth,year1];
                    
                }
                else
                {
                    finalStr =[NSString stringWithFormat:@"%g%% in %@ %@",stringFloat,originalmonth,year1];
                }                
            }

            if ([value isEqualToString:@"(null)"]) {
                cell.detailTextLabel.text=@"                                                                       Unable to load the data";
            }
            else
            {
                cell.detailTextLabel.text=[NSString stringWithFormat:@"                                                                                        %@",finalStr] ;
            }
            
            if (accesbilityflag==1) {
                
                
                
                if ([selected boolValue]) {
                    
                    NSString *accStr=[NSString stringWithFormat:@"switch button off %@ %@ ", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                    
                    cell.accessibilityLabel = NSLocalizedString(accStr,);
                    
                }
                
                else
                    
                {
                    
                    NSString *accStr=[NSString stringWithFormat:@"switch button on %@ %@ selcted", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                    
                    cell.accessibilityLabel = NSLocalizedString(accStr,);
                    
                }
                
            }
            
            else
                
            {
                
                
                
                NSString *accStr=[NSString stringWithFormat:@"%@  %@", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                
                cell.accessibilityLabel = NSLocalizedString(accStr,);
                
            }
            

            
        }
        else if ([[blsNumbers objectAtIndex:indexPath.row] isEqual:@"Unemployment Rate:"] )
        {
            
            NSString *year1=[NSString stringWithFormat:@"%@", (NSString *)[urresult objectForKey:@"year"]];
            NSString *period=[NSString stringWithFormat:@"%@", (NSString *)[urresult objectForKey:@"period"]];
            
            NSString *type=[NSString stringWithFormat:@"%@", (NSString *)[urresult objectForKey:@"type"]] ;
            NSString *value=[NSString stringWithFormat:@"%@%%", (NSString *)[urresult objectForKey:@"value"]];
            NSString *finalStr;
            int periodValue= [period intValue];
            NSString *originalmonth;
            
            if ([value isEqual:@"(null)%"]) {
                cell.detailTextLabel.text=@"                                                                       Unable to load the data";
            }
            else
            {
                float stringFloat = [value floatValue];
                
                
                switch (periodValue) {
                    case 1:
                        originalmonth=@"Jan";
                        break;
                    case 2:
                        originalmonth=@"Feb";
                        break;
                    case 3:
                        originalmonth=@"Mar";
                        break;
                    case 4:
                        originalmonth=@"Apr";
                        break;
                    case 5:
                        originalmonth=@"May";
                        break;
                    case 6:
                        originalmonth=@"Jun";
                        break;
                    case 7:
                        originalmonth=@"Jul";
                        break;
                    case 8:
                        originalmonth=@"Aug";
                        break;
                    case 9:
                        originalmonth=@"Sep";
                        break;
                    case 10:
                        originalmonth=@"Oct";
                        break;
                    case 11:
                        originalmonth=@"Nov";
                        break;
                    case 12:
                        originalmonth=@"Dec";
                        break;
                        
                    default:
                        originalmonth=@"month";
                        break;
                }
                
                
                if(![type isEqual:@"F"])
                {
                    if(stringFloat>=0)
                    {
                        finalStr=[NSString stringWithFormat:@"%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                        
                    }
                    else
                    {
                        finalStr=[NSString stringWithFormat:@"%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                    }               
                }
                else
                {
                    if(stringFloat>=0)
                    {
                        finalStr =[NSString stringWithFormat:@"%g%% in %@ %@",stringFloat,originalmonth,year1];
                        
                    }
                    else
                    {
                        finalStr =[NSString stringWithFormat:@"%g%% in %@ %@",stringFloat,originalmonth,year1];
                    }                
                }

                
                
                cell.detailTextLabel.text=[NSString stringWithFormat:@"                                                                                        %@",finalStr] ;
                if (accesbilityflag==1) {
                    
                    
                    
                    if ([selected boolValue]) {
                        
                        NSString *accStr=[NSString stringWithFormat:@"switch button off %@ %@ ", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                        
                        cell.accessibilityLabel = NSLocalizedString(accStr,);
                        
                    }
                    
                    else
                        
                    {
                        
                        NSString *accStr=[NSString stringWithFormat:@"switch button on %@ %@ selcted", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                        
                        cell.accessibilityLabel = NSLocalizedString(accStr,);
                        
                    }
                    
                }
                
                else
                    
                {
                    
                    
                    
                    NSString *accStr=[NSString stringWithFormat:@"%@  %@", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                    
                    cell.accessibilityLabel = NSLocalizedString(accStr,);
                    
                }
                
            }
            
        }
        else if ([[blsNumbers objectAtIndex:indexPath.row] isEqual:@"Payroll Employment:"])
        {
            
            NSString *year1=[NSString stringWithFormat:@"%@", (NSString *)[peresult objectForKey:@"year"]];
            NSString *period=[NSString stringWithFormat:@"%@", (NSString *)[peresult objectForKey:@"period"]];
            
            NSString *type=[NSString stringWithFormat:@"%@", (NSString *)[peresult objectForKey:@"type"]] ;
            NSString *value=[NSString stringWithFormat:@"%@", (NSString *)[peresult objectForKey:@"value"]];
            NSString *finalStr;
            
            
            
            float finalValue= [value floatValue];
            int periodValue= [period intValue];
            NSString *originalmonth;
            
            switch (periodValue) {
                case 1:
                    originalmonth=@"Jan";
                    break;
                case 2:
                    originalmonth=@"Feb";
                    break;
                case 3:
                    originalmonth=@"Mar";
                    break;
                case 4:
                    originalmonth=@"Apr";
                    break;
                case 5:
                    originalmonth=@"May";
                    break;
                case 6:
                    originalmonth=@"Jun";
                    break;
                case 7:
                    originalmonth=@"Jul";
                    break;
                case 8:
                    originalmonth=@"Aug";
                    break;
                case 9:
                    originalmonth=@"Sep";
                    break;
                case 10:
                    originalmonth=@"Oct";
                    break;
                case 11:
                    originalmonth=@"Nov";
                    break;
                case 12:
                    originalmonth=@"Dec";
                    break;
                    
                default:
                    originalmonth=@"month";
                    break;
            }
            
            if(![type isEqual:@"F"])
            {
                if(finalValue>=0)
                {
                    finalStr=[NSString stringWithFormat:@"+%g,000(%@) in %@ %@",finalValue,type,originalmonth,year1];
                    
                }
                else
                {
                    finalStr=[NSString stringWithFormat:@"%g,000(%@) in %@ %@",finalValue,type,originalmonth,year1];
                }
                
            }
            else
            {
                if(finalValue>=0)
                {
                    finalStr =[NSString stringWithFormat:@"+%g,000 in %@ %@",finalValue,originalmonth,year1];
                    
                }
                else
                {
                    finalStr =[NSString stringWithFormat:@"%g,000 in %@ %@",finalValue,originalmonth,year1];
                }                    
            }
            if ([value isEqualToString:@"(null)"]) {
                cell.detailTextLabel.text=@"                                                                       Unable to load the data";
            }
            else
            {
                cell.detailTextLabel.text=[NSString stringWithFormat:@"                                                                                        %@",finalStr] ;
            }
            if (accesbilityflag==1) {
                
                
                
                if ([selected boolValue]) {
                    
                    NSString *accStr=[NSString stringWithFormat:@"switch button off %@ %@ ", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                    
                    cell.accessibilityLabel = NSLocalizedString(accStr,);
                    
                }
                
                else
                    
                {
                    
                    NSString *accStr=[NSString stringWithFormat:@"switch button on %@ %@ selcted", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                    
                    cell.accessibilityLabel = NSLocalizedString(accStr,);
                    
                }
                
            }
            
            else
                
            {
                
                
                
                NSString *accStr=[NSString stringWithFormat:@"%@  %@", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                
                cell.accessibilityLabel = NSLocalizedString(accStr,);
                
            }
            

            
            
        }
        else if ([[blsNumbers objectAtIndex:indexPath.row] isEqual:@"Average Hourly Earnings:"])
        {
            
            NSString *year1=[NSString stringWithFormat:@"%@", (NSString *)[aheresult objectForKey:@"year"]];
            NSString *period=[NSString stringWithFormat:@"%@", (NSString *)[aheresult objectForKey:@"period"]];
            
            NSString *type=[NSString stringWithFormat:@"%@", (NSString *)[aheresult objectForKey:@"type"]] ;
            NSString *value=[NSString stringWithFormat:@"%@", (NSString *)[aheresult objectForKey:@"value"]];
            NSString *finalStr;
            int periodValue= [period intValue];
            NSString *originalmonth;
            float stringFloat = [value floatValue];
            
            
            switch (periodValue) {
                case 1:
                    originalmonth=@"Jan";
                    break;
                case 2:
                    originalmonth=@"Feb";
                    break;
                case 3:
                    originalmonth=@"Mar";
                    break;
                case 4:
                    originalmonth=@"Apr";
                    break;
                case 5:
                    originalmonth=@"May";
                    break;
                case 6:
                    originalmonth=@"Jun";
                    break;
                case 7:
                    originalmonth=@"Jul";
                    break;
                case 8:
                    originalmonth=@"Aug";
                    break;
                case 9:
                    originalmonth=@"Sep";
                    break;
                case 10:
                    originalmonth=@"Oct";
                    break;
                case 11:
                    originalmonth=@"Nov";
                    break;
                case 12:
                    originalmonth=@"Dec";
                    break;
                    
                default:
                    originalmonth=@"month";
                    break;
            }
            
            
            if(![type isEqual:@"F"])
            {
                if(stringFloat>=0)
                {
                    finalStr=[NSString stringWithFormat:@"+$%.02f(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                    
                }
                else
                {
                    finalStr=[NSString stringWithFormat:@"$%.02f(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                }                
            }
            else
            {
                if(stringFloat>=0)
                {
                    finalStr =[NSString stringWithFormat:@"+$%.02f in %@ %@",stringFloat,originalmonth,year1];
                    
                }
                else
                {
                    finalStr =[NSString stringWithFormat:@"$%.02f in %@ %@",stringFloat,originalmonth,year1];
                }                
            }

            if ([value isEqualToString:@"(null)"]) {
                cell.detailTextLabel.text=@"                                                                       Unable to load the data";
            }
            else
            {
                cell.detailTextLabel.text=[NSString stringWithFormat:@"                                                                                        %@",finalStr] ;
            }
            if (accesbilityflag==1) {
                
                
                
                if ([selected boolValue]) {
                    
                    NSString *accStr=[NSString stringWithFormat:@"switch button off %@ %@", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                    
                    cell.accessibilityLabel = NSLocalizedString(accStr,);
                    
                }
                
                else
                    
                {
                    
                    NSString *accStr=[NSString stringWithFormat:@"switch button on %@ %@ selcted", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                    
                    cell.accessibilityLabel = NSLocalizedString(accStr,);
                    
                }
                
            }
            
            else
                
            {
                
                
                
                NSString *accStr=[NSString stringWithFormat:@"%@  %@", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                
                cell.accessibilityLabel = NSLocalizedString(accStr,);
                
            }
            

        }    
        else if ([[blsNumbers objectAtIndex:indexPath.row] isEqual:@"Producer Price Index (PPI):"])
        {
            
            NSString *year1=[NSString stringWithFormat:@"%@", (NSString *)[ppiresult objectForKey:@"year"]];
            NSString *period=[NSString stringWithFormat:@"%@", (NSString *)[ppiresult objectForKey:@"period"]];
            
            NSString *type=[NSString stringWithFormat:@"%@", (NSString *)[ppiresult objectForKey:@"type"]] ;
            NSString *value=[NSString stringWithFormat:@"%@%%", (NSString *)[ppiresult objectForKey:@"value"]];
            NSString *finalStr;
            float stringFloat = [value floatValue];
            
            
            int periodValue= [period intValue];
            NSString *originalmonth;
            
            switch (periodValue) {
                case 1:
                    originalmonth=@"Jan";
                    break;
                case 2:
                    originalmonth=@"Feb";
                    break;
                case 3:
                    originalmonth=@"Mar";
                    break;
                case 4:
                    originalmonth=@"Apr";
                    break;
                case 5:
                    originalmonth=@"May";
                    break;
                case 6:
                    originalmonth=@"Jun";
                    break;
                case 7:
                    originalmonth=@"Jul";
                    break;
                case 8:
                    originalmonth=@"Aug";
                    break;
                case 9:
                    originalmonth=@"Sep";
                    break;
                case 10:
                    originalmonth=@"Oct";
                    break;
                case 11:
                    originalmonth=@"Nov";
                    break;
                case 12:
                    originalmonth=@"Dec";
                    break;
                    
                default:
                    originalmonth=@"month";
                    break;
            }
            if(![type isEqual:@"F"])
            {
                if(stringFloat>=0)
                {
                    finalStr=[NSString stringWithFormat:@"+%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                    
                }
                else
                {
                    finalStr=[NSString stringWithFormat:@"%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                }                
            }
            else
            {
                if(stringFloat>=0)
                {
                    finalStr =[NSString stringWithFormat:@"+%g%% in %@ %@",stringFloat,originalmonth,year1];
                    
                }
                else
                {
                    finalStr =[NSString stringWithFormat:@"%g%% in %@ %@",stringFloat,originalmonth,year1];
                }                
            }

            if ([value isEqualToString:@"(null)%"]) {
                cell.detailTextLabel.text=@"                                                                       Unable to load the data";
            }
            else
            {
                cell.detailTextLabel.text=[NSString stringWithFormat:@"                                                                                        %@",finalStr] ;
            }
            if (accesbilityflag==1) {
                
                
                
                if ([selected boolValue]) {
                    
                    NSString *accStr=[NSString stringWithFormat:@"switch button off %@ %@", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                    
                    cell.accessibilityLabel = NSLocalizedString(accStr,);
                    
                }
                
                else
                    
                {
                    
                    NSString *accStr=[NSString stringWithFormat:@"switch button on %@  %@selcted", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                    
                    cell.accessibilityLabel = NSLocalizedString(accStr,);
                    
                }
                
            }
            
            else
                
            {
                
                
                
                NSString *accStr=[NSString stringWithFormat:@"%@  %@", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                
                cell.accessibilityLabel = NSLocalizedString(accStr,);
                
            }
            
          
        }
        else if ([[blsNumbers objectAtIndex:indexPath.row] isEqual:@"Employment Cost Index (ECI):"])
        {
            
            NSString *year1=[NSString stringWithFormat:@"%@", (NSString *)[eciresult objectForKey:@"year"]];
            NSString *period=[NSString stringWithFormat:@"%@", (NSString *)[eciresult objectForKey:@"period"]];
            
            NSString *type=[NSString stringWithFormat:@"%@", (NSString *)[eciresult objectForKey:@"type"]] ;
            NSString *value=[NSString stringWithFormat:@"%@%%", (NSString *)[eciresult objectForKey:@"value"]];
            NSString *finalStr;
            int periodValue= [period intValue];
            NSString *originalmonth;
            float stringFloat = [value floatValue];
            
            switch (periodValue) {
                case 1:
                    originalmonth=@"1st Qtr of";
                    break;
                case 2:
                    originalmonth=@"2nd Qtr of";
                    break;
                case 3:
                    originalmonth=@"3rd Qtr of";
                    break;
                case 4:
                    originalmonth=@"4th Qtr of";
                    break;
                    
                    
                default:
                    originalmonth=@"month";
                    break;
            }
            
            
            if(![type isEqual:@"F"])
            {
                if(stringFloat>=0)
                {
                    finalStr=[NSString stringWithFormat:@"+%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                    
                }
                else
                {
                    finalStr=[NSString stringWithFormat:@"%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                }                
            }
            else
            {
                if(stringFloat>=0)
                {
                    finalStr =[NSString stringWithFormat:@"+%g%% in %@ %@",stringFloat,originalmonth,year1];
                    
                }
                else
                {
                    finalStr =[NSString stringWithFormat:@"%g%% in %@ %@",stringFloat,originalmonth,year1];
                }                
            }

            if ([value isEqualToString:@"(null)%"]) {
                cell.detailTextLabel.text=@"                                                                       Unable to load the data";
            }
            else
            {
                cell.detailTextLabel.text=[NSString stringWithFormat:@"                                                                                        %@",finalStr] ;
            }
            if (accesbilityflag==1) {
                
                
                
                if ([selected boolValue]) {
                    
                    NSString *accStr=[NSString stringWithFormat:@"switch button off %@ %@", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                    
                    cell.accessibilityLabel = NSLocalizedString(accStr,);
                    
                }
                
                else
                    
                {
                    
                    NSString *accStr=[NSString stringWithFormat:@"switch button on %@ %@ selcted", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                    
                    cell.accessibilityLabel = NSLocalizedString(accStr,);
                    
                }
                
            }

            else
                
            {
                
                
                
                NSString *accStr=[NSString stringWithFormat:@"%@  %@", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                
                cell.accessibilityLabel = NSLocalizedString(accStr,);
                
            }
            

            
        }
        else if ([[blsNumbers objectAtIndex:indexPath.row] isEqual:@"Productivity:"])
        {
            
            NSString *year1=[NSString stringWithFormat:@"%@", (NSString *)[proresult objectForKey:@"year"]];
            NSString *period=[NSString stringWithFormat:@"%@", (NSString *)[proresult objectForKey:@"period"]];
            
            NSString *type=[NSString stringWithFormat:@"%@", (NSString *)[proresult objectForKey:@"type"]] ;
            NSString *value=[NSString stringWithFormat:@"%@%%", (NSString *)[proresult objectForKey:@"value"]];
            NSString *finalStr;
            NSString *originalmonth;
            float stringFloat = [value floatValue];
            
            
            if([period isEqual:@"Q01"])
            {
                originalmonth=@"1st Qtr of";
                
            }
            else  if([period isEqual:@"Q02"])
            {
                originalmonth=@"2nd Qtr of";
                
                
            }
            else if([period isEqual:@"Q03"])
            {
                originalmonth=@"3rd Qtr of";
            }
            else if([period isEqual:@"Q04"])
            {
                originalmonth=@"4th Qtr of";
            }
            else
            {
                originalmonth=@"nothing";
                
            }
            
            if(![type isEqual:@"F"])
            {
                if(stringFloat>=0)
                {
                    finalStr=[NSString stringWithFormat:@"+%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                    
                }
                else
                {
                    finalStr=[NSString stringWithFormat:@"%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                }                
            }
            else
            {
                if(stringFloat>=0)
                {
                    finalStr =[NSString stringWithFormat:@"+%g%% in %@ %@",stringFloat,originalmonth,year1];
                    
                }
                else
                {
                    finalStr =[NSString stringWithFormat:@"%g%% in %@ %@",stringFloat,originalmonth,year1];
                }                
            }

            if ([value isEqualToString:@"(null)%"]) {
                cell.detailTextLabel.text=@"                                                                       Unable to load the data";
            }
            else
            {
                cell.detailTextLabel.text=[NSString stringWithFormat:@"                                                                                        %@",finalStr] ;
            }
            
            if (accesbilityflag==1) {
                
                
                
                if ([selected boolValue]) {
                    
                    NSString *accStr=[NSString stringWithFormat:@"switch button off %@  %@", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                    
                    cell.accessibilityLabel = NSLocalizedString(accStr,);
                    
                }
                
                else
                    
                {
                    
                    NSString *accStr=[NSString stringWithFormat:@"switch button on %@ %@ selcted", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                    
                    cell.accessibilityLabel = NSLocalizedString(accStr,);
                    
                }
                
            }

            
            else
                
            {
                
                
                
                NSString *accStr=[NSString stringWithFormat:@"%@  %@", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                
                cell.accessibilityLabel = NSLocalizedString(accStr,);
                
            }
            

        }
        else if ([[blsNumbers objectAtIndex:indexPath.row] isEqual:@"U.S. Import Price Index:"])
        {
            
            NSString *year1=[NSString stringWithFormat:@"%@", (NSString *)[usiresult objectForKey:@"year"]];
            NSString *period=[NSString stringWithFormat:@"%@", (NSString *)[usiresult objectForKey:@"period"]];
            
            NSString *type=[NSString stringWithFormat:@"%@", (NSString *)[usiresult objectForKey:@"type"]] ;
            NSString *value=[NSString stringWithFormat:@"%@%%", (NSString *)[usiresult objectForKey:@"value"]];
            NSString *finalStr;
            int periodValue= [period intValue];
            NSString *originalmonth;
            float stringFloat = [value floatValue];
            
            switch (periodValue) {
                case 1:
                    originalmonth=@"Jan";
                    break;
                case 2:
                    originalmonth=@"Feb";
                    break;
                case 3:
                    originalmonth=@"Mar";
                    break;
                case 4:
                    originalmonth=@"Apr";
                    break;
                case 5:
                    originalmonth=@"May";
                    break;
                case 6:
                    originalmonth=@"Jun";
                    break;
                case 7:
                    originalmonth=@"Jul";
                    break;
                case 8:
                    originalmonth=@"Aug";
                    break;
                case 9:
                    originalmonth=@"Sep";
                    break;
                case 10:
                    originalmonth=@"Oct";
                    break;
                case 11:
                    originalmonth=@"Nov";
                    break;
                case 12:
                    originalmonth=@"Dec";
                    break;
                    
                default:
                    originalmonth=@"month";
                    break;
            }
            
            
            if(![type isEqual:@"F"])
            {
                if(stringFloat>=0)
                {
                    finalStr=[NSString stringWithFormat:@"+%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                    
                }
                else
                {
                    finalStr=[NSString stringWithFormat:@"%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                }              
            }
            else
            {
                if(stringFloat>=0)
                {
                    finalStr =[NSString stringWithFormat:@"+%g%% in %@ %@",stringFloat,originalmonth,year1];
                    
                }
                else
                {
                    finalStr =[NSString stringWithFormat:@"%g%% in %@ %@",stringFloat,originalmonth,year1];
                }                
            }
            if ([value isEqualToString:@"(null)%"]) {
                cell.detailTextLabel.text=@"                                                                       Unable to load the data";
            }
            else
            {
                cell.detailTextLabel.text=[NSString stringWithFormat:@"                                                                                        %@",finalStr] ;
            }
            if (accesbilityflag==1) {
                
                
                
                if ([selected boolValue]) {
                    
                    NSString *accStr=[NSString stringWithFormat:@"switch button off %@ %@", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                    
                    cell.accessibilityLabel = NSLocalizedString(accStr,);
                    
                }
                
                else
                    
                {
                    
                    NSString *accStr=[NSString stringWithFormat:@"switch button on %@ %@ selcted", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                    
                    cell.accessibilityLabel = NSLocalizedString(accStr,);
                    
                }
                
            }

            else
                
            {
                
                
                
                NSString *accStr=[NSString stringWithFormat:@"%@  %@", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                
                cell.accessibilityLabel = NSLocalizedString(accStr,);
                
            }
            
            
        }
        else if ([[blsNumbers objectAtIndex:indexPath.row] isEqual:@"U.S. Export Price Index:"])
        {
            
            NSString *year1=[NSString stringWithFormat:@"%@", (NSString *)[useresult objectForKey:@"year"]];
            NSString *period=[NSString stringWithFormat:@"%@", (NSString *)[useresult objectForKey:@"period"]];
            
            NSString *type=[NSString stringWithFormat:@"%@", (NSString *)[useresult objectForKey:@"type"]] ;
            NSString *value=[NSString stringWithFormat:@"%@%%", (NSString *)[useresult objectForKey:@"value"]];
            NSString *finalStr;
            int periodValue= [period intValue];
            NSString *originalmonth;
            float stringFloat = [value floatValue];
            
            
            switch (periodValue) {
                case 1:
                    originalmonth=@"Jan";
                    break;
                case 2:
                    originalmonth=@"Feb";
                    break;
                case 3:
                    originalmonth=@"Mar";
                    break;
                case 4:
                    originalmonth=@"Apr";
                    break;
                case 5:
                    originalmonth=@"May";
                    break;
                case 6:
                    originalmonth=@"Jun";
                    break;
                case 7:
                    originalmonth=@"Jul";
                    break;
                case 8:
                    originalmonth=@"Aug";
                    break;
                case 9:
                    originalmonth=@"Sep";
                    break;
                case 10:
                    originalmonth=@"Oct";
                    break;
                case 11:
                    originalmonth=@"Nov";
                    break;
                case 12:
                    originalmonth=@"Dec";
                    break;
                    
                default:
                    originalmonth=@"month";
                    break;
            }
            
            if(![type isEqual:@"F"])
            {
                if(stringFloat>=0)
                {
                    finalStr=[NSString stringWithFormat:@"+%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                    
                }
                else
                {
                    finalStr=[NSString stringWithFormat:@"%g%%(%@) in %@ %@",stringFloat,type,originalmonth,year1];
                }               
            }
            else
            {
                if(stringFloat>=0)
                {
                    finalStr =[NSString stringWithFormat:@"+%g%% in %@ %@",stringFloat,originalmonth,year1];
                    
                }
                else
                {
                    finalStr =[NSString stringWithFormat:@"%g%% in %@ %@",stringFloat,originalmonth,year1];
                }                
            }
            if ([value isEqualToString:@"(null)%"]) {
                cell.detailTextLabel.text=@"                                                                       Unable to load the data";
            }
            else
            {
                cell.detailTextLabel.text=[NSString stringWithFormat:@"                                                                                        %@",finalStr] ;
            }
            if (accesbilityflag==1) {
                
                
                
                if ([selected boolValue]) {
                    
                    NSString *accStr=[NSString stringWithFormat:@"switch button off %@ %@ ", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                    
                    cell.accessibilityLabel = NSLocalizedString(accStr,);
                    
                }
                
                else
                    
                {
                    
                    NSString *accStr=[NSString stringWithFormat:@"switch button on %@ %@ selcted", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                    
                    cell.accessibilityLabel = NSLocalizedString(accStr,);
                    
                }
                
            }
            
            else
                
            {
                
                
                
                NSString *accStr=[NSString stringWithFormat:@"%@  %@", [blsNumbers objectAtIndex:indexPath.row] ,finalStr];
                
                cell.accessibilityLabel = NSLocalizedString(accStr,);
                
            }
            

            
        }
        
    
        
    }
    }
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
	if (inPseudoEditMode){
        switch (indexPath.section) {
            case 0:
            {
                BOOL rowSelected = [[selectedArrayForEtaNumbers objectAtIndex:[indexPath row]] boolValue];
                [selectedArrayForEtaNumbers replaceObjectAtIndex:[indexPath row] withObject:[NSNumber numberWithBool:!rowSelected]];
                [self.tableView reloadData];
            }
                break;
            case 1:
                
            {
                BOOL selected = [[selectedArrayForBlsNumbers objectAtIndex:[indexPath row]] boolValue];
                [selectedArrayForBlsNumbers replaceObjectAtIndex:[indexPath row] withObject:[NSNumber numberWithBool:!selected]];
                [self.tableView reloadData];
            }
                
            default:
                break;
        
        
        
	}
    
    }
}


-(void)govDataRequest:(GOVDataRequest *)request didCompleteWithResults:(NSArray *)resultsArray andResponseTime:(float)timeInMS {
    
    
    self.arrayOfResults = resultsArray;
    
    if(flag==0)
    {
        if(![arrayOfResults count]==0)
        {
            
            
            
            
            
            etaresult = (NSDictionary *)[arrayOfResults objectAtIndex:0];
            NSString *ses=[NSString stringWithFormat:@"%@", (NSString *)[etaresult objectForKey:@"seasonallyAdjustedInitialClaims"]];
            NSString *escaped = [ses  stringByReplacingOccurrencesOfString:@"<" withString:@""];
            NSString *escaped1 = [escaped  stringByReplacingOccurrencesOfString:@">" withString:@""];
            
            
            if ([escaped1 isEqualToString:@"null"]) {
                day--;
                
                [self ifNoValuesInETAArray];
                
            }
            else
            {
                if (finalDay1==0) {
                    finalDay1=day;
                }
                flag=1;
                [self ifNoValuesInCpiArray];
                
            }
            
        }
        else
        {
            day--;
            [self ifNoValuesInETAArray];
            
        }
    }
    
    else  if(flag==1)
    {

        if(![arrayOfResults count]==0)
        {
            flag=2;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"MM"];
            month = [[dateFormatter stringFromDate:[NSDate date]] intValue];
            if ([[[[resultsArray objectAtIndex:0]objectForKey:@"__metadata"]objectForKey:@"type"]  isEqual: @"BLS_NumbersModel.consumerPriceIndex1MonthChange"])
            {
                
                
                
                cpiresult = (NSDictionary *)[arrayOfResults objectAtIndex:0];
                [self ifNoValuesInURArray];
                
            }
        }
        else
        {
            if (!month==0) {
                month--;
                [self ifNoValuesInCpiArray];
                
            }
            else
            {
                
                month=12;
                year--;
                [self ifNoValuesInCpiArray];
            }
        }
    }
    
    
    
    
    
    else  if(flag==2)
    {
        if(![arrayOfResults count]==0)
        {
            flag=3;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"MM"];
            month = [[dateFormatter stringFromDate:[NSDate date]] intValue];
            if ([[[[resultsArray objectAtIndex:0]objectForKey:@"__metadata"]objectForKey:@"type"]  isEqual: @"BLS_NumbersModel.unemploymentRate"])
            {
                
                
                
                urresult = (NSDictionary *)[arrayOfResults objectAtIndex:0];
                [self ifNoValuesInPEArray];
                
            }
        }
        else
        {
            if (!month==0) {
                month--;
                [self ifNoValuesInURArray];
                
            }
            else
            {
                
                month=12;
                year--;
                [self ifNoValuesInURArray];
            }
        }
    }
    else  if(flag==3)
    {
        if(![arrayOfResults count]==0)
        {
            flag=4;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"MM"];
            month = [[dateFormatter stringFromDate:[NSDate date]] intValue];
            if  ([[[[resultsArray objectAtIndex:0]objectForKey:@"__metadata"]objectForKey:@"type"]  isEqual: @"BLS_NumbersModel.payrollEmployment1MonthNetChange"])
            {
                
                
                
                peresult = (NSDictionary *)[arrayOfResults objectAtIndex:0];
                [self ifNoValuesInAHEArray];
                
            }
        }
        else
        {
            if (!month==0) {
                month--;
                [self ifNoValuesInPEArray];
                
            }
            else
            {
                
                month=12;
                year--;
                [self ifNoValuesInPEArray];
            }
        }
    }
    else  if(flag==4)
    {
        if(![arrayOfResults count]==0)
        {
            flag=5;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"MM"];
            month = [[dateFormatter stringFromDate:[NSDate date]] intValue];
            if ([[[[resultsArray objectAtIndex:0]objectForKey:@"__metadata"]objectForKey:@"type"]  isEqual: @"BLS_NumbersModel.averageHourlyEarnings1MonthNetChange"])
            {
                
                
                
                aheresult = (NSDictionary *)[arrayOfResults objectAtIndex:0];
                [self ifNoValuesInPPIArray];
                
            }
        }
        else
        {
            if (!month==0) {
                month--;
                [self ifNoValuesInAHEArray];
                
            }
            else
            {
                
                month=12;
                year--;
                [self ifNoValuesInAHEArray];
            }
        }
    }
    else  if(flag==5)
    {
        if(![arrayOfResults count]==0)
        {
            flag=6;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"MM"];
            month = [[dateFormatter stringFromDate:[NSDate date]] intValue];
            if ([[[[resultsArray objectAtIndex:0]objectForKey:@"__metadata"]objectForKey:@"type"]  isEqual: @"BLS_NumbersModel.producerPriceIndex1MonthChange"])
            {
                
                
                
                ppiresult = (NSDictionary *)[arrayOfResults objectAtIndex:0];
                [self ifNoValuesInUSIArray];
                
            }
        }
        else
        {
            if (!month==0) {
                month--;
                [self ifNoValuesInPPIArray];
                
            }
            else
            {
                
                month=12;
                year--;
                [self ifNoValuesInPPIArray];
            }
            
        }
    }
    else  if(flag==6)
    {
        if(![arrayOfResults count]==0)
        {
            flag=7;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"MM"];
            month = [[dateFormatter stringFromDate:[NSDate date]] intValue];
            if ([[[[resultsArray objectAtIndex:0]objectForKey:@"__metadata"]objectForKey:@"type"]  isEqual: @"BLS_NumbersModel.importPriceIndex1MonthChange"])
            {
                
                
                
                usiresult = (NSDictionary *)[arrayOfResults objectAtIndex:0];
                [self ifNoValuesInUSEArray];
                
            }
        }
        else
        {
            if (!month==0) {
                month--;
                [self ifNoValuesInUSIArray];
                
            }
            else
            {
                
                month=12;
                year--;
                [self ifNoValuesInUSIArray];
            }      }
    }
    else  if(flag==7)
    {
        if(![arrayOfResults count]==0)
        {
            flag=8;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"MM"];
            month = [[dateFormatter stringFromDate:[NSDate date]] intValue];
            if ([[[[resultsArray objectAtIndex:0]objectForKey:@"__metadata"]objectForKey:@"type"]  isEqual: @"BLS_NumbersModel.exportPriceIndex1MonthChange"])
            {
                
                
                
                useresult = (NSDictionary *)[arrayOfResults objectAtIndex:0];
                qtr=4;
                
                [self ifNoValuesInECIQtrArray];
                
            }
        }
        else
        {
            if (!month==0) {
                month--;
                [self ifNoValuesInUSEArray];
                
            }
            else
            {
                
                month=12;
                year--;
                [self ifNoValuesInUSEArray];
            }      }
    }
    else  if(flag==8)
    {
        if(![arrayOfResults count]==0)
        {
            flag=9;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"MM"];
            month = [[dateFormatter stringFromDate:[NSDate date]] intValue];
            if ([[[[resultsArray objectAtIndex:0]objectForKey:@"__metadata"]objectForKey:@"type"]  isEqual: @"BLS_NumbersModel.employmentCostIndex"])
            {
                
                
                
                eciresult = (NSDictionary *)[arrayOfResults objectAtIndex:0];
                qtr=4;
                if(secflag==1)
                {
                    flag=10;
                }
                else
                {
                [self ifNoValuesInPROQtrArray];
                }
                
            }
        }
        else
        {
            if (!qtr==0) {
                qtr--;
                [self ifNoValuesInECIQtrArray];
            }
            else
            {
                qtr=4;
                year--;
                [self ifNoValuesInECIQtrArray];
                
            }
        }
    }
    else  if(flag==9)
    {
        if(![arrayOfResults count]==0)
        {
            if ([[[[resultsArray objectAtIndex:0]objectForKey:@"__metadata"]objectForKey:@"type"]  isEqual: @"BLS_NumbersModel.productivity"])
            {
                
                
                proresult = (NSDictionary *)[arrayOfResults objectAtIndex:0];
                
            }
        }
        else
        {
            if (!qtr==0) {
                qtr--;
                [self ifNoValuesInPROQtrArray];
            }
            else
            {
                qtr=4;
                year--;
                [self ifNoValuesInPROQtrArray];
                
            }
        }
    }
    
    
    
    
    
    
      [self.tableView reloadData];
}

-(void)govDataRequest:(GOVDataRequest *)request didCompleteWithError:(NSString *)error {
    
    UIAlertView *alert;
    
    day=0;
    finalDay1=0;
    
    if([error isEqualToString:@"Authentication needed"])
        
    {
        
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry we are unable to access DOL Numbers at this moment. Please try again later." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
    }
    
    else if([error isEqualToString:@"A connection failure occurred"])
        
    {
        
        alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"An Internet connection is required to access DOL Current Numbers. Please try again later." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
    }
    
    else
        
    {
        
        alert= [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
    }
    
    [alert show];
    
    
}

-(void)govDataRequest:(GOVDataRequest *)request didCompleteWithDictionaryResults:(NSDictionary *)resultsDictionary andResponseTime:(float)timeInMS {
    
    
    NSLog(@"Got a Dictionary");
	//Save results in our local dictionary instance
    //NSLog(@"%@", resultsDictionary);
	//self.dictionaryOfResults = [resultsDictionary retain];
    //    NSLog(@"%@", self.dictionaryOfResults);
	//Refresh the tableView
	//[self.tableView reloadData];
}

-(void)govDataRequest:(GOVDataRequest *)request didCompleteWithUnParsedResults:(NSString *)resultsString andResponseTime:(float)timeInMS {
    
    NSLog(@"Got data that was likely not formatted properly");
    //NSLog(@"%@", resultsString);
    
}

@end
