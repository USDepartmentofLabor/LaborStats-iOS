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
#define API_KEY @""
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
    @property (nonatomic, strong) NSMutableArray *blsNumbers;
    @property (nonatomic, strong) NSMutableArray *blsIndexes;
    @property (nonatomic, strong) NSMutableArray *etaNumbers;
    @property (nonatomic, strong) NSMutableArray *etaIndexes;
@property (nonatomic, strong) NSMutableArray *val;
@property (nonatomic, strong) NSMutableArray *holderArray;

@property (nonatomic, strong) NSMutableArray *holderArray1;

 @property (nonatomic, strong)NSString *displayweek;
 

    
    @property (nonatomic, strong) NSMutableArray *selectedArrayForBlsNumbers;
    @property (nonatomic, strong) NSMutableArray *selectedArrayForEtaNumbers;

    
    @property (nonatomic, strong) UIImage *selectedImage;
    @property (nonatomic, strong) UIImage *unselectedImage;

    @property(nonatomic, strong)NSArray *arrayOfResults;
    @property(nonatomic, strong)GOVDataRequest *dataRequest;
    
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
