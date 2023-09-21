import UIKit

let appDelegateClass: AnyClass = NSClassFromString("MockAppDelegate") ?? AppDelegate.self
UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegateClass))
