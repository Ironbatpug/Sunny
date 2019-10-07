# Sunny

A small weather app for iOS, which can forecast the weather for 16 days. The user can either search for a specific place or can use their own location.

The API in use is Weatherbit, which also provides the pictures in the app.

The launch screen has a 2 seconds loading time with a horizental bar.

# City selector view
On this page you can search for a city or use the current location button.

# Weather details view
On this page you can see the weather for the next 16 days with the min, max temparature, sunset and sunrise time.
With the star button on the top right you can set the city to a favorite. If you accidentaly tap on the star, just tap on the star again, and city will be removed from the favorite cities.

# Favorite city view
Can be reached from the city selector view by click on the star. If you do not have a favorite city you can not reach this page.

## To install Sunny
Prerequisite h installed legyen az xcode.
1. Install the dependencies. From the project folder send the following command: ```pod install```
2. Douple click  Sunny.xcworkspace.
3. Due to the gitignore file the xcuserdata is not added, this couse an error on build. On Sunny the "Main interface" should set to "Main.storyboard" and the "Launch screen file" to "LaunchScreen.storyboard"
