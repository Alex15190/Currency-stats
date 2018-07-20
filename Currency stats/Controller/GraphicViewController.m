//
//  GraphicViewController.m
//  Currency stats
//
//  Created by Alex Chekodanov on 12.07.2018.
//  Copyright © 2018 MERA. All rights reserved.
//

#import "GraphicViewController.h"
#import "WorkWithXML.h"
#import "DataOfCurrency.h"
#import "CreateLinkForXMLParser.h"
#import "ChangeArrayOfValue.h"

@interface GraphicViewController ()

/* пабликовские property
@property(strong,nonatomic) NSString* chosedCurrency;
@property (strong, nonatomic) NSDateComponents *chosedDate;
*/

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *arrayOfNumbers;
@property (strong, nonatomic) NSMutableArray *arrayOfNominals;
@property (strong, nonatomic) NSTimer *timer;

//Для того что бы сравнить поменялось ли что нибудь
@property (nonatomic) double lastValue;

@property (strong, nonatomic) IBOutlet UIView *viewForGraphic;
@property (strong, nonatomic) IBOutlet UILabel *lableForValueAndNominal;

//Лейблы для графика
@property (strong, nonatomic) IBOutlet UILabel *maxY;
@property (strong, nonatomic) IBOutlet UILabel *middleY;
@property (strong, nonatomic) IBOutlet UILabel *minY;
@property (strong, nonatomic) IBOutlet UILabel *lableForDate;



@end

@implementation GraphicViewController


//норм с 24 клетками и 25 значениями



#pragma mark viewWill/viewDid
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.timer invalidate];
    
    NSLog(@"viewDidLoad");
    
    if (!self.chosedCurrency && !self.chosedDate)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        self.chosedCurrency = [userDefaults objectForKey:@"Currency name"];
        self.chosedDate = [userDefaults objectForKey:@"Date"];
    }
    

    //если начал бекграунд таск то должен и закончить. (научиться это делать)
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    self.timer = [NSTimer timerWithTimeInterval:1*60*60 target:self selector:@selector(customSelectorForTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    //[[UIApplication sharedApplication] endBackgroundTask: task];
    
}// viewDidLoad

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.chosedDate = nil;
    self.chosedCurrency = nil;
    [self.timer invalidate];
}// viewWillDisappear


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self drawData];
}// viewWillAppear

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self createAndParseLinkAndGetData];
    [self drawData];
}// viewWillAppear

#pragma mark Custom selector


- (void)customSelectorForTimer
{
    NSLog(@"Updating data with interval 1 hour");
    self.lastValue = [[self.arrayOfNumbers lastObject] doubleValue];
    [self createAndParseLinkAndGetData];
}


#pragma mark Local notification

- (void) checkForChanges
{
    //для проверки нотификатора
    //self.lastValue = 1;
    
    if((self.lastValue != [[self.arrayOfNumbers lastObject] doubleValue]) && (self.lastValue != 0))
    {
        [self notificationForUser];
    }
}

- (void) notificationForUser
{
    NSLog(@"Зашел в notificationForUser");
    self.localNotification = [[UNMutableNotificationContent alloc] init];
    self.localNotification.title = [NSString localizedUserNotificationStringForKey:@"Внимание!" arguments:nil];
    self.localNotification.body = [NSString localizedUserNotificationStringForKey:@"Данные по выбраной вами валюты изменились" arguments:nil];
    
    self.localNotification.sound = [UNNotificationSound defaultSound];
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    
    self.localNotification.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber]+1);
    
    //schedule
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Внимание!" content:self.localNotification trigger:trigger];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error)
     {
         if(!error)
             NSLog(@"Notification request success");
     }];
}

#pragma mark Drawing

