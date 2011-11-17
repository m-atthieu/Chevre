//
//  Group.h
//  Chevre
//
//  Created by Matthieu DESILE on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Group : NSObject

@property (retain) NSString* name;
@property (retain) NSString* category;
@property NSRange range;

- (id) init;
- (id) initWithRange: (NSRange) range;
- (id) initWithName: (NSString*) name andCategory: (NSString*) category withIndex: (NSIndexSet*) indexes;

- (NSUInteger) start;
- (void) setStart: (NSUInteger) start;

- (NSUInteger) end;
- (void) setEnd: (NSUInteger) end;

- (NSUInteger) length;
- (void) setLength: (NSUInteger) length;

/*
 * Dictionnary keys :
 * - IKImageBrowserGroupStyle
 * - IKImageBrowserGroupBackgroundColorKey
 * - IKImageBrowserGroupTitleKey
 * - IKImageBrowserGroupRangeKey
 */
- (NSDictionary*) asNSDictionnary;

/*!
 *
 */
- (BOOL) containsImageIndex: (NSUInteger) index;
/*!
 *
 */
- (BOOL) containsImagesIndices: (NSIndexSet*) indices;
/*!
 *
 */
- (BOOL) containsAll: (NSIndexSet*) indices;
/*!
 *
 */
- (void) removeItemAtIndices: (NSIndexSet*) indices;
/*!
 *
 */
- (void) addItemsWithIndices: (NSIndexSet*) indices;
@end
