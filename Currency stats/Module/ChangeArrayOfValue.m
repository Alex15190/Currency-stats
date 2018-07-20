//
//  ChangeArrayOfValue.m
//  Currency stats
//
//  Created by Alex Chekodanov on 20.07.2018.
//  Copyright © 2018 MERA. All rights reserved.
//

#import "ChangeArrayOfValue.h"

@interface ChangeArrayOfValue()

@property (strong, nonatomic) NSMutableArray *currentArray;

@end
@implementation ChangeArrayOfValue

- (NSMutableArray *) currenArray
{
    if(!self.currentArray)
        self.currentArray = [[NSMutableArray alloc] init];
    return self.currentArray;
}

- (instancetype)initWithMutableArray: (NSMutableArray *)array
{
    if (self = [super init])
    {
        self.currentArray = array;
    }
    return self;
}

- (NSMutableArray *) changeLengthsOfArray
{
    
    if([self.currentArray count]%25 == 0)
    {
        NSLog(@"Число кратное 25");
        [self changeLengthsIfTheMultiple];
    }
    else
    {
        NSLog(@"Число не кратное 25");
        [self changeLengthsToMultiple];
        [self changeLengthsIfTheMultiple];
    }
    return self.currentArray;
}

- (void) changeLengthsIfTheMultiple
{
    NSLog(@"Уменьшаем длину до 25 элементов");
    NSInteger step = [self.currentArray count]/25;
    NSMutableArray *workingArray = [[NSMutableArray alloc] init];

    for(int j = 0; j < 24; j++)
    {
        [workingArray addObject:[self.currentArray objectAtIndex:(j*step)]];
    }
    [workingArray addObject:[self.currentArray lastObject]];
    
    self.currentArray = workingArray;
}

- (void) changeLengthsToMultiple
{
    NSLog(@"Меняем длину что бы была кратной 25");
    NSInteger numberHowManyToSubtract = -1; //сколько нужно вычесть
    NSInteger const arrayCount = [self.currentArray count]; //добавил переменную тк в for Xcode ругался мол
    //выражение всегда будет false
    
    for (int i = 2; numberHowManyToSubtract == -1;i++)
    {
        if ((arrayCount - i*25) < 0)
        {
            numberHowManyToSubtract = arrayCount - (i - 1) * 25;
            break;
        }
    }
    
    for(int i = 0; i < numberHowManyToSubtract; i++)
    {
        if (i % 2 == 0)
            [self.currentArray removeObjectAtIndex:(1 + i/2)];
        else
            [self.currentArray removeObjectAtIndex:(([self.currentArray count] - 1) - (i - 1)/2 - 1)];
    }
}

@end
