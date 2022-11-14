part of '../home_screen.dart';

class _ViewMode extends ConsumerWidget {
  const _ViewMode({required this.onSelect, required this.mode});

  final ValueChanged<VisualizationMode> onSelect;
  final VisualizationMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        const SizedBox(width: 12),
        const Expanded(child: Text('Selecciona el modo de visualización:')),
        IconButton(
          onPressed: () => onSelect(VisualizationMode.list),
          icon: Icon(
            Icons.list,
            color: mode == VisualizationMode.list ? Colors.blue[700] : Colors.grey,
          ),
        ),
        IconButton(
          onPressed: () => onSelect(VisualizationMode.grid),
          icon: Icon(
            Icons.grid_view,
            color: mode == VisualizationMode.grid ? Colors.blue[700] : Colors.grey,
          ),
        ),
      ],
    );
  }
}
