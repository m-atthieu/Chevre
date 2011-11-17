//
//  Image.h
//  Chevre
//
//  Created by Matthieu DESILE on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// IKBBrowserItem
@interface Image : NSObject

@property (retain) NSURL* url;
@property (retain) NSString* date;
@property (retain) NSString* time;

- (id) initWithURL: (NSURL*) url;
- (void) readEXIF;

/* IKBrowserItem Protocol */
- (id) imageRepresentation;
- (NSString *) imageRepresentationType;
- (NSString *) imageSubtitle;
- (NSString *) imageTitle;
- (NSString *) imageUID;
- (NSTimeInterval) dateAsSeconds;

@end
