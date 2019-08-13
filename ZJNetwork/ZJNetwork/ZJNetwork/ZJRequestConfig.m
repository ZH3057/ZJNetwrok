//
//  ZJRequestConfig.m
//  ZJNetwork
//
//  Created by Jun Zhou on 2019/8/11.
//  Copyright © 2019 Jun Zhou. All rights reserved.
//

#import "ZJRequestConfig.h"

@implementation ZJRequestConfig

+ (NSString *)reforomRequestPath:(NSString *)requestPath {
    return requestPath;
}
+ (NSDictionary *)reformParameters:(NSDictionary *)paramenters {
    return paramenters;
}

+ (NSString *)requestInfoStringForRequest:(NSURLRequest *)request requestPath:(NSString *)requestPath parameters:(NSDictionary *)parameters {
    
#if DEBUG
    
    NSMutableString *infoString = nil;
    infoString = [NSMutableString stringWithString:@"\n\n********************************************************\nRequest Start\n********************************************************\n\n"];
    
    [infoString appendFormat:@"Request Path:\t\t%@\n", requestPath];
    [infoString appendFormat:@"Method:\t\t\t%@\n", request.HTTPMethod];
    [infoString appendFormat:@"Params:\n%@", parameters];
    infoString = [self infoString:infoString appendURLRequest:request];
    
    [infoString appendFormat:@"\n\n********************************************************\nRequest End\n********************************************************\n\n\n\n"];
    
    return infoString.copy;
    
#else
    
    return nil;
    
#endif
    
}

+ (NSString *)responseInfoStringForResponse:(NSHTTPURLResponse *)response responseObject:(id)responseObject request:(NSURLRequest *)request error:(NSError *)error {
    
#if DEBUG
    
    if (![response isKindOfClass:NSHTTPURLResponse.class]) {
        return responseObject;
    }
    
    NSMutableString *infoString = nil;
    infoString = [NSMutableString stringWithString:@"\n\n=========================================\nResponse Start\n=========================================\n\n"];
    
    [infoString appendFormat:@"Status:\t%ld\t(%@)\n\n", (long)response.statusCode, [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode]];
    [infoString appendFormat:@"Request URL:\n\t%@\n\n", request.URL];
    [infoString appendFormat:@"Raw Response Header:\n\t%@\n\n", response.allHeaderFields];
    [infoString appendFormat:@"responseObject:\n%@", responseObject];
    if (error) {
        [infoString appendFormat:@"Error Domain:\t\t\t\t\t\t\t%@\n", error.domain];
        [infoString appendFormat:@"Error Domain Code:\t\t\t\t\t\t%ld\n", (long)error.code];
        [infoString appendFormat:@"Error Localized Description:\t\t\t%@\n", error.localizedDescription];
        [infoString appendFormat:@"Error Localized Failure Reason:\t\t\t%@\n", error.localizedFailureReason];
        [infoString appendFormat:@"Error Localized Recovery Suggestion:\t%@\n\n", error.localizedRecoverySuggestion];
    }
    
    [infoString appendString:@"\n---------------  Related Request Content  --------------\n"];
    
    infoString = [self infoString:infoString appendURLRequest:request];
    
    [infoString appendFormat:@"\n\n=========================================\nResponse End\n=========================================\n\n"];
    
    return infoString.copy;
    
#else
    
    return nil;
    
#endif

}

+ (NSMutableString *)infoString:(NSMutableString *)infoString appendURLRequest:(NSURLRequest *)request {
    [infoString appendFormat:@"\n\nHTTP URL:\n\t%@", request.URL];
    [infoString appendFormat:@"\n\nHTTP Header:\n%@", request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @"\t\t\t\t\tN/A"];
    [infoString appendFormat:@"\n\nHTTP Body:\n\t%@", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]];
    
    NSMutableString *headerString = [[NSMutableString alloc] init];
    [request.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *header = [NSString stringWithFormat:@" -H \"%@: %@\"", key, obj];
        [headerString appendString:header];
    }];
    
    [infoString appendString:@"\n\nCURL:\n\t curl"];
    [infoString appendFormat:@" -X %@", request.HTTPMethod];
    
    if (headerString.length > 0) {
        [infoString appendString:headerString];
    }
    if (request.HTTPBody.length > 0) {
        [infoString appendFormat:@" -d '%@'", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]];
    }
    
    [infoString appendFormat:@" %@", request.URL];
    return infoString;
}

@end
