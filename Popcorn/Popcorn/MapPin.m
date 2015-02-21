//
//  MapPin.m
//  Popcorn
//
//  Created by Nate Parrott on 2/21/15.
//  Copyright (c) 2015 Nate Parrott. All rights reserved.
//

#import "MapPin.h"

@implementation MapPin

- (CLLocationCoordinate2D)coordinate {
    PFGeoPoint *pt = self.object[@"location"];
    return CLLocationCoordinate2DMake(pt.latitude, pt.longitude);
}

- (NSString *)title {
    return self.object[@"text"];
}

- (instancetype)initWithObject:(PFObject *)object {
    self = [super init];
    self.object = object;
    return self;
}

@end
