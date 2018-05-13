//
//  STInputBar.m
//  STEmojiKeyboard
//
//  Created by zhenlintie on 15/5/29.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import "STInputBar.h"
#import "STEmojiKeyboard.h"

#define kSTIBDefaultHeight 44
#define kSTLeftButtonWidth 50
#define kSTLeftButtonHeight 30
#define kSTRightButtonWidth 55
#define kSTTextviewDefaultHeight 34
#define kSTTextviewMaxHeight 80

@interface STInputBar () <UITextViewDelegate>

@property (strong, nonatomic) UIButton *keyboardTypeButton;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) STEmojiKeyboard *keyboard;
@property (strong, nonatomic) UILabel *placeHolderLabel;


@property (strong, nonatomic) void (^sizeChangedHandler)(void);

@end

@implementation STInputBar{
    BOOL _isRegistedKeyboardNotif;
    BOOL _isDefaultKeyboard;
    NSArray *_switchKeyboardImages;

}

+ (instancetype)inputBar{
    return [self new];
}

- (void)dealloc{
    if (_isRegistedKeyboardNotif){
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kSTIBDefaultHeight)]){
        _isRegistedKeyboardNotif = NO;
        _isDefaultKeyboard = YES;
        _switchKeyboardImages = @[@"btn_expression",@"btn_keyboard"];
        [self loadUI];
    }
    return self;
}

