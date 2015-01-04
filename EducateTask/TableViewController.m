//
//  TableViewController.m
//  EducateTask
//
//  Created by Admin on 21.12.14.
//  Copyright (c) 2014 rth. All rights reserved.
//

#import "TableViewController.h"
#import "PictureTableViewCell.h"
#import "AppDelegate.h"
#import "AttrText.h"

@interface TableViewController () {
    NSMutableArray     *dataArray;
}

@property (weak, nonatomic) IBOutlet UITableView    *tableView;
@property (weak, nonatomic) IBOutlet UITextField    *addTextField;
@property (weak, nonatomic) IBOutlet UIButton       *addButton;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArray                                   = @[].mutableCopy;
    
    self.title                                  = @"TableView";
    
    _tableView.delegate                         = self;
    _tableView.dataSource                       = self;
    _tableView.tableFooterView                  = [UIView new];
    _tableView.showsVerticalScrollIndicator     = NO;
    _tableView.allowsSelection                  = YES;
    [_tableView registerNib: [UINib nibWithNibName:@"PictureTableViewCell"
                                            bundle: [NSBundle mainBundle]]
     forCellReuseIdentifier:@"tableCell"];
    
//    UITapGestureRecognizer  *gestureRecognizer  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
//    
//    [self.view addGestureRecognizer:gestureRecognizer];
    
    _addTextField.autocorrectionType            = UITextAutocorrectionTypeNo;
    
    
    NSManagedObjectContext  *context            = APP_DELEGATE.managedObjectContext;
    NSFetchRequest          *fetchRequest       = [NSFetchRequest fetchRequestWithEntityName:@"AttrText"];
    NSError                 *error              = nil;
    NSArray                 *results            = [context executeFetchRequest:fetchRequest
                                                                         error:&error];
    if (error != nil) {
        NSLog(@"fetch error: %@", error);
        return;
    }
    dataArray                                   = results.mutableCopy;
    [_tableView reloadData];
    
    
    UIBarButtonItem     *editButton             = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                                   style:UIBarButtonItemStylePlain
                                                                                  target:self
                                                                                  action:@selector(editButtonPressed)];
    self.navigationItem.rightBarButtonItem      = editButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize      keyboardSize                    = [[[notification userInfo]
                                                    objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect      frame                           = self.view.frame;
    
    frame.origin.y                             -= keyboardSize.height;
    self.view.frame                             = frame;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGSize      keyboardSize                    = [[[notification userInfo]
                                                    objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect      frame                           = self.view.frame;
    
    frame.origin.y                             += keyboardSize.height;
    self.view.frame                             = frame;
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PictureTableViewCell    *cell               = [tableView dequeueReusableCellWithIdentifier:@"tableCell"
                                                                                  forIndexPath:indexPath];
    AttrText        *attrTextEntity             = (AttrText *)dataArray[indexPath.row];
    
    cell.pictureImgView.image                   = [UIImage imageNamed:@"kitten"];
    cell.attrTitleLabel.attributedText          = [self attrStringFromString:attrTextEntity.attrTextValue];
    cell.backgroundColor                        = [UIColor clearColor];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleInsert;
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSManagedObjectContext  *context            = APP_DELEGATE.managedObjectContext;
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        AttrText    *newRowEntity               = [NSEntityDescription insertNewObjectForEntityForName:@"AttrText"
                                                                                inManagedObjectContext:context];
        newRowEntity.attrTextValue              = @"ololoabcdf";
        [APP_DELEGATE saveContext];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"increaseAttrText"
                                                            object:nil];
        
        [dataArray insertObject: newRowEntity
                        atIndex:indexPath.row];
        [_tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [context deleteObject:dataArray[indexPath.row]];
        [APP_DELEGATE saveContext];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"decreaseAttrText"
                                                            object:nil];
        
        [dataArray removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        NSManagedObjectContext  *context        = APP_DELEGATE.managedObjectContext;
        
        [_tableView beginUpdates];
        [context deleteObject:dataArray[indexPath.row]];
        [dataArray removeObject:dataArray[indexPath.row]];
        
        AttrText    *newRowEntity               = [NSEntityDescription insertNewObjectForEntityForName:@"AttrText"
                                                                                inManagedObjectContext:context];
        newRowEntity.attrTextValue              = @"mmmmm";
        [dataArray insertObject: newRowEntity
                        atIndex:indexPath.row];
        newRowEntity                            = [NSEntityDescription insertNewObjectForEntityForName:@"AttrText"
                                                                                inManagedObjectContext:context];
        newRowEntity.attrTextValue              = @"mmmmm222";
        [dataArray insertObject: newRowEntity
                        atIndex:indexPath.row + 1];
        [APP_DELEGATE saveContext];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"increaseAttrText"
                                                            object:nil];
        
        [_tableView deleteRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
        [_tableView insertRowsAtIndexPaths:@[
                                             indexPath,
                                             [NSIndexPath indexPathForRow:indexPath.row + 1
                                                                inSection:indexPath.section]
                                             ]
                          withRowAnimation:UITableViewRowAnimationFade];
        
        [_tableView endUpdates];
    }
}

- (NSAttributedString *)attrStringFromString:(NSString *)text {
    NSMutableAttributedString  *attrString      = [[NSMutableAttributedString alloc]
                                                   initWithString:text
                                                   attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20.0]}];
    
    if (attrString.length < 3) {
        return attrString;
    }
    if (attrString.length > 5) {
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:[UIColor redColor]
                           range:NSMakeRange(3, 3)];
    }
    [attrString addAttribute:NSFontAttributeName
                       value:[UIFont boldSystemFontOfSize:10]
                       range:NSMakeRange(0, 3)];

    NSRange substrRange                         = [text rangeOfString:@"abcd"];
    if (substrRange.location != NSNotFound) {
        [attrString addAttributes:@{
                                    NSFontAttributeName:            [UIFont systemFontOfSize:30],
                                    NSBackgroundColorAttributeName: [UIColor greenColor],
                                    NSForegroundColorAttributeName: [UIColor redColor],
                                    NSStrokeColorAttributeName:     [UIColor blackColor],
                                    NSStrokeWidthAttributeName:     [NSNumber numberWithInt:-2]
                                    }
                            range:substrRange];
    }
    [attrString addAttribute:NSBackgroundColorAttributeName
                       value:[UIColor blueColor]
                       range:NSMakeRange(0, 1)];
    return attrString;
}

- (IBAction)addButtonPressed {
    if (_addTextField.text.length == 0) {
        return;
    }
    NSManagedObjectContext  *context            = APP_DELEGATE.managedObjectContext;
    AttrText                *newEntity          = [NSEntityDescription insertNewObjectForEntityForName:@"AttrText"
                                                                                inManagedObjectContext:context];
    
    newEntity.attrTextId                        = @0;
    newEntity.attrTextValue                     = _addTextField.text;
    [APP_DELEGATE saveContext];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"increaseAttrText"
                                                        object:nil];
    
//    [dataArray addObject:newEntity];
    [dataArray insertObject:newEntity atIndex:0];
    
    [_tableView beginUpdates];
    [_tableView insertRowsAtIndexPaths:@[
                                         [NSIndexPath indexPathForRow:0
                                                            inSection:0],
                                         ]
                      withRowAnimation:UITableViewRowAnimationFade];
    [_tableView endUpdates];
    
    [self hideKeyboard];
    _addTextField.text                          = @"";
}

- (void)editButtonPressed {
    [_tableView setEditing:!_tableView.editing animated:YES];
    _addTextField.enabled                       = !_addTextField.enabled;
    _addButton.enabled                          = !_addButton.enabled;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

@end
