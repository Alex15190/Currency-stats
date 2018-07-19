//
//  WorkWithXML.m
//  Currency stats
//
//  Created by Alex Chekodanov on 12.07.2018.
//  Copyright © 2018 MERA. All rights reserved.
//

//http://www.cbr.ru/development/SXML/

#import "WorkWithXML.h"
#import "DataOfCurrency.h"
#import "CreateLinkForXMLParser.h"

@interface WorkWithXML()

@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, strong) NSString *element;

//Currency properties
@property (nonatomic) NSInteger currentNumCode;
@property (nonatomic, strong) NSString *currentCharCode;
@property (nonatomic) NSInteger currentNominal;
@property (nonatomic, strong) NSString *currentName;
@property (nonatomic) NSNumber *currentValue;

@end

@implementation WorkWithXML

-(instancetype)initWithArray:(NSMutableArray *)dataArray
{
    if(self = [super init])
    {
        self.dataArray = dataArray;
    }
    return self;
}// initWithArray

-(instancetype)initWithArray:(NSMutableArray *)dataArray
                        link: (NSString *)link
{
    if(self = [super init])
    {
        self.dataArray = dataArray;
        self.link = link;
    }
    return self;
}// initWithArray:date:name:

-(void)parserXMLFile
{
    if(self.link)
    {
        //Изменить ссылку на другую
        
        NSURL *xmlPath = [[NSURL alloc] initWithString:self.link];
        NSLog(@"Парсер получил следующую ссылку: %@",self.link);
        self.parser = [[NSXMLParser alloc]initWithContentsOfURL:xmlPath];
        self.parser.delegate = self;
        [self.parser parse];
    }
    else
    {
        NSURL *xmlPath = [[NSURL alloc] initWithString:@"http://www.cbr.ru/scripts/XML_daily.asp"];
        NSLog(@"Парсер получил стандартную ссылку");
        self.parser = [[NSXMLParser alloc]initWithContentsOfURL:xmlPath];
        self.parser.delegate = self;
        [self.parser parse];
    }
}// parserXMLFile

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    self.element = elementName;
}// parser:didStartElement:namespaceURI:qualifiedName:attributes

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([self.element isEqualToString:@"NumCode"]){
        self.currentNumCode = string.doubleValue;
    }
    else if ([self.element isEqualToString:@"CharCode"]){
        self.currentCharCode = string;
    }
    else if ([self.element isEqualToString:@"Nominal"]){
        self.currentNominal = string.doubleValue;
    }
    else if ([self.element isEqualToString:@"Name"]){
        self.currentName = string;
    }
    else if ([self.element isEqualToString:@"Value"]){
        string = [string stringByReplacingOccurrencesOfString:@"," withString:@"."];
        self.currentValue = [NSNumber numberWithDouble:string.doubleValue];
    }
}// parser:foundCharacters

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"Valute"]||[elementName isEqualToString:@"Record"]){
        if ([elementName isEqualToString:@"Valute"]){
            DataOfCurrency *thisData = [[DataOfCurrency alloc] initWithNumCode: self.currentNumCode
                                                                      charCode: self.currentCharCode
                                                                       nominal: self.currentNominal
                                                                          name: self.currentName
                                                                         value: self.currentValue];
            [self.dataArray addObject:thisData];
        }
        else
        {
        DataOfCurrency *thisData =[[DataOfCurrency alloc] initWithNominal: self.currentNominal
                                                              value:self.currentValue ];
            [self.dataArray addObject:thisData];
        }
        
    };
    self.element = nil;
}// parser:didEndElement:namespaceURI:qualifiedName


@end
