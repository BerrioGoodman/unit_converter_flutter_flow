class ConversionHistory {
  final String type; //Tipo de conversión: longitud, peso, temperatura
  final double inputValue; //Valor de entrada
  final String fromUnit; //Unidad inicial
  final String toUnit; //Unidad final
  final double result; //valor convertido
  final DateTime timestamp; //cuando se realizó la conversión

  // Constructor para inicializar los campos
  ConversionHistory({
    required this.type,
    required this.inputValue,
    required this.fromUnit,
    required this.toUnit,
    required this.result,
    required this.timestamp,
  });

  //Guardar como JSON y eso es útil para almacenamiento
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

  // Permite volver a crear un objeto desde JSON - para poder poner esto en el historial de la app
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

  //Muesta el historial de conversiones en un formato legible
  @override
  String toString() {
    return '$inputValue $fromUnit → $result $toUnit (${timestamp.toString().split('.')[0]})';
  }
}