/// Represents a goal in the application.
class Goal {
  int goalId;
  String goalName;
  String goalDescription;
  DateTime startDate;
  DateTime endDate;
  double budget;
  List<String>? categories;

  /// Constructor for creating a Goal object.
  Goal(this.goalId, this.goalName, this.goalDescription, this.startDate,
      this.endDate, this.budget, this.categories);

  /// Factory method to create a Goal object from JSON data.
  factory Goal.fromJson(dynamic json) {
    return Goal(
      json['goal_id'] as int,
      json['goal_name'] != null ? json['goal_name'] as String : "",
      json['goal_desc'] != null ? json['goal_desc'] as String : "bob",
      json['start_date'] != null
          ? DateTime.tryParse(json['start_date']) ?? DateTime.utc(1, 1, 1)
          : DateTime.utc(1, 1, 1),
      json['end_date'] != null
          ? DateTime.tryParse(json['end_date']) ?? DateTime.utc(1, 1, 1)
          : DateTime.utc(1, 1, 1),
      json['budget'] != null ? double.tryParse(json['budget']) ?? 0 : 0,
      json['categories'] as List<String>?,
    );
  }
}
