//
//  TravelAgencySample.m
//  Template
//
//  Created by Stadelman, Stan on 12/2/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import "TravelAgencySample.h"

#import "SODataEntityDefault.h"

#import "SODataPropertyDefault.h"

@implementation TravelAgencySample

-(id<SODataEntity>)modifiedEntity
{
    SODataEntityDefault *entityCopy = self.entity;
    
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    
    properties[@"agencynum"] = self.agencynum;
    properties[@"NAME"] = self.NAME;
    properties[@"STREET"] = self.STREET;
    properties[@"POSTBOX"] = self.POSTBOX;
    properties[@"POSTCODE"] = self.POSTCODE;
    properties[@"CITY"] = self.CITY;
    properties[@"COUNTRY"] = self.COUNTRY;
    properties[@"REGION"] = self.REGION;
    properties[@"TELEPHONE"] = self.TELEPHONE;
    properties[@"URL"] = self.URL;
    properties[@"LANGU"] = self.LANGU;
    properties[@"CURRENCY"] = self.CURRENCY;
    properties[@"mimeType"] = self.mimeType;

    __block void (^setProperties)(SODataEntityDefault*, NSMutableDictionary*) = ^void (SODataEntityDefault *entity, NSMutableDictionary *properties){
        
        [[properties allKeys] enumerateObjectsUsingBlock:^(NSString *keyName, NSUInteger idx, BOOL *stop) {
            SODataPropertyDefault *prop = [[SODataPropertyDefault alloc] initWithName:keyName];
            prop.value = properties[keyName];
            [entity.properties setObject:prop forKey:keyName];
        }];
    };
    
    setProperties(entityCopy, properties);
    
    return entityCopy;
}

@end
