import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universities_proj/universities/models/university_model.dart';
import 'package:universities_proj/universities/provider/universities_provider.dart';
import 'package:universities_proj/universities/ui/university_detail_screen.dart';

enum VisualizationMode { list, grid }

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  static const route = '/';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  VisualizationMode _mode = VisualizationMode.list;
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final universitiesState = ref.watch(universitiesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Universidades')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 12),
              const Expanded(child: Text('Selecciona el modo de visualización:')),
              IconButton(
                onPressed: () => setState(() => _mode = VisualizationMode.list),
                icon: Icon(
                  Icons.list,
                  color: _mode == VisualizationMode.list ? Colors.blue[700] : Colors.grey,
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _mode = VisualizationMode.grid),
                icon: Icon(
                  Icons.grid_view,
                  color: _mode == VisualizationMode.grid ? Colors.blue[700] : Colors.grey,
                ),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: universitiesState.universities.on(
              onInitial: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.read(universitiesProvider.notifier).getUniversities();
                });
                return const Center(child: CircularProgressIndicator());
              },
              onLoading: () => const Center(child: CircularProgressIndicator()),
              onError: (e) => Center(child: Text(e.toString())),
              onData: (data) => _mode == VisualizationMode.list
                  ? _ListViewBody(
                      universities: data,
                      controller: scrollController,
                      onTap: _handleOnSelectU,
                    )
                  : _GridViewBody(
                      universities: data,
                      controller: scrollController,
                      onTap: _handleOnSelectU,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleOnSelectU(UniversityModel university) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => UniversityDetailScreen(university: university)),
    );
  }
}

class _GridViewBody extends StatelessWidget {
  const _GridViewBody({
    Key? key,
    required this.universities,
    required this.controller,
    required this.onTap,
  }) : super(key: key);

  final List<UniversityModel> universities;
  final ScrollController controller;
  final ValueChanged<UniversityModel> onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: universities.length,
      controller: controller,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final university = universities[index];
        return Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: () => onTap(university),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  university.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text('${university.country} - ${university.alphaTwoCode}'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ListViewBody extends StatelessWidget {
  const _ListViewBody({
    Key? key,
    required this.universities,
    required this.controller,
    required this.onTap,
  }) : super(key: key);

  final List<UniversityModel> universities;
  final ScrollController controller;
  final ValueChanged<UniversityModel> onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: universities.length,
      controller: controller,
      itemBuilder: (context, index) {
        final university = universities[index];
        return ListTile(
          onTap: () => onTap(university),
          title: Text(university.name),
          trailing: IconButton(
            icon: const Icon(Icons.chevron_right_outlined),
            onPressed: () => onTap(university),
          ),
          subtitle: Text(university.country),
        );
      },
    );
  }
}