-(void) drawData
{
    self.lastValue = [[self.arrayOfNumbers lastObject] doubleValue];
    
    //Собираю дату из масива которыый я засейвил ранее
    NSDateComponents *date = [[NSDateComponents alloc] init];
    date = [self dateComponentsByChosedDate];
    
    self.lableForDate.text = [NSString stringWithFormat:@"График изменения валюты с %ld.%ld.%ld по сегоднешний день", date.day, date.month, date.year];
    
    
    
    //удаляю график
    [self.viewForGraphic.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    //Обновляю инфу на лейбле
    self.lableForValueAndNominal.text = [NSString stringWithFormat:@"%ld %@ = %.2f рублей", [[self.arrayOfNominals lastObject] integerValue], self.chosedCurrency, [[self.arrayOfNumbers lastObject] doubleValue]];
   
    self.lableForValueAndNominal.lineBreakMode = NSLineBreakByWordWrapping;
    self.lableForValueAndNominal.numberOfLines = 0;
    
    //и рисую график
    [self drawingFuncForBackGround];
    [self drawingFuncOfNumbers];

}
- (NSDateComponents *) dateComponentsByChosedDate
{
    NSDateComponents *date = [[NSDateComponents alloc] init];
    [date setDay:[[self.chosedDate objectAtIndex:0] integerValue]];
    [date setMonth:[[self.chosedDate objectAtIndex:1] integerValue]];
    [date setYear:[[self.chosedDate objectAtIndex:2] integerValue]];
    return date;
}

- (void) createAndParseLinkAndGetData
{
    
    self.dataArray = [[NSMutableArray alloc] init];
    NSDateComponents *date = [[NSDateComponents alloc] init];
    date = [self dateComponentsByChosedDate];
    
    //парсинг
    CreateLinkForXMLParser *workingLink = [[CreateLinkForXMLParser alloc] initWithName:self.chosedCurrency date:date];
    WorkWithXML *listParser = [[WorkWithXML alloc] initWithArray:self.dataArray link:[workingLink getLink]];
    [listParser parserXMLFile];
    
    //получаю значения с выбранной даты до текущей
    self.arrayOfNominals = [[NSMutableArray alloc] init];
    self.arrayOfNumbers = [[NSMutableArray alloc] init];
    
    for (int i=0;i<self.dataArray.count;i++)
    {
        DataOfCurrency *data = [self.dataArray objectAtIndex:i];
        [self.arrayOfNumbers addObject:data.value];
        [self.arrayOfNominals addObject:[NSNumber numberWithInteger:data.nominal]];
    }
    
    
    //меняем масив чисел и номиналов если много элементов
    if ([self.arrayOfNumbers count] > 25)
    {
        ChangeArrayOfValue *changeValue  = [[ChangeArrayOfValue alloc] initWithMutableArray:self.arrayOfNumbers];
        ChangeArrayOfValue *changeNominal  = [[ChangeArrayOfValue alloc] initWithMutableArray:self.arrayOfNominals];
        self.arrayOfNumbers = [changeValue changeLengthsOfArray];
        self.arrayOfNominals = [changeNominal changeLengthsOfArray];
    }
    
    [self checkForChanges];
    
    self.numOfPartitions = [self.arrayOfNumbers count] - 1 ;
}



-(void) drawingFuncForBackGround
{

    NSInteger startX = self.viewForGraphic.bounds.origin.x;
    NSInteger startY = self.viewForGraphic.bounds.origin.y;
    NSInteger maxX = self.viewForGraphic.bounds.size.height;
    NSInteger maxY = self.viewForGraphic.bounds.size.width;
    double stepX = maxX/(double)(self.numOfPartitions);
    double stepY = maxY/(double)(self.numOfPartitions);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (int i = 0; i <= self.numOfPartitions; i++)
    {
        [path moveToPoint:CGPointMake(startX + i*stepX, startY)];
        [path addLineToPoint:CGPointMake(startX + i*stepX, startY + maxY)];
    };
    
    for (int j=0; j <= self.numOfPartitions; j++)
    {
        [path moveToPoint:CGPointMake(startX, startY + j*stepY)];
        [path addLineToPoint:CGPointMake(startX + maxX, startY + j*stepY)];
    };

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor blueColor] CGColor];
    shapeLayer.lineWidth = 1.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    
    [self.viewForGraphic.layer addSublayer:shapeLayer];
}// drawingFuncForBackGround

-(void) drawingFuncOfNumbers
{
    double startX = self.viewForGraphic.bounds.origin.x;
    double startY = self.viewForGraphic.bounds.origin.y;
    double maxX = self.viewForGraphic.bounds.size.height;
    double maxY = self.viewForGraphic.bounds.size.width;
    double stepX = maxX/(double)self.numOfPartitions;
    double forYPoints[[self.arrayOfNumbers count]];
    
    double maximalY = [[self.arrayOfNumbers objectAtIndex:0] doubleValue]; // * [[self.arrayOfNominals objectAtIndex:0] doubleValue];
    double minimalY = [[self.arrayOfNumbers objectAtIndex:0] doubleValue]; // * [[self.arrayOfNominals objectAtIndex:0] doubleValue];
    
    for (int i=0;i<=self.numOfPartitions;i++)
    {
        forYPoints[i] = [[self.arrayOfNumbers objectAtIndex:i] doubleValue]; // * [[self.arrayOfNominals objectAtIndex:i] doubleValue];;
        if (forYPoints[i] < minimalY)
            minimalY = forYPoints[i];
        if (forYPoints[i] > maximalY)
            maximalY = forYPoints[i];
    }
    
    //Меняем лейблы у графика
    
    
    self.maxY.text = [NSString stringWithFormat:@"%.2f",maximalY];
    self.minY.text = [NSString stringWithFormat:@"%.2f",minimalY];
    self.middleY.text = [NSString stringWithFormat:@"%.2f",(maximalY + minimalY)/2];
    
    
    double differ = (maximalY - minimalY)*1.5;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (int i=0;i<=self.numOfPartitions;i++)
    {
        [self drawPointAt:startX + i*stepX withY:startY + maxY/1.225 - (maxY*(forYPoints[i] - minimalY))/differ] ;
        [path moveToPoint:CGPointMake(startX + i*stepX, startY + maxY/1.225 - (maxY*(forYPoints[i] - minimalY))/differ)] ;
        [path addLineToPoint:CGPointMake(startX + (i+1)*stepX, startY + maxY/1.225 - (maxY*(forYPoints[i+1] - minimalY))/differ)] ;
    };
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor redColor] CGColor];
    shapeLayer.lineWidth = 2.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    
    [self.viewForGraphic.layer addSublayer:shapeLayer];
    
}// drawingFuncOfNumbers

-(void) drawPointAt:(NSInteger)x withY: (NSInteger)y
{
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(x - 3, y - 3, 6, 6)] CGPath]];
    circleLayer.strokeColor = [[UIColor redColor] CGColor];
    circleLayer.lineWidth = 1.0;
    circleLayer.fillColor = [[UIColor redColor] CGColor];
    [[self.viewForGraphic layer] addSublayer:circleLayer];
}// drawPointAt

#pragma mark Button

- (IBAction)refreshData:(UIButton *)sender
{
    [self createAndParseLinkAndGetData];
    [self drawData];
}

@end
