//
//  CreateLinkForXMLParser.m
//  Currency stats
//
//  Created by Alex Chekodanov on 16.07.2018.
//  Copyright © 2018 MERA. All rights reserved.
//

#import "CreateLinkForXMLParser.h"

@interface CreateLinkForXMLParser()

@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, strong) NSString *element;

//Currency properties
@property (nonatomic, strong) NSString *currentName;
@property (nonatomic, strong) NSString *currentParentCode;

@end

@implementation CreateLinkForXMLParser

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
    [self parserXMLFile];
    
    //Дата на сегодня
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitYear  | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:today];
    
    //тк 06 и 6 для ссылки разные вещи приходится исхитряться
    NSString *todayStringMonth;
    NSString *todayStringDay;
    
    NSString *chosedStringMonth;
    NSString *chosedStringDay;
    
    NSInteger chosedYear = [self.date year];
    NSInteger chosedMonth = [self.date month];
    if(chosedMonth < 10)
    {
        chosedStringMonth = [[NSString alloc] initWithFormat:@"0%ld", chosedMonth];
    }
    else
    {
        chosedStringMonth = [[NSString alloc] initWithFormat:@"%ld", chosedMonth];
    }
    NSInteger chosedDay = [self.date day];
    if(chosedDay < 10)
    {
        chosedStringDay = [[NSString alloc] initWithFormat:@"0%ld", chosedDay];
    }
    else
    {
        chosedStringDay = [[NSString alloc] initWithFormat:@"%ld", chosedDay];
    }
    
    
    
    NSInteger todayYear = [dateComponents year];
    NSInteger todayMonth = [dateComponents month];
    
    
    
    if (todayMonth < 10)
    {
        todayStringMonth = [[NSString alloc] initWithFormat:@"0%ld", todayMonth];
    }
    else
    {
        todayStringMonth = [[NSString alloc] initWithFormat:@"%ld", todayMonth];
    }
    NSInteger todayDay = [dateComponents day];
    if (todayDay < 10)
    {
        todayStringDay = [[NSString alloc] initWithFormat:@"0%ld", todayDay];
    }
    else
    {
        todayStringDay = [[NSString alloc] initWithFormat:@"%ld", todayDay];
    }
    
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
    
    
    
    NSLog(@"http://www.cbr.ru/scripts/XML_dynamic.asp?date_req1=%@/%@/%ld&date_req2=%@/%@/%ld&VAL_NM_RQ=%@", chosedStringDay, chosedStringMonth, chosedYear, todayStringDay, todayStringMonth, todayYear, self.parentCode);
    
    //http://www.cbr.ru/scripts/XML_dynamic.asp?date_req1=02/03/2001&date_req2=14/03/2001&VAL_NM_RQ=R01235
    
    
    return [NSString stringWithFormat: @"http://www.cbr.ru/scripts/XML_dynamic.asp?date_req1=%@/%@/%ld&date_req2=%@/%@/%ld&VAL_NM_RQ=%@", chosedStringDay, chosedStringMonth, chosedYear, todayStringDay, todayStringMonth, todayYear, self.parentCode];
}


-(void)parserXMLFile
{
        NSURL *xmlPath = [[NSURL alloc] initWithString: @"http://www.cbr.ru/scripts/XML_val.asp?d=1"];
        self.parser = [[NSXMLParser alloc] initWithContentsOfURL: xmlPath];
        self.parser.delegate = self;
        [self.parser parse];
}// parserXMLFile

- (void)parser: (NSXMLParser *)parser
didStartElement: (NSString *)elementName
  namespaceURI: (NSString *)namespaceURI
 qualifiedName: (NSString *)qName
    attributes: (NSDictionary<NSString *,NSString *> *)attributeDict
{
    self.element = elementName;
}// parser:didStartElement:namespaceURI:qualifiedName:attributes

- (void)parser: (NSXMLParser *)parser
foundCharacters: (NSString *)string
{
    if ([self.element isEqualToString: @"Name"]){
        self.currentName = string;
    }
    else if ([self.element isEqualToString: @"ParentCode"]){
        self.currentParentCode = string;
    }
}// parser:foundCharacters

- (void)parser: (NSXMLParser *)parser
 didEndElement: (NSString *)elementName
  namespaceURI: (NSString *)namespaceURI
 qualifiedName: (NSString *)qName
{
    if ([elementName isEqualToString: @"Item"]){
        if ([self.currentName isEqualToString: self.name])
        {
            self.parentCode = self.currentParentCode;
        }
    };
    self.element = nil;
}// parser:didEndElement:namespaceURI:qualifiedName

@end