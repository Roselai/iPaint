# iPaint ![alt text](https://github.com/Roselai/iPaint/blob/Roselai-readmeImages/Icon-App-60x60%401x.png)

iPaint is a simple paint application that allows users to select a color and paint with it on the canvas (screen). The user can also save or share the image.

#Tech/Framework(s) used
* XCode 9.4.1 on IOS 11.4 using Swift
* FrameWorks: ChromaColorPicker

# Dependencies

CocoaPods using pod install to implement frameworks

Podfile:
```
platform : ios, '11.4.0'
target 'iPaint' do
use_frameworks!
pod 'ChromaColorPicker'
```
# Building/Running
1. Open project folder and clock on iPaint.xcworkspace to open project.
2. Build and run the app on target device.

# Screenshots

Main Canvas Screen: This is where the painting takes place.

![alt text](https://github.com/Roselai/iPaint/blob/master/mainCanvas.png)

Color Picker View: This is where users can select a color. When tapped, the small grey circle in the upper left corner toggles to grayscale color wheel. The user is able to move the handle around the outer circle to choose a color, and use the slider to choose a shade. Once the shade is chosen, user must hit the circular button in the middle with the + sign to set the chosen color as the current color, this also closes the color picker view and shows the canvas again.

![alt text](https://github.com/Roselai/iPaint/blob/master/colorPickerView.PNG)

Brush Width Slider: The default brush width is set to 1. User can move the slider up or down to select different values.

![alt text](https://github.com/Roselai/iPaint/blob/master/brushWidthSlider.png)

Saved Images View: This view shows all the images that a user has saved in a collectionview. Users can delete or view a selected image. The selected cell has a red border color and cell alpha has been lowered for visibility.

![alt text](https://github.com/Roselai/iPaint/blob/master/savedImagesView.png)

