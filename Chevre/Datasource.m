//
//  ImagesDatasource.m
//  Chevre
//
//  Created by Matthieu DESILE on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Quartz/Quartz.h>

#import "Datasource.h"
#import "Group.h"
#import "Image.h"

@implementation Datasource

@synthesize groups, images;
@synthesize undoManager;

- (id) initWithURL: (NSURL *) anURL
{
    self = [super init];
    if (self) {
        groups = [[NSMutableArray alloc] init];
        images = [[NSMutableArray alloc] init];
        [self scanURL: anURL];
    }
    
    return self;
}

- (void) scanURL: (NSURL*) anURL
{
    // TODO read URL, add images
    NSFileManager* fm = [NSFileManager defaultManager];
    NSArray* extensions = [NSArray arrayWithObjects: @"JPG", @"NEF", @"RW2", nil];
    NSArray* content = [fm contentsOfDirectoryAtURL: anURL
                         includingPropertiesForKeys: [NSArray arrayWithObjects: NSURLIsDirectoryKey, nil]
                                            options: NSDirectoryEnumerationSkipsHiddenFiles
                                              error: nil];
    for(NSURL* file in content){
        if([extensions containsObject: [file pathExtension]]){
            Image* image = [[Image alloc] initWithURL: file];
            [images addObject: image];
            [image release];
        }
    }
}

#pragma mark -
#pragma mark IKImageBrowserDataSource : Providing Information About Items (Required)
- (id) imageBrowser: (IKImageBrowserView*) aBrowser itemAtIndex: (NSUInteger) index
{
    return [images objectAtIndex: index];
}

- (NSUInteger) numberOfItemsInImageBrowser: (IKImageBrowserView*) aBrowser
{
    return [images count];
}

#pragma mark -
#pragma mark IKImageBrowserDatasource : Supporting Item Editing (Optional)

#pragma mark -
#pragma mark IKImageBrowserDataSource : Providing Information About Groups (Optional)
- (NSUInteger) numberOfGroupsInImageBrowser: (IKImageBrowserView*) aBrowser
{
    return [groups count];
}

- (NSDictionary *) imageBrowser: (IKImageBrowserView*) aBrowser groupAtIndex: (NSUInteger) index
{
    return [[groups objectAtIndex: index] asNSDictionnary];
}

- (void) addGroupWithName: (NSString*) name andCategory: (NSString*) category withIndex: (NSIndexSet*) index
{
    Group* group = [[Group alloc] init];
    [group setName: name];
    [group setCategory: category];
    [group setRange: NSMakeRange([index firstIndex], [index lastIndex] - [index firstIndex] + 1)];
    [groups addObject: group];
    [group release];
}

- (Group*) getGroupAtIndex: (NSUInteger) index
{
    return [groups objectAtIndex: index];
}

- (NSUInteger) getGroupIndexContainingImageIndex: (NSUInteger) index
{
    // TODO
    // browse through groups and return group index containing said index
    int i = 0;
    for(i = 0; i < [groups count]; ++i){
        if([[groups objectAtIndex: i] containsImageIndex: index]){
            return i;
        }
    }
    return 0;
}

- (Group*) getGroupContainingImageIndex: (NSUInteger) index
{
    NSUInteger idx = [self getGroupIndexContainingImageIndex: index];
    return [self getGroupAtIndex: idx];
}

- (NSIndexSet*) getGroupsIndicesContainingImagesIndices: (NSIndexSet*) indices
{
    // TODO
    NSMutableIndexSet* indexSet = [[NSMutableIndexSet alloc] init];
    int i = 0;
    for(i = 0; i < [groups count]; ++i){
        if([[groups objectAtIndex: i] containsImagesIndices: indices]){
            [indexSet addIndex: i];
        }
    }
    return [indexSet autorelease];
}

- (void) ungroupItemAtIndices: (NSIndexSet*) indices
{
    NSIndexSet* local = [self getGroupsIndicesContainingImagesIndices: indices];
    [local enumerateIndexesUsingBlock: ^(NSUInteger idx, BOOL *stop) {
        Group* group = [groups objectAtIndex: idx];
        if([group containsAll: indices]){
	    // TODO undo
            [groups removeObjectAtIndex: idx];
        } else {
	    // TODO undo
            [group removeItemAtIndices: indices];
        }
    }];
}

- (NSArray*) detectPanoramas
{
    // TODO 
    // add preference for time diff between images
    NSTimeInterval tolerance = 8;
    // collect groups indexset
    NSMutableIndexSet* groupsIndexSet = [[NSMutableIndexSet alloc] init];
    for(Group* group in groups){
        [groupsIndexSet addIndexesInRange: [group range]];
    }
    NSMutableArray* panoramas = [[NSMutableArray alloc] init];
    NSUInteger n = [images count];
    NSUInteger times[n];
    Group* current_group = nil;
    // browse all images
    int i = 0;
    times[0] = 0;
    for(i = 1; i < [images count]; ++i){
        NSUInteger time_i_1 = [[images objectAtIndex: (i - 1)] dateAsSeconds];
        NSUInteger time_i = [[images objectAtIndex: i] dateAsSeconds];
        times[i] = time_i - time_i_1;
        NSLog(@"times[%d] : %lu", i, times[i]);
        if(times[i] > tolerance){
	    if(current_group != nil){
            [panoramas addObject: current_group];
            [current_group release];
            current_group = nil;
	    }
        } else {
	    if(! [groupsIndexSet containsIndex: i] && ! [groupsIndexSet containsIndex: (i - 1)]){
		if(current_group == nil){
		    //current_group = [[Group alloc] initWithRange: NSMakeRange((i - 1), 2)];
            current_group = [[Group alloc] init];
            [current_group setRange: NSMakeRange((i - 1), 2)];
		    [current_group setCategory: @"pano"];
		    [current_group setName: @""];
		} else {
		    [current_group setLength: [current_group length] + 1];
		}
	    }
	}
    }
    // TODO undo
    [groups addObjectsFromArray: panoramas];
    
    [groupsIndexSet release];
    return [panoramas autorelease];
}

- (void) addGroup: (Group*) group
{
    [groups addObject: group];
}

- (void) removeGroup: (Group*) group
{
    [groups removeObject: group];
}

@end
