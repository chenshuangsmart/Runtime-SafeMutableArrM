//
//  NSMutableArray+SafeAccess.m
//  0416_safeMutableArray
//
//  Created by cs on 2018/4/16.
//  Copyright © 2018年 cs. All rights reserved.
//

#import "NSMutableArray+SafeAccess.h"
#import <objc/runtime.h>

@implementation NSMutableArray (SafeAccess)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id obj = [[self alloc] init];
        [obj swizzleMethod:@selector(addObject:) withMethod:@selector(safeAddObject:)];
        [obj swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(safeObjectAtIndex:)];
        [obj swizzleMethod:@selector(removeObjectAtIndex:) withMethod:@selector(safeRemoveObjectAtIndex:)];
    });
}

- (void)safeAddObject:(id)anObject
{
    if (anObject) {
        [self safeAddObject:anObject];
    }else{
        NSLog(@"add obj is nil");
    }
}

- (id)safeObjectAtIndex:(NSInteger)index
{
    if(index<[self count]){
        return [self safeObjectAtIndex:index];
    }else{
        NSLog(@"read index is beyond");
    }
    return nil;
}

- (void)safeRemoveObjectAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
        NSLog(@"remove object index is beyond");
        return;
    }
    
    return [self safeRemoveObjectAtIndex:index];
}

- (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector
{
    Class cls = [self class];

    Method originalMethod = class_getInstanceMethod(cls, origSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, newSelector);

    BOOL didAddMethod = class_addMethod(cls,
                                        origSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(cls,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


@end
