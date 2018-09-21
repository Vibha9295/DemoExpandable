//
//  ViewController.h
//  ExpandTableView
//
//  Created by krutagn on 11/07/16.
//  Copyright © 2016 com.zaptechsolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray  *arrayForBool;
    NSArray *sectionTitleArray;
    NSMutableArray *fruitData,*fruitImage;
    NSMutableArray *vegData,*vegImage;
    NSMutableArray *allAry;
}
@property (weak, nonatomic) IBOutlet UITableView *expandableTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)btn_Search:(id)sender;

- (IBAction)btn_Hide:(id)sender;
@end
