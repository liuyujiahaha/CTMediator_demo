//
//  TargetProxy.m
//  note
//
//  Created by liuyujia on 2018/12/26.
//  Copyright © 2018 liuyujia. All rights reserved.
//

#import "TargetProxy.h"

@implementation TargetProxy
-(id)initWithTarget1:(id)t1 target2:(id)t2{
    realObject1 = t1;
    realObject2 = t2;
    return self;
    
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    NSMethodSignature *sig;
    sig = [realObject1 methodSignatureForSelector:sel];
    if (sig) {
        return sig;
    }
    sig = [realObject2 methodSignatureForSelector:sel];
    return sig;
}

-(void)forwardInvocation:(NSInvocation *)invocation{
    id target = [realObject1 methodSignatureForSelector:[invocation selector]]?realObject1:realObject2;
    
    [invocation invokeWithTarget:target];
}

-(BOOL)respondsToSelector:(SEL)aSelector{
    if ([realObject1 respondsToSelector:aSelector]) {
        return YES;
    }
    if ([realObject2 respondsToSelector:aSelector]) {
        return YES;
    }
    return NO;
    
}


@end
