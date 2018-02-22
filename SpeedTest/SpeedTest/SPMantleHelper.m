//
//  PCMantleHelper.m
//  PEN
//
//  Created by Dmtech on 18.09.17.
//  Copyright © 2017 DarkMatterAB. All rights reserved.
//

#import "SPMantleHelper.h"

NSString *jsonStringForMantleWithModel(MTLModel<MTLJSONSerializing> *model) {
    if (!model) {
        return nil;
    }
    NSError *parsingError;
    
    NSDictionary *jsonDictionary = [MTLJSONAdapter JSONDictionaryFromModel:model error:&parsingError];
    if (!jsonDictionary) {
        return nil;
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:kNilOptions
                                                         error:&error];
    if (error) {
        NSLog(@"Couldn't turn FM info JSON into NSData. JSON: %@, \n\n Error: %@", model, error);
        return nil;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
