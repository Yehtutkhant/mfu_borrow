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

class ReturnScreen extends StatefulWidget {
  const ReturnScreen({super.key});

  @override
  State<ReturnScreen> createState() => _ReturnScreenState();
}

class _ReturnScreenState extends State<ReturnScreen> {
  final TextEditingController _searchController = TextEditingController();
  DateTime? _borrowDate;
  DateTime? _returnDate;
  String? _selectedCategory = "Select All";

  bool isLoading = false;
  String? error;
  List returns = [];

  @override
  void initState() {
    super.initState();
    getReturns();
  }

  Future<void> getReturns() async {
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
        '$url/api/staff_returns?category=$_selectedCategory&borrow_date=$borrowDateStr&return_date=$returnDateStr&student_id=$studentId');
    try {
      http.Response response = await http.get(uri, headers: {
        'authorization': 'Bearer $token'
      }).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        setState(() {
          returns = jsonDecode(response.body)['data'];
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
          title: "Return",
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
                    itemCount: returns.length,
                    itemBuilder: (context, index) {
                      final ret = returns[index] as Map<String, dynamic>;
                      return ExpandableContainer(
                          screen: "return",
                          borrowId: ret['id'].toString(),
                          imageName: ret['asset_image'],
                          assetName: ret['asset_name'],
                          assetId: ret['asset_id'].toString(),
                          assetCategory: ret['category'],
                          borrower: ret['borrower'],
                          approver: ret['validator'],
                          borrowDate: ret['borrow_date'],
                          returnDate: ret['return_date'],
                          requestNote: ret['request_note']);
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
          screen: "staff_return",
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
            getReturns();
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
