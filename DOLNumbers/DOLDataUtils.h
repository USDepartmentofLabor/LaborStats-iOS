//
//  DOLAPIUtils.h
//  EventsAPI
//
//  Created by the U.S. Deparment of Labor
//  Code available in the public domain
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "DOLDataContext.h"

@interface DOLDataUtils : NSObject {
    
}

+(void)addAuthorizationHeaderToRequest:(ASIHTTPRequest *)request withContext:(DOLDataContext *)context;

@end

//Extension to native classes
//NSData can now provide hex to string
@interface NSData (NSDataStrings)
- (NSString*)stringWithHexBytes;
@end


//NSString can now URLEncode strings
@interface NSString (NSStrings)
- (NSString*)urlEncoded;
@end