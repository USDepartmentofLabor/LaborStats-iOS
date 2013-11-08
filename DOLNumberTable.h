//
//  DOLNumberTable.h
//  DOLNumbers
//
//

#import <UIKit/UIKit.h>
#import "GOVDataRequest.h"
#import "LoadingView.h"


#define kCellImageViewTag		1000
#define kCellLabelTag			1001

#define kLabelIndentedRect	CGRectMake(40.0, 8.0, 240.0, 20.0)
#define kLabelRect			CGRectMake(10.0, 8.0, 275.0, 20.0)

// You need to supply your own API key and secret.  You can get yours at http://developer.dol.gov
#define API_KEY @"2bc4aa85-4d4e-4e33-820e-5ddbc7a1c237"
#define API_SECRET @""
#define API_HOST @"http://api.dol.gov"
#define API_URL @"/V1"

@interface DOLNumberTable : UITableViewController<GOVDataRequestDelegate> {

        NSMutableArray *blsNumbers;
        NSMutableArray *blsIndexes;
        NSMutableArray *etaNumbers;
        NSMutableArray *etaIndexes;
    
    NSMutableArray *holderArray;
    
    NSMutableArray *holderArray1;
       LoadingView *loadingView;
    
         NSDictionary *etaresult;
         NSMutableArray *val;

        NSDictionary *cpiresult;
        NSDictionary *urresult;
        NSDictionary *peresult;
        NSDictionary *aheresult;
        NSDictionary *ppiresult;
        NSDictionary *eciresult;
        NSDictionary *proresult;
        NSDictionary *usiresult;
        NSDictionary *useresult;
        int secflag;

    int accesbilityflag;
        int flag;
        int qtrflag;
    int numberOfSections;


       int year;
       int month;
       int qtr;
       int sectionFlag;
    
        int finalDay1;
    
        NSMutableArray *selectedArrayForBlsNumbers;
        NSMutableArray *selectedArrayForEtaNumbers;
        
        UIImage *selectedImage;
        UIImage *unselectedImage;
        UIImageView *imageView;

        
        BOOL inPseudoEditMode;
        
        UILabel *label;
        UILabel *detaillabel;
        
        UIBarButtonItem	*refreshButton;
        UIBarButtonItem	*doneEditButton;
    
    
        NSArray *arrayOfResults;
        GOVDataRequest *dataRequest;
       NSString *displayweek;
       UIActivityIndicatorView  *spinner;
       int day;
    

    
        
    }
    @property (nonatomic, retain) NSMutableArray *blsNumbers;
    @property (nonatomic, retain) NSMutableArray *blsIndexes;
    @property (nonatomic, retain) NSMutableArray *etaNumbers;
    @property (nonatomic, retain) NSMutableArray *etaIndexes;
@property (nonatomic, retain) NSMutableArray *val;
@property (nonatomic, retain) NSMutableArray *holderArray;

@property (nonatomic, retain) NSMutableArray *holderArray1;

 @property (nonatomic, retain)NSString *displayweek;
 

    
    @property (nonatomic, retain) NSMutableArray *selectedArrayForBlsNumbers;
    @property (nonatomic, retain) NSMutableArray *selectedArrayForEtaNumbers;

    
    @property (nonatomic, retain) UIImage *selectedImage;
    @property (nonatomic, retain) UIImage *unselectedImage;

    @property(nonatomic, retain)NSArray *arrayOfResults;
    @property(nonatomic, retain)GOVDataRequest *dataRequest;
    
    @property BOOL inPseudoEditMode;
    
    -(void)populateSelectedArrayForBls;
    -(void)populateSelectedArrayForEta;
   

-(void)ifNoValuesInETAArray;
-(void)ifNoValuesInCpiArray;


-(void)ifNoValuesInURArray;

-(void)ifNoValuesInPEArray;

-(void)ifNoValuesInAHEArray;

-(void)ifNoValuesInPPIArray;

-(void)ifNoValuesInUSIArray;

-(void)ifNoValuesInUSEArray;

-(void)ifNoValuesInECIQtrArray;

-(void)ifNoValuesInPROQtrArray;
+ (NSDate*)dateFromUnixDate:(double)unixdate ;




    
    @end
