//
//  JSViewController.m
//  XMLBenchmarks
//
//  Created by Jan Sanchez on 11/24/12.
//  Copyright (c) 2012 Jan Sanchez. All rights reserved.
//

#import "JSViewController.h"
#import "JSResultsViewController.h"

@interface JSViewController ()

@property (strong, nonatomic) NSMutableDictionary *libraries;
@property (strong, nonatomic) NSArray *files;
@property (strong, nonatomic) NSString *selectedFile;
@property (assign, nonatomic) NSInteger repeats;

- (void)runButtonPressed:(id)sender;
//- (BOOL)isAnyTestSelected;

@end

@implementation JSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.libraries = [[NSMutableDictionary alloc] initWithDictionary:@{
                      @"NSXMLParser" : @(NO),
                      @"libxml2" : @(NO),
                      @"TBXML" : @(NO),
                      @"KissXML" : @(NO),
                      @"RaptureXML" : @(NO),
                      @"TouchXML" : @(NO),
                      @"GDataXML" : @(NO),
                      @"TinyXML2" : @(NO),
                      @"TinyXML" : @(NO),
                      }];
    
    self.files = [[NSArray alloc] initWithObjects:@"random.json", @"twitter_timeline.json", @"repeat.json", nil];
    self.selectedFile = [self.files objectAtIndex:0];
    
    self.repeats = 1;
    
    [self setTitle:@"XML Benchmarks"];
    
    UIBarButtonItem *runButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Run" style:UIBarButtonItemStyleDone target:self action:@selector(runButtonPressed:)];
    [self.navigationItem setRightBarButtonItem:runButtonItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)runButtonPressed:(id)sender
{
    NSSet *selectedParsers = nil;
    selectedParsers = [self.libraries keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
        
        BOOL selected = [obj boolValue];
        return selected;
    }];
    
    if (!selectedParsers || selectedParsers.count < 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hmmm..."
                                                            message:@"Please select at least one parser to begin"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
        [alertView show];
        //        [alertView release];
        return;
    }
    
    NSArray *selectedParsersArray = [selectedParsers allObjects];
    
    JSResultsViewController *resultsViewController = [[JSResultsViewController alloc] initWithNibName:nil bundle:nil];
    
    [resultsViewController setSelectedFile:self.selectedFile];
    [resultsViewController setSelectedLibraries:selectedParsersArray];
    [resultsViewController setRepeats:self.repeats];
    
    [self.navigationController pushViewController:resultsViewController animated:YES];
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
    switch (section) {
        case 0:
            return self.libraries.count;
            break;
        case 1:
            return self.files.count;
            return 0;
        case 2:
        default:
            return 6;
            break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Select Parsers";
            break;
        case 1:
            return @"Select File";
            break;
        case 2:
        default:
            return @"Number of times";
            break;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if (indexPath.section == 0) {
        
        NSString *parserName = [[self.libraries allKeys] objectAtIndex:indexPath.row];
        
        cell.textLabel.text = parserName;
        
        if ([[self.libraries objectForKey:parserName] boolValue] == YES)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    } else if (indexPath.section == 1) {
        cell.textLabel.text = [self.files objectAtIndex:indexPath.row];
        
        if ([self.selectedFile isEqualToString:[self.files objectAtIndex:indexPath.row]])
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    } else if (indexPath.section == 2) {
        NSInteger number = 0;
        switch (indexPath.row) {
            case 0:
                number = 1;
                break;
            case 1:
                number = 5;
                break;
            case 2:
                number = 25;
                break;
            case 3:
                number = 50;
                break;
            case 4:
                number = 100;
                break;
            case 5:
            default:
                number = 1000;
                break;
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"%i times", number];
        
        if (self.repeats == number)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        NSString *parserName = cell.textLabel.text;
        
        if ([[self.libraries objectForKey:parserName] boolValue] == YES) {
            [self.libraries setObject:@(NO) forKey:parserName];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            [self.libraries setObject:@(YES) forKey:parserName];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }

    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (![self.selectedFile isEqualToString:[self.files objectAtIndex:indexPath.row]]) {

            NSIndexPath *prevSelection = nil;
            if (self.selectedFile != nil) {
                prevSelection = [NSIndexPath indexPathForRow:[self.files indexOfObject:self.selectedFile]
                                                   inSection:indexPath.section];
            }
            self.selectedFile = [self.files objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            if (prevSelection)
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:prevSelection, nil]
                                 withRowAnimation:UITableViewRowAnimationAutomatic];
        }

    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        NSInteger number = 0;
        switch (indexPath.row) {
            case 0:
                number = 1;
                break;
            case 1:
                number = 5;
                break;
            case 2:
                number = 25;
                break;
            case 3:
                number = 50;
                break;
            case 4:
                number = 100;
                break;
            case 5:
            default:
                number = 1000;
                break;
        }
        
        if (self.repeats == number) return;
        
        NSInteger prevSelection = 0;
        switch (self.repeats) {
            case 1:
                prevSelection = 0;
                break;
            case 5:
                prevSelection = 1;
                break;
            case 25:
                prevSelection = 2;
                break;
            case 50:
                prevSelection = 3;
                break;
            case 100:
                prevSelection = 4;
                break;
            default:
                break;
        }
        
        
        NSIndexPath *selection = [NSIndexPath indexPathForRow:prevSelection
                                                    inSection:2];
        
        self.repeats = number;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:selection, nil]
                         withRowAnimation:UITableViewRowAnimationAutomatic];

    }
}

@end
