import 'package:flutter/material.dart';
import 'package:mfuborrow/components/skeleton.dart';

class LoadingContainer extends StatelessWidget {
  const LoadingContainer({super.key});

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
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton(height: 100, width: 100),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(width: 200),
                SizedBox(
                  height: 15,
                ),
                Skeleton(width: 100),
                SizedBox(
                  height: 8,
                ),
                Skeleton(width: 100),
                SizedBox(
                  height: 8,
                ),
                Skeleton(width: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
