import 'package:flutter/material.dart';
import 'package:mfuborrow/components/piechart.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<double> asset = [22, 15, 10, 8];
  List<String> statuses = [
    "Availabe",
    "Pending",
    "Borrowed",
    "Disabled",
  ];
  List<List<int>> statusesByCategories = [
    [22, 15, 10, 8],
    [32, 1, 10, 8],
    [22, 12, 0, 9],
    [19, 15, 10, 8],
    [23, 12, 8, 18],
    [34, 13, 10, 9],
  ];

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [
      Theme.of(context).colorScheme.onSecondary,
      const Color.fromARGB(227, 247, 227, 47),
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.error,
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(
          "Dashboard",
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildContainer("Laptops", "assets/icons/laptop.png", "97",
                      const Color.fromARGB(255, 16, 173, 59)),
                  _buildContainer("Books", "assets/icons/education.png", "435",
                      const Color.fromARGB(255, 238, 147, 10)),
                  _buildContainer("Projectors", "assets/icons/projector.png",
                      "55", const Color.fromARGB(255, 114, 41, 170))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildContainer("Lab Tool", "assets/icons/lab.png", "97",
                      const Color.fromARGB(255, 22, 147, 224)),
                  _buildContainer("Visual-Audio", "assets/icons/headphones.png",
                      "435", const Color.fromARGB(255, 224, 22, 32)),
                  _buildContainer(
                      "Entertainment",
                      "assets/icons/entertainment.png",
                      "55",
                      const Color.fromARGB(255, 247, 206, 26))
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  width: 400,
                  height: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 10,
                        blurRadius: 10,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: DefaultTabController(
                      length: 7,
                      initialIndex: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Stats",
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 3),
                              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 181, 103),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ButtonsTabBar(
                                physics: const BouncingScrollPhysics(),
                                contentCenter: true,
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(12)),
                                unselectedDecoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 255, 181, 103),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                radius: 12,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                buttonMargin:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                unselectedLabelStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                                labelStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                                tabs: const [
                                  Tab(
                                    text: "ALL",
                                  ),
                                  Tab(
                                    text: "Laptops",
                                  ),
                                  Tab(
                                    text: "Books",
                                  ),
                                  Tab(
                                    text: "Projectors",
                                  ),
                                  Tab(
                                    text: "Lab Tools",
                                  ),
                                  Tab(
                                    text: "Audio-Visual",
                                  ),
                                  Tab(
                                    text: "Entertainment",
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                child: TabBarView(
                              children: [
                                PieChartCustom(
                                    statuses: statuses,
                                    statusesByCategories: statusesByCategories,
                                    colors: colors,
                                    tab: 6,
                                    tabName: "All Assets"),
                                PieChartCustom(
                                  statuses: statuses,
                                  statusesByCategories: statusesByCategories,
                                  colors: colors,
                                  tab: 0,
                                  tabName: "Laptops",
                                ),
                                PieChartCustom(
                                  statuses: statuses,
                                  statusesByCategories: statusesByCategories,
                                  colors: colors,
                                  tab: 1,
                                  tabName: "Books",
                                ),
                                PieChartCustom(
                                  statuses: statuses,
                                  statusesByCategories: statusesByCategories,
                                  colors: colors,
                                  tab: 2,
                                  tabName: "Projectors",
                                ),
                                PieChartCustom(
                                  statuses: statuses,
                                  statusesByCategories: statusesByCategories,
                                  colors: colors,
                                  tab: 3,
                                  tabName: "Lab Tools",
                                ),
                                PieChartCustom(
                                  statuses: statuses,
                                  statusesByCategories: statusesByCategories,
                                  colors: colors,
                                  tab: 4,
                                  tabName: "Audio-Visual",
                                ),
                                PieChartCustom(
                                  statuses: statuses,
                                  statusesByCategories: statusesByCategories,
                                  colors: colors,
                                  tab: 5,
                                  tabName: "Entertainment",
                                ),
                              ],
                            ))
                          ],
                        ),
                      ))),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildContainer(
      String title, String icon, String number, Color color) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: 130,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          )
        ],
        color: color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                icon,
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
          Text(
            number,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
  }
}
