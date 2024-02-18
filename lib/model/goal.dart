class Goal {
  DateTime startDate;
  DateTime endDate;
  double budget;
  List<String>? categories;

  Goal(this.startDate, this.endDate, this.budget, this.categories);

  factory Goal.fromJson(dynamic json) {
    return Goal(
      json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : DateTime.utc(1, 1, 1),
      json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : DateTime.utc(1, 1, 1),
      double.tryParse(json['budget']) ?? 0,
      json['categories'] as List<String>?,
    );
  }
}
