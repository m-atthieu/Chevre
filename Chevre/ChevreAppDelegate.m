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

- (void) applicationDidFinishLaunching: (NSNotification *) aNotification
{
    DateLister* dl = [[DateLister alloc] init];
    NSString* path = [[NSUserDefaults standardUserDefaults] stringForKey: @"depot"];
    dates = [dl getDatesInPath: path];
    NSLog(@"%@", dates);
    [dl release];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(preferencesChanged:) 
                                                 name: @"PreferencesMightHaveChanged"
                                               object: nil];

}

- (void) awakeFromNib
{
    [browserViewController setUndoManager: [[window firstResponder] undoManager]];
}

- (IBAction) openPreferencesWindow: (id) sender
{
    NSWindowController* wc = [[PreferencesWindowController alloc] init];
    [wc showWindow: self];
    //[wc autorelease];
}

- (IBAction) openPreviewWindow: (id) sender
{
    NSWindowController* wc = [[PreviewWindowController alloc] initWithDatasource: [browserViewController datasource]];
    [wc showWindow: self];
}

/* quand la date dans la liste déroulante est changée */
- (IBAction) changeDate: (id) sender
{
    NSURL* url = [[datesController selection] valueForKey: @"url"];
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

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [super dealloc];
}

@end
