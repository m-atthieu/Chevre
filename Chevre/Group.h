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

/*
 * Dictionnary keys :
 * - IKImageBrowserGroupStyle
 * - IKImageBrowserGroupBackgroundColorKey
 * - IKImageBrowserGroupTitleKey
 * - IKImageBrowserGroupRangeKey
 */
- (NSDictionary*) asNSDictionnary;

@end