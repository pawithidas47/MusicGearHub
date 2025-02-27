import 'package:flutter/foundation.dart';
import 'package:account/model/digital_instrument.dart';
import 'package:account/model/instrument_rental.dart';
import 'package:account/database/instrumentrental.dart'; // ✅ ตรวจสอบว่ามี InstrumentDB หรือไม่

class InstrumentProvider with ChangeNotifier {
  List<DigitalInstrument> instruments = [];
  List<InstrumentRental> rentals = [];

  final InstrumentDB db = InstrumentDB.instance; // ✅ ตรวจสอบให้แน่ใจว่ามี instance

  // ✅ โหลดข้อมูลเครื่องดนตรีทั้งหมด
  Future<void> loadInstruments() async {
    try {
      instruments = await db.loadAllInstruments(); // ✅ ตรวจสอบว่าเมทอดนี้มีอยู่
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading instruments: $e");
    }
  }

  // ✅ โหลดข้อมูลการเช่าทั้งหมด
  Future<void> loadRentals() async {
    try {
      rentals = await db.loadAllRentals();
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading rentals: $e");
    }
  }

  // ✅ โหลดข้อมูลเริ่มต้น (initData)
  Future<void> initData() async {
    await loadInstruments();
    await loadRentals();
  }

  // ✅ เพิ่มเครื่องดนตรีใหม่
  Future<void> addInstrument(DigitalInstrument instrument) async {
    await db.insertInstrument(instrument);
    await loadInstruments(); // โหลดข้อมูลใหม่
  }

  // ✅ เพิ่มข้อมูลการเช่า
  Future<void> addRental(InstrumentRental rental) async {
    await db.insertRental(rental);
    await loadRentals(); // โหลดข้อมูลใหม่
  }

  // ✅ ลบข้อมูลการเช่า
  Future<void> deleteRental(int rentalID) async {
    await db.deleteRental(rentalID);
    await loadRentals(); // โหลดข้อมูลใหม่
  }

  // ✅ อัปเดตข้อมูลการเช่า
  Future<void> updateRental(InstrumentRental rental) async {
    await db.updateRental(rental);
    await loadRentals(); // โหลดข้อมูลใหม่
  }

  // ✅ คืนค่าเครื่องดนตรีทั้งหมด
  List<DigitalInstrument> getInstruments() {
    return instruments;
  }

  // ✅ ลบเครื่องดนตรีตาม `instrument`
  Future<void> deleteInstrument(DigitalInstrument instrument) async {
    try {
      instruments.removeWhere((item) => item.instrumentID == instrument.instrumentID);
      await db.deleteInstrument(instrument.instrumentID!); // ลบจากฐานข้อมูล
      await loadInstruments(); // โหลดข้อมูลใหม่
    } catch (e) {
      debugPrint("Error deleting instrument: $e");
    }
  }

  // ✅ เรียงเครื่องดนตรีที่เพิ่มล่าสุด
  List<DigitalInstrument> get latestInstruments {
    List<DigitalInstrument> sortedList = List.from(instruments);
    sortedList.sort((a, b) => (b.instrumentID ?? 0).compareTo(a.instrumentID ?? 0));
    return sortedList;
  }

  // ✅ เรียงเครื่องดนตรีที่เก่าที่สุด
  List<DigitalInstrument> get oldestInstruments {
    List<DigitalInstrument> sortedList = List.from(instruments);
    sortedList.sort((a, b) => (a.instrumentID ?? 0).compareTo(b.instrumentID ?? 0));
    return sortedList;
  }
}
