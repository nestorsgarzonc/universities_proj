import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universities_proj/universities/models/university_model.dart';
import 'package:universities_proj/universities/provider/universities_provider.dart';
import 'package:universities_proj/universities/ui/university_detail_screen.dart';
import 'package:universities_proj/widgets/loading_widget.dart';
part './widgets/grid_view_body.dart';
part './widgets/list_view_body.dart';
part './widgets/view_mode.dart';

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
          _ViewMode(
            mode: _mode,
            onSelect: (mode) => setState(() => _mode = mode),
          ),
          const Divider(),
          Expanded(
            child: universitiesState.universities.on(
              onInitial: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.read(universitiesProvider.notifier).getUniversities();
                });
                return const LoadingWidget();
              },
              onLoading: () => const LoadingWidget(),
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
                    const Padding(padding: EdgeInsets.all(8.0), child: LoadingWidget()),
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

