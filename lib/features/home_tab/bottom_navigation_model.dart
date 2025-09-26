class BottomNavigationBarModel {
  final String title;
  final int index;
  final String selectedLight;
  final String deselectedLight;
  final String selectedDark;
  final String deselectedDark;

  BottomNavigationBarModel({
    required this.title,
    required this.index,
    required this.selectedLight,
    required this.deselectedLight,
    required this.selectedDark,
    required this.deselectedDark
  });
}