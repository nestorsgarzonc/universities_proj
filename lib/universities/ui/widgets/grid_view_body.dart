part of '../home_screen.dart';

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
