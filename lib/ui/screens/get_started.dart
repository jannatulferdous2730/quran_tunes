import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'sign_in_page.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    
    var size = Get.size;
    
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/get_started.png'),
                fit: BoxFit.cover
              ),
            ),
          ),
    
          Container(
            color: Colors.black54,
          ),
    
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset('assets/vectors/logo.svg'),
                ),
    
                const Spacer(),
    
                Text(
                  'Millions of songs.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width * 0.035,
                    fontWeight: FontWeight.w400
                  ),
                ),
    
                Text(
                  'Free on Spotify,',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width * 0.040,
                    fontWeight: FontWeight.bold
                  ),
                ),

                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: () => Get.to(() => const SignInPage(), transition: Transition.rightToLeft),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green
                  ),
                  child: Text('Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: size.width * 0.055,
                    ),
                  ),
                  
                )
              ],
            )  
          )
        ]
      ),
    );
  }
}