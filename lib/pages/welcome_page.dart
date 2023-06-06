import 'package:flutter/material.dart';
import 'package:sidh_chat_app/pages/login_page.dart';
import 'package:sidh_chat_app/pages/register_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sidh_chat_app/utils/constants.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => const WelcomePage());
  }

  @override
  State<StatefulWidget> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 160, 127, 190),
      body: SafeArea(
        child: Column(
          children: [
            formSpacer,
            const Text(
              "Welcome!",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SvgPicture.asset(
              'assets/chat.svg',
              width: double.infinity,
              height: 500,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(15)),
                    ),
                    onPressed: () {
                      Navigator.push(context, RegisterPage.route());
                    },
                    child: const Text('Register',  
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold, 
                                        fontSize: 18.0)
                                      ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(15)),
                    ),
                    onPressed: () {
                      Navigator.push(context, LoginPage.route());
                    },
                    child: const Text('Login',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold, 
                                        fontSize: 18.0)
                                      ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
