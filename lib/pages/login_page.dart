import 'package:discorso/components/my_button.dart';
import 'package:discorso/components/my_text_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({
    super.key,
    required this.onTap
    });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: Column(
              // ubah kalau gak cocok
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            
                Icon(
                  Icons.lock_open_rounded,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary),
            
            
            
                const SizedBox(height: 50,),
                Text("Welcome Back, you've been missed",
                style: TextStyle(color: Theme.of(context).colorScheme.primary,
                fontSize: 16),),
            
                const SizedBox(height: 25,),
                
                MyTextField(
                  controller: emailController, 
                  hintText: "Enter Email", 
                  obscureText: false),
                
                const SizedBox(height: 10,),
                MyTextField(
                  controller: pwController, 
                  hintText: "Enter Password", 
                  obscureText: true),

                const SizedBox(height: 10,),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text("Forgot Password?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),)),  

                
                const SizedBox(height: 25),

                MyButton(text: "Login", onTap: (){}),

                const SizedBox(height: 50,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't Have An Account?", style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                    const SizedBox(width: 5,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text("Register now", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold))),
                  ],
                )
                
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}