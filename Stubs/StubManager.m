
#import "StubManager.h"
#import "OHHTTPStubs.h"

#define RESPONSE_HEADE  @{@"Content-Type":@"application/json; charset=utf-8"}

@implementation StubManager


static StubManager *sharedData_ = nil;

+ (StubManager *)sharedManager{
    if (!sharedData_) {
        sharedData_ = [StubManager new];
    }
    return sharedData_;
}


#pragma mark - Private func

- (NSDictionary *)dictionaryFromQueryString:(NSString*)queryString {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSArray *pairs = [queryString componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

- (NSString*)filePath:(NSString*)fileName
{
    return OHPathForFileInBundle(fileName, [NSBundle mainBundle]);
}

#pragma mark - Public func

- (void)setupStub1
{
    static id<OHHTTPStubsDescriptor> stub1 = nil;
    
    stub1 = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        
        return [request.URL.absoluteString isEqualToString:@"http://dgg-n.com/"];
        
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        
        NSString *stringData = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
        NSDictionary *dict =  [self dictionaryFromQueryString:stringData];
        NSString *offset = dict[@"offset"];
        
        if (offset && [offset isEqualToString:@"0"]) {
            return [OHHTTPStubsResponse responseWithFileAtPath:[self filePath:@"sample1.json"]
                                              statusCode:200
                                                 headers:RESPONSE_HEADE];
        } else {
            return [OHHTTPStubsResponse responseWithFileAtPath:[self filePath:@"sample1.json"]
                                              statusCode:200
                                                 headers:RESPONSE_HEADE];
        }
    }];
    stub1.name = @"stub1";
}


@end
