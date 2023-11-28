import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/upload_profilePic.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _genderValue = "Select";
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _showPassword = false;
  bool _isUsernameAvailable = false;

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void dropdownCallback(String? selectedValue) {}

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.black, // Set the color of the OK button
            hintColor: Colors.black, // Set the color of the selected date
            colorScheme: ColorScheme.light(
                primary:
                    Colors.black), // Set the color of the selected date text
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dobController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  String? _validateDOB(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date of Birth is required';
    }
    // Add additional validation logic if needed
    return null;
  }

  void _checkUsernameAvailability(String username) async {
    // Check if the username exists in the Firestore database
    username = username.trim();
    if (username == "") {
      setState(() {
        _isUsernameAvailable = false;
      });
      return;
    }
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    bool isAvailable = querySnapshot.docs.isEmpty;
    setState(() {
      _isUsernameAvailable = isAvailable;
    });
  }

  void createAccount() async {
    // Implement your sign-up logic here
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String username = _userController.text.trim();
    String name = _nameController.text.trim();
    String age = _dobController.text.trim();
    String? gender = _genderValue;

    if (email == "" || password == "" || confirmPassword == "") {
      _showSnackbar('Please enter login details');
    } else if (password != confirmPassword) {
      _showSnackbar('Password does not match');
    } else {
      bool isUsernameUnique = await isUsernameAvailable(username);
      if (!isUsernameUnique) {
        _showSnackbar(
            'Username is not available. Please choose a different one.');
        return;
      }
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // Set the display name for the user
        await userCredential.user!.updateDisplayName(username);

        // Reload the user to get the updated information
        await userCredential.user!.reload();

        // Access the updated display name
        String displayName =
            userCredential.user!.displayName ?? 'Default Display Name';
        print('User Display Name: $displayName');
        String? uid = userCredential.user?.uid;

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': name,
          'age': age,
          'bio': "",
          'gender': gender,
          'email': email,
          'uid': uid,
          'username': username,
          'downloadUrl': '',
          // Add any other user information you want to store
        }, SetOptions(merge: true));
        _showSnackbar("User Created");

        if (userCredential.user != null) {
          try {
            UserCredential userCredential = await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: email, password: password);

            if (userCredential.user == null) {
              _showSnackbar("Error while signUp");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage()),
              );
            }
          } on FirebaseAuthException catch (ex) {
            _showSnackbar(ex.code.toString());
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UploadProfilePic()),
          );
        }
      } on FirebaseAuthException catch (ex) {
        _showSnackbar(ex.code.toString());
      }
    }

    // Add your sign-up validation and submission logic here
    // For example, you can check if the passwords match, if the email is valid, etc.
  }

  Future<bool> isUsernameAvailable(String username) async {
    // Check if the username exists in the Firestore database
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    return querySnapshot
        .docs.isEmpty; // If the list is empty, the username is available
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    focusColor: Colors.black,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.all(12.0)),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _userController,
                cursorColor: Colors.black,
                onChanged: (username) {
                  if (username.isNotEmpty) {
                    _checkUsernameAvailability(username);
                  } else {
                    setState(() {
                      _isUsernameAvailable = true;
                    });
                  }
                },
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  focusColor: Colors.black,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.all(12.0),
                  suffixIcon: _isUsernameAvailable
                      ? null
                      : Icon(
                          Icons.warning,
                          color: Colors.red,
                        ),
                  suffixText:
                      _isUsernameAvailable ? 'Available' : 'Not Available',
                  suffixStyle: TextStyle(
                      color: _isUsernameAvailable ? Colors.green : Colors.red),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _dobController,
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: _validateDOB,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'Date of Birth',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  focusColor: Colors.black,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.all(12.0),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField(
                value: _genderValue,
                items: const [
                  DropdownMenuItem(
                      child: Text("Select"), value: "Select", enabled: false),
                  DropdownMenuItem(child: Text("Male"), value: "Male"),
                  DropdownMenuItem(child: Text("Female"), value: "Female"),
                ],
                isExpanded: true,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: 'Sex',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    focusColor: Colors.black,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.all(12.0)),
                onChanged: (Object? value) {
                  setState(() {
                    _genderValue = value as String;
                  });
                },
              ),
              SizedBox(height: 16),
              TextField(
                controller: _emailController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    focusColor: Colors.black,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.all(12.0)),
              ),
              SizedBox(height: 16),
              TextField(
                cursorColor: Colors.black,
                controller: _passwordController,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.all(12.0),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                      icon: Icon(
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    )),
              ),
              SizedBox(height: 16),
              TextField(
                cursorColor: Colors.black,
                controller: _confirmPasswordController,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.all(12.0),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                      icon: Icon(
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    )),
              ),
              SizedBox(height: 24),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 160, vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    createAccount();
                  },
                  style: ElevatedButton.styleFrom(
                    // Set the minimum width and height
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    textStyle: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: Text('Sign Up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
