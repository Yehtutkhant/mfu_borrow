import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mfuborrow/components/app_bar_with_search.dart';
import 'package:mfuborrow/components/expandable_container.dart';
import 'package:mfuborrow/components/filter_options.dart';
import 'package:mfuborrow/components/loading_container.dart';
import 'package:mfuborrow/utils/constants.dart';
import 'package:mfuborrow/utils/get_token.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final TextEditingController _searchController = TextEditingController();
  DateTime? _borrowDate;
  DateTime? _returnDate;
  String? _selectedCategory = "Select All";

  bool isLoading = false;

  List requests = [];
  String? error;

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
    final df = DateFormat('yyyy-MM-dd HH:mm:ss');
    String borrowDateStr = "";
    String returnDateStr = "";
    if (_borrowDate != null) {
      borrowDateStr = df.format(_borrowDate!);
    }
    if (_returnDate != null) {
      returnDateStr = df.format(_returnDate!);
    }

    String studentId = _searchController.text;

    Uri uri = Uri.parse(
        '$url/api/lecturer_requests?category=$_selectedCategory&borrow_date=$borrowDateStr&return_date=$returnDateStr&student_id=$studentId');
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
      appBar: SearchAppBar(
          leftPadding: 20,
          title: "Requests",
          searchText: "Search by student ID....",
          searchController: _searchController,
          showFilterOptions: _showFilterOptions),
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
                          borrowId: req['id'].toString(),
                          screen: "requests",
                          imageName: req['asset_image'],
                          assetName: req['asset_name'],
                          assetId: req['asset_id'].toString(),
                          assetCategory: req['category'],
                          borrower: req['borrower'],
                          borrowDate: req['borrow_date'],
                          returnDate: req['return_date'],
                          requestNote: req['request_note']);
                    }),
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FilterOptions(
          screen: "lecturer_requests",
          selectedCategory: _selectedCategory,
          borrowDate: _borrowDate,
          returnDate: _returnDate,
          onApply:
              (String? category, DateTime? borrowDate, DateTime? returnDate) {
            setState(() {
              _selectedCategory = category;
              _borrowDate = borrowDate;
              _returnDate = returnDate;
            });
            Navigator.of(context).pop();
            getRequests();
          },
        ).animate().move(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
            curve: Curves.easeIn,
            duration: 500.ms);
      },
    );
  }
}
