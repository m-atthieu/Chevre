//
//  ChevreAppDelegate.m
//  Chevre
//
//  Created by Matthieu DESILE on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChevreAppDelegate.h"
#import "Datasource.h"
#import "DateLister.h"
#import "PreferencesWindowController.h"
#import "PreviewWindowController.h"
#import "NSString+regex.h"

@implementation ChevreAppDelegate

@synthesize window, browserViewController, dates, datesController;
@synthesize directoryPopup;


/**
 * depot : répertoire dans lequel les photos sont en vrac
 * base  : répertoire dans lequel mettre les images une fois triées
 */
+ (void) initialize
{
    /* get/set defaults */
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* defaultValues = [NSDictionary dictionaryWithObjectsAndKeys: 
                                   @"~/Pictures", @"depot", 
                                   @"~/Pictures", @"base", nil];
    [defaults registerDefaults: defaultValues];
}

- (void) updateDatesController
{
    DateLister* dl = [[DateLister alloc] init];
    NSString* path = [[NSUserDefaults standardUserDefaults] stringForKey: @"depot"];
    [self willChangeValueForKey: @"dates"];
    dates = [dl getDatesInPath: path];
    [self didChangeValueForKey: @"dates"];
    [dl release];
}

- (void) applicationDidFinishLaunching: (NSNotification *) aNotification
{
    NSLog(@"finish loading");
    [self updateDatesController];
    //NSLog(@"finish : %@", dates);
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(preferencesChanged:) 
                                                 name: @"PreferencesMightHaveChanged"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(datasourceChanged:)
                                                 name: @"DatasourceMightHaveChanged"
                                               object: nil];

}

- (void) awakeFromNib
{
    NSLog(@"awake");
    [browserViewController setUndoManager: [[window firstResponder] undoManager]];
    [datesController setContent: dates];
    //[directoryPopup bind
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed: (NSApplication *) theApplication
{
    return YES;
}


- (IBAction) openPreferencesWindow: (id) sender
{
    NSWindowController* wc = [[PreferencesWindowController alloc] init];
    [wc showWindow: self];
    //[wc autorelease];
}

- (IBAction) openPreviewWindow: (id) sender
{
    Datasource* datasource = [browserViewController datasource];
    NSWindowController* wc = [[PreviewWindowController alloc] initWithDatasource: datasource];
    [wc showWindow: self];
}

- (IBAction) sortSelectedByDate: (id) sender
{
    // check we're in @"depot"
    id selectedDate = [datesController selection];
    NSString* name = [selectedDate valueForKey: @"name"];
    if(! [name isEqualToString: @"/vrac"]) {
        return;
    }
    // only for selected images
    NSArray* selection = [browserViewController selectedImages];
    NSWindowController* wc = [[PreviewWindowController alloc] initWithArray: selection];
    [wc showWindow: self];
}

/* quand la date dans la liste déroulante est changée */
- (IBAction) changeDate: (id) sender
{
    id selection = [datesController selection];
    NSURL* url = [selection valueForKey: @"url"];
    Datasource* datasource = [[Datasource alloc] initWithURL: url];
    NSUndoManager* undoManager = [[window firstResponder] undoManager];
    [datasource setUndoManager: undoManager];
    [browserViewController updateDatasource: datasource];
    [datasource release];
}

- (void) preferencesChanged: (NSNotification *) notification
{
    if ([[notification name] isEqualToString: @"PreferencesMightHaveChanged"]){
        NSLog(@"preferences changed ?");
    }
}

- (void) datasourceChanged: (NSNotification*) aNotification
{
    if ([[aNotification name] isEqualToString: @"DatasourceMightHaveChanged"]){
        NSLog(@"datasource changed ?");
        [self updateDatesController];
        [self changeDate: nil];
    }
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [super dealloc];
}

@end
