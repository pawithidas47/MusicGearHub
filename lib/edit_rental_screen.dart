import 'package:account/model/instrument_rental.dart';
import 'package:account/provider/instrumentProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditRentalScreen extends StatefulWidget {
  final InstrumentRental rental;

  const EditRentalScreen({super.key, required this.rental});

  @override
  State<EditRentalScreen> createState() => _EditRentalScreenState();
}

class _EditRentalScreenState extends State<EditRentalScreen> {
  final formKey = GlobalKey<FormState>();
  final renterController = TextEditingController();
  final rentalDaysController = TextEditingController();

  @override
  void initState() {
    super.initState();
    renterController.text = widget.rental.renterName;
    rentalDaysController.text = widget.rental.rentalDays.toString();
  }

  void _updateRental() {
    if (formKey.currentState!.validate()) {
      var provider = Provider.of<InstrumentProvider>(context, listen: false);
      int rentalDays = int.parse(rentalDaysController.text);
      double totalCost = widget.rental.instrument.pricePerDay * rentalDays;

      InstrumentRental updatedRental = InstrumentRental(
        rentalID: widget.rental.rentalID,
        instrument: widget.rental.instrument,
        renterName: renterController.text,
        renterPhone: widget.rental.renterPhone, // คงค่าเดิมไว้
        startDate: widget.rental.startDate, // คงค่าเดิมไว้
        endDate: widget.rental.startDate.add(Duration(days: rentalDays)), // คำนวณ endDate ใหม่
        rentalDays: rentalDays,
        totalCost: totalCost,
      );

      provider.updateRental(updatedRental);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'แก้ไขข้อมูลการเช่า',
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
              Text(
                'เครื่องดนตรี: ${widget.rental.instrument.name}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: renterController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อผู้เช่า',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                autofocus: true,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'กรุณากรอกชื่อผู้เช่า';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: rentalDaysController,
                decoration: const InputDecoration(
                  labelText: 'จำนวนวันเช่า',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                keyboardType: TextInputType.number,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกจำนวนวันเช่า';
                  }
                  try {
                    int days = int.parse(value);
                    if (days <= 0) {
                      return 'จำนวนวันเช่าต้องมากกว่า 0';
                    }
                  } catch (e) {
                    return 'กรุณากรอกจำนวนวันที่ถูกต้อง';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _updateRental,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text(
                      'ยืนยัน',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
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
