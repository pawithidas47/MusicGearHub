class DigitalInstrument {
  final int instrumentID;
  final String name;
  final String type;
  final String brand;
  final double pricePerDay;
  final String imagePath;

  DigitalInstrument({
    required this.instrumentID,
    required this.name,
    required this.type,
    required this.brand,
    required this.pricePerDay,
    required this.imagePath,
  });

  factory DigitalInstrument.fromMap(Map<String, dynamic> map) {
    return DigitalInstrument(
      instrumentID: map['instrumentID'] as int? ?? -1,  
      name: map['name']?.toString() ?? "Unknown",
      type: map['type']?.toString() ?? "Unknown",
      brand: map['brand']?.toString() ?? "Unknown",
      pricePerDay: double.tryParse(map['pricePerDay'].toString()) ?? 0.0,  
      imagePath: map['imagePath']?.toString() 
      ?? 'assets/images/default.jpg', // ✅ ป้องกัน null
    );
  }
}
