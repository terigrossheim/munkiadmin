//
//  PkginfoAssimilator.m
//  MunkiAdmin
//
//  Created by Juutilainen Hannes on 3.12.2012.
//
//

#import "PkginfoAssimilator.h"
#import "MunkiAdmin_AppDelegate.h"
#import "DataModelHeaders.h"
#import "MunkiRepositoryManager.h"

@interface PkginfoAssimilator () {
    
}

@end

@implementation PkginfoAssimilator

@synthesize delegate;
@synthesize modalSession;
@synthesize sourcePkginfo;
@synthesize targetPkginfo;
@synthesize allPackagesArrayController;
@synthesize okButton;
@synthesize cancelButton;

@synthesize assimilate_blocking_applications;
@synthesize assimilate_requires;
@synthesize assimilate_update_for;
@synthesize assimilate_supported_architectures;
@synthesize assimilate_installs_items;
@synthesize assimilate_installer_choices_xml;
@synthesize assimilate_items_to_copy;

@synthesize assimilate_autoremove;
@synthesize assimilate_description;
@synthesize assimilate_display_name;
@synthesize assimilate_installable_condition;
@synthesize assimilate_maximum_os_version;
@synthesize assimilate_minimum_munki_version;
@synthesize assimilate_minimum_os_version;
@synthesize assimilate_name;
@synthesize assimilate_unattended_install;
@synthesize assimilate_unattended_uninstall;
@synthesize assimilate_uninstallable;
@synthesize assimilate_uninstaller_item_location;

@synthesize assimilate_installcheck_script;
@synthesize assimilate_preinstall_script;
@synthesize assimilate_postinstall_script;
@synthesize assimilate_preuninstall_script;
@synthesize assimilate_postuninstall_script;
@synthesize assimilate_uninstall_method;
@synthesize assimilate_uninstall_script;
@synthesize assimilate_uninstallcheck_script;


