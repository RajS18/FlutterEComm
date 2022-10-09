import 'package:flutter/material.dart';
//Material page route is a generic class and this is signaled by adding the angle brackets and t here as a
//placeholder for the generic type that can be passed in, that would be the data that the page you're loading would
//resolve to once it's popped off. So your custom route should also be a generic type and then you should add a
//constructor to custom route.

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({WidgetBuilder builder, RouteSettings settings1})
      : super(
          builder: builder,
	  settings: settings1
        );
//All these things should be forwarded to the parent class, so to material page route which we'll still use
//behind the scenes therefore and we do this with this initialize list with a colon and then by calling super
//thereafter and to super, for the builder arg., I forward the builder I'm getting and for the settings, I'm forwarding
//the settings I'm getting, so that this all works just as before with just the material page route and nothing
//changed regarding that.

//So this is now fully function custom route which in the end just wraps the material page route and doesn't add
//anything useful to it, the useful thing comes now.

//BuildTransitions is overridden, it's part of material page route and this controls how the page transition is
//animated and by overriding this, we can set up our own animation.It gets a build context and it gets an animation,
//in the end,that is the animation which Flutter controls for you, which you can simply listen to.
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    //Override this method to wrap the [child] with one or more transition widgets that define how the route
    //arrives on and leaves the screen.
    if (settings.name == '/') {
      //If the route is initial only load it normally as per device.
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class CustomPageTransitionBuilder1 extends PageTransitionsBuilder {

  //Used by [PageTransitionsTheme] to define a [MaterialPageRoute] page transition animation. Apps can configure the 
  //map of builders for [ThemeData.pageTransitionsTheme] to customize the default [MaterialPageRoute] page transition 
  //animation for different platforms.
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    //This will be same as the above overriden method with an extra argument that wil be generic.
    //Build transitions therefore also needs to be generic and get that t type here, so we have it both on build
    //transitions as an annotation to that method name and on page route, this simply means that in the end this
    //will work with different routes that will load different pages which will return different values when they're
    //popped off and this just is Dart's way of expressing this relation and making sure that type support is ensured
    //across the entire chain of logic you're executing.

    if (route.settings.name == '/') {
      // since route is present as an argument we can make use of route here tp get settings.
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
