//
//  Image.m
//  Chevre
//
//  Created by Matthieu DESILE on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Quartz/Quartz.h>

#import "Image.h"

@implementation Image

@synthesize url, date, time;

#pragma mark -
#pragma mark initialisation

- (id) initWithURL: (NSURL*) anURL
{
    self = [super init];
    if (self) {
        [self setUrl: anURL];
        // TODO lire les exifs
        [self readEXIF];
    }
    
    return self;
}

#pragma mark -
#pragma mark IKImageBrowserItem : Providing Required Information for an Image

- (id) imageRepresentation
{
    return url;
}

- (NSString *) imageRepresentationType
{
    return IKImageBrowserNSURLRepresentationType;
}

- (NSString *) imageUID
{
    return [url lastPathComponent];
}

#pragma mark -
#pragma mark IKImageBrowserItem : Providing Required Information for an Image

- (NSString *) imageSubtitle
{
    // TODO
    return [NSString stringWithFormat: @"%@ %@", date, time];
}

- (NSString *) imageTitle
{
    return [url lastPathComponent];
}

#pragma mark -
#pragma mark Utilities

- (void) readEXIF
{
    CGImageSourceRef source = CGImageSourceCreateWithURL( (CFURLRef) self.url, NULL);
    NSDictionary *metadata = (NSDictionary *) CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
    CFRelease(source);
    NSDictionary *EXIFDictionary = [[metadata objectForKey:(NSString *) kCGImagePropertyExifDictionary] autorelease];
    
    NSArray* components = [[EXIFDictionary valueForKey: @"DateTimeOriginal"] componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    [self setDate: [[components objectAtIndex: 0] stringByReplacingOccurrencesOfString: @":" withString: @"/"]];
    [self setTime: [components objectAtIndex: 1]];
    //NSLog(@"exif : %@ : %@", date, time);
}

- (NSTimeInterval) dateAsSeconds
{
    // since I consider I can not have two pictures taken the same day athe same 
    // time with two different timezone...
    //NSDate* _date = [NSDate dateWithString: [NSString stringWithFormat: @"%@ %@ +0100", date, time]];
    NSDate* _date = [NSDate dateWithNaturalLanguageString: [NSString stringWithFormat: @"%@ %@", date, time]];
    return [_date timeIntervalSince1970];
}

@end
