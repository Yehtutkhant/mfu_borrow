import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mfuborrow/components/container.dart';
import 'package:mfuborrow/components/loading_container.dart';
import 'package:mfuborrow/screens/shared_screeens/lecturer_student_detail.dart';
import 'package:mfuborrow/screens/shared_screeens/home_search.dart';
import 'package:mfuborrow/screens/staff/detail.dart';
import 'package:mfuborrow/utils/constants.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  final String role;

  const Home({super.key, required this.role});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  String? _userRole;
  List assets = [];
  String? error;
  int page = 1;
  bool hasMore = true;
  final int pageSize = 5;

  @override
  void initState() {
    super.initState();
    _userRole = widget.role;
    getAssets();
  }

  void loadMore() {
    getAssets(loadMore: true);
  }

  Future<void> getAssets({bool loadMore = false}) async {
    setState(() {
      isLoading = true;
      error = null;
    });
    final fetchPage = loadMore ? page + 1 : page;
    Uri uri = Uri.parse('$url/api/assets?page=$fetchPage&limit=$pageSize');
    try {
      http.Response response =
          await http.get(uri).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        List newAssets = jsonDecode(response.body)['data'];
        setState(() {
          if (loadMore) {
            assets.addAll(newAssets);
            page = fetchPage;
          } else {
            assets = newAssets;
          }
          hasMore = newAssets.length == pageSize;
        });
      } else {
        setState(() {
          final message = jsonDecode(response.body)['message'];
          error = '$message';
        });
      }
    } on TimeoutException catch (e) {
      debugPrint(e.message);
      setState(() {
        error = "Connection Time out";
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        error = "Something went wrong";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double fixedHeight = 250;
    final bool showLoadMoreButton = hasMore && !isLoading;
    final bool showLoadingIndicator = isLoading && assets.isNotEmpty;
    final int extraItems =
        (showLoadMoreButton ? 1 : 0) + (showLoadingIndicator ? 1 : 0);
    final int totalItemCount = assets.length + extraItems;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(
          "Home",
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: fixedHeight),
            child: error != null
                ? Center(
                    child: Card(
                      color: Colors.red.shade50,
                      margin: const EdgeInsets.all(24),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 24.0, horizontal: 16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.error_outline,
                                color: Colors.red.shade400, size: 32),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                '$error',
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : isLoading
                    ? ListView.builder(
                        padding: const EdgeInsets.all(10.0),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return const LoadingContainer();
                        },
                      )
                    : assets.isEmpty
                        ? Center(
                            child: Card(
                              color: Colors.grey.shade50,
                              margin: const EdgeInsets.all(24),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 24.0, horizontal: 16.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.error_outline,
                                        color: Colors.grey.shade400, size: 32),
                                    const SizedBox(width: 12),
                                    Flexible(
                                      child: Text(
                                        'No assets to show',
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(10.0),
                            itemCount: totalItemCount,
                            itemBuilder: (context, index) {
                              if (index < assets.length) {
                                final asset = assets[index];
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => _userRole ==
                                                      'student' ||
                                                  _userRole == "lecturer"
                                              ? LecturerStudentDetailScreen(
                                                  userRole: widget.role,
                                                  id: asset['id'].toString(),
                                                  assetImage:
                                                      asset['asset_image'],
                                                  assetName:
                                                      asset['asset_name'] ?? "",
                                                  assetId:
                                                      (asset['asset_id'] ?? '')
                                                          .toString(),
                                                  assetCategory:
                                                      asset['category'] ?? "",
                                                  assetLocation:
                                                      asset['location'] ?? "",
                                                  assetStatus:
                                                      asset['status'] ?? "",
                                                  assetDescription:
                                                      asset['description'] ??
                                                          "",
                                                )
                                              : StaffDetailScreen(
                                                  assetImage:
                                                      asset['asset_image'],
                                                  assetName:
                                                      asset['asset_name'] ?? "",
                                                  assetId:
                                                      (asset['asset_id'] ?? '')
                                                          .toString(),
                                                  assetCategory:
                                                      asset['category'] ?? "",
                                                  assetLocation:
                                                      asset['location'] ?? "",
                                                  assetStatus:
                                                      asset['status'] ?? "",
                                                  assetDescription:
                                                      asset['description'] ??
                                                          "",
                                                ),
                                        ),
                                      );
                                    },
                                    child: AssetContainer(
                                      screen: "home",
                                      imageName:
                                          asset['asset_image'] ?? "Unknown",
                                      assetName:
                                          asset['asset_name'] ?? "Unknown",
                                      assetId:
                                          (asset['asset_id'] ?? '').toString(),
                                      assetCategory:
                                          asset['category'] ?? "Unknown",
                                      assetStatus: asset['status'] ?? "Unknown",
                                    ));
                              }
                              final loadMoreButtonIndex = assets.length;
                              if (hasMore &&
                                  !isLoading &&
                                  index == loadMoreButtonIndex) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Center(
                                    child: FilledButton(
                                      onPressed: loadMore,
                                      child: const Text("Load More"),
                                    ),
                                  ),
                                );
                              }
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }),
          ),
          // Fixed horizontally scrollable container
          Positioned(
            top: 15,
            left: 15,
            right: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius:
                        const BorderRadius.all(Radius.elliptical(10.0, 10.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).colorScheme.secondary,
                          blurRadius: 3,
                          spreadRadius: 3,
                          blurStyle: BlurStyle.normal,
                          offset: const Offset(0, 0)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Search by category",
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w200,
                                ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            genrateCategory(
                                "assets/icons/laptop.png", "Laptop"),
                            genrateCategory("assets/icons/book.png", "Book"),
                            genrateCategory(
                                "assets/icons/projector.png", "Projector"),
                            genrateCategory(
                                "assets/icons/lab.png", "Lab Tools"),
                            genrateCategory(
                                "assets/icons/headphones.png", "Audio-Visual"),
                            genrateCategory("assets/icons/entertainment.png",
                                "Entertainment"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 17,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Browse assets",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    widget.role == "staff"
                        ? FilledButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/create_asset');
                            },
                            style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor:
                                  Theme.of(context).colorScheme.onSecondary,
                            ),
                            child: Text(
                              "Create",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector genrateCategory(String icon, String label) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(_createRoute(label));
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        width: 110,
        height: 80,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 243, 230),
          borderRadius: BorderRadius.all(
            Radius.elliptical(10.0, 10.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                icon,
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
              Text(label)
            ],
          ),
        ),
      ),
    );
  }

  Route _createRoute(String category) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          HomeSearchScreen(category: category),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0); // Slide from the right
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
