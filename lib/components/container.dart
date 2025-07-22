import 'package:flutter/material.dart';

class AssetContainer extends StatelessWidget {
  final String imageName;
  final String assetId;
  final String assetName;
  final String assetCategory;
  final String assetStatus;
  final String requestStatus;
  final String borrower;
  final String approver;
  final String returnDate;
  final String borrowDate;
  final String requestNote;
  final String screen;

  const AssetContainer(
      {super.key,
      required this.imageName,
      required this.assetName,
      this.assetId = "",
      required this.assetCategory,
      this.assetStatus = "",
      this.requestStatus = "",
      this.borrower = "",
      this.approver = "",
      this.borrowDate = "",
      this.returnDate = "",
      this.requestNote = "",
      required this.screen});

  Color _getRequestStatusColor(context) {
    if (requestStatus == "Approved") {
      return Theme.of(context).colorScheme.onSecondary;
    } else if (requestStatus == "Disapproved") {
      return Theme.of(context).colorScheme.error;
    } else if (requestStatus == "Canceled") {
      return Theme.of(context).colorScheme.error;
    } else if (requestStatus == "Returned") {
      return Theme.of(context).colorScheme.primary;
    }
    return Colors.black;
  }

  Color _getAssetStatusColor(context) {
    if (assetStatus == "Available") {
      return Theme.of(context).colorScheme.onSecondary;
    } else if (assetStatus == "Disabled") {
      return Theme.of(context).colorScheme.error;
    } else if (assetStatus == "Borrowed") {
      return Theme.of(context).colorScheme.primary;
    } else if (assetStatus == "Onholded") {
      return const Color.fromARGB(227, 247, 227, 47);
    }

    return Colors.black;
  }

  Icon _getAssetStatusIcon(context) {
    if (assetStatus == "Available") {
      return Icon(
        Icons.check_circle,
        color: Theme.of(context).colorScheme.onSecondary,
      );
    } else if (assetStatus == "Disabled") {
      return Icon(
        Icons.block,
        color: Theme.of(context).colorScheme.error,
      );
    } else if (assetStatus == "Borrowed") {
      return Icon(
        Icons.book,
        color: Theme.of(context).colorScheme.primary,
      );
    } else if (assetStatus == "Onholded") {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      width: 100,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(imageName),
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
                  assetName,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                screen == "home" ? const SizedBox(height: 2) : const SizedBox(),
                screen == "home"
                    ? Text(
                        'Id $assetId',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.4)),
                      )
                    : const SizedBox(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.laptop,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        assetCategory,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                screen == "home" ? const SizedBox(height: 4) : const SizedBox(),
                screen == "home"
                    ? Row(
                        children: [
                          _getAssetStatusIcon(context),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              assetStatus,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: _getAssetStatusColor(context)),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
                screen != "home"
                    ? Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              screen == "staff_history" ||
                                      screen == "lecturer_history"
                                  ? Text(
                                      "Borrower",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    )
                                  : const SizedBox(),
                              screen == "staff_history" ||
                                      screen == "lecturer_history"
                                  ? const SizedBox(height: 10)
                                  : const SizedBox(),
                              screen == "staff_history" ||
                                      screen == "student_history"
                                  ? Text(
                                      "Approver",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    )
                                  : const SizedBox(),
                              screen == "staff_history" ||
                                      screen == "student_history"
                                  ? const SizedBox(height: 10)
                                  : const SizedBox(),
                              Text(
                                "Borrow Date",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Return Date",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Status",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Request Note",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                          const Spacer(
                            flex: 1,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              screen == "staff_history" ||
                                      screen == "lecturer_history"
                                  ? Text(
                                      borrower,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Colors.black
                                                  .withOpacity(0.7)),
                                    )
                                  : const SizedBox(),
                              screen == "staff_history" ||
                                      screen == "lecturer_history"
                                  ? const SizedBox(height: 10)
                                  : const SizedBox(),
                              screen == "staff_history" ||
                                      screen == "student_history"
                                  ? Text(
                                      approver,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Colors.black
                                                  .withOpacity(0.7)),
                                    )
                                  : const SizedBox(),
                              screen == "staff_history" ||
                                      screen == "student_history"
                                  ? const SizedBox(height: 10)
                                  : const SizedBox(),
                              Text(
                                borrowDate,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Colors.black.withOpacity(0.7)),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                returnDate,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Colors.black.withOpacity(0.7)),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                requestStatus,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: _getRequestStatusColor(context),
                                    ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                requestNote,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Colors.black.withOpacity(0.7)),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                          const Spacer(),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
