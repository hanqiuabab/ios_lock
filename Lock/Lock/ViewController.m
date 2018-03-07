//
//  ViewController.m
//  Lock
//
//  Created by 陆久银 on 2018/3/7.
//  Copyright © 2018年 lujiuyin. All rights reserved.
//

#import "ViewController.h"
#import <pthread/pthread.h>
#import <libkern/OSAtomic.h>
#import <os/lock.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

#pragma mark -- @synchronized
    CFAbsoluteTime start;
    CFAbsoluteTime end;
    CFAbsoluteTime cost;
    NSInteger count = 1000000;
//    NSObject *obj = [[NSObject alloc] init];
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        @synchronized(obj){
//            NSLog(@"线程1开始");
//            sleep(5);
//            NSLog(@"线程1结束");
//        }
//    });
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        sleep(1);
//        NSLog(@"线程2开始");
//        @synchronized(self){
//            NSLog(@"线程2结束");
//        }
//    });
    {
        NSObject *lock = [[NSObject alloc] init];
        start = CFAbsoluteTimeGetCurrent();
        for (int i = 0; i < count; i++) {
            @synchronized(lock){}
        }
        end = CFAbsoluteTimeGetCurrent();
        cost = end - start;
        NSLog(@"synchronized = %f",cost);
    }

#pragma mark -- dispatch_semaphore
//    dispatch_semaphore_t signal = dispatch_semaphore_create(1);
//    dispatch_time_t timeout= dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        dispatch_semaphore_wait(signal, timeout);
//        NSLog(@"需要线程同步的操作1 开始");
//        sleep(3);
//        NSLog(@"需要线程同步的操作1 结束");
//        dispatch_semaphore_signal(signal);
//    });
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        sleep(1);
//        dispatch_semaphore_wait(signal, timeout);
//        NSLog(@"需要线程同步的操作2");
//        dispatch_semaphore_signal(signal);
//    });
    
    {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
        dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
        start = CFAbsoluteTimeGetCurrent();
        for (int i = 0; i < count; i++) {
            dispatch_semaphore_wait(semaphore, timeout);
            dispatch_semaphore_signal(semaphore);
        }
        end = CFAbsoluteTimeGetCurrent();
        cost = end - start;
        NSLog(@"dispatch_semaphore_t = %f",cost);
    }
    
#pragma mark -- NSLock
//    NSLock *lock = [[NSLock alloc] init];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [lock lockBeforeDate:[NSDate date]];
//
//        NSLog(@"需要线程同步的操作1 开始");
//        sleep(3);
//        NSLog(@"需要线程同步的操作1 结束");
//        [lock unlock];
//    });
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        sleep(1);
//        if ([lock tryLock]) {
//            NSLog(@"锁可用的操作");
//            sleep(1);
//            [lock unlock];
//        }else {
//            NSLog(@"锁不可用的操作");
//        }
//
//        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:3];
//        if ([lock lockBeforeDate:date]) {
//            NSLog(@"没有超时,获得锁");
//            [lock unlock];
//        }else {
//            NSLog(@"超时,没有获得锁");
//        }
//    });
    {
        NSLock *lock = [[NSLock alloc] init];
        start = CFAbsoluteTimeGetCurrent();
        for (int i = 0; i < count; i++) {
            [lock lock];
            [lock unlock];
        }
        end = CFAbsoluteTimeGetCurrent();
        cost = end - start;
        NSLog(@"NSLock = %f",cost);
    }
    
#pragma mark -- NSRecursiveLock
////    NSLock *lock = [[NSLock alloc] init];
//    NSRecursiveLock *lock = [[NSRecursiveLock alloc] init];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        static void (^RecursiveMethod)(int);
//        RecursiveMethod = ^(int value) {
//            [lock lock];
//            if (value > 0) {
//                NSLog(@"value = %d", value);
//                sleep(1);
//                RecursiveMethod(value - 1);
//            }
//            [lock unlock];
//        };
//        RecursiveMethod(5);
//    });
    {
        NSRecursiveLock *lock = [[NSRecursiveLock alloc] init];
        start = CFAbsoluteTimeGetCurrent();
        for (int i = 0; i < count; i++) {
            [lock lock];
            [lock unlock];
        }
        end = CFAbsoluteTimeGetCurrent();
        cost = end - start;
        NSLog(@"NSRecursiveLock = %f",cost);
    }
    
#pragma mark -- NSConditionLock
//    NSConditionLock *lock = [[NSConditionLock alloc] initWithCondition:0];
//    NSMutableArray *products = [NSMutableArray array];
//    NSInteger HAS_DATA = 1;
//    NSInteger NO_DATA = 0;
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        while (1) {
//            [lock lockWhenCondition:NO_DATA];
//            [products addObject:[[NSObject alloc] init]];
//            NSLog(@"produce a product,总量:%zi",products.count);
//            [lock unlockWithCondition:HAS_DATA];
//            sleep(1);
//        }
//    });
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        while (1) {
//            NSLog(@"wait for product");
//            [lock lockWhenCondition:HAS_DATA];
//            [products removeObjectAtIndex:0];
//            NSLog(@"custom a product");
//            [lock unlockWithCondition:NO_DATA];
//        }
//    });
    {
        NSConditionLock *lock = [[NSConditionLock alloc] initWithCondition:0];
        start = CFAbsoluteTimeGetCurrent();
        for (int i = 0; i < count; i++) {
            [lock lock];
            [lock unlock];
        }
        end = CFAbsoluteTimeGetCurrent();
        cost = end - start;
        NSLog(@"NSConditionLock = %f",cost);
    }
#pragma mark -- NSCondition
//    NSCondition *condition = [[NSCondition alloc] init];
//    NSMutableArray *products = [NSMutableArray array];
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        while (1) {
//            [condition lock];
//            if (products.count == 0 ) {
//                NSLog(@"wait for product");
//                [condition wait];
//            }
//            [products removeObjectAtIndex:0];
//            NSLog(@"custom a product");
//            [condition unlock];
//        }
//    });
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        while (1) {
//            [condition lock];
//            [products addObject:[[NSObject alloc] init]];
//            NSLog(@"produce a product");
//            [condition signal];
//            [condition unlock];
//            sleep(1);
//        }
//    });
    {
        NSCondition *lock = [[NSCondition alloc] init];
        start = CFAbsoluteTimeGetCurrent();
        for (int i = 0; i < count; i++) {
            [lock lock];
            [lock unlock];
        }
        end = CFAbsoluteTimeGetCurrent();
        cost = end - start;
        NSLog(@"NSCondition = %f",cost);
    }
#pragma mark -- pthread_mutex
//    __block pthread_mutex_t theLock;
//    pthread_mutex_init(&theLock, NULL);
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        pthread_mutex_lock(&theLock);
//        NSLog(@"需要线程同步的操作1 开始");
//        sleep(3);
//        NSLog(@"需要线程同步的操作1 结束");
//        pthread_mutex_unlock(&theLock);
//    });
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        sleep(1);
//        pthread_mutex_lock(&theLock);
//        NSLog(@"需要线程同步的操作2");
//        pthread_mutex_unlock(&theLock);
//    });
    {
        pthread_mutex_t lock;
        pthread_mutex_init(&lock, NULL);
        start = CFAbsoluteTimeGetCurrent();
        for (int i = 0; i < count; i++) {
            pthread_mutex_lock(&lock);
            pthread_mutex_unlock(&lock);
        }
        end = CFAbsoluteTimeGetCurrent();
        cost = end - start;
        NSLog(@"pthread_mutex_t = %f",cost);
    }
    
#pragma mark -- pthread_mutex(recursive)
//    __block pthread_mutex_t theLock;
//    //pthread_mutex_init(&theLock, NULL);
//    pthread_mutexattr_t attr;
//    pthread_mutexattr_init(&attr);
//    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
//    pthread_mutex_init(&theLock, &attr);
//    pthread_mutexattr_destroy(&attr);
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        static void (^RecursiveMethod)(int);
//        RecursiveMethod = ^(int value) {
//            pthread_mutex_lock(&theLock);
//            if (value > 0) {
//                NSLog(@"value = %d", value);
//                sleep(1);
//                RecursiveMethod(value - 1);
//            }
//            pthread_mutex_unlock(&theLock);
//        };
//        RecursiveMethod(5);
//    });
    {
        pthread_mutex_t lock;
        pthread_mutex_init(&lock, NULL);
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&lock, &attr);
        pthread_mutexattr_destroy(&attr);
        
        start = CFAbsoluteTimeGetCurrent();
        for (int i = 0; i < count; i++) {
            pthread_mutex_lock(&lock);
            pthread_mutex_unlock(&lock);
        }
        end = CFAbsoluteTimeGetCurrent();
        cost = end - start;
        NSLog(@"PTHREAD_MUTEX_RECURSIVE = %f",cost);
    }
    
#pragma mark -- OSSpinLock
    
//    __block os_unfair_lock_t theLock = &(OS_UNFAIR_LOCK_INIT);
////    __block OSSpinLock theLock = OS_SPINLOCK_INIT;
//
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
////        OSSpinLockLock(&theLock);
//        os_unfair_lock_lock(theLock);
//        NSLog(@"需要线程同步的操作1 开始");
//        sleep(3);
//        NSLog(@"需要线程同步的操作1 结束");
////        OSSpinLockUnlock(&theLock);
//        os_unfair_lock_unlock(theLock);
//    });
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
////        OSSpinLockLock(&theLock);
//        os_unfair_lock_lock(theLock);
//        sleep(1);
//        NSLog(@"需要线程同步的操作2");
////        OSSpinLockUnlock(&theLock);
//        os_unfair_lock_unlock(theLock);
//    });
    {
        os_unfair_lock_t lock = &(OS_UNFAIR_LOCK_INIT);

        start = CFAbsoluteTimeGetCurrent();
        for (int i = 0; i < count; i++) {
            os_unfair_lock_lock(lock);
            os_unfair_lock_unlock(lock);
        }
        end = CFAbsoluteTimeGetCurrent();
        cost = end - start;
        NSLog(@"os_unfair_lock_t = %f",cost);
    }
    
}




@end
