import 'package:airbnb_app/Authentication/google_authentication.dart';
import 'package:airbnb_app/view/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Text(
                  "Log in or Sign up",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )),
                Divider(
                  thickness: 1,
                  color: Colors.black12,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Column(
                    children: [
                      Text(
                        "Welcome to AirBnb",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                PhoneNumberField(size),
                SizedBox(height: 10),
                RichText(
                    text: TextSpan(
                        text:
                            "We,ll call or text you to conform your number. Standard message and data rates apply.",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        children: [
                      TextSpan(
                          text: "Prrivacy Policy",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ))
                    ])),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Container(
                  width: size.width,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.pink),
                  child: Center(
                    child: Text(
                      "Continue",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.026,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.black26,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "or",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.black26,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.015,
                ),
                socialIcons(size, Icons.facebook, "Continue with Facebook",
                    Colors.blue, 30),
                InkWell(
                  onTap: () async {
                    await FirbaseAuthServices().signInWithGoogle();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AppMainScreen()));
                  },
                  child: socialIcons(size, FontAwesomeIcons.google,
                      "Continue with Google", Colors.orangeAccent, 27),
                ),
                socialIcons(size, Icons.email_outlined, "Continue with Email",
                    Colors.black, 30),
                SizedBox(
                  height: 10,
                ),
                Center(
                    child: Text(
                  "Need help?",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ))
              ],
            ),
          )),
    );
  }

  Padding socialIcons(Size size, icon, name, color, double iconSize) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Container(
        width: size.width,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(),
        ),
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.05,
            ),
            Icon(icon, color: color, size: iconSize),
            SizedBox(
              width: size.width * 0.09,
            ),
            Text(
              name,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  Container PhoneNumberField(Size size) {
    return Container(
      width: size.width,
      height: 130,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black45),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Country/Region",
                  style: TextStyle(color: Colors.black45),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "India(+91)",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_sharp,
                      size: 30,
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: "Phone number",
                  hintStyle: TextStyle(fontSize: 14, color: Colors.black45),
                  border: InputBorder.none),
            ),
          )
        ],
      ),
    );
  }
}
