//
//  ChatViewController.m
//  Parse Chat
//
//  Created by rodrigoandrade on 7/10/19.
//  Copyright © 2019 rodrigoandrade. All rights reserved.
//

#import "ChatViewController.h"
#import "Parse/Parse.h"
#import "ChatCell.h"

@interface ChatViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textEdit;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *chatArray;


@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    
    
    //[self onTimer];
    [self refreshData];
}

- (void)onTimer {
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshData) userInfo:nil repeats:true];
}

- (void)refreshData{
    // construct PFQuery
    PFQuery *chatQuery = [PFQuery queryWithClassName:@"Message_fbu2019"];
    [chatQuery orderByDescending:@"createdAt"];
    // [chatQuery includeKey:@"author"];
    chatQuery.limit = 20;
    
    // fetch data asynchronously
    [chatQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable chats, NSError * _Nullable error) {
        if (chats) {
            self.chatArray = [NSArray arrayWithArray: chats];
            
            [self.tableView reloadData];
        }
        else {
            // handle error
        }
    }];
    
}
- (IBAction)didTapSend:(id)sender {
    PFObject *chatMessage = [PFObject objectWithClassName:@"Message_fbu2019"];
    // Use the name of your outlet to get the text the user typed
    chatMessage[@"text"] = self.textEdit.text;
    
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
            self.textEdit.text = nil;
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    PFObject *chatMessage = self.chatArray[indexPath.row];
    NSString * message = [chatMessage objectForKey:@"text"];
    // NSLog(@"%@", message);
    cell.chatMessageField.text = message;
    NSLog(@"%@", cell.chatMessageField.text);
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatArray.count;
}


@end
