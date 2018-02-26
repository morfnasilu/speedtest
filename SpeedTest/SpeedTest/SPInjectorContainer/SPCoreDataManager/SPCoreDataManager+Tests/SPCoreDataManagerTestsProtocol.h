//
//  SPCoreDataManagerTestsProtocol.h
//  SpeedTest
//
//  Created by Dmtech on 22.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPCoreDataManager.h"

@class SPTestModel;

@protocol SPCoreDataManagerTestsProtocol<NSObject>

-(void)addTestToDataBase:(SPTestModel *)test withCompletion:(SPCoreDataStackDeleteOperationCompletion)completion;

-(NSFetchRequest *)wholeHistoryFetchRequest;

@end
