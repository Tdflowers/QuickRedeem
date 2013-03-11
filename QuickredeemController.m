#import "BBWeeAppController-Protocol.h"

static NSBundle *_QuickredeemWeeAppBundle = nil;

@interface QuickredeemController: NSObject <BBWeeAppController> {
	UIView *_view;
	UIImageView *_backgroundView;
    UITextField *codeView;
    UIButton *redeembutton;
    UIButton *pasteButton;
}
@property (nonatomic, retain) UIView *view;

-(void)redeemClick;
-(void)pasteClick;

@end

@implementation QuickredeemController
@synthesize view = _view;

+ (void)initialize {
	_QuickredeemWeeAppBundle = [[NSBundle bundleForClass:[self class]] retain];
}

- (id)init {
	if((self = [super init]) != nil) {
		
	} return self;
}

- (void)dealloc {
	[_view release];
	[_backgroundView release];
    [redeembutton release];
    [codeView release];
	[super dealloc];
}

- (void)loadFullView {
	// Add subviews to _backgroundView (or _view) here.
}

- (void)loadPlaceholderView {
	// This should only be a placeholder - it should not connect to any servers or perform any intense
	// data loading operations.
	//
	// All widgets are 316 points wide. Image size calculations match those of the Stocks widget.
	_view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, {316, [self viewHeight]}}];
	_view.autoresizingMask = UIViewAutoresizingFlexibleWidth;

	UIImage *bgImg = [UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/StocksWeeApp.bundle/WeeAppBackground.png"];
	UIImage *stretchableBgImg = [bgImg stretchableImageWithLeftCapWidth:floorf(bgImg.size.width / 2.f) topCapHeight:floorf(bgImg.size.height / 2.f)];
	_backgroundView = [[UIImageView alloc] initWithImage:stretchableBgImg];
	_backgroundView.frame = CGRectInset(_view.bounds, 2.f, 0.f);
	_backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[_view addSubview:_backgroundView];
    
    codeView = [[UITextField alloc] initWithFrame:CGRectMake(20, 7, 200, 20)];
    [codeView setBorderStyle:UITextBorderStyleRoundedRect];
    [codeView setFont:[UIFont fontWithName:@"Times New Roman" size:12]];
    [_view addSubview:codeView];
    
    redeembutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [redeembutton addTarget:self 
               action:@selector(redeemClick)
     forControlEvents:UIControlEventTouchUpInside];
    [redeembutton setTitle:@"" forState:UIControlStateNormal];
    redeembutton.frame = CGRectMake(275, 7, 20, 20);
    [redeembutton setBackgroundImage:[UIImage imageWithContentsOfFile:@"/Library/WeeLoader/Plugins/Quickredeem.bundle/mark.png"] forState:UIControlStateNormal];
    [_view addSubview:redeembutton];
    
    pasteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pasteButton addTarget:self 
                     action:@selector(pasteClick)
           forControlEvents:UIControlEventTouchUpInside];
    [pasteButton setTitle:@"" forState:UIControlStateNormal];
    pasteButton.frame = CGRectMake(235, 7, 20, 20);
    [pasteButton setBackgroundImage:[UIImage imageWithContentsOfFile:@"/Library/WeeLoader/Plugins/Quickredeem.bundle/paste.png"] forState:UIControlStateNormal];
    [_view addSubview:pasteButton];
}

- (void)redeemClick{
    NSString *text = codeView.text;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/redeemLandingPage?code=%@", text]];
    
    if (![[UIApplication sharedApplication] openURL:url])
        
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

- (void)pasteClick{
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    codeView.text = [pb string];
}

- (id)launchURLForTapLocation:(CGPoint)point
{
	// Dirty hack to fix the "TouchHandler" bug.
	NSLog(@"Here We Are. %@ - %@", NSStringFromCGPoint([[self view].window convertPoint:point fromView:[self view]]), NSStringFromCGPoint(point));
	UIButton* btn=(UIButton*)[[self view].window hitTest:[[self view].window convertPoint:point fromView:[self view]] withEvent:nil];
	if([btn respondsToSelector:@selector(sendActionsForControlEvents:)]){
		[btn sendActionsForControlEvents: UIControlEventTouchUpInside];
	}
	return nil;
}

- (void)unloadView {
	[_view release];
	_view = nil;
	[_backgroundView release];
	_backgroundView = nil;
    [codeView release];
    codeView = nil;
	// Destroy any additional subviews you added here. Don't waste memory :(.
}

- (float)viewHeight {
	return 35.f;
}

@end
