//
//  DataOfCurrency.m
//  Currency stats
//
//  Created by Alex Chekodanov on 12.07.2018.
//  Copyright © 2018 MERA. All rights reserved.
//

#import "DataOfCurrency.h"

@implementation DataOfCurrency

- (instancetype)initWithNumCode: (NSInteger) numCode
             charCode: (NSString *) charCode
              nominal: (NSInteger) nominal
                 name: (NSString *) name
                value: (NSNumber *) value
{
    
    if (self = [super init])
    {
        self.numCode = numCode;
        self.charCode = charCode;
        self.nominal = nominal;
        self.name = name;
        self.value = value;
    }
    return self;
}
- (instancetype)initWithNominal: (NSInteger) nominal
                          value: (NSNumber *) value
{
    if (self = [super init])
    {
        self.numCode = 1;
        self.charCode = @"none";
        self.nominal = nominal;
        self.name = @"none";
        self.value = value;
    }
    return self;
}
@end
