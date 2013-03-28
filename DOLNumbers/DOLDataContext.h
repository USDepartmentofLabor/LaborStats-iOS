//
//  DOLDataContext.h
//  APISample
//
//  Created by the U.S. Deparment of Labor
//  Code available in the public domain
//

#import <Foundation/Foundation.h>


@interface DOLDataContext : NSObject {
    
}

@property (nonatomic, copy) NSString *APIKey;
@property (nonatomic, copy) NSString *SharedSecret;
@property (nonatomic, copy) NSString *APIHost;
@property (nonatomic, copy) NSString *APIURL;


-(id)initWithAPIKey:(NSString *)key Host:(NSString *)host SharedSecret:(NSString *)secret;

@end
