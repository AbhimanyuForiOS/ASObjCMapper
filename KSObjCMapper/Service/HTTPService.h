//
//  HTTPService.h
//
//  Created by Ashish Sharma on 30/05/15.
//  Copyright (c) 2015 Konstant Info. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
//base URL for all HTTP communication
//Local Url Akhilesh
//#define BASE_URL    @"http://192.168.0.158:9100/"
//#define BASE_URL_SYNC       @"http://192.168.0.158:9110/"

//Local Url Kirtesh
//#define BASE_URL    @"http://192.168.0.193:9100/"
//#define BASE_URL_SYNC       @"http://192.168.0.158:9110/"

//DEVELOPMENT
//#define BASE_URL    @"http://52.42.64.178:9100/"
//#define BASE_URL_SYNC    @"http://52.42.64.178:9110/"

//STAGING
//#define BASE_URL       @"http://52.42.64.178:9102/"
//#define BASE_URL_SYNC  @"http://52.42.64.178:9112/"

//TESTING
#define BASE_URL            @"http://52.42.64.178:9101/"
#define BASE_URL_SYNC       @"http://52.42.64.178:9111/"

//USER
#define SOCIAL_LOGIN_API @"users/social_login"
#define SOCIAL_SIGNUP_API @"users/social_signup"
#define LOGIN_API @"users/login"
#define EMAIL_SIGNUP_API @"users/register"
#define USER_SETTINGS_API @"user_settings"
#define SEND_CODE_API @"users/send_authentication_code"
#define MERGE_ACCOUNT_API @"users/merge_account"
#define AUTHENTICATE_CODE_API @"users/authenticate"
#define FORGOT_PASSWORD_API @"users/forgot_password"
#define HAS_NEXUS_API @"find_nexus"
#define USER_PROFILE_API @"users/profile"
#define OTHER_USER_PROFILE_API @"users/other_profile"
#define UPDATE_PROFILE_API @"users/edit_profile"

//Claim Email
#define CLAIM_EMAIL_API @"claim/email"
#define CLAIM_VERIFY_EMAIL_API @"claim/verify_otp"
#define CLAIM_UPDATE_EMAIL_API @"claim/update_email"
#define CLAIM_VERIFY_UPDATED_EMAIL_API @"claim/verify_updated_otp"

//INTEREST
#define INTEREST_API @"interests/fetch"
#define INTEREST_CREATE_API @"interests/create"
#define INTEREST_ADD_API @"interests/add"

#define MY_INTEREST @"interests/myInterests"

//NeverDo / RarelyDo / UsuallyDo / AlwaysDo / Delete
///interests/myInterests/{itype}



//LDT
#define CREATE_LDT_API @"ldt/create"
#define SHOW_LDT_API @"ldt/show"
#define LDT_IM_IN @"/ldt/i_am_in"
#define UPDATE_SETTINGS @"/ldt/updateNotifications"

//My FUTURE
#define FUTURE_CREATED_LDT_API @"future/created/"
#define FUTURE_RECEIVED_LDT_API @"future/received/"
#define INVITE_USERS @"invite/inviteUsers"

//LOOKING BACK
#define LOOKING_BACK_CREATED_API @"look_back/created/"
#define LOOKING_BACK_RECEIVED_API @"look_back/received/"

//Suggestions APIs
#define SUGGESTIONS_LIST_API @"suggestion/list"
#define SUGGESTIONS_CREATE_API @"suggestion/create"
#define SUGGESTIONS_VOTE_API @"suggestion/vote"
#define SEND_REACTIONS_API @"suggestion/send_reaction"
#define REACTIONS_LIST_API @"suggestion/reaction_list"
#define DECIDE_SUGGESTION_API @"decision/"
#define CANCEL_LDT @"ldt/cancel"

//NEXUS
#define NEXUS_LIST_API @"my_nexus/fetchNexus"
#define NEXUS_INVITE_API @"invite/invite_nexus"

//Activities APIs
#define ACTIVITY_CREATE_API @"activity/create"
#define ACTIVITY_SHOW_API @"activity/show"

