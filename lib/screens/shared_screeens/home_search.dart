import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mfuborrow/components/app_bar_with_search.dart';
import 'package:mfuborrow/components/container.dart';
import 'package:mfuborrow/components/loading_container.dart';
import 'package:mfuborrow/utils/constants.dart';

class HomeSearchScreen extends StatefulWidget {
  final String category;
  const HomeSearchScreen({super.key, required this.category});

  @override
  State<HomeSearchScreen> createState() => _HomeSearchScreeState();
}

class _HomeSearchScreeState extends State<HomeSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  Timer? _debounce;
  final int itemLength = 10;
  String _category = "";
  List assets = [];
  String? error;
  int page = 1;
  bool hasMore = true;
  final int pageSize = 5;
  @override
  void initState() {
    super.initState();
    _category = widget.category;
    getAssets();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // every time the text changes, reset the timer
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // only called after 500 ms of no new typing:
      page = 1;
      hasMore = true;
      assets.clear();
      getAssets();
    });
  }

  void loadMore() {
    getAssets(loadMore: true);
  }

  void getAssets({bool loadMore = false}) async {
    if (!loadMore) {
      page = 1;
      hasMore = true;
      assets.clear();
    }
    setState(() {
      isLoading = true;
      error = null;
    });
    final fetchPage = loadMore ? page + 1 : page;
    debugPrint(fetchPage.toString());
    final search = _searchController.text;
    Uri uri = Uri.parse(
        '$url/api/assets?asset_name=$search&category=$_category&page=$fetchPage&limit=$pageSize');
    try {
      http.Response response =
          await http.get(uri).timeout(const Duration(seconds: 5));
      debugPrint(response.statusCode.toString());
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
    final bool showLoadMoreButton = hasMore && !isLoading;
    final bool showLoadingIndicator = isLoading && assets.isNotEmpty;
    final int extraItems =
        (showLoadMoreButton ? 1 : 0) + (showLoadingIndicator ? 1 : 0);
    final int totalItemCount = assets.length + extraItems;
    return Scaffold(
      appBar: SearchAppBar(
        homeSearch: true,
        leftPadding: 60,
        title: _category,
        searchText: "Search by asset name....",
        searchController: _searchController,
        onChanged: _onSearchChanged,
      ),
      body: itemLength == 0
          ? Align(
              alignment: const Alignment(0, 0),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/no_data.png",
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Text("No assets to be shown!",
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
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
                                          color: Colors.grey.shade400,
                                          size: 32),
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

                                  return AssetContainer(
                                    screen: "home",
                                    imageName:
                                        asset['asset_image'] ?? "Unknown",
                                    assetName: asset['asset_name'] ?? "Unknown",
                                    assetId:
                                        (asset['asset_id'] ?? '').toString(),
                                    assetCategory:
                                        asset['category'] ?? "Unknown",
                                    assetStatus: asset['status'] ?? "Unknown",
                                  );
                                }
                                final loadMoreButtonIndex = assets.length;
                                if (hasMore &&
                                    !isLoading &&
                                    index == loadMoreButtonIndex) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
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
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }),
            ),
    );
  }
}
