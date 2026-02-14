import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AuthGradientButton extends StatelessWidget {
  const AuthGradientButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          AppPallete.gradient1,
          AppPallete.gradient2
        ],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight),
        borderRadius: BorderRadius.circular(10)
      ),
      child: ElevatedButton(onPressed: (){},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPallete.transparentColor,
        shadowColor: AppPallete.transparentColor,
        fixedSize: const Size(395, 55),
      ), child: Text('Sign Up',
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600, // Bold is 800, SemiBold is 600
      
      ),)),
    );
  }
}