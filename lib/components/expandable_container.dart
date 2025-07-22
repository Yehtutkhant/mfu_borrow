import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mfuborrow/utils/constants.dart';
import 'package:mfuborrow/utils/get_token.dart';

class ExpandableContainer extends StatefulWidget {
  final String borrowId;
  final String imageName;
  final String assetId;
  final String assetName;
  final String assetCategory;
  final String assetLocation;
  final String screen;
  final String requestNote;
  final String borrower;
  final String approver;
  final String borrowDate;
  final String returnDate;
  final String requestStatus;

  const ExpandableContainer({
    super.key,
    required this.borrowId,
    required this.screen,
    required this.imageName,
    required this.assetName,
    this.assetId = "",
    required this.assetCategory,
    this.assetLocation = "",
    this.borrower = "",
    this.approver = "",
    this.borrowDate = "",
    this.returnDate = "",
    this.requestNote = "",
    this.requestStatus = "",
  });

  @override
  State<ExpandableContainer> createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer>
    with SingleTickerProviderStateMixin {
  String _borrowId = "";
  String _imageName = "";
  String _assetId = "";
  String _assetName = "";
  String _assetCategory = "";
  String _assetLocation = "";
  String _screen = "";
  String _requestNote = "";
  String _borrower = "";
  String _approver = "";
  String _borrowDate = "";
  String _returnDate = "";
  String _requestStatus = "";
  bool _isExpanded = false;
  bool isApprovedLoading = false;
  bool isDisapprovedLoading = false;
  bool isReturnLoading = false;
  bool isCancelLoading = false;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _borrowId = widget.borrowId;
    _imageName = widget.imageName;
    _assetId = widget.assetId;
    _assetName = widget.assetName;
    _assetCategory = widget.assetCategory;
    _assetLocation = widget.assetLocation;
    _screen = widget.screen;
    _requestNote = widget.requestNote;
    _borrower = widget.borrower;
    _approver = widget.approver;
    _borrowDate = widget.borrowDate;
    _returnDate = widget.returnDate;
    _requestStatus = widget.requestStatus;
  }

  Future<void> _validateRequest({String status = "Disapproved"}) async {
    setState(() {
      if (status == "Approved") {
        isApprovedLoading = true;
      } else {
        isDisapprovedLoading = true;
      }
    });
    try {
      Uri uri = Uri.parse('$url/api/lecturer_requests');
      String token = await getToken(context);
      http.Response response = await http
          .put(uri,
              headers: {
                'Content-Type': 'application/json',
                'authorization': 'Bearer $token'
              },
              body:
                  jsonEncode({'borrow_id': _borrowId, 'borrow_status': status}))
          .timeout(const Duration(seconds: 5));

      if (!mounted) return;
      if (response.statusCode == 201) {
        Map? message = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${message?['message'] ?? "Unvalid inputs"}'),
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
      debugPrint(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Connection Time Out"),
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
        if (status == "Approved") {
          isApprovedLoading = false;
        } else {
          isDisapprovedLoading = false;
        }
      });
    }
  }

