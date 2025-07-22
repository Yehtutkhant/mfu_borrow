import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mfuborrow/components/app_bar_with_search.dart';
import 'package:mfuborrow/components/container.dart';
import 'package:mfuborrow/components/filter_options.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mfuborrow/components/loading_container.dart';
import 'package:mfuborrow/utils/constants.dart';
import 'package:mfuborrow/utils/get_token.dart';

class StaffHistory extends StatefulWidget {
  const StaffHistory({super.key});

  @override
  State<StaffHistory> createState() => _StaffHistoryState();
}

class _StaffHistoryState extends State<StaffHistory> {
  final TextEditingController _searchController = TextEditingController();
  DateTime? _borrowDate;
  DateTime? _returnDate;
  String? _selectedCategory = "Select All";
  String? _selectedStatus = "Select All";
  bool isLoading = false;
  String? error;
  List history = [];

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  Future<void> getHistory() async {
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

    String assetName = _searchController.text;

    Uri uri = Uri.parse(
        '$url/api/staff_history?asset_name=$assetName&category=$_selectedCategory&borrow_status=$_selectedStatus&borrow_date=$borrowDateStr&return_date=$returnDateStr');
    try {
      http.Response response = await http.get(uri, headers: {
        'authorization': 'Bearer $token'
      }).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        setState(() {
          history = jsonDecode(response.body)['data'];
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
          title: "History",
          searchText: "Search by asset name....",
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
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final his = history[index] as Map<String, dynamic>;
                      return AssetContainer(
                          screen: "staff_history",
                          imageName: his['asset_image'],
                          assetName: his['asset_name'],
                          assetId: his['asset_id'].toString(),
                          assetCategory: his['category'],
                          requestStatus: his['status'],
                          borrower: his['borrower'],
                          approver: his['validator'],
                          borrowDate: his['borrow_date'],
                          returnDate: his['return_date'],
                          requestNote: his['request_note']);
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
                screen: "staff_history",
                selectedCategory: _selectedCategory,
                selectedStatus: _selectedStatus,
                borrowDate: _borrowDate,
                returnDate: _returnDate,
                onApplyWithStatus: (String? category, String? status,
                    DateTime? borrowDate, DateTime? returnDate) {
                  setState(() {
                    _selectedCategory = category;
                    _selectedStatus = status;
                    _borrowDate = borrowDate;
                    _returnDate = returnDate;
                  });
                  Navigator.of(context).pop();
                  getHistory();
                })
            .animate()
            .move(
                begin: const Offset(0, 1),
                end: const Offset(0, 0),
                curve: Curves.easeIn,
                duration: 500.ms);
      },
    );
  }
}
