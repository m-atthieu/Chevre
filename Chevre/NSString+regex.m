//
//  NSString+regex.m
//  Chevre
//
//  Created by Matthieu DESILE on 9/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "NSString+regex.h"

#if MAC_OS_X_VERSION_MIN_REQUIRED <= MAC_OS_X_VERSION_10_6
#import <regex.h>
#endif

@implementation NSString (regex)

- (NSString *) captureRegex: (NSString *) pattern 
{
#if MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_6
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:&error];
    if(regex == nil) {
        NSLog(@"-- %@", error);
        return nil;
    }
    
    NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:self options: 0 range: NSMakeRange(0, [self length])];
    if(rangeOfFirstMatch.location == NSNotFound) return nil;
    
    return [self substringWithRange: rangeOfFirstMatch];
#else 
    regex_t preg;
    int err = regcomp(&preg, [pattern UTF8String], REG_EXTENDED);
    if(err){
        char errbuf[256];
        regerror(err, &preg, errbuf, sizeof(errbuf));
        [NSException raise:@"CSRegexException"
                    format:@"Could not compile regex '%@': %s", pattern, errbuf];
    }
    
    const char *cstr = [self UTF8String];
    regmatch_t match;
    NSString* result;
    if(regexec(&preg, cstr, 1, &match, 0) == 0)
    {
        result = [[[NSString alloc] initWithBytes: cstr + match.rm_so
                                           length: match.rm_eo - match.rm_so 
                                         encoding: NSUTF8StringEncoding] autorelease];
    }
    return result;
#endif
}


- (BOOL)matchRegex:(NSString *)pattern 
{
#if MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_6
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: pattern 
                                                                           options: NSRegularExpressionCaseInsensitive
                                                                             error: &error];
    if(regex == nil) {
        NSLog(@"-- %@", error);
        return NO;
    }
    
    NSUInteger n = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];
    return n == 1;
#else
    regex_t preg;
    int err = regcomp(&preg, [pattern UTF8String], REG_EXTENDED);
    if(err){
        char errbuf[256];
        regerror(err, &preg, errbuf, sizeof(errbuf));
        [NSException raise: @"CSRegexException"
                    format: @"Could not compile regex '%@': %s", pattern, errbuf];
    }
    const char* cstr = [self UTF8String];
    regmatch_t match;
    if(regexec(&preg, cstr, 1, &match, 0) == 0){
        return YES;
    } else {
        return NO;
    }
#endif
}
@end
