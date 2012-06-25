//
//  DateLister.m
//  Chevre
//
//  Created by Matthieu DESILE on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DateLister.h"

@implementation DateLister

- (id) init
{
    if(self = [super init]){
    }
    return self;
}

- (NSArray*) getDatesInPath: (NSString*) _path
{
    NSFileManager* fm = [NSFileManager defaultManager];
    NSURL* base = [NSURL fileURLWithPath: _path];
    NSDirectoryEnumerator* de = [fm enumeratorAtURL: base
                         includingPropertiesForKeys:[NSArray arrayWithObjects: NSURLIsDirectoryKey, nil]
                                            options: NSDirectoryEnumerationSkipsHiddenFiles
                                       errorHandler: nil];
    NSMutableArray* newDates = [[NSMutableArray alloc] init];
    NSArray* content;
    
    // so we can return to the base directory
    [self addDepotPath: newDates];
    
    NSURL* filename;
    NSString* path;
    BOOL match;
    NSNumber* isDir;
    while (filename = [de nextObject]){
        path = [filename path];
        match = [path matchRegex: @".*[0-9]{4}\/[0-9]{2}\/[0-9]{2}"];
        [filename getResourceValue: &isDir forKey: NSURLIsDirectoryKey error: nil];
        if(match && [isDir boolValue] == YES){
            content = [fm contentsOfDirectoryAtURL: filename 
                        includingPropertiesForKeys: nil 
                                           options: NSDirectoryEnumerationSkipsHiddenFiles
                                             error: nil];
            if( [content count] != 0){
                [newDates addObject: [NSDictionary dictionaryWithObjectsAndKeys: 
                                      filename, @"url", 
                                      path, @"name", nil]];
            }
        }
    }
    return [newDates autorelease];
}

- (NSMutableArray*) addDepotPath: (NSMutableArray*) anArray
{
    NSString* path = [[NSUserDefaults standardUserDefaults] stringForKey: @"depot"];
    NSURL* basePath = [NSURL fileURLWithPath: path];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys: basePath, @"url", @"/vrac", @"name", nil];
    [anArray addObject: dict];
    return anArray;
}

@end