#define ACTIVITY_INTERESTED_USERS @"activity/related_users"


//Google places web service API to show suggetions on map screen
#define GOOGLE_PLACES_API @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="

typedef NS_ENUM(NSInteger, kHttpMethodType) {
    kHttpMethodTypeGet      = 0,    // GET
    kHttpMethodTypePost     = 1,    // POST
    kHttpMethodTypeDelete   = 2,    // DELETE
    kHttpMethodTypePut      = 3     // PUT
};

typedef NS_ENUM(NSInteger, kHttpStatusCode) {
    kHttpStatusCodeOK   = 0,    //200 SUCCESS
    kHttpStatusCodeNoResponse   = 1,    //204 NO RESPONSE
    kHttpStatusCodeBadRequest   = 2,    //400 BAD REQUEST
    kHttpStatusCodeUnAuthorized   = 3,    //401 UNAUTHORIZED
    kHttpStatusCodeNoSession   = 4    //404 NO SESSION
};

@interface HTTPService : NSObject
{
    /**
     *  HTTP session manager (AFNetworking Client)
     */
    AFHTTPSessionManager *httpSessionManager;
    
    /**
     *  Base URL for all http communication
     */
    NSString *httpBaseURL;
}

#pragma mark - Properties

/**
 *  Security Policy is for SSL pinning, default value is false.
 */
@property (nonatomic,assign) BOOL shouldUseSecurityPolicy;

#pragma mark - Designated Initializer

/**
 *  Designated initializer, initialize ServiceManager with base URL and URL session configuration
 *
 *  @param baseURL base URL
 *  @param config  URL session configuration
 *
 *  @return self
 */
- (id)initWithBaseURL:(NSURL*) baseURL andSessionConfig:(NSURLSessionConfiguration*) config;

#pragma mark - Instance Methods

/**
 *  Call this to create a request with any HTTP method
 *  NOTE: It posts params in raw JSON format
 *
 *  @param httpMethodType HTTP method type post,get etc
 *  @param headers        HTTP header key-value pair (no need to Content-Type,Accept)
 *  @param serviceName    name of service which need to call
 *  @param params         parameters in key-value pair
 *  @param success        success callback handler
 *  @param failure        failure callback handler
 *
 *  @return NSURLSessionDataTask object
 */
- (NSURLSessionDataTask*) startRequestWithHttpMethod:(kHttpMethodType) httpMethodType
                                     withHttpHeaders:(NSMutableDictionary*) headers
                                     withServiceName:(NSString*) serviceName
                                      withParameters:(NSMutableDictionary*) params
                                         withSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                         withFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  Call this to create a request with multipart/form-data
 *  NOTE: It posts params in raw form-data format
 *
 *  @param headers     HTTP header key-value pair (no need to Content-Type)
 *  @param serviceName name of service which need to call
 *  @param params      parameters in key-value pair
 *  @param files       array of NSData objects for file content
 *  @param success     success callback handler
 *  @param failure     failure callback handler
 *
 *  @return NSURLSessionDataTask object
 */
- (NSURLSessionDataTask*) startMultipartFormDataRequestWithHttpHeaders:(NSMutableDictionary*) headers
                                                       withServiceName:(NSString*) serviceName
                                                        withParameters:(NSMutableDictionary*) params
                                                          withFileData:(NSArray*) files
                                                           withSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                                           withFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


- (NSURLSessionDataTask*) startMultipartZipFormDataRequestWithHttpHeaders:(NSMutableDictionary*) headers
                                                          withServiceName:(NSString*) serviceName
                                                           withParameters:(NSMutableDictionary*) params
                                                             withFileData:(NSArray*) files
                                                              withSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                                              withFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


- (NSURLSessionDataTask*) startRequestWithContactSyncHttpMethod:(kHttpMethodType) httpMethodType
                                                withHttpHeaders:(NSMutableDictionary*) headers
                                                withServiceName:(NSString*) serviceName
                                                 withParameters:(NSMutableDictionary*) params
                                                    withSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                                    withFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
/**
 *  Call this to cancel all tasks running on single instance
 */
- (void) cancelAllTasks;

@end
