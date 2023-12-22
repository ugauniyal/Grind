import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_app/AuthCheck.dart';
import 'package:workout_app/BottomNagivationBar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  bool isGoogleSignIn = false;

  late TextEditingController nameController;
  var usernameController = TextEditingController(text: "");
  late TextEditingController bioController;
  var passwordController = TextEditingController();
  var CpasswordController = TextEditingController();
  File? profilePic;
  File? viewPhoto;

  File? imageFile;
  bool isImageUploaded = false;

  bool showCurrentPassword = false;
  bool showNewPassword = false;
  bool showConfirmPassword = false;

  bool isNameChanged = false;
  bool isUsernameChanged = false;
  bool isBioChanged = false;
  late FocusNode nameFocusNode;
  late FocusNode usernameFocusNode;
  late FocusNode bioFocusNode;

  bool isBioLoaded = false;
  bool isUsernameUnique = true;
  String viewPhotoUrl = '';

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> updateName() async {
    String name = nameController.text.trim();

    if (name != "") {
      setState(() {
        isNameChanged = false; // Reset the flag after updating the name
        _showSnackbar('Name Updated');
      });
      nameFocusNode.unfocus();

      String? uid = user?.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': name,
      });
    }
  }

  Future<void> updateBio() async {
    String bio = bioController.text.trim();

    if (bio != "") {
      setState(() {
        isBioChanged = false; // Reset the flag after updating the name
        _showSnackbar('Bio Updated');
      });
      bioFocusNode.unfocus();

      String? uid = user?.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'bio': bio,
      });
    }
  }

  Future<void> updateUsername() async {
    String newUsername = usernameController.text.trim();

    if (newUsername.isNotEmpty) {
      // Check if the new username is unique
      bool isUnique = await checkUsernameUniqueness(newUsername);

      if (isUnique) {
        setState(() {
          isUsernameChanged = false;
          isUsernameUnique = true;
          _showSnackbar('Username Updated');
        });

        // Update the display name in Firebase Authentication
        user?.updateDisplayName(newUsername);

        // Update the username in Firestore
        String? uid = user?.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'username': newUsername,
        });
      } else {
        setState(() {
          isUsernameUnique = false;
        });
      }
    } else {
      // Handle the case where the new username is empty
      _showSnackbar('Username cannot be empty');
    }

    usernameFocusNode.unfocus();
  }

  Future<bool> checkUsernameUniqueness(String newUsername) async {
    try {
      // Query Firestore to check if the username already exists
      newUsername = newUsername.trim();
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('username', isEqualTo: newUsername)
              .get();

      // If the query returns no documents, the username is unique
      return querySnapshot.docs.isEmpty;
    } catch (error) {
      // Handle the error (e.g., log it or show a generic error message)
      print('Error checking username uniqueness: $error');
      return false;
    }
  }

  void _cropImageProfile(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Image Cropper",
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: "Image Cropper",
        )
      ],
    );

    if (croppedFile != null) {
      imageCache.clear();
      updateProfilePic(croppedFile);
    }
  }

  void showImagePickerProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Card(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5.2,
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    child: const Column(
                      children: [
                        Icon(
                          Icons.image,
                          size: 60.0,
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          "Gallery",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        )
                      ],
                    ),
                    onTap: () async {
                      await _imgFromGalleryForProfile();
                      // Close the bottom sheet after a slight delay
                      Future.delayed(const Duration(milliseconds: 200), () {
                        Navigator.pop(context);
                      });
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 60.0,
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            "Camera",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    onTap: () async {
                      await _imgFromCameraForProfile();
                      // Close the bottom sheet after a slight delay
                      Future.delayed(const Duration(milliseconds: 200), () {
                        Navigator.pop(context);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _imgFromGalleryForProfile() async {
    Navigator.pop(context); // Close the bottom sheet
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      _cropImageProfile(File(pickedFile.path));
    }
  }

  Future<void> _imgFromCameraForProfile() async {
    Navigator.pop(context); // Close the bottom sheet
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      _cropImageProfile(File(pickedFile.path));
    }
  }

  Future<void> updateProfilePic(final croppedFile) async {
    String? uid = user?.uid;

    if (croppedFile != null) {
      File convertedFile = File(croppedFile.path);
      setState(() {
        profilePic = convertedFile;
      });

      ProgressDialog progressDialog = ProgressDialog(context);
      progressDialog.style(
        message: 'Uploading Profile Picture',
      );

      try {
        progressDialog.show();
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child("ProfilePictures_folder")
            .child(const Uuid().v1())
            .putFile(profilePic!);

        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Update the user's photoURL in Firebase Authentication
        await user?.updatePhotoURL(downloadUrl);
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'downloadUrl': downloadUrl,
        });

        // Ensure the user information is refreshed
        await user?.reload();

        // Access the refreshed user information
        User? updatedUser = FirebaseAuth.instance.currentUser;

        // Update the user variable to trigger a rebuild
        setState(() {
          user = updatedUser;
        });

        // Perform any additional update logic here

        _showSnackbar('Profile Picture Uploaded');
      } catch (error) {
        _showSnackbar('Error updating profile picture');
      } finally {
        progressDialog
            .hide(); // Hide loading screen whether upload succeeded or failed

        // Remove the line below if not intended to show the image picker again
        // showImagePickerProfile(context);
      }
    } else {
      print("No image selected");
    }
  }

  final picker = ImagePicker();

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Card(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5.2,
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    child: const Column(
                      children: [
                        Icon(
                          Icons.image,
                          size: 60.0,
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          "Gallery",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        )
                      ],
                    ),
                    onTap: () async {
                      await _imgFromGallery();
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 60.0,
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            "Camera",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    onTap: () async {
                      await _imgFromCamera();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _imgFromGallery() async {
    Navigator.pop(context);
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      _cropImage(File(pickedFile.path));
    }
  }

  Future<void> _imgFromCamera() async {
    Navigator.pop(context);
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      _cropImage(File(pickedFile.path));
    }
  }

  void _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Image Cropper",
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: "Image Cropper",
        )
      ],
    );

    if (croppedFile != null) {
      imageCache.clear();
      saveViewPhoto(croppedFile);
    }
  }

  void saveViewPhoto(final croppedFile) async {
    ProgressDialog progressDialog = ProgressDialog(context);
    progressDialog.style(
      message: 'Uploading Grind picture',
    );

    User? user = FirebaseAuth.instance.currentUser;
    String uid = user?.uid ?? '';

    if (croppedFile != null) {
      File convertedFile = File(croppedFile.path);
      progressDialog.show();

      try {
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child("ViewerPictures_folder")
            .child(const Uuid().v1())
            .putFile(convertedFile);

        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl1 = await taskSnapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'downloadUrl1': downloadUrl1,
        });

        await user?.reload();

        _showSnackbar('View Image Updated');

        // Wait for the setState to complete before navigating
        setState(() {});

        print("View Photo URL: $viewPhotoUrl");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EditProfilePage()),
        );
      } catch (error) {
        print("Error uploading image: $error");
        _showSnackbar('Error uploading image');
        // } finally {
        //   // Delay hiding the loading indicator to ensure it's visible for a short period
        //   Future.delayed(Duration(milliseconds: 500), () {
        //     progressDialog.hide();
        //   });
      }
    } else {
      _showSnackbar('No image selected');
    }
  }

  Future<void> getDownloadUrl() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user?.uid)
          .get();
      String updatedDownloadUrl = snapshot.data()?['downloadUrl1'] ?? "";

      setState(() {
        viewPhotoUrl = updatedDownloadUrl;
      });
    } catch (error) {
      print("Error fetching download URL: $error");
      // Handle the error, e.g., show a default image or a placeholder
      setState(() {
        viewPhotoUrl =
            'https://moorepediatricnc.com/wp-content/uploads/2022/08/default_avatar.jpg';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDownloadUrl();

    nameController = TextEditingController();
    bioController = TextEditingController();
    fetchNameFromFirestore();
    fetchUsernameFromFirestore();
    fetchBioFromFirestore();
    usernameController = TextEditingController();
    nameFocusNode = FocusNode();
    usernameFocusNode = FocusNode();
    bioFocusNode = FocusNode();
    checkGoogleSignIn();
  }

  void checkGoogleSignIn() {
    // Check if the user signed in with Google
    isGoogleSignIn = user?.providerData
            .any((userInfo) => userInfo.providerId == 'google.com') ??
        false;
  }

  bool CheckPhoneNumberSignIn() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // You may have additional checks based on your user model or authentication details
      return user.providerData
          .any((provider) => provider.providerId == 'phone');
    }
    return false;
  }

  Future<void> fetchNameFromFirestore() async {
    String? uid = user?.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    String name = snapshot.data()?['name'] ?? "";

    setState(() {
      nameController.text = name;
    });
  }

  Future<void> fetchUsernameFromFirestore() async {
    String? uid = user?.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    String username = snapshot.data()?['username'] ?? "";

    setState(() {
      usernameController.text = username;
    });
  }

  Future<void> fetchBioFromFirestore() async {
    String? uid = user?.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    String bio = snapshot.data()?['bio'] ?? "";
    setState(() {
      bioController = TextEditingController(text: bio);
    });
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    usernameFocusNode.dispose();
    bioFocusNode.dispose();
    super.dispose();
  }

  void saveChanges() async {
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
    bool isPhoneNumberSignIn = CheckPhoneNumberSignIn();
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Nav())),
        ),
        elevation: 0,
        backgroundColor: Colors.white54,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Edit Your Profile",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          child: ClipOval(
                            child: Image.network(
                              user?.photoURL ??
                                  'https://moorepediatricnc.com/wp-content/uploads/2022/08/default_avatar.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: const Icon(Icons.photo),
                                      title: const Text('Change current Photo'),
                                      onTap: () {
                                        Navigator.pop(
                                            context); // Close the bottom sheet
                                        showImagePickerProfile(
                                            context); // Call your function to change photo
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.delete),
                                      title: const Text('Delete Current Photo'),
                                      onTap: () {
                                        Navigator.pop(
                                            context); // Close the bottom sheet
                                        // deleteProfilePic(); // Call your function to delete photo
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text(
                            "Edit Profile Picture",
                            style: TextStyle(fontSize: 14, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          child: ClipOval(
                            child: Image.network(
                              viewPhotoUrl.isNotEmpty
                                  ? viewPhotoUrl
                                  : 'https://moorepediatricnc.com/wp-content/uploads/2022/08/default_avatar.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: const Icon(Icons.photo),
                                      title: const Text('Change Photo'),
                                      onTap: () {
                                        Navigator.pop(
                                            context); // Close the bottom sheet
                                        showImagePicker(
                                            context); // Call your function to change photo
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.delete),
                                      title: const Text('Delete Current Photo'),
                                      onTap: () {
                                        Navigator.pop(
                                            context); // Close the bottom sheet
                                        // deleteViewPhoto(); // Call your function to delete photo
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text(
                            "Edit Grind Picture",
                            style: TextStyle(fontSize: 14, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
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
                        labelStyle: const TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        focusColor: Colors.black,
                        suffixIcon: isNameChanged
                            ? IconButton(
                                icon: const Icon(Icons.check),
                                onPressed: updateName,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    controller: usernameController,
                    onChanged: (value) async {
                      bool isUnique = await checkUsernameUniqueness(value);
                      setState(() {
                        isUsernameChanged = true;
                        isUsernameUnique = isUnique;
                      });
                    },
                    focusNode: usernameFocusNode,
                    decoration: InputDecoration(
                      labelText: "Username",
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusColor: Colors.black,
                      suffixIcon: isUsernameChanged
                          ? IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: () => updateUsername(),
                            )
                          : null,
                      suffixText: isUsernameChanged
                          ? isUsernameUnique
                              ? 'Available'
                              : 'Not Available'
                          : '',
                      suffixStyle: TextStyle(
                          color: isUsernameChanged
                              ? isUsernameUnique
                                  ? Colors.green
                                  : Colors.red
                              : Colors.transparent),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    controller: bioController,
                    onChanged: (value) {
                      setState(() {
                        isBioChanged = true;
                      });
                    },
                    focusNode: bioFocusNode,
                    maxLength: 150,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: InputDecoration(
                      labelText: "Bio",
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusColor: Colors.black,
                      suffixIcon: isBioChanged
                          ? IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: updateBio,
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: isGoogleSignIn // Conditionally show or hide "Change Password?" based on Google Sign-In
                      ? Container() // If signed in with Google, hide the button
                      : isPhoneNumberSignIn // Conditionally show or hide "Change Password?" based on Phone Number Sign-In
                          ? Container() // If signed in with Phone Number, hide the button
                          : TextButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AuthCheck()),
                                );
                                // Additional code to execute after navigating (if needed)
                              },
                              child: const Text(
                                'Change Password?',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
