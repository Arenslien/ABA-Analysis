import 'package:aba_analysis/constants.dart';
import 'package:flutter/material.dart';

class AuthGoogleButton extends StatelessWidget {
  final String text;
  final Function()? onPress;
  const AuthGoogleButton({
    Key? key,
    required this.text,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.grey[300],
        minimumSize: Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('asset/icon_google.png'),
            width: 30,
            height: 30,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ],
      ),
      onPressed: onPress,
    );
    return GestureDetector(
      onTap: onPress,
      child: Container(
        color: Colors.grey,
        width: 200,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('asset/icon_google.png'),
              width: 30,
              height: 30,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
    //   return ElevatedButton(
    //     style: ElevatedButton.styleFrom(
    //       primary: Colors.grey[300],
    //       minimumSize: Size(double.infinity, 50),
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(40),
    //       ),
    //     ),
    //     child: Image(
    //       fit: BoxFit.fill,
    //       image: AssetImage('asset/icon_google.png'),
    //       width: 20,
    //       height: 20,
    //     ),
    //     //   Text(
    //     //     text,
    //     //     style: TextStyle(
    //     //       fontSize: 20.0,
    //     //     ),
    //     //   ),
    //     // ],

    //     onPressed: onPress,
    //   );
    // }
  }
}
