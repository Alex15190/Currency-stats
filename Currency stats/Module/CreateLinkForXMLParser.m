//
//  CreateLinkForXMLParser.m
//  Currency stats
//
//  Created by Alex Chekodanov on 16.07.2018.
//  Copyright © 2018 MERA. All rights reserved.
//

#import "CreateLinkForXMLParser.h"

@interface CreateLinkForXMLParser()

//Currency properties
@property (nonatomic, strong) NSString *currentName;
@property (nonatomic, strong) NSString *currentParentCode;

@end

@implementation CreateLinkForXMLParser

//пабликовские property
//@property (nonatomic, strong) NSDateComponents *date;
//@property (nonatomic, strong) NSString *name;

-(instancetype)initWithName: (NSString *)name
                     date: (NSDateComponents *)date
{
    if(self = [super init])
    {
        self.name = name;
        self.date = date;
    }
    return self;
}

-(NSString *)getLink
{
    //Дата на сегодня
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *chosedDate = [gregorian dateFromComponents:self.date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSString *firstDate = [dateFormatter stringFromDate:chosedDate];
    NSString *secondDate = [dateFormatter stringFromDate:today];
    
    
    
    //тк их не было в списке кодировок но в daily были пришлось их все тупо перечислить (ID внутри получу позже)
    
    if([self.name isEqualToString:@"Австралийский доллар"])
    {
        self.parentCode = @"R01010";
    }
    else if([self.name isEqualToString:@"Азербайджанский манат"])
    {
        self.parentCode = @"R01020A";
    }
    else if([self.name isEqualToString:@"Фунт стерлингов Соединенного королевства"])
    {
        self.parentCode = @"R01035";
    }
    else if([self.name isEqualToString:@"Армянских драмов"])
    {
        self.parentCode = @"R01060";
    }
    else if([self.name isEqualToString:@"Белорусский рубль"])
    {
        self.parentCode = @"R01090B";
    }
    else if([self.name isEqualToString:@"Болгарский лев"])
    {
        self.parentCode = @"R01100";
    }
    else if([self.name isEqualToString:@"Бразильский реал"])
    {
        self.parentCode = @"R01115";
    }
    else if([self.name isEqualToString:@"Венгерских форинтов"])
    {
        self.parentCode = @"R01135";
    }
    else if([self.name isEqualToString:@"Гонконгских долларов"])
    {
        self.parentCode = @"R01200";
    }
    else if([self.name isEqualToString:@"Датских крон"])
    {
        self.parentCode = @"R01215";
    }
    else if([self.name isEqualToString:@"Доллар США"])
    {
        self.parentCode = @"R01235";
    }
    else if([self.name isEqualToString:@""])
    {
        self.parentCode = @"R01235";
    }
    else if([self.name isEqualToString:@""])
    {
        self.parentCode = @"R01100";
    }
    else if([self.name isEqualToString:@""])
    {
        self.parentCode = @"R01090B";
    }
    else if([self.name isEqualToString:@"Евро"])
    {
        self.parentCode = @"R01239";
    }
    else if([self.name isEqualToString:@"Индийских рупий"])
    {
        self.parentCode = @"R01270";
    }
    else if([self.name isEqualToString:@"Казахстанских тенге"])
    {
        self.parentCode = @"R01335";
    }
    else if([self.name isEqualToString:@"Канадский доллар"])
    {
        self.parentCode = @"R01350";
    }
    else if([self.name isEqualToString:@"Киргизских сомов"])
    {
        self.parentCode = @"R01370";
    }
    else if([self.name isEqualToString:@"Китайских юаней"])
    {
        self.parentCode = @"R01375";
    }
    else if([self.name isEqualToString:@"Молдавских леев"])
    {
        self.parentCode = @"R01500";
    }
    else if([self.name isEqualToString:@"Норвежских крон"])
    {
        self.parentCode = @"R01535";
    }
    else if([self.name isEqualToString:@"Польский злотый"])
    {
        self.parentCode = @"R01565";
    }
    else if([self.name isEqualToString:@"Румынский лей"])
    {
        self.parentCode = @"R01585F";
    }
    else if([self.name isEqualToString:@"СДР (специальные права заимствования)"])
    {
        self.parentCode = @"R01589";
    }
    else if([self.name isEqualToString:@"Сингапурский доллар"])
    {
        self.parentCode = @"R01625";
    }
    else if([self.name isEqualToString:@"Таджикских сомони"])
    {
        self.parentCode = @"R01670";
    }
    else if([self.name isEqualToString:@"Турецкая лира"])
    {
        self.parentCode = @"R01700J";
    }
    else if([self.name isEqualToString:@"Новый туркменский манат"])
    {
        self.parentCode = @"R01710A";
    }
    else if([self.name isEqualToString:@"Узбекских сумов"])
    {
        self.parentCode = @"R01717";
    }
    else if([self.name isEqualToString:@"Украинских гривен"])
    {
        self.parentCode = @"R01720";
    }
    else if([self.name isEqualToString:@"Чешских крон"])
    {
        self.parentCode = @"R01760";
    }
    else if([self.name isEqualToString:@"Шведских крон"])
    {
        self.parentCode = @"R01770";
    }
    else if([self.name isEqualToString:@"Швейцарский франк"])
    {
        self.parentCode = @"R01775";
    }
    else if([self.name isEqualToString:@"Южноафриканских рэндов"])
    {
        self.parentCode = @"R01810";
    }
    else if([self.name isEqualToString:@"Вон Республики Корея"])
    {
        self.parentCode = @"R01815";
    }
    else if([self.name isEqualToString:@"Японских иен"])
    {
        self.parentCode = @"R01820";
    }
    
    
    
    NSLog(@"http://www.cbr.ru/scripts/XML_dynamic.asp?date_req1=%@&date_req2=%@&VAL_NM_RQ=%@",firstDate ,secondDate ,self.parentCode);
    
    //http://www.cbr.ru/scripts/XML_dynamic.asp?date_req1=02/03/2001&date_req2=14/03/2001&VAL_NM_RQ=R01235
    
    
    return [NSString stringWithFormat: @"http://www.cbr.ru/scripts/XML_dynamic.asp?date_req1=%@&date_req2=%@&VAL_NM_RQ=%@",firstDate ,secondDate ,self.parentCode];
}
@end
