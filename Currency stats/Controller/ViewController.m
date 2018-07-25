//
//  ViewController.m
//  Currency stats
//
//  Created by Alex Chekodanov on 12.07.2018.
//  Copyright © 2018 MERA. All rights reserved.
//

#import "ViewController.h"
#import "GraphicViewController.h"

#import "WorkWithXML.h"
#import "DataOfCurrency.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, atomic) NSMutableArray *namesOfCurrency;
@property (strong, nonatomic) NSString *choosedName;
@property (strong, nonatomic) NSArray *date;

@property (strong, nonatomic) IBOutlet UITextField *textDay;
@property (strong, nonatomic) IBOutlet UITextField *textMonth;
@property (strong, nonatomic) IBOutlet UITextField *textYear;

//пабликовский property для pickerView
//@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    [self parseForNames];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.choosedName = [userDefaults objectForKey:@"Currency name"];
    self.date = [userDefaults objectForKey:@"Date"];
    
    if(!self.date)
    {
        [self setDateComponents];
    }        
    
    NSLog(@"Count of names %lu", self.dataArray.count);
    NSLog(@"Chosed data is %@", self.date);
    
    if (self.choosedName && self.date) //переход на второй view
    {
        [self setLableBySavedDate];
        [self performSegueWithIdentifier:@"GraphicViewControllerShowSegue" sender:self];
    }
    
}// viewDidLoad

- (void) setLableBySavedDate
{
    NSLog(@"%@",[self.date objectAtIndex:0]);
    self.textDay.text = [NSString stringWithFormat:@"%@",[self.date objectAtIndex:0]];
    self.textMonth.text = [NSString stringWithFormat:@"%@",[self.date objectAtIndex:1]];
    self.textYear.text = [NSString stringWithFormat:@"%@",[self.date objectAtIndex:2]];
}

- (void) parseForNames
{
    dispatch_queue_t namesQ = dispatch_queue_create("names queue", NULL);
    dispatch_async(namesQ, ^{
        //парсим стандартную ссылку что бы получить список названий валют
        self.namesOfCurrency = [[NSMutableArray alloc] init];
        self.dataArray = [[NSMutableArray alloc] init];
        WorkWithXML *listParser = [[WorkWithXML alloc] initWithArray:self.dataArray];
        [listParser parserXMLFile];
        
        for (int i = 0; i < self.dataArray.count; i++)
        {
            DataOfCurrency *data = [self.dataArray objectAtIndex:i];
            [self.namesOfCurrency addObject:data.name];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pickerView reloadAllComponents];
        });
    
    });

}// parseForNames

//проверка крутится ли pickerView

-(BOOL)anySubViewScrolling:(UIView*)view
{
    if([ view isKindOfClass:[ UIScrollView class ] ])
    {
        UIScrollView* scroll_view = (UIScrollView*) view;
        if(scroll_view.dragging || scroll_view.decelerating)
        {
            return true;
        }
    }
    
    for(UIView *sub_view in [ view subviews ])
    {
        if([ self anySubViewScrolling:sub_view ])
        {
            return true;
        }
    }
    
    return false;
}// anySubViewScrolling

-(void)setDateComponents
{
    if (self.checkDataForValid)
    {
        NSInteger day = [self.textDay.text integerValue];
        NSInteger month = [self.textMonth.text integerValue];
        NSInteger year = [self.textYear.text integerValue];
        self.date =[[NSArray alloc]initWithObjects:[NSNumber numberWithInteger: day],[NSNumber numberWithInteger: month],[NSNumber numberWithInteger: year], nil];
        
        NSLog(@"Chosed day is %ld",[self.textDay.text integerValue]);
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.date forKey:@"Date"];
        [userDefaults synchronize];
    }
    else exit(1);
}// setDateComponents

- (IBAction)buttonStartWork:(UIButton *)sender
{
    if (![self anySubViewScrolling: self.view]) // если не крутится picker view то
    {
        [self setDateComponents];
        
    }
    else
    {
        NSLog(@"PickerView is rolling");
        exit(2);
    }
    // переход в GraphicViewController
    [self performSegueWithIdentifier:@"GraphicViewControllerShowSegue" sender:self];
}// buttonStartWork


- (BOOL)checkDataForValid
{
    #warning Сделать более жесткую проверку даты тк эту при желании можно обойти и крашнуть приложение
    if ((0<[self.textDay.text integerValue])&&([self.textDay.text integerValue]<31))
        if((0<[self.textMonth.text integerValue])&&([self.textMonth.text integerValue]<13))
            if((1970<[self.textYear.text integerValue])&&([self.textYear.text integerValue]<2019))
                return YES;
    return NO;
}// checkDataForValid

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}// numberOfComponentsInPickerView




- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.namesOfCurrency count];
}// numberOfRowsInComponent




- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.namesOfCurrency[row];
}// titleForRow




- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //применяем и сохраняем значение PickerView
    self.choosedName = self.namesOfCurrency[row];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.choosedName forKey:@"Currency name"];
    [userDefaults synchronize];
}// didSelectRow



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GraphicViewControllerShowSegue"])
    {
        if ([segue.destinationViewController isKindOfClass:[GraphicViewController class]])
        {
            GraphicViewController *gvc = (GraphicViewController * )segue.destinationViewController;
            gvc.chosedCurrency = self.choosedName;
            gvc.chosedDate = self.date;
        }
    }
}// prepareForSegue






@end
