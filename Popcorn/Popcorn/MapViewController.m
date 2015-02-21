//
//  MapViewController.m
//  Popcorn
//
//  Created by Nate Parrott on 2/21/15.
//  Copyright (c) 2015 Nate Parrott. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "MapPin.h"
#import "PinAnnotationView.h"

@interface MapViewController () <MKMapViewDelegate>

@property (nonatomic) MKMapView *mapView;
@property (nonatomic) NSArray *pins;

@end

@implementation MapViewController

- (instancetype)init {
    self = [super init];
    self.title = @"Map";
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    if ([[AppDelegate shared] isHostOfEvent:self.event]) {
        UILongPressGestureRecognizer *rec = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(dropPin:)];
        [self.mapView addGestureRecognizer:rec];
        
        UILabel *hint = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-30-50, self.view.bounds.size.width, 30)];
        hint.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        hint.text = @"Long-press to add a pin.";
        hint.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.6];
        hint.textColor = [UIColor whiteColor];
        hint.textAlignment = NSTextAlignmentCenter;
        hint.font = [UIFont boldSystemFontOfSize:12];
        [self.view addSubview:hint];
    }
    [self reloadPins];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPins) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadPins {
    [[[self.event relationForKey:@"pins"] query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        BOOL shouldZoomToFitPins = self.pins == nil; // if we're reloading the map (but we've already loaded before), don't move
        self.pins = objects;
        if (shouldZoomToFitPins) {
            [self.mapView showAnnotations:self.mapView.annotations animated:YES];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.event valueForKey:@"mapCenter"]) {
        PFGeoPoint *center = [self.event valueForKey:@"mapCenter"];
        CLLocationDistance radius = [[self.event valueForKey:@"mapRadius"] doubleValue];
        MKMapPoint centerPt = MKMapPointForCoordinate(CLLocationCoordinate2DMake(center.latitude, center.longitude));
        double radiusInMapPoints = MKMapPointsPerMeterAtLatitude(center.latitude) * radius;
        MKMapRect mapRect = MKMapRectMake(centerPt.x - radiusInMapPoints, centerPt.y - radiusInMapPoints, radiusInMapPoints * 2, radiusInMapPoints * 2);
        [self.mapView setVisibleMapRect:mapRect];
    }
}

#pragma mark Pins

- (void)setPins:(NSArray *)pins {
    _pins = pins;
    [self.mapView removeAnnotations:self.mapView.annotations];
    for (PFObject *pin in pins) {
        [self.mapView addAnnotation:[[MapPin alloc] initWithObject:pin]];
    }
}

- (void)dropPin:(UILongPressGestureRecognizer *)gestureRec {
    CGPoint point = [gestureRec locationInView:self.mapView];
    if (gestureRec.state == UIGestureRecognizerStateBegan) {
        UIAlertController *prompt = [UIAlertController alertControllerWithTitle:@"Add Map Pin" message:@"What's the title of this pin?" preferredStyle:UIAlertControllerStyleAlert];
        [prompt addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Registration and information desk";
        }];
        [prompt addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            // do nothing
        }]];
        [prompt addAction:[UIAlertAction actionWithTitle:@"Add Pin" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            PFObject *pin = [PFObject objectWithClassName:@"pin"];
            CLLocationCoordinate2D location = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
            [pin setValue:[PFGeoPoint geoPointWithLatitude:location.latitude longitude:location.longitude] forKey:@"location"];
            [pin setValue:[prompt.textFields.firstObject text] forKey:@"text"];
            [pin saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [[self.event relationForKey:@"pins"] addObject:pin];
                [self.event saveInBackground];
            }];
            [self.mapView addAnnotation:[[MapPin alloc] initWithObject:pin]];
        }]];
        [self presentViewController:prompt animated:YES completion:nil];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    PinAnnotationView *pin = (id)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    if (!pin) {
        pin = [[PinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
    } else {
        pin.annotation = annotation;
    }
    return pin;
}

@end
