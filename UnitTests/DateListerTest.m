//
//  DateListerTest.m
//  Chevre
//
//  Created by Matthieu DESILE on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DateLister.h"
#import "DateListerTest.h"

@implementation DateListerTest
@synthesize instance;

- (void) setUp
{
    instance = [[DateLister alloc] init];
}

- (void) testListHasOneEntry
{
    NSString* path = [[NSUserDefaults standardUserDefaults] stringForKey: @"base"];
    NSArray* array = [instance getDatesInPath: path];
    STAssertTrue([array count] >= 1, @"should have at least one entry");
}

- (void) tearDown
{
}
@end
