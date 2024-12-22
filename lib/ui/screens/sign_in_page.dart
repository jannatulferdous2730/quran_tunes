import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quran_tunes/services/auth_service.dart';
import 'package:quran_tunes/ui/screens/home.dart';
import 'package:quran_tunes/ui/widgets/custom_textfield.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {

    AuthService authService = AuthService();
    TextEditingController mailController = TextEditingController(),
        nameController = TextEditingController(),
        passwordController = TextEditingController();
    RxBool isRegistering = false.obs, 
      isGLoading = false.obs,
      isLoading = false.obs;

    
    var size = Get.size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SvgPicture.asset(
          'assets/vectors/logo.svg',
          height: size.height * 0.05,  
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Obx(() => Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Sign In", style: TextStyle(color: Colors.white, fontSize: size.height * 0.05),),
          
              Visibility(
                visible: isRegistering.value,
                child: CustomTextfield(
                  hint: "itachi uchiha",
                  controller: nameController,
                  tag: "your full name",
                  iconData: CupertinoIcons.creditcard,
                )),
            Visibility(
                visible: isRegistering.value,
                child: SizedBox(
                  height: size.height * 0.03,
                )),
          
              CustomTextfield(
                hint: "abc@gmail.com", 
                controller: mailController, 
                tag: "email address",
                iconData: CupertinoIcons.mail,),
          
              SizedBox(height : size.height * 0.03,),
          
          
              CustomTextfield(
                hint: "********",
                controller: passwordController,
                tag: "passkey",
                iconData: CupertinoIcons.padlock_solid,
              ),
          
          
       
              SizedBox(height: size.height * 0.03,),

              const Text(
                "by signing in / registering, you are agreeing to comply with our terms and services.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
          
          
              SizedBox(height: size.height * 0.03,),
          
          
              GestureDetector(
                onTap: () async {
                  isLoading.value = true;
                  isRegistering.value
                  ? await authService.register(mailController.text, passwordController.text)
                  : await authService.signin(mailController.text, passwordController.text);
                  isLoading.value = false;
                  Get.to(() => const Home());
                },
                child: Container(
                  width: size.width,
                  height: AppBar().preferredSize.height * .87,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100)),
                  child: Center(
                    child: isLoading.value
                    ? const CircularProgressIndicator() 
                    : Text(
                      isRegistering.value ? "register" : "sign in",
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, 
                          color: Colors.black87,
                          fontSize: 19
                        ),
                    ),
                  ),
                ),
              ),
          
              SizedBox(height: size.height * 0.03,),


              Visibility(
                visible: !isRegistering.value,
                child: GestureDetector(
                  onTap: () async {
                    isGLoading.value = true;
                    await authService.signInWithGoogle();
                    isGLoading.value = false;
                    Get.to(() => const Home());
                  },
                  child: Container(
                    width: size.width,
                    height: AppBar().preferredSize.height * .87,
                    decoration: BoxDecoration(
                        color: Colors.red[600],
                        borderRadius: BorderRadius.circular(100)),
                    child: Center(
                      child: isGLoading.value
                      ? const CircularProgressIndicator()  
                      : const Text(
                        "sign in with google",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 19),
                      ),
                    ),
                  ),
                ),
              ),
          
              Visibility(
                visible: !isRegistering.value,
                child: SizedBox(height: size.height * 0.03,),
              ),
              
              Center(
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: isRegistering.value
                            ? "already have an account? "
                            : "don't have an account? ",
                        style: const TextStyle(color: Colors.white)),
                    WidgetSpan(
                        child: GestureDetector(
                          onTap: () => isRegistering.value =
                              !isRegistering.value,
                          child: Text(
                            isRegistering.value
                                ? "sign in here"
                                : "register here",
                            style: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                        alignment: PlaceholderAlignment.middle)
                  ]),
                  textAlign: TextAlign.center,
                ),
              ),
              

            
          
                     
            ],
          ),
        ),
      ),
    ));
  }
}