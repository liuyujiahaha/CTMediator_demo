//
//  TargetProxy.h
//  note
//
//  Created by liuyujia on 2018/12/26.
//  Copyright © 2018 liuyujia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TargetProxy : NSProxy{
    id realObject1;
    id realObject2;
}

-(id)initWithTarget1:(id)t1 target2:(id)t2;

@end

NS_ASSUME_NONNULL_END
