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

- (id) init
{
    self = [super initWithWindowNibName: @"PreferencesWindow" owner: self];
    if (self) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        self.depot = [defaults stringForKey: @"depot"];
        self.base = [defaults stringForKey: @"base"];
    }
    return self;
}

- (void) windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void) awakeFromNib 
{
    if(base != nil){
        [baseTextField setStringValue: base];
    }
    
    if(depot != nil){
        [depotTextField setStringValue: depot];
    }
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
    [[NSUserDefaults standardUserDefaults] setValue: name forKey: key];
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


@end
