/// How the collection (groups) list is ordered.
enum GroupSort {
  alphabetical,
  measurements,
  date;

  String get label => switch (this) {
        GroupSort.alphabetical => 'Alphabetically',
        GroupSort.measurements => 'Measurements',
        GroupSort.date => 'Date',
      };
}

/// How the flat items (measurements) list is ordered.
enum ItemSort {
  alphabetical,
  date,
  brand;

  String get label => switch (this) {
        ItemSort.alphabetical => 'Alphabetically',
        ItemSort.date => 'Date',
        ItemSort.brand => 'Brand',
      };
}
