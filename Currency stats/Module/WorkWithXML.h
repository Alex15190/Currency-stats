//
//  WorkWithXML.h
//  Currency stats
//
//  Created by Alex Chekodanov on 12.07.2018.
//  Copyright © 2018 MERA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkWithXML : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
//for GraphicViewController
@property (nonatomic, strong) NSString *link;

-(instancetype)initWithArray: (NSMutableArray *)dataArray;
-(instancetype)initWithArray:(NSMutableArray *)dataArray
                        link: (NSString *)link;
-(void)parserXMLFile;

@end

