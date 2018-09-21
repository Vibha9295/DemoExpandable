//
//  ViewController.m
//  ExpandTableView
//
//  Created by krutagn on 11/07/16.
//  Copyright © 2016 com.zaptechsolution. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIImageView *img;
    UIView *sectionView;
    NSMutableArray *filteredContentList;
    BOOL isSearching;
    BOOL collapsed;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.hidden=YES;
    filteredContentList = [[NSMutableArray alloc] init];
  
    // Do any additional setup after loading the view, typically from a nib.
    [self initialization];
    
}

-(void)initialization
{
    arrayForBool=[[NSMutableArray alloc]init];
    
    fruitData = [[NSMutableArray alloc]initWithObjects:@"Apple",@"Orange", nil];
    fruitImage = [[NSMutableArray alloc]initWithObjects:@"safarjan.jpg",@"narangi.jpg", nil];
    
    vegData = [[NSMutableArray alloc]initWithObjects:@"Bhinda",@"Karela",@"Kankoda",@"gavar",@"tindola", nil];
    vegImage = [[NSMutableArray alloc]initWithObjects:@"Bhindo.jpg",@"Karela.jpg",@"kankodo.jpg",@"gavar.jpeg",@"tindola.jpeg", nil];
    
    allAry = [[NSMutableArray alloc]init];
    
    for (int i=0; i<fruitData.count; i++) {
        [allAry addObject:fruitData[i]];
    }
    for (int i=0; i<vegData.count; i++) {
        [allAry addObject:vegData[i]];
    }
  
    
    sectionTitleArray=[[NSMutableArray alloc]initWithObjects:
                       @"Fruit",
                       @"Vegitable",
                       nil];
    
    for (int i=0; i<[sectionTitleArray count]; i++) {
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }
}


#pragma mark -
#pragma mark TableView DataSource and Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    

    if (isSearching) {
        
        
        return filteredContentList.count;
    }
    else
    {
    if (section==0) {
        return fruitData.count;
    }
    else
    {
       
            return [vegData count];
      

    }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellid=@"hello";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
   
    if (isSearching) {
        cell.textLabel.text = [filteredContentList objectAtIndex:indexPath.row];
    }
    else {
       // cell.textLabel.text = [allAry objectAtIndex:indexPath.row];
    


    
    
    BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
    
    /********** If the section supposed to be closed *******************/
    if(!manyCells)
    {
        

        cell.backgroundColor=[UIColor clearColor];
        
        cell.textLabel.text=@"";
    }
    /********** If the section supposed to be Opened *******************/
    else if(indexPath.section==0)
    {
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[fruitData objectAtIndex:indexPath.row]];
        cell.textLabel.font=[UIFont systemFontOfSize:15.0f];
        cell.backgroundColor=[UIColor whiteColor];
        cell.imageView.image=[UIImage imageNamed:[fruitImage objectAtIndex:indexPath.row]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    else
    {
        
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[vegData objectAtIndex:indexPath.row]];
        cell.textLabel.font=[UIFont systemFontOfSize:15.0f];
        cell.backgroundColor=[UIColor whiteColor];
        cell.imageView.image=[UIImage imageNamed:[vegImage objectAtIndex:indexPath.row]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone ;
    }
    cell.textLabel.textColor=[UIColor blackColor];
    
    /********** Add a custom Separator with cell *******************/
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 40, _expandableTableView.frame.size.width-15, 1)];
    separatorLineView.backgroundColor = [UIColor blackColor];
    [cell.contentView addSubview:separatorLineView];
    }
    return cell;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearching = YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     if (isSearching) {
         
             return 1;
     }
    else
    {
    return [sectionTitleArray count];
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"Text change - %d",isSearching);
    
    //Remove all objects first.
    [filteredContentList removeAllObjects];
    
    if([searchText length] != 0) {
        isSearching = YES;
        NSString *searchString = searchBar.text;
        
        for (NSString *tempStr in allAry)
        {
            NSComparisonResult result = [tempStr compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
            if (result == NSOrderedSame) {
                [filteredContentList addObject:tempStr];
            }
        }
        
    }
    else {
        isSearching = NO;
    }
    [self.expandableTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    NSString *searchString = searchBar.text;
    
    for (NSString *tempStr in allAry)
    {
        NSComparisonResult result = [tempStr compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
        if (result == NSOrderedSame) {
            [filteredContentList addObject:tempStr];
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*************** Close the section, once the data is selected ***********************************/
    [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:NO]];
    
    [_expandableTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
        return 40;
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(isSearching)
    {
        return 20;
    }
    else{
        
    return 40;
    }
}

#pragma mark - Creating View for TableView Section

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if(isSearching)
    {
        UIView *tmpview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 280,20)];
//        UILabel *viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, _expandableTableView.frame.size.width-10, 20)];
//        viewLabel.backgroundColor=[UIColor clearColor];
//        viewLabel.textColor=[UIColor blackColor];
//        viewLabel.font=[UIFont systemFontOfSize:15];
//        viewLabel.text=[NSString stringWithFormat:@"Search Result"];
        return tmpview;
    }
    else
    {
    sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 280,40)];
    sectionView.tag=section;
    

        img=[[UIImageView alloc]initWithFrame:CGRectMake(280, 10, 10, 15)];
        img.image=[UIImage imageNamed:@"carat.png"];
        [sectionView addSubview:img];


    UILabel *viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, _expandableTableView.frame.size.width-10, 40)];
    viewLabel.backgroundColor=[UIColor clearColor];
    viewLabel.textColor=[UIColor blackColor];
    viewLabel.font=[UIFont systemFontOfSize:15];
    viewLabel.text=[NSString stringWithFormat:@"List of %@",[sectionTitleArray objectAtIndex:section]];
    
    [sectionView addSubview:viewLabel];
    /********** Add a custom Separator with Section view *******************/
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 40, _expandableTableView.frame.size.width-15, 1)];
    separatorLineView.backgroundColor = [UIColor blackColor];
    [sectionView addSubview:separatorLineView];
    
    /********** Add UITapGestureRecognizer to SectionView   **************/
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionView addGestureRecognizer:headerTapped];
    
    
    
    return  sectionView;
    
    }
}


#pragma mark - Table header gesture tapped

- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    

    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
         collapsed = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i=0; i<[sectionTitleArray count]; i++) {
            if (indexPath.section==i) {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
                
            }
        }
        [_expandableTableView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if (collapsed==NO)
        {
            img.image=[UIImage imageNamed:@"carat-open.png"];
        }
        else
        {
            img.image=[UIImage imageNamed:@"carat.png"];
        }
        
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btn_Search:(id)sender {
    self.searchBar.hidden = NO;
    

}

- (IBAction)btn_Hide:(id)sender{
    
}
@end
