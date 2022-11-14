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
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    if (maxScroll - currentScroll <= 200) {
      ref.read(universitiesProvider.notifier).getMoreUniversities();
    }
  }

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
              onData: (data) => ListView(
                controller: scrollController,
                children: [
                  _mode == VisualizationMode.list
                      ? _ListViewBody(
                          universities: universitiesState.paginatedList,
                          onTap: _handleOnSelectU,
                        )
                      : _GridViewBody(
                          universities: universitiesState.paginatedList,
                          onTap: _handleOnSelectU,
                        ),
                  if (universitiesState.isGettingMore)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
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
    required this.onTap,
  }) : super(key: key);

  final List<UniversityModel> universities;
  final ValueChanged<UniversityModel> onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      primary: false,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: universities.length,
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
    required this.onTap,
  }) : super(key: key);

  final List<UniversityModel> universities;
  final ValueChanged<UniversityModel> onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: universities.length,
      primary: false,
      shrinkWrap: true,
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
