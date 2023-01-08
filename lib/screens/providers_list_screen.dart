import 'package:flutter/material.dart';
import '../bot_nav_components/provider_list/all_provider.dart';
import '../bot_nav_components/provider_list/appointed_provider.dart';

class ProvidersList extends StatefulWidget {
  @override
  State<ProvidersList> createState() => _ProvidersListState();
}

class _ProvidersListState extends State<ProvidersList>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final _pages = [
    const AllProviders(),
    AppointedProviders(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _pages.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                color: Colors.orange[50],
                child: TabBar(
                  automaticIndicatorColorAdjustment: true,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  labelColor: Colors.black,
                  unselectedLabelColor: Theme.of(context).colorScheme.secondary,
                  controller: _tabController,
                  indicatorWeight: 4,
                  tabs: const [
                    Tab(
                      text: 'All providers',
                    ),
                    Tab(
                      text: 'Appointed providers',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: _pages,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
