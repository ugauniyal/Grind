import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_app/EditProfilePage.dart';

class SettingsOnePage extends StatefulWidget {
  const SettingsOnePage({super.key});

  @override
  State<SettingsOnePage> createState() => _SettingsOnePageState();
}

class _SettingsOnePageState extends State<SettingsOnePage> {
  final User _user = FirebaseAuth.instance.currentUser!;
  List<String> selectedInterests = [];

  String _userPreference = "";

  List<String> availableInterests = [
    'Running/Jogging',
    'Weightlifting',
    'Yoga',
    'Cycling',
    'Swimming',
    'CrossFit',
    'Zumba',
    'Home Workout',
    'Powerlifting',
    'HIIT',
    'Dance',
    'Hiking',
    'Meditation',
    'Gymnastics',
    'Athletes'
  ];

  final TextEditingController _interestController = TextEditingController();

  bool enableDiscovery = true;
  bool sendReadReceipt = true;
  bool enableDarkMode = true;
  double distanceRadius = 10.0;
  double dialogDistanceRadius = 10.0;
  bool isDistanceRadiusExpanded = false;
  bool isChangePasswordExpanded = false;

  bool isSaveButtonPressed = false;

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

  void updatePreferences() async {
    String preferenceValue = '';

    if (menSelected) {
      preferenceValue = 'Male';
    } else if (womenSelected) {
      preferenceValue = 'Female';
    } else if (bothSelected) {
      preferenceValue = 'Both';
    }

    // Update the preference field in the user document
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .update({'preference': preferenceValue});
  }

  @override
  void initState() {
    super.initState();
    _loadUserPreference();
  }

  Widget _buildInterestsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select up to 5 Interests:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: availableInterests.map((interest) {
            bool isSelected = selectedInterests.contains(interest);
            return FilterChip(
              label: Text(interest),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    if (selectedInterests.length < 5) {
                      selectedInterests.add(interest);
                    } else {
                      // Notify the user that they can't select more than 5 interests
                      _showMaxInterestsPopup(context, selectedInterests);
                    }
                  } else {
                    selectedInterests.remove(interest);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Future<void> _loadUserPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _userPreference = prefs.getString('user_preference') ?? "";
      menSelected = _userPreference == "Men";
      womenSelected = _userPreference == "Women";
      bothSelected = _userPreference == "Both";
    });

    // Fetch user's preference from Firestore and update the local state
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user.uid)
          .get();

      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

