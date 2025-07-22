import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mfuborrow/components/expandable_container.dart';
import 'package:mfuborrow/components/loading_container.dart';
import 'package:mfuborrow/utils/constants.dart';
import 'package:mfuborrow/utils/get_token.dart';

class Request extends StatefulWidget {
  const Request({super.key});

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {
  bool isLoading = false;
  String? error;
  List requests = [];

  @override
  void initState() {
    super.initState();
    getRequests();
  }

  Future<void> getRequests() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    String token = await getToken(context);

    Uri uri = Uri.parse('$url/api/student_requests');
    try {
      http.Response response = await http.get(uri, headers: {
        'authorization': 'Bearer $token'
      }).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        setState(() {
          requests = jsonDecode(response.body)['data'];
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
        error = "Connection Time Out";
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(
          "Request",
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: false,
      ),
      body: Padding(
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
                    itemCount: 6,
                    itemBuilder: (context, index) => const LoadingContainer())
                : ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final req = requests[index] as Map<String, dynamic>;
                      return ExpandableContainer(
                          screen: "request",
                          borrowId: req['id'].toString(),
                          imageName: req['asset_image'],
                          assetName: req['asset_name'],
                          assetId: req['asset_id'].toString(),
                          assetCategory: req['category'],
                          requestStatus: req['status'],
                          assetLocation: req['location'],
                          requestNote: req['request_note'],
                          borrowDate: req['borrow_date'],
                          returnDate: req['return_date']);
                    },
                  ),
      ),
    );
  }
}
