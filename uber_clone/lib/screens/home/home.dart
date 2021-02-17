import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:uber_clone/screens/home/drawer/drawer.dart';
import 'package:uber_clone/screens/home/drawer_menu_icon.dart';
import 'package:uber_clone/screens/home/pick_destination.dart';
import 'package:uber_clone/screens/home/ride_now.dart';

class Home extends StatefulWidget {
  static const route = '/home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final globalKey = GlobalKey<ScaffoldState>();
  Color statusBarColor = Colors.transparent;

  @override
  void initState() {
    super.initState();

     print('pozvo se init state');
  }


  Future<void> changeStatusBarColor() async {
    await FlutterStatusbarcolor.setStatusBarColor(Colors.transparent, animate: true);
  }



  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: statusBarColor
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        key: globalKey,
        backgroundColor: Colors.grey,
        body: SafeArea(
          child: Stack(
            fit: StackFit.loose,
            children: [

              //BOTTOM WHERE TO AND SAVED PLACE PART
              PickDestination(),
              //BLUE RIDE NOW PART
              RideNow(),
              //Drawer Menu Icon
              DrawerMenu(),
            ]
          )
        ),
        drawer: HomeDrawer(),
      ),
    );
  }


}
