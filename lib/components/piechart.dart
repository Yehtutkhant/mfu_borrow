import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartCustom extends StatelessWidget {
  final List<String> statuses;
  final List<List<int>> statusesByCategories;
  final List<Color> colors;
  final int tab;
  final String tabName;

  const PieChartCustom(
      {super.key,
      required this.statuses,
      required this.statusesByCategories,
      required this.colors,
      required this.tab,
      required this.tabName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          height: 300,
          child: PieChart(
            PieChartData(
              sections: List.generate(statuses.length, (index) {
                return PieChartSectionData(
                  value: tab == 6
                      ? (statusesByCategories[0][index] +
                              statusesByCategories[1][index] +
                              statusesByCategories[2][index] +
                              statusesByCategories[3][index] +
                              statusesByCategories[4][index] +
                              statusesByCategories[5][index])
                          .toDouble()
                      : statusesByCategories[tab][index].toDouble(),
                  color: colors[index],
                  radius: 60,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  title: (tab == 6
                          ? (statusesByCategories[0][index] +
                              statusesByCategories[1][index] +
                              statusesByCategories[2][index] +
                              statusesByCategories[3][index] +
                              statusesByCategories[4][index] +
                              statusesByCategories[5][index])
                          : statusesByCategories[tab][index])
                      .toString(),
                );
              }),
              centerSpaceRadius: 50,
            ),
          ),
        ),
        const Center(
          child: Text(
            "Asset Distribution",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            statuses.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    color: colors[index],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    statuses[index],
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
