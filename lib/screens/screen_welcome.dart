import 'package:flutter/material.dart';
import 'package:predict/screens/screen_initial.dart';
import 'package:predict/screens/test_welcome.dart';

class ScreenWelcome extends StatelessWidget {
  const ScreenWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  child: Image(
                    image: AssetImage('./assets/images/welcome.jpg'),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Welcome',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 123, 191, 247),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Find your weather predictions in your City. Easy steps to predict the weather and make your day easier. ',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.5,
                  ),
                ),
              ),
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: TextButton.icon(
              //     // color: Colors.white,
              //     label: Text(''),
              //     onPressed: () {},
              //     icon: Icon(Icons.arrow_right),
              //     style: IconButton.styleFrom(
              //       backgroundColor: Color.fromARGB(255, 123, 191, 247),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      // --- remove it if not looking good -----
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (builder) => ScreenInitial(),
            ),
          );
        },
        child: Icon(
          Icons.arrow_forward,
          color: Colors.black,
        ),
        backgroundColor: Color.fromARGB(255, 123, 191, 247),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}