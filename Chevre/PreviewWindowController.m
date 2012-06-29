//
//  PreviewWindowController.m
//  Chevre
//
//  Created by Matthieu DESILE on 9/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "Group.h"
#import "Image.h"
#import "PreviewWindowController.h"

@interface PreviewWindowController (private)

- (void) prepareArray: (NSArray*) anArray;
- (void) prepareDatasource: (Datasource*) aDatasource;

@end

@implementation PreviewWindowController

@synthesize arrayController, images;

- (id) initWithDatasource: (Datasource *) aDatasource
{
    self = [super initWithWindowNibName: @"PreviewWindow" owner: self];
    if (self) {
        images = [[NSMutableArray alloc] initWithCapacity: [aDatasource numberOfItemsInImageBrowser: nil]];
        [self prepareDatasource: aDatasource];
    }
    
    return self;
}

- (id) initWithArray: (NSArray *) anArray
{
    self = [super initWithWindowNibName: @"PreviewWindow" owner: self];
    if(self){
        images = [[NSMutableArray alloc] initWithCapacity: [anArray count]];
        [self prepareArray: anArray];
    }
    return self;
}

- (void) prepareArray: (NSArray *) anArray
{
    NSString* depot = [[NSUserDefaults standardUserDefaults] valueForKey: @"depot"];
    int i;
    Image* image;
    
    for (i = 0; i < [anArray count]; ++i) {
        image = [anArray objectAtIndex: i];
        NSString* to = [NSString pathWithComponents: [NSArray arrayWithObjects: depot, [image date], [[image url] lastPathComponent], nil]];
        NSURL* toURL = [NSURL fileURLWithPath: to];
            
        [images addObject: [NSDictionary dictionaryWithObjectsAndKeys: 
                                [image url], @"from", 
                                toURL, @"to", nil]];
    }
}

- (void) prepareDatasource: (Datasource*) aDatasource
{
    NSString* base = [[NSUserDefaults standardUserDefaults] valueForKey: @"base"];
    int i;
    NSUInteger j;
    Group* group;
    NSRange range;
    Image* image;
    
    for (i = 0; i < [aDatasource numberOfGroupsInImageBrowser: nil]; ++i) {
        group = [aDatasource getGroupAtIndex: i];
        range = [group range];
        for(j = range.location; j < (range.location + range.length); ++j){
            image = [aDatasource imageBrowser: nil itemAtIndex: j];
            NSString* to = [NSString pathWithComponents: [NSArray arrayWithObjects: base, [group category], [image date], [group name], [[image url] lastPathComponent], nil]];
            NSURL* toURL = [NSURL fileURLWithPath: to];
            
            [images addObject: [NSDictionary dictionaryWithObjectsAndKeys: 
                                [image url], @"from", 
                                toURL, @"to", nil]];
        }
    }
}

- (void) awakeFromNib
{
    //NSLog(@"images : %@", images);
}

- (void) windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction) commit: (id) sender
{
    NSFileManager* fm = [NSFileManager defaultManager];
    NSURL* to;
    NSError* error = nil;
    NSURL* directory;
    for(NSDictionary* file in images){
        to = [file valueForKey: @"to"];
        directory = [to URLByDeletingLastPathComponent];
#if MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_6
        [fm createDirectoryAtURL: directory withIntermediateDirectories: YES attributes: nil error: &error];
#else
        [fm createDirectoryAtPath: [directory path] withIntermediateDirectories: YES attributes: nil error: &error];
#endif
        if(error != nil){ NSLog(@"error creating %@: %@", directory, [error localizedDescription]); continue; }
        [fm moveItemAtURL: [file valueForKey: @"from"] toURL: to error: &error];
        if(error != nil){ NSLog(@"error moving %@: %@", [file valueForKey: @"from"], [error localizedDescription]); continue; }
    }
    [self close];
}

@end
