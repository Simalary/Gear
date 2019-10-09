#include <spawn.h>
#include <signal.h>

#define gearBundle @"/Library/Application Support/Gear"
#define localizedString(string) [[NSBundle bundleWithPath:gearBundle] localizedStringForKey:string value:@"" table:nil]


@interface PSUIPrefsListController : UIViewController
@end

%hook PSUIPrefsListController
- (void)viewDidLoad{
	%orig;
	UIBarButtonItem *restartSpringBoard = [[UIBarButtonItem alloc] initWithTitle:localizedString(@"NAVIGATION_ITEM_TITLE") style:UIBarButtonItemStylePlain target:self action:@selector(restartSpringBoardButtonClicked:)];
	self.navigationItem.rightBarButtonItem = restartSpringBoard;
}

%new
- (void)restartSpringBoardButtonClicked:(id)sender{
     UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:localizedString(@"ALERT_TITLE")
                                 message:localizedString(@"ALERT_MESSAGE")
                                 preferredStyle:UIAlertControllerStyleAlert];

    //Add Buttons

    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:localizedString(@"ALERT_YES")
                                style:UIAlertActionStyleDestructive
                                handler:^(UIAlertAction * action) {
									pid_t pid;
									int status;
									const char *argv[] = {"sbreload", NULL, NULL};
									posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)argv, NULL);
									waitpid(pid, &status, WEXITED);
                                }];

    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:localizedString(@"ALERT_CANCEL")
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {

                               }];

    [alert addAction:yesButton];
    [alert addAction:noButton];

    [self presentViewController:alert animated:YES completion:nil];
}
%end