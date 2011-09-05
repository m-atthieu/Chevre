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
            [images addObject: [[Image alloc] initWithURL: file]];
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

@end
