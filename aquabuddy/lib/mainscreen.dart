import 'package:flutter/material.dart';

// Inputs: user weight, user age, activity level (dropdown), temperature (dropdown: hot/cold).
// Output: recommended liters per day.

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  // for text fields
  TextEditingController weightController = TextEditingController();
  FocusNode weightFocusNode = FocusNode();

  TextEditingController ageController = TextEditingController();
  FocusNode ageFocusNode = FocusNode();

  // for dropdowns
  String activityLevel = 'Low';
  // ignore: non_constant_identifier_names
  String current_weather = 'Cold';
  double recommendedWater = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AquaBuddy Calculator',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 76, 152, 214),
      ), //AppBar
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Column(
              children: [
                Text(
                  'Enter your details below!💧',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),

                Container(
                  padding: EdgeInsets.all(16.0),
                  margin: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 214, 235, 254),
                    border: Border.all(
                      color: Color.fromARGB(255, 76, 152, 214),
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  width: 500,
                  height: 500,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40),
                      Row(
                        children: [
                          SizedBox(
                            width: 130,
                            child: Text(
                              'Weight (kg)',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            height: 50,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              focusNode: weightFocusNode,
                              controller: weightController,
                              decoration: InputDecoration(
                                labelText: 'Example: 50',
                                prefixIcon: Icon(Icons.monitor_weight_outlined),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(
                            width: 130,
                            child: Text(
                              'Age',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            height: 50,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              focusNode: ageFocusNode,
                              controller: ageController,
                              decoration: InputDecoration(
                                labelText: 'Example: 20',
                                prefixIcon: Icon(Icons.cake_outlined),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(
                            width: 140,
                            child: Text(
                              'Activity Level',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          DropdownButton<String>(
                            value: activityLevel,
                            items: <String>['Low', 'Medium', 'High'].map((
                              String value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              activityLevel = newValue!;
                              setState(() {});
                            },
                          ),
                        ], //children
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(
                            width: 140,
                            child: Text(
                              'Weather Today',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          DropdownButton<String>(
                            value: current_weather,
                            items: <String>['Cold', 'Normal', 'Hot'].map((
                              String value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              current_weather = newValue!;
                              setState(() {});
                            },
                          ),
                        ], //children
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: calculateWater,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.black, width: 1.0),
                            ),

                            child: Text(
                              'Calculate 📱',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              weightController.clear();
                              ageController.clear();
                              activityLevel = 'Low';
                              current_weather = 'Cold';
                              recommendedWater = 0.0;

                              FocusScope.of(
                                context,
                              ).requestFocus(weightFocusNode);
                              setState(() {});
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.black, width: 1.0),
                            ),

                            child: Text(
                              'Reset ♻️',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void calculateWater() {
    if (ageController.text.isEmpty || weightController.text.isEmpty) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please fill in all the fields!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

   double? weight = double.tryParse(weightController.text);
    double? age = double.tryParse(ageController.text);
    
    if (double.parse(weightController.text) <= 0 ||
        double.parse(weightController.text) > 200 ||
        double.parse(ageController.text) <= 0 ||
        double.parse(ageController.text) > 120) {
      weightController.clear();
      ageController.clear();

      SnackBar snackBar = const SnackBar(
        content: Text('Please enter valid values for weight and age!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    double baseWater, waterperAge, waterperActivity, waterperWeather;

    if (age! >= 18 && age <= 30) {
      waterperAge = 0.035;
    } else if (age >= 31 && age <= 55) {
      waterperAge = 0.033;
    } else {
      waterperAge = 0.03;
    }

    baseWater = weight! * waterperAge;

    waterperActivity = 0;
    if (activityLevel == 'Medium') {
      waterperActivity = 0.35;
    } else if (activityLevel == 'High') {
      waterperActivity = 0.7;
    }

    waterperWeather = 0;
    if (current_weather == 'Normal') {
      waterperWeather = 0.25;
    } else if (current_weather == 'Hot') {
      waterperWeather = 0.5;
    }

    double finalWater = baseWater + waterperActivity + waterperWeather;

    // round to 2 decimal places
    recommendedWater = double.parse((finalWater).toStringAsFixed(2));
    setState(() {});

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Calculating...'),
            ],
          ),
        );
      },
      barrierDismissible: false,
    );

    Future.delayed(const Duration(seconds: 2), () {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('🫗Recommended Water Intake🫗'),
            content: Text(
              'It is recommended for you to drink $recommendedWater liters per day.',
            ),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    });
  }
}
