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

@implementation PreviewWindowController

@synthesize datasource, arrayController, images;

- (id) initWithDatasource: (Datasource *) aDatasource
{
    self = [super initWithWindowNibName: @"PreviewWindow" owner: self];
    if (self) {
        [self setDatasource: aDatasource];
        images = [[NSMutableArray alloc] initWithCapacity: [aDatasource numberOfItemsInImageBrowser: nil]];
        [self prepareDatasource];
    }
    
    return self;
}

- (void) prepareDatasource
{
    NSString* base = [[NSUserDefaults standardUserDefaults] valueForKey: @"base"];
    int i;
    NSUInteger j;
    Group* group;
    NSRange range;
    Image* image;
    
    for (i = 0; i < [datasource numberOfGroupsInImageBrowser: nil]; ++i) {
        group = [datasource getGroupAtIndex: i];
        range = [group range];
        for(j = range.location; j < (range.location + range.length); ++j){
            image = [datasource imageBrowser: nil itemAtIndex: j];
            NSString* to = [NSString pathWithComponents: [NSArray arrayWithObjects: base, [group category], [image date], [group name], [[image url] lastPathComponent], nil]];
            NSURL* toURL = [NSURL URLWithString: [@"file://localhost" stringByAppendingString: to]];
            
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
