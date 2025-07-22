import 'package:flutter/material.dart';
import 'package:mfuborrow/screens/staff/edit_asset.dart';

class StaffDetailScreen extends StatefulWidget {
  final String assetStatus;
  final String assetName;
  final String assetId;
  final String assetCategory;
  final String assetDescription;
  final String assetLocation;
  final String assetImage;

  const StaffDetailScreen(
      {super.key,
      required this.assetImage,
      required this.assetName,
      required this.assetId,
      required this.assetCategory,
      required this.assetLocation,
      required this.assetStatus,
      required this.assetDescription});

  @override
  State<StaffDetailScreen> createState() => _StaffDetailScreenState();
}

class _StaffDetailScreenState extends State<StaffDetailScreen> {
  String _assetImage = "";
  String _assetName = "";
  String _assetId = "";
  String _assetCategory = "";
  String _assetLocation = "";
  String _assetStatus = "";
  String _assetDescription = "";

  @override
  void initState() {
    super.initState();
    _assetImage = widget.assetImage;
    _assetName = widget.assetName;
    _assetId = widget.assetId;
    _assetCategory = widget.assetCategory;
    _assetLocation = widget.assetLocation;
    _assetStatus = widget.assetStatus;
    _assetDescription = widget.assetDescription;
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
            child: FilledButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditAsset(
                          id: _assetId,
                          assetImage: _assetImage,
                          assetName: _assetName,
                          assetCategory: _assetCategory,
                          assetDescription: _assetDescription,
                          assetLocation: _assetLocation,
                          assetStatus: _assetStatus,
                        )));
              },
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                "Edit",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
            ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
