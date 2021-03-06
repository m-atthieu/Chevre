//
//  BrowserView.m
//  Chevre
//
//  Created by Matthieu DESILE on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BrowserViewController.h"
#import "Image.h"

@implementation BrowserViewController

@synthesize browserView; 
@synthesize datasource;
@synthesize panel;
@synthesize nameTextField;
@synthesize categoryPopup;
@synthesize slider;
@synthesize undoManager;
@synthesize editPanel;
@synthesize editNameTextField;
@synthesize editCategoryPopup;

#pragma mark -
#pragma mark Initialization
- (id) init
{
    self = [super init];
    if (self) {
        // undo manager get set by the window controller
        //[self setUndoManager: [[NSUndoManager alloc] init]];

        NSString* depot = [[NSUserDefaults standardUserDefaults] valueForKey: @"depot"];
        if(depot != nil){
            NSURL* url = [NSURL fileURLWithPath: depot];
            Datasource* tDatasource = [[Datasource alloc] initWithURL: url];
            [tDatasource setUndoManager: [self undoManager]];
            [self setDatasource: tDatasource];
            [tDatasource release];
        }
        
    }
    return self;
}

- (void) awakeFromNib
{
    [browserView setAnimates: YES];
    [browserView setAllowsReordering: NO];
    [browserView setCellsStyleMask: IKCellsStyleTitled | IKCellsStyleSubtitled];
    
    //[self updateSize: nil];

    [browserView setDelegate: self];
    [browserView setDataSource: datasource];
    [browserView reloadData];
    
    [self emptyPanel];
}

- (void) updateDatasource: (Datasource*) aDatasource
{
    [aDatasource setUndoManager: [self undoManager]];
    [datasource release];
    datasource = [aDatasource retain];
    [browserView setDataSource: aDatasource];
    [browserView reloadData];
}

- (void) dealloc
{
    [datasource release];
    [undoManager release];
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

- (IBAction) groupSelection: (id) sender
{
    if([[browserView selectionIndexes] count] != 0){
        [panel makeKeyAndOrderFront: nil];
    }
}

- (IBAction) createGroup: (id) sender
{
    NSString* name = [nameTextField stringValue];
    NSString* category = [[categoryPopup selectedItem] title];
    // TODO undo
    Group* group = [[Group alloc] initWithName: name andCategory: category withIndex: [browserView selectionIndexes]];
    
    [undoManager beginUndoGrouping];
    [[undoManager prepareWithInvocationTarget: browserView] reloadData];
    [[undoManager prepareWithInvocationTarget: datasource] removeGroup: group];
    [undoManager setActionName: @"Add Group"];
    [undoManager endUndoGrouping];
    
    [datasource addGroup: group];
    [group release];
    [panel orderOut: nil];
    [self emptyPanel];
    [browserView reloadData];
}

- (IBAction) deleteGroupAtSelection: (id) sender
{
    // retreive groups indices matching selection 
    NSIndexSet* selection = [browserView selectionIndexes];
    NSIndexSet* groups = [datasource getGroupsIndicesContainingImagesIndices: selection];
    // TODO undo
    [datasource removeGroupsAtGroupsIndexes: groups];
    [browserView reloadData];
}

- (IBAction) ungroupSelection: (id) sender
{
    // TODO 
    // retreive group indices matching selection
    NSIndexSet* selection = [browserView selectionIndexes];
    // reduce selection range from start image indice till end of range
    // TODO undo
    [datasource ungroupItemAtIndices: selection];
    [browserView reloadData];
}

- (IBAction) addSelectionToGroup: (id) sender
{
    NSIndexSet* selection = [browserView selectionIndexes];
    NSIndexSet* groups = [datasource getGroupsIndicesContainingImagesIndices: selection];
    if([groups count] == 1){
        Group* group = [datasource getGroupAtIndex: [groups firstIndex]];
        // TODO undo
        [group addItemsWithIndices: selection];
        [browserView reloadData];
    }
}

- (IBAction) cancelCreateGroup: (id) sender
{
    [panel orderOut: nil];
    [self emptyPanel];
}

- (IBAction) cancelEditGroup: (id) sender
{
    [editPanel orderOut: nil];
}

- (IBAction) editGroupAtSelection: (id) sender
{
    // WARNING : I only take the group under the first selected item
    NSIndexSet* selection = [browserView selectionIndexes];
    NSUInteger groupIndex = [selection firstIndex];
    Group* group = [datasource getGroupContainingImageIndex: groupIndex];
    [editNameTextField setStringValue: [group name]];
    // TODO : select group category
    int i = 0;
    for(i = 0; i < [editCategoryPopup numberOfItems]; ++i){
        if([[[editCategoryPopup itemAtIndex: i] title] isEqualToString: [group category]]){
            [editCategoryPopup selectItemAtIndex: i];
        }
    }
    [editPanel makeKeyAndOrderFront: nil];
}

- (IBAction) editGroup: (id) sender
{
    NSIndexSet* selection = [browserView selectionIndexes];
    NSUInteger groupIndex = [selection firstIndex];
    Group* group = [datasource getGroupContainingImageIndex: groupIndex];
    // TODO undo
    [group setName: [editNameTextField stringValue]];
    [group setCategory: [[editCategoryPopup selectedItem] title]];
    [editPanel orderOut: nil];
    [browserView reloadData];
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

- (IBAction) detectPanoramas: (id) sender
{
    // TODO submit acceptance ?
    [undoManager beginUndoGrouping];
    [[undoManager prepareWithInvocationTarget: browserView] reloadData];

    NSArray* added = [datasource detectPanoramas];
    [[undoManager prepareWithInvocationTarget: datasource] removeGroups: added];
    [undoManager setActionName: @"Detect panoramas"];
    [undoManager endUndoGrouping];
    [browserView reloadData];
}

- (NSArray*) selectedImages
{
    NSIndexSet* indices = [browserView selectionIndexes];
    NSMutableArray* selection = [[NSMutableArray alloc] initWithCapacity: [indices count]];
    Image* image;
    int i = [indices firstIndex];
    int n = [indices lastIndex];
    for(; i <= n; ++i){
        image = [datasource imageBrowser: nil itemAtIndex: i];
        [selection addObject: image];
    }
    return [selection autorelease];
}

@end
