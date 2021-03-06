//
//  TGFileLocation+Extensions.m
//  TelegramTest
//
//  Created by keepcoder on 28.10.13.
//  Copyright (c) 2013 keepcoder. All rights reserved.
//

#import "TGFileLocation+Extensions.h"

@implementation TGFileLocation (Extensions)

-(BOOL)isEqual:(id)object {
    return [object local_id] == self.local_id && [object volume_id] == self.volume_id && [object secret] == self.secret;
}

-(BOOL)isEncrypted {
    return self.local_id == -1;
}

DYNAMIC_PROPERTY(CacheKey);


- (NSString *) cacheKey {
    
    NSString *string = [self getCacheKey];
    if(!string) {
        string = [NSString stringWithFormat:@"%lu_%lu", self.volume_id, self.secret];
        [self setCacheKey:string];
    }
    
    return string;
}

DYNAMIC_PROPERTY(HashCacheKey);


- (NSUInteger) hashCacheKey {
    NSNumber *number = [self getHashCacheKey];
    if(!number) {
        number = [NSNumber numberWithUnsignedInteger:[[self cacheKey] hash]];
        [self setHashCacheKey:number];
    }
    return [[self cacheKey] hash];
}

-(BOOL)isEqualTo:(TGFileLocation *)object {
    return object.volume_id == self.volume_id && object.local_id == self.local_id && object.secret == self.secret;
}

@end
