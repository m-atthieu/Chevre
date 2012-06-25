//
//  DateLister.h
//  Chevre
//
//  Created by Matthieu DESILE on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateLister : NSObject
- (id) init;
- (NSArray*) getDatesInPath: (NSString*) path;
@end
