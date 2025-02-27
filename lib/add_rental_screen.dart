import 'package:account/model/instrument_rental.dart'; 
import 'package:account/provider/instrumentProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/model/digital_instrument.dart';
import 'package:intl/intl.dart';

class AddRentalScreen extends StatefulWidget {
  const AddRentalScreen({super.key});

  @override
  State<AddRentalScreen> createState() => _AddRentalScreenState();
}

class _AddRentalScreenState extends State<AddRentalScreen> {
  final formKey = GlobalKey<FormState>();
  final renterNameController = TextEditingController();
  final renterPhoneController = TextEditingController();
  DigitalInstrument? selectedInstrument;
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    InstrumentProvider instrumentProvider = Provider.of<InstrumentProvider>(context);
    List<DigitalInstrument> instruments = instrumentProvider.getInstruments();

    // ✅ กำหนดค่าเริ่มต้น ถ้ามีเครื่องดนตรี
    if (selectedInstrument == null && instruments.isNotEmpty) {
      selectedInstrument = instruments.first;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'เพิ่มข้อมูลการเช่า',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (instruments.isNotEmpty) ...[
                DropdownButtonFormField<DigitalInstrument>(
                  decoration: const InputDecoration(
                    labelText: 'เลือกเครื่องดนตรี',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  value: selectedInstrument,
                  items: instruments.map((instrument) {
                    return DropdownMenuItem(
                      value: instrument,
                      child: Text('${instrument.name} (${instrument.brand})'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedInstrument = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'กรุณาเลือกเครื่องดนตรี' : null,
                ),
              ] else
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    '⚠️ ไม่พบเครื่องดนตรีในระบบ กรุณาเพิ่มข้อมูลก่อน',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              TextFormField(
                controller: renterNameController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อผู้เช่า',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอกชื่อผู้เช่า' : null,
              ),
              TextFormField(
                controller: renterPhoneController,
                decoration: const InputDecoration(
                  labelText: 'เบอร์โทรศัพท์',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกเบอร์โทรศัพท์';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text(
                    'วันที่เริ่มเช่า: ${startDate != null ? DateFormat('dd/MM/yyyy').format(startDate!) : 'เลือกวันที่'}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      startDate = picked;
                      if (endDate == null || endDate!.isBefore(startDate!)) {
                        endDate = startDate!.add(const Duration(days: 1));
                      }
                    });
                  }
                },
              ),
              ListTile(
                title: Text(
                    'วันที่สิ้นสุด: ${endDate != null ? DateFormat('dd/MM/yyyy').format(endDate!) : 'เลือกวันที่'}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: endDate ?? startDate ?? DateTime.now(),
                    firstDate: startDate ?? DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      endDate = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: instruments.isEmpty
                        ? null
                        : () {
                            if (formKey.currentState!.validate() &&
                                selectedInstrument != null &&
                                startDate != null &&
                                endDate != null) {
                              var provider = Provider.of<InstrumentProvider>(context,
                                  listen: false);
                              int rentalDays = endDate!.difference(startDate!).inDays;
                              rentalDays = rentalDays == 0 ? 1 : rentalDays;
                              double totalCost =
                                  selectedInstrument!.pricePerDay * rentalDays;

                              InstrumentRental rental = InstrumentRental(
                                rentalID: DateTime.now().millisecondsSinceEpoch,
                                instrument: selectedInstrument!,
                                renterName: renterNameController.text,
                                renterPhone: renterPhoneController.text,
                                startDate: startDate!,
                                endDate: endDate!,
                                rentalDays: rentalDays,
                                totalCost: totalCost,
                              );

                              provider.addRental(rental);
                              Navigator.pop(context);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: instruments.isEmpty ? Colors.grey : Colors.green,
                    ),
                    child: const Text(
                      'เพิ่มข้อมูล',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text(
                      'ยกเลิก',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
