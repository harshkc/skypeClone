import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skypeclone/models/call.dart';
import 'package:skypeclone/provider/user_provider.dart';
import 'package:skypeclone/resources/call_methods.dart';
import 'package:skypeclone/screens/call_screens/pickups/pickup_screen.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  PickupLayout({@required this.scaffold});

  final CallMethods callMethods = CallMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return (userProvider != null && userProvider.getUser != null)
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(uid: userProvider.getUser.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.data != null) {
                //i.e. if there is no documents because of hanging of call before it is received or some reasons
                Call call = Call.fromMap(snapshot.data.data);

                if (!call.hasDialled) {
                  return PickupScreen(call: call);
                }
              }
              return scaffold;
            },
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
