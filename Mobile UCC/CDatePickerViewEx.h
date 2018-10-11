//
//  CDatePickerViewEx.h
//  Mobile UCC
//
//  Created by MacbookPRO on 18/04/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

#ifndef CDatePickerViewEx_h
#define CDatePickerViewEx_h


#endif /* CDatePickerViewEx_h */
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CDatePickerViewEx : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIColor *monthSelectedTextColor;
@property (nonatomic, strong) UIColor *monthTextColor;

@property (nonatomic, strong) UIColor *yearSelectedTextColor;
@property (nonatomic, strong) UIColor *yearTextColor;

@property (nonatomic, strong) UIFont *monthSelectedFont;
@property (nonatomic, strong) UIFont *monthFont;

@property (nonatomic, strong) UIFont *yearSelectedFont;
@property (nonatomic, strong) UIFont *yearFont;

@property (nonatomic, assign) NSInteger rowHeight;

@property (nonatomic, strong, readonly) NSDate *date;

-(void)setupMinYear:(NSInteger)minYear maxYear:(NSInteger)maxYear;
-(void)selectToday;

@end
