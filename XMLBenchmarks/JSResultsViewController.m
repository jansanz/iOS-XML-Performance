//
//  JSResultsViewController.m
//  XMLBenchmarks
//
//  Created by Jan Sanchez on 11/24/12.
//  Copyright (c) 2012 Jan Sanchez. All rights reserved.
//

#import "JSResultsViewController.h"
#import "MBProgressHUD.h"
#import "RXMLElement.h"
#import "TBXML.h"
#import "DDXML.h"

@interface JSResultsViewController ()

@property (strong, nonatomic) NSMutableDictionary *results;

- (float)average:(NSArray *)items;
- (float)max:(NSArray *)items;
- (float)min:(NSArray *)items;

- (void)parseSmallUTF8Test;
- (NSNumber *)parseSmallUTF8TestWithRaptureXML:(NSData *)data;
- (NSNumber *)parseSmallUTF8TestWithTBXML:(NSData *)data;
- (NSNumber *)parseSmallUTF8TestWithKissXML:(NSData *)data;

@end

@implementation JSResultsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.results = [[NSMutableDictionary alloc] initWithCapacity:[self.selectedLibraries count]];
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self parseSmallUTF8Test];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - parse methods
// TODO: move this to a different file
- (void)parseSmallUTF8Test
{
    NSError *error = nil;
    NSString *pathToFile = [[NSBundle mainBundle] pathForResource:@"utf8test.xml" ofType:@""];
    NSString *contentFile = [NSString stringWithContentsOfFile:pathToFile encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"Error: %@", [error description]);
        return;
    }
    NSData *contentData = [contentFile dataUsingEncoding:NSUTF8StringEncoding];
    
    //Libs JSONKit, TouchJSON, NextiveJson, SBJSON, NSJSONSerialization
    
    for (NSString *libName in self.selectedLibraries)
    {
        NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:self.repeats];
        SEL method = NSSelectorFromString([NSString stringWithFormat:@"parseSmallUTF8TestWith%@:",libName]);
        
        for (int i = 0; i < self.repeats; i++) {
            [results addObject:[self performSelector:method withObject:contentData]];
        }
        
        [self.results setObject:results forKey:libName];
    }
    
    [self.tableView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (NSNumber *)parseSmallUTF8TestWithKissXML:(NSData *)data
{
    NSDate *startTime = [NSDate date];
    
    NSError *error = nil;
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:data options:0 error:&error];
    
    NSArray *elements = [doc.rootElement children];

    for (DDXMLElement *element in elements) {
        NSString *tag = nil;
        NSString *value = nil;
        NSString *name = nil;
        NSString *text = nil;
        
        tag = element.name;
        value = [element attributeForName:@"value"].stringValue;
        name = [element attributeForName:@"name"].stringValue;
        text = element.stringValue;
        
//        NSLog(@"%@: \nname: %@ / value: %@ -> %@",tag, name, value, text);
        
        name = nil, value = nil, text = nil;
    }

    float elapsedTime = [startTime timeIntervalSinceNow] * -1000;
    if (doc == nil)
        elapsedTime = -1.0;
    return [NSNumber numberWithFloat:elapsedTime];
}

- (NSNumber *)parseSmallUTF8TestWithTBXML:(NSData *)data
{
    NSDate *startTime = [NSDate date];
    NSError *error = nil;
    TBXML *doc = [[TBXML alloc] initWithXMLData:data error:&error];
    
    TBXMLElement *elem = doc.rootXMLElement->firstChild;
    
    do {
        
        NSString *tag = nil;
        NSString *value = nil;
        NSString *name = nil;
        NSString *text = nil;
        
        tag = [TBXML elementName:elem];
        name = [TBXML valueOfAttributeNamed:@"name" forElement:elem];
        value = [TBXML valueOfAttributeNamed:@"value" forElement:elem];
        text = [TBXML textForElement:elem];
        
//        NSLog(@"%@: \nname: %@ / value: %@ -> %@",tag, name, value, text);
        
        name = nil, value = nil, text = nil;
        
    } while ((elem = elem->nextSibling));
    
    float elapsedTime = [startTime timeIntervalSinceNow] * -1000;
    if (doc == nil)
        elapsedTime = -1.0;
    return [NSNumber numberWithFloat:elapsedTime];
}

- (NSNumber *)parseSmallUTF8TestWithRaptureXML:(NSData *)data
{
    NSDate *startTime = [NSDate date];
    RXMLElement *doc = [[RXMLElement alloc] initFromXMLData:data];
    
    [doc iterate:@"*" usingBlock:^(RXMLElement *element) {
        
        NSString *tag = nil;
        NSString *value = nil;
        NSString *name = nil;
        NSString *text = nil;
        
        tag = [element tag];
        name = [element attribute:@"name"];
        value = [element attribute:@"value"];
        text = [element text];
        
//        NSLog(@"%@: \nname: %@ / value: %@ -> %@",tag, name, value, text);
        
        name = nil, value = nil, text = nil;
    }];
    
    float elapsedTime = [startTime timeIntervalSinceNow] * -1000;
    if (doc == nil)
        elapsedTime = -1.0;
    return [NSNumber numberWithFloat:elapsedTime];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.selectedLibraries.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [NSString stringWithFormat:@"Average (%i repeats)", self.repeats];
            break;
        case 1:
            return @"Min";
            break;
        case 2:
        default:
            return @"Max";
            break;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [self.selectedLibraries objectAtIndex:indexPath.row];
    
    NSMutableArray *results = [self.results objectForKey:[self.selectedLibraries objectAtIndex:indexPath.row]];
    
    if (indexPath.section == 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f ms", [self average:results]];
    } else if (indexPath.section == 1) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f ms", [self min:results]];
    } else if (indexPath.section == 2) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f ms", [self max:results]];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


#pragma mark - Calculation

- (float)average:(NSArray *)items
{
    if ([items count] == 0) return 0;
    float total = 0.0;
    for (NSNumber *n in items) {
        total+= [n floatValue];
    }
    return total / [items count];
}

- (float)min:(NSArray *)items
{
    if ([items count] == 0) return 0;
    float min = MAXFLOAT;
    for (NSNumber *n in items) {
        if ([n floatValue] < min)
            min = [n floatValue];
    }
    return min;
}

- (float)max:(NSArray *)items
{
    if ([items count] == 0) return 0;
    float max = 0.0;
    for (NSNumber *n in items) {
        if ([n floatValue] > max)
            max = [n floatValue];
    }
    return max;
}

@end
