//
//  CPIAPStoreManager.m
//  CrazyPuzzzle
//
//  Created by mac on 13-8-15.
//  Copyright (c) 2013年 xiaoran. All rights reserved.
//

#import "CPIAPStoreManager.h"

@implementation CPIAPStoreManager

+ (id)shareManager{

    static CPIAPStoreManager *instance;
    static dispatch_once_t token;
    dispatch_once(&token,^{
        
        instance = [[CPIAPStoreManager alloc] init];
    });
    
    return instance;
}

// 程序启动就开始监听交易
- (void)registerStoreObserver
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

}

// 出现退出时，自然要清除监听
- (void)removeStoreObserver
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

//// 获取产品信息

- (void)buyProduct:(NSString *)productId
{
    [self requestProductData:productId];

}

- (void)requestProductData:(NSString *)productId
{
    NSSet *set = [NSSet setWithObject:productId];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
    
    
}


///// 下面是购买流程


- (BOOL)canMakePay
{
    return [SKPaymentQueue canMakePayments];
    
}


- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    
    SLog(@"购买完成。。transaction data=%@",transaction.transactionReceipt);
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSString *productID = transaction.payment.productIdentifier;
    NSArray *IDs = CP_Golden_ProductIDs;
   int index = [IDs indexOfObject:productID];
    
    NSArray *values = CP_Golden_values;
    int value = [[values objectAtIndex:index] intValue];
    
    int currentGold = [[USER_DEFAULT objectForKey:@"CurrentGolden"] intValue];
    [USER_DEFAULT setInteger:(currentGold+value) forKey:@"CurrentGolden"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCPPaidForGoldsNotificatioin object:self];
    
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction{
    
    SLog(@"购买失败。。。%@",transaction.error);
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction{
     SLog(@"transaction.originalTransaction=%@",transaction.originalTransaction);
}



#pragma mark SKRequest delegate

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{

    NSArray *products = response.products;
    
    SLog(@"products:%@",products);
    SLog(@"invalid product ids:%@",response.invalidProductIdentifiers);
    
    for (SKProduct *product in products) {
        
        NSLog(@"Detail product info\n");
        NSLog(@"SKProduct description: %@\n", [product description]);
        NSLog(@"Product localized title: %@\n" , product.localizedTitle);
        NSLog(@"Product localized descitption: %@\n" , product.localizedDescription);
        NSLog(@"Product price: %@\n" , product.price);
        NSLog(@"Product identifier: %@\n" , product.productIdentifier);
        
    }
    
    //如果取到产品信息，今日购买流程
    if ([products count]>0) {
        SKPayment *payment = [SKPayment paymentWithProduct:products[0]];
        if (payment) {
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }
    }
 

}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    SLog(@"skrequest failed...");

}

- (void)requestDidFinish:(SKRequest *)request
{
    SLog(@"skrequest finished...");


}


/// SKPaymen transcation observer delegate


// @required   Sent when the transaction array has changed (additions or state changes).  Client should check state of transactions and finish as appropriate.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{

    SLog(@"transactions=%@",transactions);
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
                SLog(@"apple 服务器加入购买队列。。。");
                break;
            case SKPaymentTransactionStatePurchased:
                
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
               
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

//@optional


// Sent when transactions are removed from the queue (via finishTransaction:).
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions{

    
} 

// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{



}

// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{


}

// Sent when the download state has changed.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads{


}




@end
