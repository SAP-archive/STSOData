//
//  SODataPropertyDictionary.m
//  Template
//
//  Created by Stadelman, Stan on 9/25/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import "SODataPropertyDictionary.h"

#import "SODataProperty.h"

#import "SODataPropertyDefault.h"

@interface SODataPropertyDictionary () {
    
    NSMutableDictionary *_dictionary;
    
}

@end

@implementation SODataPropertyDictionary

-(instancetype)initWithDictionary:(NSDictionary *)otherDictionary
{
    if (self == [super init]) {

        _dictionary = [NSMutableDictionary dictionaryWithDictionary:otherDictionary];
        
        return self;
    }
    return nil;

}

-(id)objectForKey:(id)aKey
{
    id value = [(id<SODataProperty>)_dictionary[aKey] value];
    
    NSLog(@" value's class = %@", [value class]);
    
//    if ([value isKindOfClass:[NSDictionary class]]) {
//        
//        NSArray *allKeys = [value allKeys];
//        
//        if (allKeys.count > 0) {
//            SODataPropertyDictionary *complexType = [[SODataPropertyDictionary alloc] initWithDictionary:value];
//            
//            return complexType;
////        }//[value[[value allKeys][0]] isMemberOfClass:[SODataPropertyDefault class]]) {
//    
//        
//        
//    }
   
    return value;
}

@end
