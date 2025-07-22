import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterOptions extends StatefulWidget {
  final String? selectedCategory;
  final DateTime? borrowDate;
  final DateTime? returnDate;
  final String? screen;
  final String? selectedStatus;
  final Function(String?, DateTime?, DateTime?)? onApply;
  final Function(String?, String?, DateTime?, DateTime?)? onApplyWithStatus;

  const FilterOptions({
    super.key,
    this.selectedStatus,
    required this.screen,
    this.selectedCategory,
    this.borrowDate,
    this.returnDate,
    this.onApply,
    this.onApplyWithStatus,
  });

  @override
  State<FilterOptions> createState() => FilterOptionsState();
}

class FilterOptionsState extends State<FilterOptions> {
  DateTime? _borrowDate;
  DateTime? _returnDate;
  String? _selectedCategory;
  String? _screen;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _borrowDate = widget.borrowDate;
    _returnDate = widget.returnDate;
    _selectedCategory = widget.selectedCategory;
    _screen = widget.screen;
    _selectedStatus = widget.selectedStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Filter Options",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: [
                'Select All',
                'Laptop',
                'Book',
                'Projector',
                'Lab Tool',
                'Audio-Visual',
                'Entertainment'
              ].map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
              decoration: const InputDecoration(labelText: "Category"),
            ),
            const SizedBox(
              height: 30,
            ),
            _screen == 'lecturer_requests' || _screen == 'staff_return'
                ? const SizedBox()
                : _statusFilter(),
            _screen == 'lecturer_requests' || _screen == 'staff_return'
                ? const SizedBox()
                : const SizedBox(
                    height: 30,
                  ),
            const Text("Select Dates"),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      hintText: _borrowDate != null
                          ? DateFormat.yMd().format(_borrowDate!)
                          : 'Borrow Date',
                    ),
                    onTap: () async {
                      DateTime? pickedDate =
                          await _selectDate(context, _borrowDate);
                      if (pickedDate != null) {
                        setState(() => _borrowDate = pickedDate);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      hintText: _returnDate != null
                          ? DateFormat.yMd().format(_returnDate!)
                          : 'Return Date',
                    ),
                    onTap: () async {
                      DateTime? pickedDate =
                          await _selectDate(context, _returnDate);
                      if (pickedDate != null) {
                        setState(() => _returnDate = pickedDate);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: FilledButton(
                onPressed: () {
                  if (_screen == 'lecturer_requests' ||
                      _screen == 'staff_return') {
                    widget.onApply!(
                        _selectedCategory, _borrowDate, _returnDate);
                  } else {
                    widget.onApplyWithStatus!(_selectedCategory,
                        _selectedStatus, _borrowDate, _returnDate);
                  }
                  // No validation for borrow date and return date becuase they are user input fields and not range search
                },
                child: Text(
                  "Apply",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _selectDate(
      BuildContext context, DateTime? initialDate) async {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  }

  DropdownButtonFormField<String> _statusFilter() {
    List<String> statusList = [];
    if (_screen == "student_history") {
      statusList.addAll(["Select All", "Approved", "Returned"]);
    } else if (_screen == "lecturer_history") {
      statusList.addAll(["Select All", "Approved", "Disapproved"]);
    } else if (_screen == "staff_history") {
      statusList.addAll(
          ["Select All", "Approved", "Disapproved", "Returned", "Canceled"]);
    }

    return DropdownButtonFormField<String>(
      value: _selectedStatus,
      items: statusList.map((String status) {
        return DropdownMenuItem<String>(
          value: status,
          child: Text(status),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _selectedStatus = value!;
        });
      },
      decoration: const InputDecoration(labelText: "Request Status"),
    );
  }
}
