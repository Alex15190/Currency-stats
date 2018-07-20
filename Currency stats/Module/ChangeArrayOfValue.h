//
//  ChangeArrayOfValue.h
//  Currency stats
//
//  Created by Alex Chekodanov on 20.07.2018.
//  Copyright © 2018 MERA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChangeArrayOfValue : NSObject

- (instancetype)initWithMutableArray: (NSMutableArray *)array;

- (NSMutableArray *) changeLengthsOfArray;
@end
