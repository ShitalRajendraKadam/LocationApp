//
//  ViewController.h
//  LocationAppUsingForwardAndRevercGeoCoder
//
//  Created by Student P_02 on 23/05/18.
//  Copyright © 2018 Shital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *AddressTextField;

@property (weak, nonatomic) IBOutlet MKMapView *myMapView;

- (IBAction)CurrentLocationButton:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegment;

- (IBAction)ChangeMapViewType:(UISegmentedControl *)sender;

@property CLLocationManager *locationManager;

@end

