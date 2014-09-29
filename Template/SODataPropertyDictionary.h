//
//  SODataPropertyDictionary.h
//  Template
//
//  Created by Stadelman, Stan on 9/25/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SODataPropertyDictionary : NSMutableDictionary

-(instancetype)initWithDictionary:(NSDictionary *)otherDictionary;

-(id)objectForKey:(id)aKey;

@end
