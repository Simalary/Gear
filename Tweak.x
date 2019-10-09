#include <spawn.h>
#include <signal.h>

@interface PSUIPrefsListController : UIViewController
@end

%hook PSUIPrefsListController
- (void)viewDidLoad{
	%orig;
	UIBarButtonItem *restartSpringBoard = [[UIBarButtonItem alloc] initWithTitle:@"Restart SpringBoard" style:UIBarButtonItemStylePlain target:self action:@selector(restartSpringBoardButtonClicked:)];
	self.navigationItem.rightBarButtonItem = restartSpringBoard;
	[restartSpringBoard release];
}

%new
- (void)restartSpringBoardButtonClicked:(id)sender{
	pid_t pid;
	int status;
	const char *argv[] = {"sbreload", NULL, NULL};
	posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)argv, NULL);
	waitpid(pid, &status, WEXITED);
}
%end