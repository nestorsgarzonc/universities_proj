part of '../home_screen.dart';

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
