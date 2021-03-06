/*
 * Copyright 2010 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <UIKit/UIKit.h>
#import "FBViewController.h"

@class FBSession;

/*!
 @protocol 
 
 @abstract
 The `FBUserSettingsDelegate` protocol defines the methods called by a <FBUserSettingsViewController>.
 */
@protocol FBUserSettingsDelegate <FBViewControllerDelegate>

@optional

/*!
 @abstract
 Called when the view controller will log the user out in response to a button press.

 @param sender          The view controller sending the message.
 */
- (void)loginViewControllerWillLogUserOut:(id)sender;

/*!
 @abstract
 Called after the view controller logged the user out in response to a button press.

 @param sender          The view controller sending the message.
 */
- (void)loginViewControllerDidLogUserOut:(id)sender;

/*!
 @abstract
 Called when the view controller will log the user in in response to a button press.
 Note that logging in can fail for a number of reasons, so there is no guarantee that this
 will be followed by a call to loginViewControllerDidLogUserIn:. Callers wanting more granular
 notification of the session state changes can use KVO or the NSNotificationCenter to observe them.

 @param sender          The view controller sending the message.
 */
- (void)loginViewControllerWillAttemptToLogUserIn:(id)sender;

/*!
 @abstract
 Called after the view controller successfully logged the user in in response to a button press.

 @param sender          The view controller sending the message.
 */
- (void)loginViewControllerDidLogUserIn:(id)sender;

/*!
 @abstract
 Called if the view controller encounters an error while trying to log a user in.

 @param sender          The view controller sending the message.
 @param error           The error encountered.
 */
- (void)loginViewController:(id)sender receivedError:(NSError *)error;

@end


/*!
 @class FBUserSettingsViewController
 
 @abstract
 The `FBUserSettingsViewController` class provides a user interface exposing a user's
 Facebook-related settings. Currently, this is limited to whether they are logged in or out
 of Facebook.
 */
@interface FBUserSettingsViewController : FBViewController

/*!
 @abstract
 The permissions to request if the user logs in via this view.
 */
@property (nonatomic, retain) NSArray *permissions;

@end

