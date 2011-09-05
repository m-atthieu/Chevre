//
//  BrowserView.m
//  Chevre
//
//  Created by Matthieu DESILE on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BrowserViewController.h"

@implementation BrowserViewController

@synthesize browserView, datasource, directoryPopup, panel, nameTextField, categoryPopup, slider;

- (id) init
{
    self = [super init];
    if (self) {
        NSString* depot = [[NSUserDefaults standardUserDefaults] valueForKey: @"depot"];
        if(depot != nil){
            NSURL* url = [NSURL URLWithString: depot];
            [self setDatasource: [[Datasource alloc] initWithURL: url]];
        }
    }
    return self;
}

- (void) awakeFromNib
{
    [browserView setAnimates: YES];
    [browserView setAllowsReordering: NO];
    [browserView setCellsStyleMask: IKCellsStyleTitled | IKCellsStyleSubtitled];
    
    [self updateSize: nil];

    [browserView setDelegate: self];
    [browserView setDataSource: datasource];
    [browserView reloadData];
    
    [self emptyPanel];
}

- (void) updateDatasource: (Datasource*) aDatasource
{
    [self setDatasource: aDatasource];
    [browserView setDataSource: aDatasource];
    [browserView reloadData];
}

- (void) dealloc
{
    [datasource release];
    [super dealloc];
}

#pragma mark -
#pragma mark IKImageBrowserDelegate : Performing Custom Tasks in Response to User Events
- (void) imageBrowser: (IKImageBrowserView *) aBrowser backgroundWasRightClickedWithEvent: (NSEvent *) event
{
}

- (void) imageBrowser: (IKImageBrowserView *) aBrowser cellWasDoubleClickedAtIndex: (NSUInteger) index
{
}

- (void) imageBrowser: (IKImageBrowserView *) aBrowser cellWasRightClickedAtIndex: (NSUInteger) index withEvent: (NSEvent *) event
{
}

- (void) imageBrowserSelectionDidChange: (IKImageBrowserView *) aBrowser
{
}

#pragma mark -
#pragma mark Selection Handling
- (void) groupSelection
{
    if([[browserView selectionIndexes] count] != 0){
        [panel makeKeyAndOrderFront: nil];
    }
}

- (IBAction) createGroup: (id) sender
{
    // TODO ouvrir la fenêtre pour donner les indications de groupe
    NSString* name = [nameTextField stringValue];
    NSString* category = [[categoryPopup selectedItem] title];
    [datasource addGroupWithName: name andCategory: category withIndex: [browserView selectionIndexes]];
    [panel orderOut: nil];
    [self emptyPanel];
    [browserView reloadData];
}

- (IBAction) cancelCreateGroup: (id) sender
{
    [panel orderOut: nil];
    [self emptyPanel];
}

- (void) emptyPanel
{
    // TODO ? option pour reseter le nom ?
    [nameTextField setStringValue: @""];
    // TODO ? option pour reseter le popup ?
    [categoryPopup selectItemAtIndex: 0];
}

- (IBAction) updateSize: (id) sender
{
    CGFloat size = [slider floatValue] / 256;
    [browserView setZoomValue: size];
}

@end
