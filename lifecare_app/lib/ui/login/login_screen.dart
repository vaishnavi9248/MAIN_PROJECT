import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool hidePassword = true;

  String loginButtonText = "Login";

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Image.asset("assets/png/icon.png", height: 250),
                  const Spacer(),
                  TextFormField(
                    controller: _username,
                    decoration: const InputDecoration(
                      hintText: "User Name",
                      labelText: "User Name",
                      border: OutlineInputBorder(),
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                    ),
                    validator: (String? value) {
                      if (value != null) {
                        if (value.isEmpty) {
                          return "Mandatory field";
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _password,
                    decoration: InputDecoration(
                      hintText: "Password",
                      labelText: "Password",
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      isDense: true,
                      suffixIcon: InkWell(
                        onTap: () =>
                            setState(() => hidePassword = !hidePassword),
                        child: Icon(
                          hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    obscureText: hidePassword,
                    validator: (String? value) {
                      if (value != null) {
                        if (value.isEmpty) {
                          return "Password is mandatory";
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50)),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_username.text == "admin" &&
                            _password.text == "admin") {
                          setState(() => loginButtonText = "Loading...");
                          await Future.delayed(const Duration(seconds: 2));

                          setState(() => loginButtonText = "Please wait...");
                          await Future.delayed(const Duration(seconds: 2));

                          setState(() => loginButtonText = "Success");
                        }
                      }
                    },
                    child: Text(
                      loginButtonText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
