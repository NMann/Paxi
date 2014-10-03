//
//  PApiCall.m
//  PaxiApp
//
//  Created by TarunMahajan on 24/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PApiCall.h"
static PApiCall *_sharedAppManager = nil;
#define baseUrl @"http://deftsoft.info/paxiapp/paxi.php?method="
#define imageUrl @"http://deftsoft.info/paxiapp/images/"
#define imageUploadPath @"http://deftsoft.info/paxiapp/images/upload.php"
@implementation PApiCall

+(PApiCall *)sharedInstance
{
    if (!_sharedAppManager)
        _sharedAppManager = [[PApiCall alloc] init];
    return _sharedAppManager;
}
-(void)m_GetApiResponse:(NSString*)methodName parameters:(NSString*)param onCompletion:(JSONResponseBlock)completionBlock
{
    NSString *string=[NSString stringWithFormat:@"%@%@%@",baseUrl,methodName,param];
    NSURL *url = [NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
          completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [[NSOperationQueue currentQueue] addOperation:operation];

}
-(NSString *)uploadimage:(NSData*)imagedata
{
  
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:imageUploadPath]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\".jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imagedata]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSLog(@"first operation");
//    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSDictionary *responseDictonay=[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingAllowFragments error:nil ];
    NSLog(@"Return string is %@",responseDictonay);
    NSString *strImageUrl=nil;
    if ([[responseDictonay valueForKey:@"data"] length]>0)
    {
        strImageUrl=[NSString stringWithFormat:@"%@%@",imageUrl,[responseDictonay valueForKey:@"data"]];
        
    }
    return strImageUrl;
}

@end
