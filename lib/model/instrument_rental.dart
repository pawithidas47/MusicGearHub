import 'package:account/model/digital_instrument.dart';

class InstrumentRental {
  final int? rentalID;
  final DigitalInstrument instrument;
  final String renterName;
  final String renterPhone;
  final DateTime startDate;
  final DateTime endDate;
  final int rentalDays;
  final double totalCost;

  InstrumentRental({
    required this.rentalID,
    required this.instrument,
    required this.renterName,
    required this.renterPhone,
    required this.startDate,
    required this.endDate,
    required this.rentalDays,
    required this.totalCost,
  });

  factory InstrumentRental.fromMap(Map<String, dynamic> record, Map<int, DigitalInstrument> instrumentMap) {
    int instrumentID = record['instrumentID'] as int? ?? -1;
    print("🔎 rental instrumentID: $instrumentID");

    final instrument = instrumentMap[instrumentID] ?? DigitalInstrument(
      instrumentID: -1,
      name: "Unknown",
      type: "Unknown",
      brand: "Unknown",
      pricePerDay: 0.0,
      imagePath: 'assets/images/default.jpg', // ✅ ป้องกัน null
    );

    return InstrumentRental(
      rentalID: record['rentalID'] as int?,
      instrument: instrument,
      renterName: record['renterName']?.toString() ?? "Unknown",
      renterPhone: record['renterPhone']?.toString() ?? "Unknown",
      startDate: DateTime.tryParse(record['startDate'].toString()) ?? DateTime.now(),
      endDate: DateTime.tryParse(record['endDate'].toString()) ?? DateTime.now(),
      rentalDays: int.tryParse(record['rentalDays'].toString()) ?? 0,
      totalCost: double.tryParse(record['totalCost'].toString()) ?? 0.0,
    );
  }
}
