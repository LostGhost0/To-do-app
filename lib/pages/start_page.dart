import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  bool _SignInLoading = false;
  bool _SignUpLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _googleSignInLoading = false;

  @override
  void dispose() {
    supabase.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/photo1.png',
                      height: 150,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Field is Required";
                        }
                        return null;
                      },
                      controller: _emailController,
                      decoration: const InputDecoration(label: Text("Email")),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Field is required";
                        }
                        return null;
                      },
                      controller: _passwordController,
                      decoration:
                          const InputDecoration(label: Text("Password")),
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    _SignInLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              final isValid = _formKey.currentState?.validate();
                              if (isValid != true) {
                                return;
                              }
                              setState(() {
                                _SignInLoading = true;
                              });
                              try {
                                await supabase.auth.signInWithPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text);

                                setState(() {
                                  _SignInLoading = false;
                                });
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Wrong credintainls!"),
                                  backgroundColor: Colors.red,
                                ));
                                setState(() {
                                  _SignInLoading = false;
                                });
                              }
                            },
                            child: Text("Sign In")),
                    const Divider(),
                    _SignUpLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : OutlinedButton(
                            onPressed: () async {
                              final isValid = _formKey.currentState?.validate();
                              if (isValid != true) {
                                return;
                              }
                              setState(() {
                                _SignUpLoading = true;
                              });
                              try {
                                await supabase.auth.signUp(
                                    email: _emailController.text,
                                    password: _passwordController.text);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content:
                                      Text("Success, conformation Email sent"),
                                  backgroundColor: Colors.amber,
                                ));
                                setState(() {
                                  _SignUpLoading = false;
                                });
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Sign up faild!"),
                                  backgroundColor: Colors.red,
                                ));
                                setState(() {
                                  _SignUpLoading = false;
                                });
                              }
                            },
                            child: const Text("Sign Up")),
                    SizedBox(height: 15),
                    _googleSignInLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : OutlinedButton(
                            onPressed: () async {
                              setState(() {
                                _googleSignInLoading = true;
                              });
                              try {
                                await supabase.auth.signInWithOAuth(
                                    Provider.google,
                                    redirectTo: kIsWeb
                                        ? null
                                        : 'io.supabase.myflutterapp://login-callback');
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('wrong data')));
                                setState(() {
                                  _googleSignInLoading = false ;
                                });
                              }
                            },
                            child: Text("sign up with google"))
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
