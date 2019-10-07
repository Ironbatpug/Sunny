# Sunny

A small weather app for iOS, which can forecast the weather for 16 days. Either a specific place could be seached or for user locations. Only use the user location when the app in used.

The API in use is Weatherbit, which is also provided the pictures in the app.

The launch screen has 2 second loading with a horizental bar.

City selector view: in this page you can search for a city or use the current location button.

Weather details view: in this page you can see the weather for the next 16 days with the min, max temparature, sunset and sunrise time.
With the star button on the top right you can set the city to a favorite. If you accidentaly tap on it, just tap on star again, and city will be removed from the favorite cities.

Favorite city view: can be reached from the city selector view by click on the star. If you do not have a favorite city you can not reach this page.

To install Sunny:
The project use a pod, so after git clone, the pod has to installed.
After that start the Sunny.xcworkspace. Due to the gitignore file the xcuserdata is not added, this couse an error on first run. On Sunny the "Main interface" should setted to "Main.storyboard" and the "Launch screen file" to "LaunchScreen.storyboard"
