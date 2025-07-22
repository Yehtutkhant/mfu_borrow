import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mfuborrow/utils/constants.dart';
import 'package:mfuborrow/utils/get_token.dart';

class LecturerStudentDetailScreen extends StatefulWidget {
  final String id;
  final String userRole;
  final String assetStatus;
  final String assetName;
  final String assetId;
  final String assetCategory;
  final String assetDescription;
  final String assetLocation;
  final String assetImage;

  const LecturerStudentDetailScreen(
      {super.key,
      required this.id,
      required this.userRole,
      required this.assetImage,
      required this.assetName,
      required this.assetId,
      required this.assetCategory,
      required this.assetLocation,
      required this.assetStatus,
      required this.assetDescription});

  @override
  State<LecturerStudentDetailScreen> createState() =>
      _StaffStudentDetailScreenState();
}

class _StaffStudentDetailScreenState
    extends State<LecturerStudentDetailScreen> {
  DateTime? _borrowDate;
  DateTime? _returnDate;
  String? _userRole;
  String _id = "";
  String _assetImage = "";
  String _assetName = "";
  String _assetId = "";
  String _assetCategory = "";
  String _assetLocation = "";
  String _assetStatus = "";
  String _assetDescription = "";

  final TextEditingController _requestController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _id = widget.id;
    _userRole = widget.userRole;
    _assetImage = widget.assetImage;
    _assetName = widget.assetName;
    _assetId = widget.assetId;
    _assetCategory = widget.assetCategory;
    _assetLocation = widget.assetLocation;
    _assetStatus = widget.assetStatus;
    _assetDescription = widget.assetDescription;
    _borrowDate = DateTime.now();
  }

  Color _getAssetStatusColor(context) {
    if (_assetStatus == "Available") {
      return Theme.of(context).colorScheme.onSecondary;
    } else if (_assetStatus == "Disabled") {
      return Theme.of(context).colorScheme.error;
    } else if (_assetStatus == "Borrowed") {
      return Theme.of(context).colorScheme.primary;
    } else if (_assetStatus == "Onholded") {
      return const Color.fromARGB(227, 247, 227, 47);
    }

    return Colors.black;
  }

  Icon _getAssetStatusIcon(context) {
    if (_assetStatus == "Available") {
      return Icon(
        Icons.check_circle,
        color: Theme.of(context).colorScheme.onSecondary,
      );
    } else if (_assetStatus == "Disabled") {
      return Icon(
        Icons.block,
        color: Theme.of(context).colorScheme.error,
      );
    } else if (_assetStatus == "Borrowed") {
      return Icon(
        Icons.book,
        color: Theme.of(context).colorScheme.primary,
      );
    } else if (_assetStatus == "Onholded") {
      return const Icon(
        Icons.hourglass_empty,
        color: Color.fromARGB(227, 247, 227, 47),
      );
    }
    return Icon(
      Icons.check_circle,
      color: Theme.of(context).colorScheme.onSecondary,
    );
  }

  Future<DateTime?> _selectDate(
      BuildContext context, DateTime? initialDate) async {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
  }

  Future<void> _borrow() async {
    setState(() {
      isLoading = true;
    });
    try {
      String token = await getToken(context);

      if (_borrowDate == null || _returnDate == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Both borrow and return dates are required!'),
            backgroundColor: Colors.red, // Custom background
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(
              top: kToolbarHeight + 16, // Offset below app bar
              left: 16,
              right: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        return;
      }
      final df = DateFormat('yyyy-MM-dd HH:mm:ss');
      final borrowDateStr = df.format(_borrowDate!);
      final returnDateStr = df.format(_returnDate!);
      Uri uri = Uri.parse('$url/api/borrow');
      http.Response response = await http
          .post(uri,
              headers: {
                'Content-Type': 'application/json',
                'authorization': 'Bearer $token'
              },
              body: jsonEncode({
                'id': _id,
                'asset_id': _assetId,
                'borrow_date': borrowDateStr,
                'return_date': returnDateStr,
                'request_note': _requestController.text
              }))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Asset Borrowed sucessfully!"),
            backgroundColor: Colors.green, // Custom background
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(
              top: kToolbarHeight + 16, // Offset below app bar
              left: 16,
              right: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        Map? message = jsonDecode(response.body);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${message?['message'] ?? "Unvalid inputs"}'),
            backgroundColor: Colors.red, // Custom background
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(
              top: kToolbarHeight + 16, // Offset below app bar
              left: 16,
              right: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } on TimeoutException catch (e) {
      if (!mounted) return;
      debugPrint(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Connection Time out"),
          backgroundColor:
              const Color.fromARGB(255, 29, 22, 21), // Custom background
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(
            top: kToolbarHeight + 16, // Offset below app bar
            left: 16,
            right: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Unknown Error"),
          backgroundColor:
              const Color.fromARGB(255, 29, 22, 21), // Custom background
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(
            top: kToolbarHeight + 16, // Offset below app bar
            left: 16,
            right: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
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
        centerTitle: false,
        title: Text(
          'Detail',
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _userRole == "student"
                ? FilledButton(
                    onPressed: _borrow,
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            "Borrow",
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
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    _assetImage,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2), // Shadow position
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _assetName,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        const SizedBox(height: 5),
                        Text(_assetId,
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black.withOpacity(0.4),
                                    )),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.theater_comedy),
                            const SizedBox(width: 10),
                            Text(
                              _assetCategory,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.location_on),
                            const SizedBox(width: 10),
                            Text(
                              _assetLocation,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _getAssetStatusIcon(context),
                            const SizedBox(width: 10),
                            Text(
                              _assetStatus,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: _getAssetStatusColor(context)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2), // Shadow position
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info_sharp),
                          const SizedBox(width: 10),
                          Text('Description',
                              style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _assetDescription,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.black.withOpacity(0.7),
                            ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _userRole == "student"
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 2), // Shadow position
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.date_range_rounded),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Date',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: Text(
                                        "Borrow Date",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: Text(
                                        "Return Date",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Request Note",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                                const Spacer(
                                  flex: 2,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 180,
                                      height: 35,
                                      child: TextField(
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(8.0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          hintText: _borrowDate != null
                                              ? DateFormat.yMd()
                                                  .format(_borrowDate!)
                                              : 'select date',
                                          hintStyle: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                        ),
                                        onTap: () async {
                                          DateTime? pickedDate =
                                              await _selectDate(
                                                  context, _borrowDate);
                                          if (pickedDate != null) {
                                            setState(
                                                () => _borrowDate = pickedDate);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: 180,
                                      height: 35,
                                      child: TextField(
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(8.0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          hintText: _returnDate != null
                                              ? DateFormat.yMd()
                                                  .format(_returnDate!)
                                              : 'select date',
                                          hintStyle: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                        ),
                                        onTap: () async {
                                          DateTime? pickedDate =
                                              await _selectDate(
                                                  context, _returnDate);
                                          if (pickedDate != null) {
                                            setState(
                                                () => _returnDate = pickedDate);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: 260,
                                      height: 120,
                                      child: TextFormField(
                                        maxLines: 5,
                                        controller: _requestController,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 10,
                                          ),
                                          hintText: 'Describe asset....',
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Colors.grey,
                                              ),
                                          border: const OutlineInputBorder(),
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(
                                  flex: 3,
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
