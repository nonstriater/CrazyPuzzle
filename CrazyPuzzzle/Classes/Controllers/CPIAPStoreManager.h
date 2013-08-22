//
//  CPIAPStoreManager.h
//  CrazyPuzzzle
//
//  Created by mac on 13-8-15.
//  Copyright (c) 2013年 xiaoran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface CPIAPStoreManager : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>


+ (id)shareManager;

- (void)registerStoreObserver;
- (void)removeStoreObserver;

- (BOOL)canMakePay;
- (void)buyProduct:(NSString *)productId;

- (void)requestProductData:(NSString *)productId;

@end
