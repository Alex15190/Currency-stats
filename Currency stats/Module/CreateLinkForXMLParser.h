//
//  CreateLinkForXMLParser.h
//  Currency stats
//
//  Created by Alex Chekodanov on 16.07.2018.
//  Copyright © 2018 MERA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateLinkForXMLParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) NSDateComponents *date;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *parentCode;

@property (nonatomic, strong) NSMutableArray *dataArray;

-(instancetype)initWithName: (NSString *)name
                     date: (NSDateComponents *)date;
-(NSString *)getLink;

//-(instancetype)initWithArray: (NSMutableArray *)dataArray;
-(void)parserXMLFile;
@end
