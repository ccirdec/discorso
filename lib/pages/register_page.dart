import 'package:discorso/components/my_button.dart';
import 'package:discorso/components/my_text_field.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({
    super.key,
    required this.onTap
    });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();
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
                Text("Let's create an account for you",
                style: TextStyle(color: Theme.of(context).colorScheme.primary,
                fontSize: 16),),
            
                const SizedBox(height: 25,),
                MyTextField(
                  controller: nameController, 
                  hintText: "Enter name", 
                  obscureText: false),

                const SizedBox(height: 10,),
                
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

                MyTextField(
                  controller: confirmPwController, 
                  hintText: "Confirm Password", 
                  obscureText: true),

                
                const SizedBox(height: 25),

                MyButton(text: "Register", onTap: (){}),

                const SizedBox(height: 50,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already Have An Account?", style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                    const SizedBox(width: 5,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text("Login now", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold))),
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