# Sequenced Animations

Level up your application appearance with smooth and complex animations!

Easily create smooth and precise sequenced animation to your widgets, creating beautiful and creative animations and transitions.

Inspired from ![flutter_staggered_animations](https://pub.dev/packages/flutter_staggered_animations)

## Showcase

![](https://github.com/IsmailIbrahim5/sequenced_animations/blob/main/assets/sequenceAnimationBuilder.gif?raw=true)
![](https://github.com/IsmailIbrahim5/sequenced_animations/blob/main/assets/sequenceAnimationBuilder1.gif?raw=true)
![](https://github.com/IsmailIbrahim5/sequenced_animations/blob/main/assets/loading.gif?raw=true)


## Basic usages

Here is a sample sequenced animation

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SequencedAnimationsBuilder(
      animations: 4, // Number of sequenced animations
      repeat: true,
      reverse: true,
      curve: Curves.easeOutQuad,
      duration: const Duration(milliseconds: 600),
      builder: (values, [children]) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          4,
              (index) => Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: FractionalTranslation(
                translation: Offset(0.0, -values[index]),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.lightBlue, Colors.blueAccent],
                    ),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
```
## More information

You can identify `SequencedAnimationsController` object and pass it to the `SequencedAnimationsBuilder` widget to control the animation and check whether the animation status `(Completed , Dismissed, isForwarding, isReversing)`

You can customize the animation using following parameters:
- `duration`
- `reverseDuration`
- `repeat`
- `reverse`
- `delay` : The cycle fraction between each animation (eg 0.5 = half a cycle)
- `curve`
- `reverseCurve`
- `endCallback` : A callback function for when the animation is completed or dismissed
- `children` : Widgets that are prevented from being rebuilt with the animation, they are passed as parameters in the builder method

## Share your work!

This is just a package for a concept, the animations and transitions that can be done using this package is infinite.
We'd love to see the community achieve creativity using this package, so if you would like to send us your work and implementation that will be helpful to grow more!

