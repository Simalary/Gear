#include <spawn.h>
#include <signal.h>

@interface PSUIPrefsListController : UIViewController
@end

%hook PSUIPrefsListController
- (void)viewDidLoad{
	%orig;
	UIBarButtonItem *restartSpringBoard = [[UIBarButtonItem alloc] initWithTitle:@"Restart SpringBoard" style:UIBarButtonItemStylePlain target:self action:@selector(restartSpringBoardButtonClicked:)];
	self.navigationItem.rightBarButtonItem = restartSpringBoard;
}

%new
- (void)restartSpringBoardButtonClicked:(id)sender{
     UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Settings"
                                 message:@"Are you sure you want to restart SpringBoard?"
                                 preferredStyle:UIAlertControllerStyleAlert];

    //Add Buttons

    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDestructive
                                handler:^(UIAlertAction * action) {
									pid_t pid;
									int status;
									const char *argv[] = {"sbreload", NULL, NULL};
									posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)argv, NULL);
									waitpid(pid, &status, WEXITED);
                                }];

    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Cancel"
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {

                               }];

    [alert addAction:yesButton];
    [alert addAction:noButton];

    [self presentViewController:alert animated:YES completion:nil];
}
%end