      if (userData != null) {
        String firestorePreference = userData['preference'] ?? '';
        setState(() {
          menSelected = firestorePreference == "Male";
          womenSelected = firestorePreference == "Female";
          bothSelected = firestorePreference == "Both";
        });
      }
    } catch (error) {
      print('Error fetching user preference: $error');
    }
  }

  Widget _buildAddInterestButton(BuildContext context) {
    return ListTile(
      title: ElevatedButton(
        onPressed: () {
          _addUserInterest();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        child: const Text("Add Interest"),
      ),
    );
  }

  void _addUserInterest() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch current interests
        List<String> currentInterests = List.from(selectedInterests);

        // Update user interests in Firebase
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'interests': currentInterests});

        // Update the local state
        setState(() {
          selectedInterests = currentInterests;
        });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Interest added successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      // Handle the error
      print('Error adding interest: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add interest. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showMaxInterestsPopup(
      BuildContext context, List<String> selectedInterests) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Max Interests Reached",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Customize the color
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "You can only select up to 5 interests.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Selected Interests:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: selectedInterests
                    .map(
                      (interest) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              interest,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the popup
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.blue, // Customize the color
                  fontSize: 16,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white, // Customize the background color
          elevation: 8,
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
          onPressed: () async {
            setState(() {
              isDistanceRadiusExpanded = false;
            });
            try {
              User? user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                // Update user interests in Firebase
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .set({'buddyRadius': dialogDistanceRadius},
                        SetOptions(merge: true));

                // Show a success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Radius changed successfully!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            } catch (error) {
              // Handle the error
              print('Error adding radius: $error');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to change radius. Please try again.'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Save"),
          ),
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white54,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        user?.photoURL ??
                            'https://moorepediatricnc.com/wp-content/uploads/2022/08/default_avatar.jpg',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 10.0,
                ),
                Center(
                  child: Container(
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EditProfilePage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        "Update Profile",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
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
                        leading: const Icon(
                          Icons.social_distance,
                          color: Colors.black,
                        ),
                        title: const Text("Edit Distance radius"),
                        trailing: isDistanceRadiusExpanded
                            ? const Icon(Icons.keyboard_arrow_down,
                                color: Colors.black)
                            : const Icon(Icons.keyboard_arrow_right,
                                color: Colors.black),
                        onExpansionChanged: (expanded) {
                          setState(() {
                            isDistanceRadiusExpanded = expanded;
                          });
                        },
                        children: <Widget>[
                          if (isDistanceRadiusExpanded)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDistanceSlider(context),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const Divider(),
                      ExpansionTile(
                        leading: const Icon(
                          Icons.height,
                          color: Colors.black,
                        ),
                        title: const Text("Show Me"),
                        trailing: isShowMeExpanded
                            ? const Icon(Icons.keyboard_arrow_down,
                                color: Colors.black)
                            : const Icon(Icons.keyboard_arrow_right,
                                color: Colors.black),
                        onExpansionChanged: (expanded) {
                          setState(() {
                            isShowMeExpanded = expanded;
                          });
                        },
                        children: <Widget>[
                          if (isShowMeExpanded)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CheckboxListTile(
                                    title: const Text("Men"),
                                    value: menSelected ??
                                        (_userPreference == "Men"),
                                    activeColor: Colors.black,
                                    onChanged: (bool? value) {
                                      if (value != null && value) {
                                        setState(() {
                                          menSelected = true;
                                          womenSelected = false;
                                          bothSelected = false;
                                        });
                                      }
                                    },
                                  ),
                                  CheckboxListTile(
                                    title: const Text("Women"),
                                    value: womenSelected ??
                                        (_userPreference == "Women"),
                                    activeColor: Colors.black,
                                    onChanged: (bool? value) {
                                      if (value != null && value) {
                                        setState(() {
                                          menSelected = false;
                                          womenSelected = true;
                                          bothSelected = false;
                                        });
                                      }
                                    },
                                  ),
                                  CheckboxListTile(
                                    title: const Text("Both"),
                                    value: bothSelected ??
                                        (_userPreference == "Both"),
                                    activeColor: Colors.black,
                                    onChanged: (bool? value) {
                                      if (value != null) {
                                        setState(() {
                                          bothSelected = value;
                                          menSelected = false;
                                          womenSelected = false;
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  if (isShowMeExpanded)
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (menSelected ||
                                              womenSelected ||
                                              bothSelected) {
                                            updatePreferences();
                                            setState(() {
                                              isShowMeExpanded = false;
                                            });
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "Please select at least one option."),
                                              ),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Save"),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const Divider(),
                      ExpansionTile(
                        leading: const Icon(
                          Icons.height,
                          color: Colors.black,
                        ),
                        title: const Text("Level of gym buddy"),
                        trailing: isLevelOfGymBuddyExpanded
                            ? const Icon(Icons.keyboard_arrow_down,
                                color: Colors.black)
                            : const Icon(Icons.keyboard_arrow_right,
                                color: Colors.black),
                        onExpansionChanged: (expanded) {
                          setState(() {
                            isLevelOfGymBuddyExpanded = expanded;
                          });
                        },
                        children: <Widget>[
                          if (isLevelOfGymBuddyExpanded)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CheckboxListTile(
                                    title: const Text("Beginner"),
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
                                    title: const Text("Intermediate"),
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
                                    title: const Text("Advanced"),
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
                                  const SizedBox(
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
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Please select at least one option.")));
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Save"),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 8,
                                  )
                                ],
                              ),
                            ),
                        ],
                      ),
                      const Divider(),
                      ExpansionTile(
                        leading: const Icon(
                          Icons.interests,
                          color: Colors.black,
                        ),
                        title: const Text("Interests"),
                        trailing: isInterestExpanded
                            ? const Icon(Icons.keyboard_arrow_down,
                                color: Colors.black)
                            : const Icon(Icons.keyboard_arrow_right,
                                color: Colors.black),
                        onExpansionChanged: (expanded) {
                          setState(() {
                            isInterestExpanded = expanded;
                          });
                        },
                        children: <Widget>[
                          _buildInterestsList(),
                          _buildAddInterestButton(context),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
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
                    title: const Text(
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
                const SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InterestItem extends StatelessWidget {
  final String title;

  const InterestItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
    );
  }
}
