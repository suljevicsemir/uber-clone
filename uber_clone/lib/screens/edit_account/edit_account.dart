import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/services/authentication_service.dart';

class EditAccount extends StatefulWidget {

  static const route = '/editAccount';

  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {

  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<AuthenticationService>(context, listen: false).currentUser;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child : Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, isScrolled) {
            return [
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverSafeArea(
                  top: false,
                  sliver: SliverAppBar(
                      iconTheme: IconThemeData(
                          color: Colors.white
                      ),
                      brightness: Brightness.dark,
                      elevation: 0.0,
                      expandedHeight: MediaQuery.of(context).size.height * 0.45,
                      pinned: true,
                      actions: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {},
                        ),
                      ],
                      flexibleSpace: LayoutBuilder(
                        builder: (context, constraints) {
                          return  FlexibleSpaceBar(
                            centerTitle: false,
                            title: Text('John', style: TextStyle(color: Colors.white, fontSize: 22),),
                            background: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/new_york.jpg'),
                                    fit: BoxFit.cover,
                                  )
                              ),
                            ),
                          );
                        },
                      )
                  ),
                ),
              )
            ];
          },
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(height: 30, color: Colors.grey, thickness: 0.5,),
                  Text('First Name', style: Theme.of(context).textTheme.headline5,),
                  SizedBox(height: 10,),
                  Text(user.displayName, style: Theme.of(context).textTheme.headline6,),
                  SizedBox(height: 40,),
                  Text('Last Name', style: Theme.of(context).textTheme.headline5,),
                  SizedBox(height: 10,),
                  Text(user.displayName, style: Theme.of(context).textTheme.headline6,),
                  SizedBox(height: 40,),
                  Text('Phone number', style: Theme.of(context).textTheme.headline5,),
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Image.asset(
                          'icons/flags/png/ba.png', package: 'country_icons',

                          scale: 2,
                        ),
                      ),
                      Text(' +387 62 972 494', style: Theme.of(context).textTheme.headline6,),
                      Spacer(),
                      Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text('Verified' ,style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.green, fontWeight: FontWeight.w300),))
                    ],
                  ),
                  SizedBox(height: 40,),
                  Text('Email', style: Theme.of(context).textTheme.headline5,),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Expanded(
                          child: Text(user.email + 'dsadas', style: Theme.of(context).textTheme.headline6, overflow: TextOverflow.clip,)),
                     // Spacer(),
                      Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text('Verified', style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.green, fontWeight: FontWeight.w300),))
                    ],
                  ),
                  SizedBox(height: 40,),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/google_icon.png',
                        scale: 15,
                      ),
                      SizedBox(width: 20,),
                      Text('Google', style: Theme.of(context).textTheme.headline6,),
                      Spacer(),
                      Text('Connected', style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.green, fontWeight: FontWeight.w300),)
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
