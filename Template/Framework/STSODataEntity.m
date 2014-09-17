//
//  STSODataEntity.m
//  SMP3ODataAPI
//
//  Created by Stadelman, Stan on 6/5/14.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import "STSODataEntity.h"

#import "STSODataComplex.h"

#import "SODataEntity.h"
#import "SODataEntitySet.h"
#import "SODataProperty.h"
#import "SODataNavigationProperty.h"

#import <objc/runtime.h>

@implementation STSODataEntity

-(instancetype)initWithEntity:(id<SODataEntity>)entity
{
    if (self == [super init]) {
        
        self->_entity = entity;
        
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
        [(id<SODataProperty>)[self.properties objectForKey:key] setValue:obj];
    } else {
        // GET
        
        objc_property_t p = class_getProperty([self class], [key UTF8String]);
        
        NSLog(@"Prop info: %s %s", property_getName(p), property_getAttributes(p));
        
        NSString *atts = [NSString stringWithFormat:@"%s", property_getAttributes(p)];
        
        NSRange range = [atts rangeOfString:@","];
        NSRange range2 = NSMakeRange(3, range.location-4);
        NSString *className = [atts substringWithRange:range2];
        
        // check if the selector references a nav property ...
        id<SODataNavigationProperty> nav = [self->_entity navigationPropertyForRelationIdentifier:key];
        if (nav == nil || nav == (id)0x0) {
            // property ...
            id<SODataProperty> prop = (id<SODataProperty>)[self->_entity.properties objectForKey:key];
            if ([prop isComplex]) {
                
                id obj = [(STSODataComplex *)[NSClassFromString(className) alloc] initWithComplex:(NSDictionary *)[prop value]];
                
                [invocation setReturnValue:&obj];
                [invocation retainArguments];
            } else {
                NSObject *obj = [prop value];
                
                [invocation setReturnValue:&obj];
                [invocation retainArguments];
            }
        } else {
            // nav
            
            id obj = nil;
            
            if (nav.navigationType == SODataNavigationPropertyTypeEntity) {
                obj = [(STSODataEntity *)[NSClassFromString(className) alloc] initWithEntity:(id<SODataEntity>)nav.navigationContent];
            } else if (nav.navigationType == SODataNavigationPropertyTypeEntitySet) {
                id<SODataEntitySet> es = (id<SODataEntitySet>)nav.navigationContent;
                NSMutableArray *entities = [[NSMutableArray alloc] init];
                
                for (id<SODataEntity> e in es.entities) {
                    STSODataEntity *be = [STSODataEntity createFromEntity:e];
                    [entities addObject:be];
                }
                
                obj = entities;
            } if (nav.navigationType == SODataNavigationPropertyTypeResourcePath) {
                obj = nil;
            }
            
            [invocation setReturnValue:&obj];
            [invocation retainArguments];
        }
    }
}

NSDictionary* (^SetODataTypesInDictionary)(NSDictionary *dictionary) = ^NSDictionary* (NSDictionary *inputDict) {
    
    NSMutableDictionary *mutableObj = [NSMutableDictionary dictionaryWithDictionary:inputDict];
    
    NSArray *allKeys = [mutableObj allKeys];
    [allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        NSObject *propValue = [(id<SODataProperty>)[mutableObj objectForKey:key] value];
        
        if  ([propValue isKindOfClass:[NSDictionary class]]) {
            
            propValue = SetODataTypesInDictionary((NSDictionary *)propValue);
        }
        [mutableObj setValue:propValue forKey:key];
        
    }];
    return [NSDictionary dictionaryWithDictionary:mutableObj];
};

@end
