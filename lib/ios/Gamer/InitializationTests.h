//
//  InitializationTests.h
//  Gamer
//
//  Created by Adam Venturella on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

//  Application unit tests contain unit test code that must be injected into an application to run correctly.
//  Define USE_APPLICATION_UNIT_TEST to 0 if the unit test code is designed to be linked into an independent test executable.


#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
//#import "GMRClient.h"

@interface InitializationTests : SenTestCase 
{
}


//- (void) testMath;              // simple standalone test

- (void)testPlatformStrings;
- (void)testAuthenticateUser;
- (void)testVersion;
- (void)testSearchPlatformForGame;
- (void)testGamesForPlatform;
- (void)testMatch1Create;
- (void)testMatch2Join;
- (void)testMatch3Leave;
- (void)testMatch4Cancel;


@end
