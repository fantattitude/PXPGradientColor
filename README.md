
#PXPGradientColor

iOS 4.0 minimum for ObjC.
iOS 8.0 minimum for Swift.

##License

Without any further information, all the sources provided here are under the MIT License quoted in PXPGradientColor/LICENSE.


##What is PXPGradientColor

PXPGradientColor is an Objective-C / Swift wrapper for CGGradient. Useful for your iOS projects.
It Offers you the ability to create a nice gradient with just one line of code.

ObjC:

	+ (id)gradientWithStartingColor:(UIColor *)startingColor 
						endingColor:(UIColor *)endingColor;
	+ (id)gradientWithColors:(NSArray *)colors
	
Swift:
	
	init(colors: UIColor[]!, locations: CGFloat[]?, colorSpace: PXPColorSpace?)
	init(startingColor: UIColor!, endingColor: UIColor!);
	init(colors: UIColor[]!)
	
Once your PXPGradientColor object has been created, you can use the drawing method from any graphics context :

ObjC:

	@implement MyCustomView
	@synthesize gradient = _gradient;
	
	- (void)drawRect:(CGRect)rect
	{
		[[self gradient] drawInRect:rect angle:90];
		// or provide your UIBezierPath and use -drawInBezierPath:angle:
	}
	
	@end
	
	
Swift:
	
	class MyCustomView: UIView {
		var gradient: PXPGradientColor?
		override func drawRect(rect: CGRect) {
			self.gradient?.draw(inRect: rect)
			// or provide your UIBezierPath and use .draw(inBezierPath bezierPath: UIBezierPath, angle: Double)
		}
	}
	
	
	
As simple as that.

Please notice that this is a first draft of the Swift implementation. So please report any issue you may encounter. Feel free to provide some tips about the Swift implementation too!

Thank you.