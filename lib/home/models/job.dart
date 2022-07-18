class Job {
  Job({required this.name, required this.ratePerHour});
  final String name;
  final int ratePerHour;
  // Factory Constructor when implementing a constructor that doesn’t always create a new instance of its class
  factory Job.fromMap(Map<String, dynamic> data) {
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    return Job(name: name, ratePerHour: ratePerHour);
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }
}
