class ConversionHistory {
  final String type; // 'length', 'weight', 'temperature'
  final double inputValue;
  final String fromUnit;
  final String toUnit;
  final double result;
  final DateTime timestamp;

  ConversionHistory({
    required this.type,
    required this.inputValue,
    required this.fromUnit,
    required this.toUnit,
    required this.result,
    required this.timestamp,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'inputValue': inputValue,
      'fromUnit': fromUnit,
      'toUnit': toUnit,
      'result': result,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create from JSON
  factory ConversionHistory.fromJson(Map<String, dynamic> json) {
    return ConversionHistory(
      type: json['type'],
      inputValue: json['inputValue'],
      fromUnit: json['fromUnit'],
      toUnit: json['toUnit'],
      result: json['result'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  @override
  String toString() {
    return '$inputValue $fromUnit → $result $toUnit (${timestamp.toString().split('.')[0]})';
  }
}