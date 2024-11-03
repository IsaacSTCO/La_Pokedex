import 'package:flutter/material.dart';
import 'generations_tab.dart';
import 'types_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pokédex'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Generaciones'),
              Tab(text: 'Tipos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GenerationsTab(),
            TypesTab(),
          ],
        ),
      ),
    );
  }
}