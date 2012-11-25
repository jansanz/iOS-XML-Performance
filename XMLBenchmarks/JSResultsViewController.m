//
//  JSResultsViewController.m
//  XMLBenchmarks
//
//  Created by Jan Sanchez on 11/24/12.
//  Copyright (c) 2012 Jan Sanchez. All rights reserved.
//

#import "JSResultsViewController.h"

@interface JSResultsViewController ()

@property (strong, nonatomic) NSMutableDictionary *results;

- (void)parse;

@end

@implementation JSResultsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
//    NSMutableArray *results = [_results objectForKey:[_selectedLibraries objectAtIndex:indexPath.row]];
    
//    if (indexPath.section == 0) {
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f ms", [self average:results]];
//    } else if (indexPath.section == 1) {
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f ms", [self min:results]];
//    } else if (indexPath.section == 2) {
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f ms", [self max:results]];
//    }
    
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

@end
