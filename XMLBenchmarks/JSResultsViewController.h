//
//  JSResultsViewController.h
//  XMLBenchmarks
//
//  Created by Jan Sanchez on 11/24/12.
//  Copyright (c) 2012 Jan Sanchez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSResultsViewController : UIViewController

@property (strong, nonatomic) NSArray *selectedLibraries;
@property (copy, nonatomic) NSString *selectedFile;
@property (assign, nonatomic) NSInteger repeats;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
