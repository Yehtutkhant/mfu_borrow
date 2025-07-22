import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mfuborrow/screens/shared_screeens/dashboard.dart';
import 'package:mfuborrow/screens/shared_screeens/edit_profile.dart';
import 'package:mfuborrow/screens/shared_screeens/login.dart';
import 'package:mfuborrow/utils/constants.dart';
import 'package:mfuborrow/utils/get_token.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map? user;
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  Future<void> getProfile() async {
    setState(() {
      isLoading = true;
    });
    try {
      Uri uri = Uri.parse('$url/api/profile');
      String token = await getToken(context);
      http.Response response =
          await http.get(uri, headers: {'authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        setState(() {
          user = jsonDecode(response.body)['user'];
        });
      } else {
        Map? message = jsonDecode(response.body)['message'];
        setState(() {
          error = "$message";
        });
      }
    } on TimeoutException catch (e) {
      debugPrint(e.message);
      setState(() {
        error = "Connection Time Out";
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        error = "Unknown Error";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileImage = user?['profile_image'];
    final studentId = user?['student_id'];
    final username = user?['username'];
    final email = user?['email'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: false,
      ),
      body: isLoading
          ? const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: 200,
                      height: 200,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: user?["profile_image"] != null
                          ? ClipOval(
                              child: Image.network(
                                '$profileImage',
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipOval(
                              child: Container(
                              width: 200,
                              height: 200,
                              color: Colors.grey[300], // light gray background
                              child: const Center(
                                child: Icon(
                                  Icons.person,
                                  size: 80,
                                  color: Colors
                                      .white, // or Colors.grey[700] for contrast
                                ),
                              ),
                            )),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Student ID : $studentId',
                      style: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 212, 212, 212),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$username',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    user?['role'] == "staff" || user?['role'] == "lecturer"
                        ? ListTile(
                            minTileHeight: 35,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const DashboardScreen()));
                            },
                            leading:
                                const Icon(Icons.dashboard_customize_outlined),
                            title: Text(
                              "Dashboard",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            trailing: const Icon(
                              Icons.arrow_right_alt,
                              size: 30,
                            ),
                          )
                        : const SizedBox(),
                    user?['role'] == "staff" || user?['role'] == "lecturer"
                        ? const Divider()
                        : const SizedBox(),
                    user?['role'] == "staff" || user?['role'] == "lecturer"
                        ? const SizedBox(
                            height: 10,
                          )
                        : const SizedBox(),
                    ListTile(
                      minTileHeight: 35,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditProfileScreen(
                                image: profileImage,
                                username: username,
                                email: email,
                                studentId: studentId.toString())));
                      },
                      leading: const Icon(Icons.edit_sharp),
                      title: Text(
                        "Edit Profile",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      trailing: const Icon(
                        Icons.arrow_right_alt,
                        size: 30,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      minTileHeight: 35,
                      onTap: () async {
                        const storage = FlutterSecureStorage();
                        await storage.deleteAll();

                        Navigator.pushAndRemoveUntil(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                      leading: const Icon(Icons.logout_outlined),
                      title: Text(
                        "Logout",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      trailing: const Icon(
                        Icons.arrow_right_alt,
                        size: 30,
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
