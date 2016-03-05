//
//  ViewController.m
//  SearchTestWH35
//
//  Created by Nikolay Berlioz on 04.03.16.
//  Copyright © 2016 Nikolay Berlioz. All rights reserved.
//

#import "ViewController.h"
#import "Student.h"
#import "Sections.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *studentsArray;
@property (strong, nonatomic) NSMutableArray *sectionsArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.studentsArray = [NSMutableArray array];
    self.sectionsArray = [NSMutableArray array];
    
    for (int i = 0; i < 100; i++)
    {
        [self.studentsArray addObject:[Student randomStudent]];
    }
    
    self.studentsArray = [self sortArrayToMonthWithArray:self.studentsArray];
    
    self.sectionsArray = [self createDataForTableWith:self.studentsArray withFilter:self.searchBar.text];
}

#pragma mark - Private Methods

- (NSMutableArray*) createDataForTableWith:(NSMutableArray*)array withFilter:(NSString*)filterString
{
    NSMutableArray *sectionsArray = [NSMutableArray array];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger currentMonth = 0;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM"];
    
    for (Student *student in array)
    {
        if ([filterString length] > 0 && [student.firstName rangeOfString:filterString].location == NSNotFound)
        {
            continue;
        }
        
        NSInteger month = [calendar component:NSCalendarUnitMonth fromDate:student.dayOfBirthday];
        Sections *section = nil;
        
        if (currentMonth != month)
        {
            section = [[Sections alloc] init];
            section.sectionsName = [dateFormatter stringFromDate:student.dayOfBirthday];
            section.itemsArray = [NSMutableArray array];
            currentMonth = month;
            [sectionsArray addObject:section];
            
        }
        else
        {
            section = [sectionsArray lastObject];
        }
        [section.itemsArray addObject:student];
    }
    
    sectionsArray = [self sortItemsArray:sectionsArray];
    
    return sectionsArray;
}

- (NSMutableArray*) sortItemsArray:(NSMutableArray*)array
{
    for (Sections *section in array)
    {
        [section.itemsArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [[obj1 lastName] compare:[obj2 lastName]];
        }];
        
        [section.itemsArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [[obj1 firstName] compare:[obj2 firstName]];
        }];
    }
    
    return array;
}

- (NSMutableArray*) sortArrayToMonthWithArray:(NSMutableArray*)array
{
    [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 monthOfBirthday] < [obj2 monthOfBirthday] ? NSOrderedAscending : NSOrderedDescending;
    }];
    
    return array;
}


#pragma mark - UITableViewDataSource

- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (Sections *section in self.sectionsArray)
    {
        [array addObject:section.sectionsName];
    }
    
    return array;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionsArray count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.sectionsArray objectAtIndex:section] sectionsName];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Sections *sec = [self.sectionsArray objectAtIndex:section];
    
    return [sec.itemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    Sections *section = [self.sectionsArray objectAtIndex:indexPath.section];
    
    Student *student = [section.itemsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    
    static NSDateFormatter *dateFormatter = nil;
    
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    }
    
    cell.detailTextLabel.text = [dateFormatter stringFromDate:student.dayOfBirthday];
    
    cell.imageView.image = [UIImage imageNamed:@"image.ico"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.sectionsArray = [self createDataForTableWith:self.studentsArray withFilter:searchText];
    [self.tableView reloadData];
}

@end







































