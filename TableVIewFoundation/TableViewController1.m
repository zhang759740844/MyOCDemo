//
//  TableViewController1.m
//  AutoHeightTableViewDemo
//
//  Created by Zachary on 16/8/24.
//  Copyright © 2016年 Zachary. All rights reserved.
//

#import "TableViewController1.h"
#import "TableViewCell1.h"
@interface TableViewController1 ()<MyDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *data;
//  heightForRowAtIndexPath 需要用到
@property (nonatomic, strong) TableViewCell1 *cell;

// 要用strong ，因为这个tableview是自己创建的。如果是weak那么指向的地方在创建后就被ARC回收了,那么这个tableview指针就成了野指针了。
//  如果是连线的就可以用weak，weak属性一般用在当前属性是其他类创建，只存一个该属性的引用的时候，为了强引用那个类。
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation TableViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    //Plain将会保持在顶部直到被顶掉。
    //grouped 将会随着cell一起滚动
    self.tableView = [[UITableView alloc]initWithFrame: [ UIScreen mainScreen ].applicationFrame style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    _data = [NSMutableArray arrayWithArray:@[@"1\n2\n3\n4\n5\n6\n7\n8",@"1\n2\n3\n4\n5\n6\n7",@"1\n2\n3\n4\n5\n6",@"1\n2\n3\n4\n5",@"1\n2\n3\n4",@"1\n2\n3",@"1\n2",@"1"]];
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell1" bundle:nil] forCellReuseIdentifier:tableViewCell1];
    _cell = [self.tableView dequeueReusableCellWithIdentifier:tableViewCell1];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    UIView *header = [[[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil] lastObject];
    [self.tableView setTableHeaderView:header];
    
}


#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // loadNibNamed 和 initWithNibName 区别
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil] lastObject];
    return view;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"%ld",(long)section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCell1];
    cell.delegate = self;
    [cell initCellView:[_data objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    _cell.label.text = [_data objectAtIndex:indexPath.row];
    CGSize textHeight = [_cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGFloat height = textHeight.height+1>90?textHeight.height+1:90;
    return height;
}

// 会先调用N次获取tableview的大致高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_data replaceObjectAtIndex:indexPath.row withObject:@"我是修改的row"];
    
    //下面两个方法都能刷新数据，一个刷新一条，一个刷新整个section
    //这个方法部分刷新部分cell，在cell中数据变化时调用。不能用于删除cell，必须保证update前后数据的条数一样。
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    //这个reloadSections方法会局部刷新Section,调用刷新section里面各个cell以及headfootView的各个方法。并且可以使用动画。
//    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]withRowAnimation:UITableViewRowAnimationLeft];
}

//旁边的索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *indexs = [[NSMutableArray alloc]init];
    [indexs addObject:@"我"];
    [indexs addObject:@"是"];
    [indexs addObject:@"帅哥"];
    return indexs;
}


//其中delete可以在不设置[_tableView setEditing:!_tableView.isEditing animated:true]时，通过左滑做到
//插入则必须通过[_tableView setEditing:!_tableView.isEditing animated:true]进入编辑模式才可使用
//插入删除操作不是一定要在编辑模式才可以，任何时候都可以调用deleteRowsAtIndexPaths：insertRowsAtIndexPaths：方法，删除添加cell
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.data removeObjectAtIndex:indexPath.row];
        //indexPath 只能用init创建，创建后的row，section不能改变
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:indexPath.row inSection:!indexPath.section];
        
        //下面两条都能删除，一个刷新一条，一个刷新整个section。不能用reloadRowsAtIndexPaths删除、
        //NSIndexSet的创建方式如下，多个需要用到range。
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath,indexPath2] withRowAnimation:UITableViewRowAnimationFade];
    }else if (editingStyle == UITableViewCellEditingStyleInsert){
        [_data insertObject:@"我是新来的" atIndex:indexPath.row];
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:indexPath.row inSection:!indexPath.section];
        [_tableView insertRowsAtIndexPaths:@[indexPath,indexPath2] withRowAnimation:UITableViewRowAnimationBottom];
    }
}

// 设置能编辑的行
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return YES;
    }else{
        return NO;
    }
}

//该方法实现cell移动
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSString *string = [_data objectAtIndex:sourceIndexPath.row];
    [_data removeObjectAtIndex:sourceIndexPath.row];
    [_data insertObject:string atIndex:destinationIndexPath.row];
}

// 设置编辑模式下 是删除还是插入
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (true) {
        return UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleDelete;
}


- (void)buttonPressed:(TableViewCell1 *)cell event:(UIEvent *)event{
    NSSet *touched=[event allTouches];
    UITouch*touch=[touched anyObject];
    CGPoint cure=[touch locationInView:self.tableView];
    NSIndexPath *indexPath=[self.tableView indexPathForRowAtPoint:cure];
    NSLog(@"所属行数：%ld",(long)indexPath.row+1);
//    TableViewCell1 *cell = (TableViewCell1)[[cell superview] superview];
//    NSIndexPath* index=[_tableView indexPathForCell:cell];
    NSIndexPath *indexPath2 = [_tableView indexPathForCell:cell];
    NSLog(@"所属行数：%ld",(long)indexPath2.row+1);
}



@end