- (id)initWithWindow:(NSWindow *)window
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"debug"]) {
		NSLog(@"%@", NSStringFromSelector(_cmd));
	}
    self = [super initWithWindow:window];
    if (self) {
        NSArray *basicKeys = [NSArray arrayWithObjects:
                              @"assimilate_autoremove",
                              @"assimilate_description",
                              @"assimilate_display_name",
                              @"assimilate_installable_condition",
                              @"assimilate_maximum_os_version",
                              @"assimilate_minimum_munki_version",
                              @"assimilate_minimum_os_version",
                              @"assimilate_name",
                              @"assimilate_unattended_install",
                              @"assimilate_unattended_uninstall",
                              @"assimilate_uninstallable",
                              @"assimilate_uninstaller_item_location",
                              nil];
        NSArray *scriptKeys = [NSArray arrayWithObjects:
                              @"assimilate_installcheck_script",
                              @"assimilate_preinstall_script",
                              @"assimilate_postinstall_script",
                              @"assimilate_preuninstall_script",
                              @"assimilate_postuninstall_script",
                              @"assimilate_uninstall_method",
                              @"assimilate_uninstall_script",
                              @"assimilate_uninstallcheck_script",
                              nil];
        NSArray *arrayKeys = [NSArray arrayWithObjects:
                              @"assimilate_blocking_applications",
                              @"assimilate_installer_choices_xml",
                              @"assimilate_installs_items",
                              @"assimilate_items_to_copy",
                              @"assimilate_requires",
                              @"assimilate_supported_architectures",
                              @"assimilate_update_for",
                              nil];
        keyGroups = [[NSDictionary alloc] initWithObjectsAndKeys:
                     basicKeys, @"basicKeys",
                     scriptKeys, @"scriptKeys",
                     arrayKeys, @"arrayKeys",
                     nil];
        
        defaultsKeysToLoop = [[NSArray alloc] initWithObjects:
                              @"assimilate_autoremove",
                              @"assimilate_blocking_applications",
                              @"assimilate_description",
                              @"assimilate_display_name",
                              @"assimilate_installable_condition",
                              @"assimilate_installcheck_script",
                              @"assimilate_installer_choices_xml",
                              @"assimilate_installs_items",
                              @"assimilate_items_to_copy",
                              @"assimilate_maximum_os_version",
                              @"assimilate_minimum_munki_version",
                              @"assimilate_minimum_os_version",
                              @"assimilate_name",
                              @"assimilate_preinstall_script",
                              @"assimilate_postinstall_script",
                              @"assimilate_preuninstall_script",
                              @"assimilate_postuninstall_script",
                              @"assimilate_requires",
                              @"assimilate_supported_architectures",
                              @"assimilate_unattended_install",
                              @"assimilate_unattended_uninstall",
                              @"assimilate_uninstall_method",
                              @"assimilate_uninstall_script",
                              @"assimilate_uninstallable",
                              @"assimilate_uninstallcheck_script",
                              @"assimilate_uninstaller_item_location",
                              @"assimilate_update_for",
                              nil];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [self.window center];
    
    NSSortDescriptor *sortByTitle = [NSSortDescriptor sortDescriptorWithKey:@"munki_name" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSSortDescriptor *sortByVersion = [NSSortDescriptor sortDescriptorWithKey:@"munki_version" ascending:YES selector:@selector(localizedStandardCompare:)];
    [self.allPackagesArrayController setSortDescriptors:[NSArray arrayWithObjects:sortByTitle, sortByVersion, nil]];
    
    
}

- (void)commitChangesToCurrentPackage
{
    for (NSString *assimilateKeyName in [keyGroups objectForKey:@"basicKeys"]) {
        if ([[self valueForKey:assimilateKeyName] boolValue]) {
            NSString *munkiadminKeyName = [assimilateKeyName stringByReplacingOccurrencesOfString:@"assimilate_" withString:@"munki_"];
            id sourceValue = [self.sourcePkginfo valueForKey:munkiadminKeyName];
            [self.targetPkginfo setValue:sourceValue forKey:munkiadminKeyName];
        }
    }
    
    for (NSString *assimilateKeyName in [keyGroups objectForKey:@"scriptKeys"]) {
        if ([[self valueForKey:assimilateKeyName] boolValue]) {
            NSString *munkiadminKeyName = [assimilateKeyName stringByReplacingOccurrencesOfString:@"assimilate_" withString:@"munki_"];
            id sourceValue = [self.sourcePkginfo valueForKey:munkiadminKeyName];
            [self.targetPkginfo setValue:sourceValue forKey:munkiadminKeyName];
        }
    }
    
    NSManagedObjectContext *moc = [[NSApp delegate] managedObjectContext];
    MunkiRepositoryManager *repoManager = [MunkiRepositoryManager sharedManager];
        
    // Blocking applications
    if (self.assimilate_blocking_applications) {
        for (StringObjectMO *blockingApp in self.sourcePkginfo.blockingApplications) {
            StringObjectMO *newBlockingApplication = [NSEntityDescription insertNewObjectForEntityForName:@"StringObject" inManagedObjectContext:moc];
            newBlockingApplication.title = blockingApp.title;
            newBlockingApplication.typeString = @"package";
            [self.targetPkginfo addBlockingApplicationsObject:newBlockingApplication];
        }
    }
    
    // Requires
    if (self.assimilate_requires) {
        for (StringObjectMO *requiresItem in self.sourcePkginfo.requirements) {
            StringObjectMO *newRequiredPkgInfo = [NSEntityDescription insertNewObjectForEntityForName:@"StringObject" inManagedObjectContext:moc];
            newRequiredPkgInfo.title = requiresItem.title;
            newRequiredPkgInfo.typeString = @"package";
            [self.targetPkginfo addRequirementsObject:newRequiredPkgInfo];
        }
    }
    
    // Update for
    if (self.assimilate_update_for) {
        for (StringObjectMO *updateForItem in self.sourcePkginfo.updateFor) {
            StringObjectMO *newUpdateForItem = [NSEntityDescription insertNewObjectForEntityForName:@"StringObject" inManagedObjectContext:moc];
            newUpdateForItem.title = updateForItem.title;
            newUpdateForItem.typeString = @"package";
            [self.targetPkginfo addUpdateForObject:newUpdateForItem];
        }
    }
    
    // Supported architectures
    if (self.assimilate_supported_architectures) {
        for (StringObjectMO *supportedArch in self.sourcePkginfo.supportedArchitectures) {
            StringObjectMO *newSupportedArchitecture = [NSEntityDescription insertNewObjectForEntityForName:@"StringObject" inManagedObjectContext:moc];
            newSupportedArchitecture.title = supportedArch.title;
            newSupportedArchitecture.typeString = @"architecture";
            [self.targetPkginfo addSupportedArchitecturesObject:newSupportedArchitecture];
        }
    }
    
    // Installs
    if (self.assimilate_installs_items) {
        [repoManager copyInstallsItemsFrom:self.sourcePkginfo target:self.targetPkginfo inManagedObjectContext:moc];
    }
    
    // Installer choices XML
    if (self.assimilate_installer_choices_xml) {
        [repoManager copyInstallerChoicesFrom:self.sourcePkginfo target:self.targetPkginfo inManagedObjectContext:moc];
    }
    
    // Items to copy
    if (self.assimilate_items_to_copy) {
        [repoManager copyItemsToCopyItemsFrom:self.sourcePkginfo target:self.targetPkginfo inManagedObjectContext:moc];
    }
}

- (IBAction)saveAction:(id)sender;
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"debug"]) {
		NSLog(@"%@", NSStringFromSelector(_cmd));
	}
    
    [self commitChangesToCurrentPackage];
    
    [[self window] orderOut:sender];
    [NSApp endModalSession:modalSession];
    [NSApp stopModal];
    
    if ([self.delegate respondsToSelector:@selector(pkginfoAssimilatorDidFinish:returnCode:object:)]) {
        [self.delegate pkginfoAssimilatorDidFinish:self returnCode:NSOKButton object:nil];
    }
}

