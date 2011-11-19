//
//  PreferencesWindowController.h
//  Chevre
//
//  Created by Matthieu DESILE on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesWindowController : NSWindowController <NSWindowDelegate>

//@property (retain) IBOutlet NSWindow* window;
@property (assign) IBOutlet NSTextField* baseTextField;
@property (assign) IBOutlet NSTextField* depotTextField;
@property (retain) IBOutlet NSMutableArray* categories;
@property (retain) IBOutlet NSTextField *panoramaDelayTextField;

@property (retain) NSString* base;
@property (assign) NSString* depot;
@property NSUInteger panoramaDelay;

@property (retain) NSUserDefaults* defaults;

- (IBAction) depotBrowse: (id) sender;
- (IBAction) baseBrowse: (id) sender;

@end
