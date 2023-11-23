import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_app/BottomNagivationBar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  var nameController = TextEditingController(text: "Tun Tun");
  var usernameController = TextEditingController(text: 'your_tuntun');
  var passwordController = TextEditingController();
  var CpasswordController = TextEditingController();
  File? profilePic;

  bool showCurrentPassword = false;
  bool showNewPassword = false;
  bool showConfirmPassword = false;

  final user = FirebaseAuth.instance.currentUser;

  String name = "Tun Tun";
  String username = " ";

  bool _showPassword = false;

  bool isNameChanged = false;
  bool isUsernameChanged = false;
  late FocusNode nameFocusNode;

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // void checkCurrentPassword(BuildContext context) async{
  //   String currentPassword = currentPasswordController.text.trim();
  //
  //   if(currentPassword !=  )
  // }

  void updateName() {
    setState(() {
      name = nameController.text.trim();
      isNameChanged = false; // Reset the flag after updating the name
      _showSnackbar('Name Updated');
    });
    nameFocusNode.unfocus();
    // You can implement additional logic here to update the name in your data storage
  }

  void updateUsername() {
    setState(() {
      username = usernameController.text.trim();
      isUsernameChanged = false; // Reset the flag after updating the name
      _showSnackbar('Username Updated');
    });
    nameFocusNode.unfocus();
    // You can implement additional logic here to update the name in your data storage
  }

  // void userData() async{
  //   if (name != '' && username != "" && profilePic != null) {
  //     Map<String, dynamic> userData = {
  //       "name": name,
  //       "username": username,
  //     };
  //     FirebaseFirestore.instance.collection("users").add(userData);
  //   } else {
  //     _showSnackbar("fill the details");
  //   }
  // }

  @override
  void updateProfilePic() async {
    XFile? selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      File convertedFile = File(selectedImage.path);
      setState(() {
        profilePic = convertedFile;
      });
      _showSnackbar('Profile Image Updated');
    } else {
      print("No image selected");
      return;
    }

    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child("ProfilePictures_folder")
        .child(Uuid().v1())
        .putFile(profilePic!);

    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    User? user = FirebaseAuth.instance.currentUser;
    await user?.updatePhotoURL(downloadUrl);

    // Perform any additional update logic here
    _showSnackbar('Profile Picture Uploaded and Updated');
  }
  // void saveProfilePic() async {
  //   XFile? selectedImage =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);
  //
  //   if (selectedImage != null) {
  //     File convertedFile = File(selectedImage.path);
  //     setState(() {
  //       profilePic = convertedFile;
  //     });
  //     _showSnackbar('Profile Image Updated');
  //   } else {
  //     print("no image selected");
  //   }
  //
  //   UploadTask uploadTask = FirebaseStorage.instance
  //       .ref()
  //       .child("ProfilePictures_folder")
  //       .child(Uuid().v1())
  //       .putFile(profilePic!);
  //
  //   TaskSnapshot taskSnapshot = await uploadTask;
  //   String downloadUrl = await taskSnapshot.ref.getDownloadURL();
  // }

  void initState() {
    super.initState();
    nameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    nameFocusNode.dispose(); // Dispose the FocusNode when it's no longer needed
    super.dispose();
  }

  void saveChanges() async {
    // Implement the logic to save changes here
    // You can use the updated 'name' and 'email' variables to update your user data

    // Navigate back to the LoggedInPage
    String newPassword = passwordController.text.trim();
    String ConfirmPassword = CpasswordController.text.trim();
    if (newPassword == "" || ConfirmPassword == "") {
      _showSnackbar('Please enter New Password details');
    } else if (newPassword != ConfirmPassword) {
      _showSnackbar('Password does not match');
    } else {
      try {
        if (user != null) {
          await user?.updatePassword(newPassword);
          _showSnackbar('Changes Done');
        }
      } on FirebaseAuthException catch (ex) {
        _showSnackbar(ex.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => Nav())),
        ),
        elevation: 0,
        backgroundColor: Colors.white54,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Edit Your Profile",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage:
                    (profilePic != null) ? FileImage(profilePic!) : null,
                backgroundColor: Colors.black,
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: updateProfilePic,
                child: Text(
                  "Edit Profile Picture",
                  style: TextStyle(fontSize: 14, color: Colors.blue),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        cursorColor: Colors.black,
                        controller: nameController,
                        onChanged: (value) {
                          setState(() {
                            isNameChanged = true;
                          });
                        },
                        focusNode: nameFocusNode,
                        decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusColor: Colors.black,
                          suffixIcon: isNameChanged
                              ? IconButton(
                                  icon: Icon(Icons.check),
                                  onPressed: updateName,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  cursorColor: Colors.black,
                  controller: usernameController,
                  onChanged: (value) {
                    setState(() {
                      isUsernameChanged = true;
                    });
                  },
                  focusNode: nameFocusNode,
                  decoration: InputDecoration(
                    labelText: "Username",
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusColor: Colors.black,
                    suffixIcon: isUsernameChanged
                        ? IconButton(
                            icon: Icon(Icons.check),
                            onPressed: updateUsername,
                          )
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  cursorColor: Colors.black,
                  controller: passwordController,
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.black),
                      labelText: 'New Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      filled: true,
                      focusColor: Colors.black,
                      contentPadding: EdgeInsets.all(12.0),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      )),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  cursorColor: Colors.black,
                  controller: CpasswordController,
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.black),
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      filled: true,
                      focusColor: Colors.black,
                      contentPadding: EdgeInsets.all(12.0),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      )),
                ),
              ),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: saveChanges,
                child: Text(
                  "Save new password",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Change button color
                  foregroundColor: Colors.white, // Change text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
