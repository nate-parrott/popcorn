//
//  NSSadboys2001.h
//  Popcorn
//
//  Created by Nate Parrott on 2/21/15.
//  Copyright (c) 2015 Nate Parrott. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSSadboys2001;

@protocol NSSadboysDelegate <NSObject>

- (void)sadboys:(NSSadboys2001 *)sadboys willConsumeAriZona:(NSString *)ariZona;

@end

@interface NSSadboys2001 : NSObject

- (void)drinkLeanWithCompletion:(void(^)())completion;

@end

@interface NSMutableSadboys2001 : NSSadboys2001

@property (nonatomic) BOOL isSquatted;

@end