- (void)loadUI{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];

    _keyboard = [STEmojiKeyboard keyboard];

    self.keyboardTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, (kSTIBDefaultHeight-kSTLeftButtonHeight)/2, kSTLeftButtonWidth, kSTLeftButtonHeight)];
    [_keyboardTypeButton addTarget:self action:@selector(keyboardTypeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _keyboardTypeButton.tag = 0;
    [_keyboardTypeButton setImage:[UIImage imageNamed:_switchKeyboardImages[_keyboardTypeButton.tag]] forState:UIControlStateNormal];

    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(kSTLeftButtonWidth, (kSTIBDefaultHeight-kSTTextviewDefaultHeight)/2, CGRectGetWidth(self.frame)-kSTLeftButtonWidth-kSTRightButtonWidth, kSTTextviewDefaultHeight)];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.textColor = [UIColor whiteColor];
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.delegate = self;
    self.textView.tintColor = [UIColor whiteColor];
    self.textView.scrollEnabled = NO;
    self.textView.showsVerticalScrollIndicator = NO;

    _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSTLeftButtonWidth+5, CGRectGetMinY(_textView.frame), CGRectGetWidth(_textView.frame), kSTTextviewDefaultHeight)];
    _placeHolderLabel.adjustsFontSizeToFitWidth = YES;
    _placeHolderLabel.minimumScaleFactor = 0.9;
    _placeHolderLabel.textColor = [UIColor colorWithWhite:1 alpha:0.5];
    _placeHolderLabel.font = _textView.font;
    _placeHolderLabel.userInteractionEnabled = NO;

    self.sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.sendButton.frame = CGRectMake(self.frame.size.width-kSTRightButtonWidth, 0, kSTRightButtonWidth, kSTIBDefaultHeight);
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.3] forState:UIControlStateDisabled];
    [self.sendButton setTitleEdgeInsets:UIEdgeInsetsMake(2.50f, 0.0f, 0.0f, 0.0f)];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:19];
    [self.sendButton addTarget:self action:@selector(sendTextCommentTaped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.sendButton.enabled = NO;
    
    [self addSubview:_keyboardTypeButton];
    [self addSubview:_textView];
    [self addSubview:_placeHolderLabel];
    [self addSubview:self.sendButton];
    
}

- (void)layout{
    
    self.sendButton.enabled = ![@"" isEqualToString:self.textView.text];
    _placeHolderLabel.hidden = self.sendButton.enabled;
    
    CGRect textViewFrame = self.textView.frame;
    CGSize textSize = [self.textView sizeThatFits:CGSizeMake(CGRectGetWidth(textViewFrame), 1000.0f)];
    
    CGFloat offset = 10;
    self.textView.scrollEnabled = (textSize.height > kSTTextviewMaxHeight-offset);
    textViewFrame.size.height = MAX(kSTTextviewDefaultHeight, MIN(kSTTextviewMaxHeight, textSize.height));
    self.textView.frame = textViewFrame;
    
    CGRect addBarFrame = self.frame;
    CGFloat maxY = CGRectGetMaxY(addBarFrame);
    addBarFrame.size.height = textViewFrame.size.height+offset;
    addBarFrame.origin.y = maxY-addBarFrame.size.height;
    self.frame = addBarFrame;
    
    self.keyboardTypeButton.center = CGPointMake(CGRectGetMidX(self.keyboardTypeButton.frame), CGRectGetHeight(addBarFrame)/2.0f);
    self.sendButton.center = CGPointMake(CGRectGetMidX(self.sendButton.frame), CGRectGetHeight(addBarFrame)/2.0f);
    
    if (self.sizeChangedHandler){
        self.sizeChangedHandler();
    }
}

- (void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolderLabel.text = placeHolder;
    _placeHolder = [placeHolder copy];
}

- (BOOL)resignFirstResponder{
    [super resignFirstResponder];
    return [_textView resignFirstResponder];
}
- (BOOL)becomeFirstResponder{
    [super becomeFirstResponder];
    return [_textView becomeFirstResponder];
}

- (void)setInputBarSizeChangedHandle:(void (^)(void))handler{
    _sizeChangedHandler = handler;
}

- (void)setFitWhenKeyboardShowOrHide:(BOOL)fitWhenKeyboardShowOrHide{
    if (fitWhenKeyboardShowOrHide){
        [self registerKeyboardNotif];
    }
    if (!fitWhenKeyboardShowOrHide && _fitWhenKeyboardShowOrHide){
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    _fitWhenKeyboardShowOrHide = fitWhenKeyboardShowOrHide;
}

- (void)registerKeyboardNotif{
    _isRegistedKeyboardNotif = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    self.hidden = NO;
    
    NSTimeInterval animationDuration;
    CGRect keyBoardEndFrame;
    NSDictionary * userInfo = notification.userInfo;
    
    [userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [userInfo[UIKeyboardFrameEndUserInfoKey] getValue:&keyBoardEndFrame];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];

    CGRect rect = [_relativeView.superview convertRect:_relativeView.frame toView:[[UIApplication sharedApplication] delegate].window];

    float moveDistance = keyBoardEndFrame.origin.y -(rect.origin.y+rect.size.height);

    CGRect newInputBarFrame = self.frame;
    newInputBarFrame.origin.y = [UIScreen mainScreen].bounds.size.height-CGRectGetHeight(self.frame)-keyBoardEndFrame.size.height;


    BOOL isAdaptionScroll = NO;
    if (!(moveDistance >  newInputBarFrame.size.height&&self.scrollView.contentOffset.y <= (moveDistance-newInputBarFrame.size.height))&&self.kbScrollInsetBlock) {
        self.kbScrollInsetBlock(UIEdgeInsetsMake(0, 0, [UIScreen mainScreen].bounds.size.height-((rect.origin.y+rect.size.height))-moveDistance +newInputBarFrame.size.height, 0));
        isAdaptionScroll = YES;
    }

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDelegate:self];
    
    if (isAdaptionScroll&&self.kbScrollOffsetBlock) {
        self.kbScrollOffsetBlock(CGPointMake(0 , self.scrollView.contentOffset.y-moveDistance +newInputBarFrame.size.height));
    }
    self.frame = newInputBarFrame;
    [UIView commitAnimations];
}

- (void)keyboardWillHidden:(NSNotification *)notification {
    CGFloat originalOffsetY = self.scrollView.contentOffset.y;
    CGFloat maxOffset = self.scrollView.contentSize.height-self.scrollView.frame.size.height;
    if (maxOffset < originalOffsetY) {
        originalOffsetY = maxOffset;
    }
    NSDictionary* info = [notification userInfo];
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0
                        options:([info[UIKeyboardAnimationCurveUserInfoKey] integerValue]<<16)
                     animations:^{
                         self.center = CGPointMake(self.bounds.size.width/2.0f, height+CGRectGetHeight(self.frame)/2.0);

                         if (self.kbScrollOffsetBlock) {
                             self.kbScrollOffsetBlock(CGPointMake(0 , originalOffsetY));
                         }
                     }
                     completion:^(BOOL finished) {
                         if (self.kbScrollInsetBlock) {
                             self.kbScrollInsetBlock(UIEdgeInsetsZero);
                         }
                         if (self.kbScrollOffsetBlock) {
                             self.kbScrollOffsetBlock(CGPointMake(0 , originalOffsetY));
                         }
                         self.hidden = YES;
                     }];
}

- (void)sendTextCommentTaped:(UIButton *)button{

    if (self.updateMessageBlock){
        self.updateMessageBlock(self.textView.text, self.placeHolder);
        self.textView.text = @"";
        [self layout];
    }
}

- (void)keyboardTypeButtonClicked:(UIButton *)button{

    if (button.tag == 1){
        self.textView.inputView = nil;
    }
    else{
        [_keyboard setTextView:self.textView];
    }
    [self.textView reloadInputViews];

    button.tag = (button.tag+1)%2;
    [_keyboardTypeButton setImage:[UIImage imageNamed:_switchKeyboardImages[button.tag]] forState:UIControlStateNormal];
    [_textView becomeFirstResponder];
}

#pragma mark - text view delegate

- (void)textViewDidChange:(UITextView *)textView{
    [self layout];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

@end
