//
//  ImagesDatasource.h
//  Chevre
//
//  Created by Matthieu DESILE on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

#import "Group.h"

@interface Datasource : NSObject

@property (retain) NSMutableArray* groups;
@property (retain) NSMutableArray* images;

#pragma mark -
#pragma mark Initialization
/*!
 *
 */
- (id) initWithURL: (NSURL*) url;
/*!
 *
 */
- (void) scanURL: (NSURL*) anURL;

#pragma mark -
#pragma mark IKImageBrowserDataSource
/*!
 *
 */
- (NSDictionary *) imageBrowser: (IKImageBrowserView*) aBrowser groupAtIndex: (NSUInteger) index;
/*!
 *
 */
- (id) imageBrowser: (IKImageBrowserView*) aBrowser itemAtIndex: (NSUInteger) index;
/*!
 *
 */
- (BOOL) imageBrowser: (IKImageBrowserView*) aBrowser moveItemsAtIndexes: (NSIndexSet*) indexes toIndex: (NSUInteger) destinationIndex;
/*!
 *
 */
- (void) imageBrowser: (IKImageBrowserView*) aBrowser removeItemsAtIndexes: (NSIndexSet*) indexes;
/*!
 *
 */
- (NSUInteger) numberOfGroupsInImageBrowser: (IKImageBrowserView*) aBrowser;
/*!
 *
 */
- (NSUInteger) numberOfItemsInImageBrowser: (IKImageBrowserView*) aBrowser;

#pragma mark -
#pragma mark Grouping
- (void) addGroupWithName: (NSString*) name andCategory: (NSString*) category withIndex: (NSIndexSet*) index;
/*!
 * 
 */
- (Group*) getGroupAtIndex: (NSUInteger) index;
/*!
 *
 */
- (void) removeGroupsAtIndexes: (NSIndexSet *) indexes;
/*!
 *
 */
- (NSUInteger) getGroupIndexContainingImageIndex: (NSUInteger) index;
/*!
 * 
 */
- (Group*) getGroupContainingImageIndex: (NSUInteger) index;
/*!
 *
 */
- (NSIndexSet*) getGroupsIndicesContainingImagesIndices: (NSIndexSet*) indices;
/*!
 *
 */
- (void) ungroupItemAtIndices: (NSIndexSet*) indices;
- (NSArray*) detectPanoramas;

@end
