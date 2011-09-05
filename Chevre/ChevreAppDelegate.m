//
//  ChevreAppDelegate.m
//  Chevre
//
//  Created by Matthieu DESILE on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChevreAppDelegate.h"
#import "Datasource.h"
#import "PreferencesWindowController.h"
#import "PreviewWindowController.h"
#import "NSString+regex.h"

@implementation ChevreAppDelegate

@synthesize window, browserViewController, dates, datesController;

- (void) applicationDidFinishLaunching: (NSNotification *) aNotification
{
    dates = [self getDates];
}

- (IBAction) openPreferencesWindow: (id) sender
{
    NSWindowController* wc = [[PreferencesWindowController alloc] init];
    [wc showWindow: sender];
}

- (IBAction) groupSelection: (id) sender
{
    [browserViewController groupSelection];
}

- (IBAction) openPreviewWindow: (id) sender
{
    NSWindowController* wc = [[PreviewWindowController alloc] initWithDatasource: [browserViewController datasource]];
    [wc showWindow: sender];
}


- (NSArray*) getDates
{
    NSFileManager* fm = [NSFileManager defaultManager];
    NSString* depot = [[NSUserDefaults standardUserDefaults] valueForKey: @"depot"];
    NSURL* base = [NSURL URLWithString: depot];
    NSDirectoryEnumerator* de = [fm enumeratorAtURL: base
                         includingPropertiesForKeys:[NSArray arrayWithObjects: NSURLIsDirectoryKey, nil]
                                            options: NSDirectoryEnumerationSkipsHiddenFiles
                                       errorHandler: nil];
    NSMutableArray* newDates = [[NSMutableArray alloc] init];
    
    NSURL* filename;
    NSString* path;
    BOOL match;
    NSNumber* isDir;
    while (filename = [de nextObject]){
        path = [filename path];
        match = [path matchRegex: @".*[0-9]{4}\/[0-9]{2}\/[0-9]{2}"];
        [filename getResourceValue: &isDir forKey: NSURLIsDirectoryKey error: nil];
        if(match && [isDir boolValue] == YES){
            [newDates addObject: [NSDictionary dictionaryWithObjectsAndKeys: 
                                              filename, @"url", 
                                              path, @"name", nil]];
        }
    }

    return newDates;
}

- (IBAction) changeDate: (id) sender
{
    NSURL* url = [[datesController selection] valueForKey: @"url"];
    [browserViewController updateDatasource: [[Datasource alloc] initWithURL: url]];
}

@end
