//
//  NSString+regex.m
//  Chevre
//
//  Created by Matthieu DESILE on 9/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString+regex.h"

@implementation NSString (regex)

- (NSString *) captureRegex: (NSString *) pattern {
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:&error];
    if(regex == nil) {
        NSLog(@"-- %@", error);
        return nil;
    }
    
    NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
    if(rangeOfFirstMatch.location == NSNotFound) return nil;
    
    return [self substringWithRange:rangeOfFirstMatch];
}


- (BOOL)matchRegex:(NSString *)pattern {    
    
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
}
@end
