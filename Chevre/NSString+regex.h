//
//  NSString+regex.h
//  Chevre
//
//  Created by Matthieu DESILE on 9/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (regex)

- (NSString *)captureRegex: (NSString *) pattern;
- (BOOL) matchRegex: (NSString *) pattern;

@end
