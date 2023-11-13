import 'package:flutter/material.dart';

class SettingsOnePage extends StatefulWidget {
  const SettingsOnePage({Key? key}) : super(key: key);

  @override
  State<SettingsOnePage> createState() => _SettingsOnePageState();
}

class _SettingsOnePageState extends State<SettingsOnePage> {
  List<String> interests = [];

  bool enableDiscovery = true;
  bool sendReadReceipt = true;
  bool enableDarkMode = true;
  double distanceRadius = 10.0;
  double dialogDistanceRadius = 10.0;
  bool isDistanceRadiusExpanded = false;
  bool isChangePasswordExpanded = false;

  bool isCurrentPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isReenterPasswordVisible = false;

  bool beginnerSelected = false;
  bool intermediateSelected = false;
  bool advancedSelected = false;
  bool isLevelOfGymBuddyExpanded = false;

  bool isShowMeExpanded = false;
  bool menSelected = false;
  bool womenSelected = false;
  bool bothSelected = false;

  bool isInterestExpanded = false;

  Widget _buildInterestsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: interests.length,
      itemBuilder: (context, index) {
        return InterestItem(title: interests[index]);
      },
    );
  }

  Widget _buildAddInterestButton() {
    return ListTile(
      title: ElevatedButton(
        onPressed: () {
          _showAddInterestDialog(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green, // Change button color
          foregroundColor: Colors.white, // Change text color
        ),
        child: Text("Add Interest"),
      ),
    );
  }

  void _showAddInterestDialog(BuildContext context) {
    TextEditingController _interestController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Interest", style: TextStyle(color: Colors.black)),
          content: TextField(
            controller: _interestController,
            decoration: InputDecoration(labelText: 'Enter interest'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                String enteredInterest = _interestController.text.trim();
                if (enteredInterest.isNotEmpty) {
                  // Do something with the entered interest
                  interests.add(enteredInterest);
                  setState(() {}); // Assuming you are using StatefulWidget
                  Navigator.pop(context); // Close the dialog
                } else {
                  // Show Snackbar if the user didn't enter anything
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter an interest'),
                    ),
                  );
                }
              },
              child: Text(
                'Add',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget _buildDistanceSlider(BuildContext context) {
    return Column(
      children: [
        Text("Current Distance: ${dialogDistanceRadius.round()} kms"),
        Slider(
          value: dialogDistanceRadius,
          min: 1,
          max: 10,
          activeColor: Colors.black,
          divisions: 9,
          label: dialogDistanceRadius.round().toString(),
          onChanged: (value) {
            setState(() {
              dialogDistanceRadius = value;
            });
          },
        ),
        ElevatedButton(
          onPressed: () {
            // Add logic to save password changes
            // You can call a method to handle the password change here
            setState(() {
              isDistanceRadiusExpanded = false;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // Change button color
            foregroundColor: Colors.white, // Change text color
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Save"),
          ),
        ),
        SizedBox(
          height: 8,
        )
      ],
    );
  }

  Widget _buildChangePasswordForm() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: "Enter Your Current Password",
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            style: TextStyle(color: Colors.black),
            // Add controller and logic as needed
          ),
        ),
        SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            labelText: "Enter New Password",
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(),
          ),
          obscureText: true,
          style: TextStyle(color: Colors.black),
          // Add controller and logic as needed
        ),
        SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            labelText: "Re-enter New Password",
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(),
          ),
          obscureText: true,
          style: TextStyle(color: Colors.black),
          // Add controller and logic as needed
        ),
        SizedBox(height: 16),
        if (isChangePasswordExpanded)
          ElevatedButton(
            onPressed: () {
              // Add logic to save password changes
              // You can call a method to handle the password change here
              setState(() {
                isChangePasswordExpanded = false;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Change button color
              foregroundColor: Colors.white, // Change text color
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Save"),
            ),
          ),
        SizedBox(
          height: 8,
        )
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white54,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 10.0,
            ),
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: <Widget>[
                  ExpansionTile(
                    leading: Icon(
                      Icons.lock_outline,
                      color: Colors.black,
                    ),
                    title: Text("Change Password"),
                    trailing: isChangePasswordExpanded
                        ? Icon(Icons.keyboard_arrow_down, color: Colors.black)
                        : Icon(Icons.keyboard_arrow_right, color: Colors.black),
                    onExpansionChanged: (expanded) {
                      setState(() {
                        isChangePasswordExpanded = expanded;
                      });
                    },
                    children: <Widget>[
                      if (isChangePasswordExpanded)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildChangePasswordForm(),
                              // Add more widgets as needed
                            ],
                          ),
                        ),
                    ],
                  ),
                  Divider(),
                  ExpansionTile(
                    leading: Icon(
                      Icons.social_distance,
                      color: Colors.black,
                    ),
                    title: Text("Edit Distance radius"),
                    trailing: isDistanceRadiusExpanded
                        ? Icon(Icons.keyboard_arrow_down, color: Colors.black)
                        : Icon(Icons.keyboard_arrow_right, color: Colors.black),
                    onExpansionChanged: (expanded) {
                      setState(() {
                        isDistanceRadiusExpanded = expanded;
                      });
                    },
                    children: <Widget>[
                      if (isDistanceRadiusExpanded)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDistanceSlider(context),
                              // Add more widgets as needed
                            ],
                          ),
                        ),
                    ],
                  ),
                  Divider(),
                  ExpansionTile(
                    leading: Icon(
                      Icons.height,
                      color: Colors.black,
                    ),
                    title: Text("Show Me"),
                    trailing: isShowMeExpanded
                        ? Icon(Icons.keyboard_arrow_down, color: Colors.black)
                        : Icon(Icons.keyboard_arrow_right, color: Colors.black),
                    onExpansionChanged: (expanded) {
                      setState(() {
                        isShowMeExpanded = expanded;
                      });
                    },
                    children: <Widget>[
                      if (isShowMeExpanded)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CheckboxListTile(
                                title: Text("Men"),
                                value: menSelected,
                                activeColor: Colors.black,
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    setState(() {
                                      menSelected = value;
                                    });
                                  }
                                },
                              ),
                              CheckboxListTile(
                                title: Text("Women"),
                                value: womenSelected,
                                activeColor: Colors.black,
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    setState(() {
                                      womenSelected = value;
                                    });
                                  }
                                },
                              ),
                              CheckboxListTile(
                                title: Text("Both"),
                                value: bothSelected,
                                activeColor: Colors.black,
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    setState(() {
                                      bothSelected = value;
                                      menSelected = value;
                                      womenSelected = value;
                                    });
                                  }
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              if (isShowMeExpanded)
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Check if at least one checkbox is selected
                                      if (menSelected ||
                                          womenSelected ||
                                          bothSelected) {
                                        // Add logic to save changes
                                        setState(() {
                                          isShowMeExpanded = false;
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Please select at least one option.")));
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.green, // Change button color
                                      foregroundColor:
                                          Colors.white, // Change text color
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Save"),
                                    ),
                                  ),
                                ),
                              SizedBox(
                                height: 8,
                              )
                              // Add more widgets as needed
                            ],
                          ),
                        ),
                    ],
                  ),
                  Divider(),
                  ExpansionTile(
                    leading: Icon(
                      Icons.height,
                      color: Colors.black,
                    ),
                    title: Text("Level of gym buddy"),
                    trailing: isLevelOfGymBuddyExpanded
                        ? Icon(Icons.keyboard_arrow_down, color: Colors.black)
                        : Icon(Icons.keyboard_arrow_right, color: Colors.black),
                    onExpansionChanged: (expanded) {
                      setState(() {
                        isLevelOfGymBuddyExpanded = expanded;
                      });
                    },
                    children: <Widget>[
                      if (isLevelOfGymBuddyExpanded)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CheckboxListTile(
                                title: Text("Beginner"),
                                value: beginnerSelected,
                                activeColor: Colors.black,
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    setState(() {
                                      beginnerSelected = value;
                                    });
                                  }
                                },
                              ),
                              CheckboxListTile(
                                title: Text("Intermediate"),
                                value: intermediateSelected,
                                activeColor: Colors.black,
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    setState(() {
                                      intermediateSelected = value;
                                    });
                                  }
                                },
                              ),
                              CheckboxListTile(
                                title: Text("Advanced"),
                                value: advancedSelected,
                                activeColor: Colors.black,
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    setState(() {
                                      advancedSelected = value;
                                    });
                                  }
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              if (isLevelOfGymBuddyExpanded)
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Check if at least one checkbox is selected
                                      if (beginnerSelected ||
                                          intermediateSelected ||
                                          advancedSelected) {
                                        // Add logic to save changes
                                        setState(() {
                                          isLevelOfGymBuddyExpanded = false;
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Please select at least one option.")));
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.green, // Change button color
                                      foregroundColor:
                                          Colors.white, // Change text color
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Save"),
                                    ),
                                  ),
                                ),
                              SizedBox(
                                height: 8,
                              )
                              // Add more widgets as needed
                            ],
                          ),
                        ),
                    ],
                  ),
                  Divider(),
                  ExpansionTile(
                    leading: Icon(
                      Icons.interests,
                      color: Colors.black,
                    ),
                    title: Text("Interests"),
                    trailing: isInterestExpanded
                        ? Icon(Icons.keyboard_arrow_down, color: Colors.black)
                        : Icon(Icons.keyboard_arrow_right, color: Colors.black),
                    onExpansionChanged: (expanded) {
                      setState(() {
                        isInterestExpanded = expanded;
                      });
                    },
                    children: <Widget>[
                      _buildInterestsList(),
                      _buildAddInterestButton(),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "Enable Discovery",
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SwitchListTile(
                dense: true,
                activeColor: Colors.black,
                contentPadding: const EdgeInsets.all(0),
                value: enableDiscovery,
                title: Text(
                  'Enable Discovery',
                  style: TextStyle(fontSize: 13),
                ),
                onChanged: (val) {
                  setState(() {
                    enableDiscovery = val;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "Read Receipt",
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SwitchListTile(
                  dense: true,
                  activeColor: Colors.black,
                  contentPadding: const EdgeInsets.all(0),
                  value: sendReadReceipt,
                  title:
                      Text('Send Read Receipt', style: TextStyle(fontSize: 13)),
                  onChanged: (val) {
                    setState(() {
                      sendReadReceipt = val;
                    });
                  }),
            ),
            const SizedBox(
              height: 5.0,
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 8.0),
            //   child: Text(
            //     "Dark Mode",
            //     style: TextStyle(
            //       fontSize: 15.0,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.indigo,
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 8.0),
            //   child: SwitchListTile(
            //       dense: true,
            //       activeColor: Colors.black,
            //       contentPadding: const EdgeInsets.all(0),
            //       value: enableDarkMode,
            //       title:
            //           Text('Enable Dark Mode', style: TextStyle(fontSize: 13)),
            //       onChanged: (val) {
            //         setState(() {
            //           enableDarkMode = val;
            //           // Provider.of<ThemeProvider>(context, listen: false)
            //           //     .toggleTheme();
            //         });
            //       }),
            // ),
          ],
        ),
      ),
    );
  }
}

class InterestItem extends StatelessWidget {
  final String title;

  InterestItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      // Customize ListTile as needed
    );
  }
}
