//
//  ViewController.m
//  LocationAppUsingForwardAndRevercGeoCoder
//
//  Created by Student P_02 on 23/05/18.
//  Copyright © 2018 Shital. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.AddressTextField.delegate=self;
    // Do any additional setup after loading the view, typically from a nib.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *location =self.AddressTextField.text;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:location
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         
                         MKCoordinateRegion region = self.myMapView.region;
                         region.center = placemark.region.center;
                         region.span.longitudeDelta /= 8.0;
                         region.span.latitudeDelta /= 8.0;
                         
                         [self.myMapView setRegion:region animated:YES];
                         [self.myMapView addAnnotation:placemark];
                     }
                 }
     ];
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startDetectingLocation{
    self.locationManager=[[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate=self;
    [self.locationManager startUpdatingLocation];
    
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *currentLocation=[locations lastObject];
    float latitude=currentLocation.coordinate.latitude;
    float longitude=currentLocation.coordinate.longitude;
    if(currentLocation !=nil)
    {
        [manager stopUpdatingLocation];
    }
    CLLocationCoordinate2D coOrdinate=currentLocation.coordinate;
    NSLog(@"Latitude=%f and Longitude=%f",latitude,longitude);
    MKCoordinateSpan span=MKCoordinateSpanMake(0.5,0.5);
    MKCoordinateRegion region=MKCoordinateRegionMake(coOrdinate, span);
    [self.myMapView setRegion:region];
    CLGeocoder *geoCoder=[[CLGeocoder alloc]init];
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark=[placemarks firstObject];
        NSString *subtitle=[NSString stringWithFormat:@"%@ ,%@,%@",placeMark.subLocality,placeMark.thoroughfare,placeMark.subThoroughfare];
        NSString *title=[NSString stringWithFormat:@"%@",placeMark.locality];
        
        MKPointAnnotation *annotation=[[MKPointAnnotation alloc]init];
        annotation.coordinate=coOrdinate;
        annotation.title=title;
        annotation.subtitle=subtitle;
        
        [self.myMapView addAnnotation:annotation];
        
    }];
    
    
}

- (IBAction)CurrentLocationButton:(UIButton *)sender
{
        [self startDetectingLocation];
    
}

/*- (IBAction)AddressLoctionButton:(UIButton *)sender
{
    NSString *location =self.AddressTextField.text;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:location
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         
                         MKCoordinateRegion region = self.myMapView.region;
                         region.center = placemark.region.center;
                         region.span.longitudeDelta /= 8.0;
                         region.span.latitudeDelta /= 8.0;
                         
                         [self.myMapView setRegion:region animated:YES];
                         [self.myMapView addAnnotation:placemark];
                     }
                 }
     ];

}*/
- (IBAction)ChangeMapViewType:(UISegmentedControl *)sender
{
    switch (self.mySegment.selectedSegmentIndex) {
        case 0:
            self.myMapView.mapType=MKMapTypeStandard;
            break;
        case 1:
            self.myMapView.mapType=MKMapTypeSatellite;
            
            break;
        case 2:
            self.myMapView.mapType=MKMapTypeHybrid;
            
            break;
        default:
            break;
    }
}
@end