  Future<void> _handleReturn() async {
    setState(() {
      isReturnLoading = true;
    });
    try {
      Uri uri = Uri.parse('$url/api/staff_returns');
      String token = await getToken(context);
      http.Response response = await http
          .put(uri,
              headers: {
                'Content-Type': 'application/json',
                'authorization': 'Bearer $token'
              },
              body: jsonEncode({'borrow_id': _borrowId}))
          .timeout(const Duration(seconds: 5));

      if (!mounted) return;
      if (response.statusCode == 201) {
        Map? message = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${message?['message'] ?? "Unvalid inputs"}'),
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
        isReturnLoading = false;
      });
    }
  }

  Future<void> _handleCancel() async {
    setState(() {
      isCancelLoading = true;
    });
    try {
      Uri uri = Uri.parse('$url/api/student_requests');
      String token = await getToken(context);
      http.Response response = await http
          .put(uri,
              headers: {
                'Content-Type': 'application/json',
                'authorization': 'Bearer $token'
              },
              body: jsonEncode({'borrow_id': _borrowId}))
          .timeout(const Duration(seconds: 5));

      if (!mounted) return;
      if (response.statusCode == 201) {
        Map? message = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${message?['message'] ?? "Unvalid inputs"}'),
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
        isCancelLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  Color _getRequestStatusColor(context) {
    if (_requestStatus == "Approved") {
      return Theme.of(context).colorScheme.onSecondary;
    } else if (_requestStatus == "Disapproved" ||
        _requestStatus == "Canceled") {
      return Theme.of(context).colorScheme.error;
    } else if (_requestStatus == "Returned") {
      return Theme.of(context).colorScheme.primary;
    } else if (_requestStatus == "Pending") {
      return const Color.fromARGB(227, 247, 227, 47);
    }

    return Colors.black;
  }

  Icon _getRequestStatusIcon(context) {
    if (_requestStatus == "Approved") {
      return Icon(
        Icons.check_circle,
        size: 15,
        color: Theme.of(context).colorScheme.onSecondary,
      );
    } else if (_requestStatus == "Disapproved" ||
        _requestStatus == "Canceled") {
      return Icon(
        Icons.block,
        size: 15,
        color: Theme.of(context).colorScheme.error,
      );
    } else if (_requestStatus == "Returned") {
      return Icon(
        Icons.book,
        size: 15,
        color: Theme.of(context).colorScheme.primary,
      );
    } else if (_requestStatus == "Pending") {
      return const Icon(
        Icons.hourglass_empty,
        size: 15,
        color: Color.fromARGB(227, 247, 227, 47),
      );
    }
    return Icon(
      Icons.check_circle,
      size: 15,
      color: Theme.of(context).colorScheme.onSecondary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(_imageName),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _assetName,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Id $_assetId',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.4),
                          ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.laptop,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            _assetCategory,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _screen == "request"
                        ? Row(
                            children: [
                              _getRequestStatusIcon(context),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  _requestStatus,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color:
                                              _getRequestStatusColor(context)),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    _screen == "request"
                        ? const SizedBox(height: 10)
                        : const SizedBox(),
                    _screen == "request"
                        ? Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 15,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  _assetLocation,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    _screen == "request"
                        ? const SizedBox(height: 10)
                        : const SizedBox(),
                    _screen != "request"
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Borrower",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 6),
                                  _screen == "return"
                                      ? Text(
                                          "Approver",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        )
                                      : const SizedBox(),
                                  _screen == "return"
                                      ? const SizedBox(height: 6)
                                      : const SizedBox(),
                                  Text(
                                    "Borrow Date",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Return Date",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Request Note",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 6),
                                ],
                              ),
                              const Spacer(
                                flex: 2,
                              ),
                              SizedBox(
                                width: 140,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _borrower,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Colors.black
                                                  .withOpacity(0.7)),
                                    ),
                                    const SizedBox(height: 6),
                                    _screen == "return"
                                        ? Text(
                                            _approver,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: Colors.black
                                                        .withOpacity(0.7)),
                                          )
                                        : const SizedBox(),
                                    _screen == "return"
                                        ? const SizedBox(height: 6)
                                        : const SizedBox(),
                                    Text(
                                      _borrowDate,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Colors.black
                                                  .withOpacity(0.7)),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      _returnDate,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Colors.black
                                                  .withOpacity(0.7)),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      _requestNote,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    const SizedBox(height: 6),
                                  ],
                                ),
                              ),
                              const Spacer(
                                flex: 1,
                              )
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: _toggleExpand),
          SizeTransition(
            sizeFactor:
                CurvedAnimation(parent: _controller, curve: Curves.easeOut),
            axisAlignment: 1.0,
            child: _screen == "return"
                ? Align(
                    alignment: Alignment.bottomRight,
                    child: FilledButton(
                      onPressed: () {
                        _handleReturn();
                      },
                      child: isReturnLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text("Return"),
                    ),
                  )
                : _screen == "requests"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FilledButton(
                            onPressed: () {
                              _validateRequest(status: 'Approved');
                            },
                            style: FilledButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.onSecondary),
                            child: isApprovedLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Text("Approved"),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          FilledButton(
                            onPressed: () {
                              _validateRequest(status: 'Disapproved');
                            },
                            style: FilledButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: isDisapprovedLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Text("Disapproved"),
                          )
                        ],
                      )
                    : _screen == "request"
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.info_sharp,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 10),
                                    Text('Request Note',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _requestNote,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                  textAlign: TextAlign.justify,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.date_range_rounded,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 10),
                                    Text('Date',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: Text("Borrow Date",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: Text("Return Date",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall),
                                        ),
                                      ],
                                    ),
                                    const Spacer(
                                      flex: 1,
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 5, 10, 5),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Text(_borrowDate,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 5, 10, 5),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Text(_returnDate,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall),
                                        ),
                                      ],
                                    ),
                                    const Spacer(
                                      flex: 5,
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: FilledButton(
                                    onPressed: _handleCancel,
                                    style: FilledButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    child: isReturnLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                            ),
                                          )
                                        : const Text('Cancel'),
                                  ),
                                )
                              ],
                            ),
                          )
                        : const SizedBox(),
          )
        ],
      ),
    );
  }
}
