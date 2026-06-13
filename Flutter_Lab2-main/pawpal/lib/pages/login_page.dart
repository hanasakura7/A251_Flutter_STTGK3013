import 'dart:convert';
import 'package:pawpal/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/model/user.dart';
import 'package:pawpal/pages/home_page.dart';
import 'package:pawpal/pages/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isVisible = false;
  bool isRemember = false;
  bool isLoading = false;

  late User user;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Page")),
      body: Row(
        children: [
          //left side login form
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome Back!",
                        style: TextStyle(
                          fontSize: 56,
                          fontFamily: "Bubblegum Sans",
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[400],
                        ),
                      ),
                      Text(
                        "Please enter your details",
                        style: TextStyle(fontSize: 20, color: Colors.black87),
                      ),
                      SizedBox(height: 40),

                      //email textfield
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: 'Email',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      //password textfield
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                          ),
                          labelText: 'Password',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                        ),
                        obscureText: isVisible ? false : true,
                      ),

                      //remember me checkbox
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Checkbox(
                            value: isRemember,
                            onChanged: (value) {
                              isRemember = value!;
                              setState(() {});
                            },
                          ),
                          Text(
                            "Remember Me",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      //login button
                      ElevatedButton(
                        onPressed: isLoading ? null : loginUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[400],
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),

                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "Register here.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue[900],
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //right side with image
          Expanded(
            child: Container(
              color: Colors.orange[100],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "PawPal",
                      style: TextStyle(
                        fontSize: 56,
                        fontFamily: "Bubblegum Sans",
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Image.asset(
                      'assets/images/pawpal_icon.png',
                      width: 350,
                      height: 350,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });

    //validate inputs
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      SnackBar snackBar = SnackBar(
        content: Text('Please fill in all fields'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    //show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(color: Colors.orange),
              SizedBox(width: 20),
              Text("Logging in..."),
            ],
          ),
        );
      },
    );

    //authenticate user
    bool loginSuccess = await authenticateUser(
      emailController.text,
      passwordController.text,
    );

    Navigator.pop(context); //close loading dialog

    if (loginSuccess) {
      await handleSharedPreferences();
      // Navigate to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(user: user)),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  void loadPreferences() {
    SharedPreferences.getInstance().then((prefs) {
      bool? rememberMe = prefs.getBool('rememberMe');

      if (rememberMe != null && rememberMe) {
        String? email = prefs.getString('email');
        String? password = prefs.getString('password');
        isRemember = true;
        emailController.text = email ?? '';
        passwordController.text = password ?? '';
      } else {
        isRemember = false;
      }

      setState(() {});
    });
  }

  Future<bool> authenticateUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${MyConfig.baseUrl}/pawpal/api/login.php'),
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          user = User.fromJson(jsonResponse['data']);

          SnackBar snackBar = SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          return true;
        } else {
          SnackBar snackBar = SnackBar(
            content: Text('Login failed. Please check your credentials.'),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          return false;
        }
      } else {
        SnackBar snackBar = SnackBar(
          content: Text('Server error. Please try again later.'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  Future<void> handleSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (isRemember) {
      await prefs.setString('email', emailController.text);
      await prefs.setString('password', passwordController.text);
      await prefs.setBool('rememberMe', true);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
      await prefs.setBool('rememberMe', false);

      emailController.clear();
      passwordController.clear();
      setState(() {});
    }
  }
}
