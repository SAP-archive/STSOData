//
//  STSODataEntity.m
//  SMP3ODataAPI
//
//  Created by Stadelman, Stan on 6/5/14.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import "STSODataComplex.h"

#import "SODataProperty.h"

@implementation STSODataComplex

- (instancetype) initWithComplex:(NSDictionary *)complex
{
    if (self == [super init]) {
        
        self->_complex = complex;
        
        return self;
    }
    
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSString *sel = NSStringFromSelector(selector);
    if ([sel rangeOfString:@"set"].location == 0) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    } else {
        return [NSMethodSignature signatureWithObjCTypes:"@@:"];
    }
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    NSString *key = NSStringFromSelector([invocation selector]);
    if ([key rangeOfString:@"set"].location == 0) {
        key = [[key substringWithRange:NSMakeRange(3, [key length]-4)] lowercaseString];
        NSObject *obj;
        [invocation getArgument:&obj atIndex:2];
        
        [(id<SODataProperty>)[self->_complex objectForKey:key] setValue:obj];
    } else {
        id<SODataProperty> prop = (id<SODataProperty>)[self->_complex objectForKey:key];
        NSObject *obj = [prop value];
        [invocation setReturnValue:&obj];
    }
}

@end
