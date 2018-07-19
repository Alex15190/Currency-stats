//
//  DataOfCurrency.h
//  Currency stats
//
//  Created by Alex Chekodanov on 12.07.2018.
//  Copyright © 2018 MERA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataOfCurrency : NSObject

@property (nonatomic) NSInteger numCode;
@property (nonatomic, strong) NSString *charCode;
@property (nonatomic) NSInteger nominal;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSNumber *value;

- (instancetype)initWithNumCode: (NSInteger) numCode
             charCode: (NSString *) charCode
              nominal: (NSInteger) nominal
                 name: (NSString *) name
                value: (NSNumber *) value;
- (instancetype)initWithNominal: (NSInteger) nominal
                          value: (NSNumber *) value;


@end
