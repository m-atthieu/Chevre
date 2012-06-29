//
//  PreviewWindowController.h
//  Chevre
//
//  Created by Matthieu DESILE on 9/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Datasource.h"

@interface PreviewWindowController : NSWindowController

@property (assign) IBOutlet NSArrayController* arrayController;
@property (retain) NSMutableArray* images;

- (id) initWithDatasource: (Datasource*) datasource;
- (id) initWithArray: (NSArray*) anArray;

- (IBAction) commit: (id) sender;

@end
