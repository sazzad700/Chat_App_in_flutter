import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app/Component/rounded_button.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {

  static String id="wellcome_screen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

   late AnimationController controller;
   late Animation animation;

  double? value=0.0;


  @override
  void initState() {
    super.initState();

    controller=AnimationController(
        duration: Duration(seconds: 1),
      vsync:this,

    );

    // animation=CurvedAnimation(parent: controller, curve: Curves.easeIn);

    animation=ColorTween(begin: Colors.blueGrey,end: Colors.white).animate(controller);

    controller.forward();

    // animation.addStatusListener((status) {
    //   if(status==AnimationStatus.completed){
    //     controller.reverse(from: 1.0);
    //   }else if(status==AnimationStatus.dismissed){
    //     controller.forward();
    //   }
    // });

    controller.addListener(() {
      setState(() {
        value=controller.value;
      });

    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Hero(

                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                AnimatedTextKit(
                 animatedTexts: [
                   TypewriterAnimatedText( 'Flash Chat',textStyle: TextStyle(
                       fontSize: 45.0,
                       fontWeight: FontWeight.w900,
                       color:Colors.black54
                   ),
                   speed: Duration(seconds: 1),

                   ),

                 ],
                  
                  repeatForever: false,

                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
        RoundedButton(
          text: 'Login',
          fun: () {
            Navigator.pushNamed(context, LoginScreen.id);
          },
          color: Colors.lightBlueAccent,
        ),
        RoundedButton(
          text: 'Register',
          fun: () {
            Navigator.pushNamed(context, RegistrationScreen.id);
          },
          color: Colors.blueAccent,
          ),
          ],
        ),
      ),
    );
  }
}


