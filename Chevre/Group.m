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

#pragma mark -
#pragma mark Initialization
- (id) init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id) initWithRange: (NSRange) range
{
    self = [self init];
    [self setRange: range];
    return self;
}

- (id) initWithName: (NSString*) name andCategory: (NSString*) category withIndex: (NSIndexSet*) indexes
{
    self = [self init];
    [self setName: name];
    [self setCategory: category];
    [self setStart: [indexes firstIndex]];
    [self setEnd: [indexes lastIndex]];
    return self;
}

#pragma mark - 
#pragma mark Accessors

- (NSUInteger) start
{
    return range.location;
}

- (void) setStart: (NSUInteger) start
{
    range.location = start;
}

- (NSUInteger) end
{
    return (range.location + range.length - 1);
}

- (void) setEnd: (NSUInteger) end
{
    if(end >= range.location){
	range.length = end - range.location + 1;
    }
}

- (NSUInteger) length
{
    return range.length;
}

- (void) setLength: (NSUInteger) length
{
    range.length = length;
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
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys: 
                          [NSNumber numberWithInt: IKGroupBezelStyle], IKImageBrowserGroupStyleKey, 
                          color, IKImageBrowserGroupBackgroundColorKey,
                          [NSString stringWithFormat: @"%@ - %@", name, category], IKImageBrowserGroupTitleKey,
                          [NSValue valueWithRange: range], IKImageBrowserGroupRangeKey, nil];
    return dict;
}

- (BOOL) containsImageIndex: (NSUInteger) index
{
    // return [[[NSIndexSet alloc] initWithIndexesInRange: [self range]] containsIndex: index];
    if(index < ([self range].location + [self range].length)){
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) containsImagesIndices: (NSIndexSet*) indices
{
    NSIndexSet* local = [[NSIndexSet alloc] initWithIndexesInRange: [self range]];
    BOOL contains = [local intersectsIndexesInRange: [self range]];
    [local release];
    return contains;
}

- (void) removeItemAtIndices: (NSIndexSet*) indices
{
    if([indices intersectsIndexesInRange: [self range]]){
        NSUInteger intersection[range.length];
        NSUInteger length = [indices getIndexes: intersection maxCount: range.length inIndexRange: &range];
	NSUInteger first = intersection[0];
	NSUInteger last = intersection[length - 1];

	if(first == range.location && last < (range.length + range.location)){
	    // changer le range.location et range.length
	    range.location = last + 1;
	    range.length = range.length - length;
	} else if(first > range.location && last < (range.location + range.length)){
	    // changer le range.length
	    range.length = first - range.location;
	} else if(first > range.location && last == (range.location + range.length)){
	    // changer le range.length
	    range.length = range.length - length;
	} 
    }
}

- (BOOL) containsAll: (NSIndexSet*) indices
{
    NSUInteger intersection = [indices countOfIndexesInRange: range];
    if(range.length == intersection){
	return YES;
    } else {
	return NO;
    }
}

- (void) addItemsWithIndices: (NSIndexSet*) indices
{
    NSUInteger intersection = [indices countOfIndexesInRange: range];
    //NSUInteger shared[range.length];
    //NSUInteger length = [indices getIndexes: shared maxCount: range.length inIndexRange: &range];
    
    if(intersection != 0){
        range.length = range.length + [indices count] - intersection;
        if([indices firstIndex] < range.location){
            range.location = [indices firstIndex];
        }
    }
}

@end
