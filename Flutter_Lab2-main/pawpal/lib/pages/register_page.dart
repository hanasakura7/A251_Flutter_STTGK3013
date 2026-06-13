import 'dart:convert';
import 'package:pawpal/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isVisible1 = false;
  bool isVisible2 = false;
  bool isLoading = false; //manage laoding state

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register Page")),
      body: Row(
        children: [
          //left side image
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              color: Colors.orange[100],
              child: Center(
                child: Image.asset(
                  'assets/images/register_image.png',
                  width: 500,
                  height: 500,
                ),
              ),
            ),
          ),

          //right side register form
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Register Here!",
                      style: TextStyle(
                        fontSize: 56,
                        fontFamily: "Bubblegum Sans",
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[700],
                      ),
                    ),
                    SizedBox(height: 20),

                    //full name
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: 'Full Name',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    //email address
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Email Address',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    //create password
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isVisible1
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isVisible1 = !isVisible1;
                            });
                          },
                        ),
                        labelText: 'Create Password',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                      ),
                      obscureText: isVisible1 ? false : true,
                    ),
                    SizedBox(height: 20),

                    //confirm password
                    TextField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isVisible2
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isVisible2 = !isVisible2;
                            });
                          },
                        ),
                        labelText: 'Confirm Password',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                      ),
                      obscureText: isVisible2 ? false : true,
                    ),
                    SizedBox(height: 20),

                    //phone number
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        labelText: 'Phone Number',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    //register button
                    ElevatedButton(
                      onPressed: () {
                        confirmRegisterDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[400],
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),

                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "Login now.",
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
        ],
      ),
    );
  }

  void confirmRegisterDialog() {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String phone = phoneController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        phone.isEmpty) {
      SnackBar snackBar = SnackBar(content: Text("Please fill in all fields."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (password != confirmPassword) {
      SnackBar snackBar = SnackBar(content: Text("Passwords do not match."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (!RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    ).hasMatch(email)) {
      SnackBar snackBar = SnackBar(content: Text("Invalid email address."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (password.length < 6) {
      SnackBar snackBar = SnackBar(
        content: Text("Password must be at least 6 characters long."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (!RegExp(r'^\d{10,11}$').hasMatch(phone)) {
      SnackBar snackBar = SnackBar(
        content: Text(
          "Invalid phone number. Phone number must be between 10 and 11 digits.",
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Register an account?"),
          content: Text("Do you want to register this account?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                registerUser(name, email, password, phone);
              },
              child: Text("Register"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void registerUser(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    setState(() {
      isLoading = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(color: Colors.orange),
              SizedBox(width: 20),
              Text("Registering..."),
            ],
          ),
        );
      },
    );

    await http
        .post(
          Uri.parse('${MyConfig.baseUrl}/pawpal/api/register.php'),
          body: {
            'name': name,
            'email': email,
            'password': password,
            'phone': phone,
          },
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = json.decode(jsonResponse);

            if (resarray['status'] == 'success') {
              if (!mounted) return;
              SnackBar snackBar = SnackBar(
                content: Text("Registration successful!"),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              if (isLoading) {
                Navigator.of(context).pop(); //close the loading dialog
                setState(() {
                  isLoading = false;
                });
              }

              //close the register dialog and Navigate to the login page
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            } else {
              if (!mounted) return;
              SnackBar snackBar = SnackBar(content: Text(resarray['message']));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          } else {
            if (!mounted) return;
            SnackBar snackBar = SnackBar(
              content: Text(
                "Error during registration. Please try again later.",
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        })
        // Handle timeout if the request takes too long
        .timeout(
          Duration(seconds: 10),
          onTimeout: () {
            if (!mounted) return;
            SnackBar snackBar = SnackBar(
              content: Text("Request timed out. Please try again."),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        )
        .catchError((error) {
          if (!mounted) return;
          SnackBar snackBar = SnackBar(
            content: Text("An error occurred: $error"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });

    if (isLoading) {
      Navigator.of(context).pop(); //close the loading dialog
      setState(() {
        isLoading = false;
      });
    }
  }
}
