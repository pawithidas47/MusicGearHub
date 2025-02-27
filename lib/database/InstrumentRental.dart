import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:account/model/digital_instrument.dart';
import 'package:account/model/instrument_rental.dart';

class InstrumentDB {
  static final InstrumentDB instance = InstrumentDB._internal();
  static Database? _database;
  final String dbName = 'instrument_rentals.db';

  InstrumentDB._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDir.path, dbName);
    return await databaseFactoryIo.openDatabase(dbLocation);
  }

  // ✅ เพิ่มเครื่องดนตรีเข้า database
  Future<int> insertInstrument(DigitalInstrument instrument) async {
    var db = await database;
    var store = intMapStoreFactory.store('instruments');
    return await store.add(db, {
      'name': instrument.name,
      'type': instrument.type,
      'brand': instrument.brand,
      'pricePerDay': instrument.pricePerDay,
    });
  }

  // ✅ โหลดข้อมูลเครื่องดนตรีทั้งหมด
  Future<List<DigitalInstrument>> loadAllInstruments() async {
    var db = await database;
    var store = intMapStoreFactory.store('instruments');
    var instrumentSnapshot = await store.find(db);

    return instrumentSnapshot.map((record) {
      return DigitalInstrument(
        instrumentID: record.key,
        name: record['name'].toString(),
        type: record['type'].toString(),
        brand: record['brand'].toString(),
        pricePerDay: double.tryParse(record['pricePerDay'].toString()) ?? 0.0,
         imagePath: 'assets/images/default.jpg',
      );
    }).toList();
  }

  // ✅ เพิ่มข้อมูลการเช่า
  Future<int> insertRental(InstrumentRental rental) async {
    var db = await database;
    var store = intMapStoreFactory.store('rentals');

    return await store.add(db, {
      'instrumentID': rental.instrument.instrumentID,
      'renterName': rental.renterName,
      'renterPhone': rental.renterPhone,
      'startDate': rental.startDate.toIso8601String(),
      'endDate': rental.endDate.toIso8601String(),
      'rentalDays': rental.rentalDays,
      'totalCost': rental.totalCost,
    });
  }

  // ✅ โหลดข้อมูลการเช่าทั้งหมด พร้อม debug logs
  Future<List<InstrumentRental>> loadAllRentals() async {
    var db = await database;
    var rentalStore = intMapStoreFactory.store('rentals');
    var instrumentStore = intMapStoreFactory.store('instruments');

    var rentalSnapshot = await rentalStore.find(db);
    var instrumentSnapshot = await instrumentStore.find(db);

    print("📦 Rentals loaded: ${rentalSnapshot.length}");
    print("🎸 Instruments loaded: ${instrumentSnapshot.length}");

    // Map เครื่องดนตรีจาก DB
    Map<int, DigitalInstrument> instrumentMap = {
      for (var record in instrumentSnapshot)
        record.key: DigitalInstrument(
          instrumentID: record.key,
          name: record['name'].toString(),
          type: record['type'].toString(),
          brand: record['brand'].toString(),
          pricePerDay: double.tryParse(record['pricePerDay'].toString()) ?? 0.0,
           imagePath: 'assets/images/key.jpg',
        )
    };

    print("🎵 instrumentMap Keys: ${instrumentMap.keys}");

    return rentalSnapshot.map((record) {
      final instrumentID = record['instrumentID'] as int?;
      final instrument = instrumentID != null ? instrumentMap[instrumentID] : null;

      if (instrument == null) {
        print("⚠️ ไม่พบเครื่องดนตรีที่มี ID: $instrumentID");
        return null; // ข้ามค่าที่ไม่มีเครื่องดนตรี
      }

      return InstrumentRental(
        rentalID: record.key,
        instrument: instrument,
        renterName: record['renterName'].toString(),
        renterPhone: record['renterPhone'].toString(),
        startDate: DateTime.tryParse(record['startDate'].toString()) ?? DateTime.now(),
        endDate: DateTime.tryParse(record['endDate'].toString()) ?? DateTime.now(),
        rentalDays: int.tryParse(record['rentalDays'].toString()) ?? 0,
        totalCost: double.tryParse(record['totalCost'].toString()) ?? 0.0,
      );
    }).whereType<InstrumentRental>().toList();
  }

  // ✅ ลบข้อมูลการเช่า
  Future<void> deleteRental(int rentalID) async {
    var db = await database;
    var store = intMapStoreFactory.store('rentals');
    await store.delete(db, finder: Finder(filter: Filter.byKey(rentalID)));
  }

  // ✅ อัปเดตข้อมูลการเช่า (แก้ไข)
  Future<void> updateRental(InstrumentRental rental) async {
    var db = await database;
    var store = intMapStoreFactory.store('rentals');
    await store.update(
      db,
      {
        'instrumentID': rental.instrument.instrumentID,
        'renterName': rental.renterName,
        'renterPhone': rental.renterPhone,
        'startDate': rental.startDate.toIso8601String(),
        'endDate': rental.endDate.toIso8601String(),
        'rentalDays': rental.rentalDays,
        'totalCost': rental.totalCost,
      },
      finder: Finder(filter: Filter.byKey(rental.rentalID)),
    );
  }

  // ✅ ลบข้อมูลเครื่องดนตรี
  Future<void> deleteInstrument(int instrumentID) async {
    var db = await database;
    var store = intMapStoreFactory.store('instruments');
    await store.delete(db, finder: Finder(filter: Filter.byKey(instrumentID)));
  }
}
