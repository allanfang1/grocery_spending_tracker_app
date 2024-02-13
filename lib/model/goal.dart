class Goal {
  DateTime? startDate;
  DateTime? endDate;
  double? budget;
  List<String>? categories;

  Goal(this.startDate, this.endDate, this.budget, this.categories);

  factory Goal.fromJson(dynamic json) {
    return Goal(
      json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      double.tryParse(json['budget']),
      json['categories'] as List<String>?,
    );
  }
}
