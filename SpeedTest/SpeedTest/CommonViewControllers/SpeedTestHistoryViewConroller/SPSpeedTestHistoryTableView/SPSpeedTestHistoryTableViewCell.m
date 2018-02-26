//
//  SPSpeedTestHistoryTableViewCell.m
//  SpeedTest
//
//  Created by Dmtech on 22.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import "SPSpeedTestHistoryTableViewCell.h"

@implementation SPSpeedTestHistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


-(void)setupUI {
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.testTypeLabel = [UILabel new];
    self.testTypeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.testTypeLabel.font = [UIFont systemFontOfSize:16];
    self.testTypeLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.testTypeLabel];
    
    [NSLayoutConstraint constraintWithItem:self.testTypeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:10].active = YES;
    [NSLayoutConstraint constraintWithItem:self.testTypeLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10].active = YES;
    
    self.testAverageSpeedLabel = [UILabel new];
    self.testAverageSpeedLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.testAverageSpeedLabel.font = [UIFont systemFontOfSize:14];
    self.testAverageSpeedLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.testAverageSpeedLabel];
    
    [NSLayoutConstraint constraintWithItem:self.testAverageSpeedLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.testTypeLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10].active = YES;
    [NSLayoutConstraint constraintWithItem:self.testAverageSpeedLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10].active = YES;
}


-(void)prepareForReuse {
    [super prepareForReuse];
    self.testTypeLabel.text = nil;
    self.testAverageSpeedLabel.text = nil;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
