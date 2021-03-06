//
//  TWRViewController.m
//  ChartJS
//
//  Created by Michelangelo Chasseur on 21/04/14.
//  Copyright (c) 2014 Touchware. All rights reserved.
//

#import "TWRViewController.h"
#import "TWRChart.h"
#import "TWRChartView.h"

typedef NS_ENUM(NSInteger, ChartsType) {
    Line,
    Bar,
    Pie,
    Polar
};

@interface TWRViewController ()

@property(strong, nonatomic) TWRChartView *chartView;
@property(weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (void)switchChart:(UISegmentedControl *)sender;

@end

@implementation TWRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Charts";

    // Segmented Control
    [_segmentedControl addTarget:self action:@selector(switchChart:) forControlEvents:UIControlEventValueChanged];

    // Chart View
    _chartView = [[TWRChartView alloc] initWithFrame:CGRectMake(0, 64, 320, 300)];
    _chartView.backgroundColor = [UIColor clearColor];

    // User interaction is disabled by default. You can enable it again if you want
    // _chartView.userInteractionEnabled = YES;

    // Load chart by using a ChartJS javascript file
    NSString *jsFilePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"js"];
    [_chartView setChartJsFilePath:jsFilePath];

    // Add the chart view to the controller's view
    [self.view addSubview:_chartView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
*  Loads a bar chart using native code
*/
- (void)loadBarChart {
    // Build chart data
    TWRDataSet *dataSet1 = [[TWRDataSet alloc] initWithDataPoints:@[@10, @15, @5, @15, @5]
                                                        fillColor:[[UIColor orangeColor] colorWithAlphaComponent:0.5]
                                                      strokeColor:[UIColor orangeColor]];

    TWRDataSet *dataSet2 = [[TWRDataSet alloc] initWithDataPoints:@[@5, @10, @5, @15, @10]
                                                        fillColor:[[UIColor redColor] colorWithAlphaComponent:0.5]
                                                      strokeColor:[UIColor redColor]];

    NSArray *labels = @[@"A", @"B", @"C", @"D", @"E"];
    TWRBarChart *bar = [[TWRBarChart alloc] initWithLabels:labels
                                                  dataSets:@[dataSet1, dataSet2]
                                                  animated:YES];
    // Load data
    [_chartView loadBarChart:bar];
}

/**
*  Loads a line chart using native code
*/
- (void)loadLineChart {
    // Build chart data
    TWRDataSet *dataSet1 = [[TWRDataSet alloc] initWithDataPoints:@[@10, @15, @5, @15, @5]];
    TWRDataSet *dataSet2 = [[TWRDataSet alloc] initWithDataPoints:@[@5, @10, @5, @15, @10]];

    NSArray *labels = @[@"A", @"B", @"C", @"D", @"E"];

    TWRLineChart *line = [[TWRLineChart alloc] initWithLabels:labels
                                                     dataSets:@[dataSet1, dataSet2]
                                                     animated:NO];
    // Load data
    [_chartView loadLineChart:line];
}

/**
*  Loads a pie / doughnut chart using native code
*/
- (void)loadPieChart {
    // Values
    NSArray *values = @[@20, @30, @15, @5];

    // Colors
    UIColor *color1 = [UIColor colorWithHue:0.5 saturation:0.6 brightness:0.6 alpha:1.0];
    UIColor *color2 = [UIColor colorWithHue:0.6 saturation:0.6 brightness:0.6 alpha:1.0];
    UIColor *color3 = [UIColor colorWithHue:0.7 saturation:0.6 brightness:0.6 alpha:1.0];
    UIColor *color4 = [UIColor colorWithHue:0.8 saturation:0.6 brightness:0.6 alpha:1.0];
    NSArray *colors = @[color1, color2, color3, color4];

    // Doughnut Chart
    TWRCircularChart *pieChart = [[TWRCircularChart alloc] initWithValues:values
                                                                   colors:colors
                                                                     type:TWRCircularChartTypeDoughnut
                                                                 animated:YES];

    // You can even leverage callbacks when chart animation ends!
    [_chartView loadCircularChart:pieChart withCompletionHandler:^(BOOL finished) {
        if (finished) {
            NSLog(@"Animation finished!!!");
        }
    }];
}

#pragma mark - UISegmentedController switch methods

- (void)switchChart:(UISegmentedControl *)sender {
    ChartsType type = (ChartsType) sender.selectedSegmentIndex;
    switch (type) {
        //Line
        case Line: {
            [self loadLineChart];
        }
            break;

            //Bar
        case Bar: {
            [self loadBarChart];
        }
            break;

            //Pie
        case Pie: {
            [self loadPieChart];
        }
            break;
        case Polar:{
            [self loadPolarChart];
        }
            break;
        default:
            break;
    }
}

- (void)loadPolarChart
{
    //todo implement polar chart parser in the future (now Polar char just loading from file index.js
    NSString *jsFilePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"js"];
    NSData *data = [NSData dataWithContentsOfFile:jsFilePath];
    NSString *jsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    [_chartView loadChartFromString:jsString];
}

@end
