//
//  STSODataComplex.h
//  SMP3ODataAPI
//
//  Created by Jobson, Chris on 06/06/2014.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface STSODataComplex : NSObject
{
    NSDictionary *_complex;
}

- (instancetype) initWithComplex:(NSDictionary *)complex;

@end
