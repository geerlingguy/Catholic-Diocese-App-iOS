//
//  CHCSVSupport.m
//  CHCSVParser
/**
 Copyright (c) 2010 Dave DeLong
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 **/

#import "CHCSVSupport.h"


@implementation NSArrayCHCSVAggregator
@synthesize lines, error;


- (void) parser:(CHCSVParser *)parser didStartDocument:(NSString *)csvFile {
	lines = [[NSMutableArray alloc] init];
}

- (void) parser:(CHCSVParser *)parser didStartLine:(NSUInteger)lineNumber {
	currentLine = [[NSMutableArray alloc] init];
}

- (void) parser:(CHCSVParser *)parser didEndLine:(NSUInteger)lineNumber {
	if ([currentLine count] > 0) {
		[lines addObject:currentLine];
	}
	currentLine = nil;
}

- (void) parser:(CHCSVParser *)parser didReadField:(NSString *)field {
	[currentLine addObject:field];
}

- (void) parser:(CHCSVParser *)parser didEndDocument:(NSString *)csvFile {
	
}

- (void) parser:(CHCSVParser *)parser didFailWithError:(NSError *)anError {
	error = anError;
}

@end