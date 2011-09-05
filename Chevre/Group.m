//
//  Group.m
//  Chevre
//
//  Created by Matthieu DESILE on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Quartz/Quartz.h>

#import "Group.h"

@implementation Group

@synthesize category, name, range;

- (id) init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NSDictionary*) asNSDictionnary
{
    NSColor* color;
    if([category isEqualToString: @"photo"]){
        color = [NSColor yellowColor];
    } else if([category isEqualToString: @"pano"]){
        color = [NSColor orangeColor];
    } else if([category isEqualToString: @"hdr"]){
        color = [NSColor purpleColor];
    }
    return [NSDictionary dictionaryWithObjectsAndKeys: 
            [NSNumber numberWithInt: IKGroupBezelStyle], IKImageBrowserGroupStyleKey, 
            color, IKImageBrowserGroupBackgroundColorKey,
            [NSString stringWithFormat: @"%@ - %@", name, category], IKImageBrowserGroupTitleKey,
            [NSValue valueWithRange: range], IKImageBrowserGroupRangeKey, nil];
}

@end
