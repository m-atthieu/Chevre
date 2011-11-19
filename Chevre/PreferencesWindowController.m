//
//  PreferencesWindowController.m
//  Chevre
//
//  Created by Matthieu DESILE on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PreferencesWindowController.h"

@implementation PreferencesWindowController

@synthesize depot, depotTextField, base, baseTextField, categories;
@synthesize panoramaDelay;
@synthesize panoramaDelayTextField;
//@synthesize window;
@synthesize defaults;

- (id) init
{
    self = [super initWithWindowNibName: @"PreferencesWindow" owner: self];
    if (self) {
        [self setDefaults: [NSUserDefaults standardUserDefaults]];
        self.panoramaDelay = [defaults integerForKey: @"panoramaDelay"];
	if(self.panoramaDelay == 0){
	    self.panoramaDelay = 10;
	}
        self.depot = [defaults stringForKey: @"depot"];
        self.base = [defaults stringForKey: @"base"];
    }
    return self;
}

- (void) windowDidLoad
{
    [super windowDidLoad];
    //[window setDelegate: self];
}

- (void) awakeFromNib 
{
    if(base != nil){ [baseTextField setStringValue: base]; }
    if(depot != nil){ [depotTextField setStringValue: depot]; }
    [panoramaDelayTextField setIntegerValue: panoramaDelay];
}

- (void) browserForField: (NSTextField*) field forKey: (NSString*) key
{
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles: NO];
    [panel setCanChooseDirectories:YES];
    NSString* name = nil;
    if ( [panel runModal] == NSOKButton ){
        name = [[panel directoryURL] path];
    }
    [defaults setValue: name forKey: key];
    [field setStringValue: name];
}

- (IBAction) depotBrowse: (id) sender 
{
    [self browserForField: self.depotTextField forKey: @"depot"];
}

- (IBAction) baseBrowse: (id) sender 
{
    [self browserForField: self.baseTextField forKey: @"base"];
}

#pragma mark - 
#pragma mark window delegate

- (void) windowWillClose: (NSNotification *) notification
{
    // save defaults
    // paths are already saved
    NSNumber* delay = [NSNumber numberWithInt: [panoramaDelayTextField intValue]];
    [defaults setValue: delay forKey: @"panoramaDelay"];
}

@end
