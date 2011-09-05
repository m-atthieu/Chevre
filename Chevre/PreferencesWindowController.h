//
//  PreferencesWindowController.h
//  Chevre
//
//  Created by Matthieu DESILE on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesWindowController : NSWindowController

@property (retain) IBOutlet NSString* base;
@property (assign) IBOutlet NSTextField* baseTextField;
@property (assign) IBOutlet NSString* depot;
@property (assign) IBOutlet NSTextField* depotTextField;
@property (retain) IBOutlet NSMutableArray* categories;

- (IBAction) depotBrowse: (id) sender;
- (IBAction) baseBrowse: (id) sender;

@end