- (IBAction)cancelAction:(id)sender;
{
    [[self window] orderOut:sender];
    [NSApp endModalSession:modalSession];
    [NSApp stopModal];
    
    if ([self.delegate respondsToSelector:@selector(pkginfoAssimilatorDidFinish:returnCode:object:)]) {
        [self.delegate pkginfoAssimilatorDidFinish:self returnCode:NSCancelButton object:nil];
    }
}


- (IBAction)enableAllAction:(id)sender
{
    for (NSString *aKey in defaultsKeysToLoop) {
        [self setValue:[NSNumber numberWithBool:YES] forKey:aKey];
    }
}


- (IBAction)disableAllAction:(id)sender
{
    for (NSString *aKey in defaultsKeysToLoop) {
        [self setValue:[NSNumber numberWithBool:NO] forKey:aKey];
    }
}

- (NSUndoManager*)windowWillReturnUndoManager:(NSWindow*)window
{
    if (!undoManager) {
        undoManager = [[NSUndoManager alloc] init];
    }
    return undoManager;
}

- (void)dealloc
{
    [undoManager release];
    [super dealloc];
}

- (NSModalSession)beginEditSessionWithObject:(PackageMO *)targetPackage source:(PackageMO *)sourcePackage delegate:(id)modalDelegate
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"debug"]) {
		NSLog(@"%@", NSStringFromSelector(_cmd));
	}
    self.targetPkginfo = targetPackage;
    self.sourcePkginfo = nil;
    if (sourcePackage != nil) {
        self.sourcePkginfo = sourcePackage;
    }
    self.delegate = modalDelegate;
    
    self.modalSession = [NSApp beginModalSessionForWindow:self.window];
    [NSApp runModalSession:self.modalSession];
    
    // Setup the default selection
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    for (NSString *assimilateKeyName in [keyGroups objectForKey:@"basicKeys"]) {
        BOOL sourceValue = [defaults boolForKey:assimilateKeyName];
        [self setValue:[NSNumber numberWithBool:sourceValue] forKey:assimilateKeyName];
    }
    for (NSString *assimilateKeyName in [keyGroups objectForKey:@"scriptKeys"]) {
        BOOL sourceValue = [defaults boolForKey:assimilateKeyName];
        [self setValue:[NSNumber numberWithBool:sourceValue] forKey:assimilateKeyName];
    }
    for (NSString *assimilateKeyName in [keyGroups objectForKey:@"arrayKeys"]) {
        BOOL sourceValue = [defaults boolForKey:assimilateKeyName];
        [self setValue:[NSNumber numberWithBool:sourceValue] forKey:assimilateKeyName];
    }
    
    return self.modalSession;
}



@end
