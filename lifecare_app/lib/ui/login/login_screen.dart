import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifecare/const/preference_key.dart';
import 'package:lifecare/data/services/shared_pref.dart';
import 'package:lifecare/ui/login/home/home_screen.dart';
import 'package:lifecare/util/show_custom_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _hidePassword = true;

  String _loginButtonText = "Login";

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
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: "User Name",
                      labelText: "User Name",
                      border: OutlineInputBorder(),
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                    ),
                    validator: _userNameValidator,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _password,
                    textInputAction: TextInputAction.done,
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
                            setState(() => _hidePassword = !_hidePassword),
                        child: Icon(
                          _hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    obscureText: _hidePassword,
                    validator: _passwordValidator,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: Text(
                      _loginButtonText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    onPressed: () => _onSubmit(),
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

  String? _userNameValidator(String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return "User name is required";
      }
      if (value.replaceAll(" ", "").length < 5) {
        return "Username must be 5 letters";
      }
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value != null) {
      RegExp regex = RegExp(
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
      if (value.isEmpty) {
        return ("Password is required");
      } else if (value.length < 8) {
        return ("Password Must be more than 8 characters");
      } else if (!regex.hasMatch(value)) {
        return ("Password should contain upper,lower,digit and Special character ");
      }
    }
    return null;
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());

      setState(() => _loginButtonText = "Loading...");
      await Future.delayed(const Duration(seconds: 1));

      if (_username.text == "Admin" && _password.text == "Admin@123") {
        setState(() => _loginButtonText = "Please wait...");
        await Future.delayed(const Duration(seconds: 1));

        successLogin();
      } else {
        setState(() => _loginButtonText = "Login");

        // ignore: use_build_context_synchronously
        showCustomSnackBar(context: context, message: "Invalid password");
      }
    }
  }

  Future<void> successLogin() async {
    SharedPref().setBool(key: PreferenceKey.isLoggedIn, value: true);

    showCustomSnackBar(context: context, message: "Successfully logged-in");

    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => HomeScreen(),
        transitionsBuilder: (context, animation1, animation2, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation1.drive(tween),
            child: child,
          );
        },
      ),
      (route) => false,
    );
  }
}
