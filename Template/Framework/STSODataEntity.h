//
//  STSODataEntity.h
//  SMP3ODataAPI
//
//  Created by Stadelman, Stan on 6/5/14.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SODataEntity.h"

@interface STSODataEntity : NSObject <SODataEntity>
{
    id<SODataEntity> _entity;
}

-(instancetype)initWithEntity:(id<SODataEntity>)entity;

//+ (STSODataEntity *) createFromEntity:(id<SODataEntity>)entity;

@end
