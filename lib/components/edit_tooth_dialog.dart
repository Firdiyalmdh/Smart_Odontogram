import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odontogram/models/tooth.dart';

class EditToothDialog extends StatelessWidget {
  final Tooth tooth;
  final String selectedCondition;
  final bool isLoading;
  final void Function(String) onSelectCondition;
  final void Function() onSave;
  const EditToothDialog({
    super.key,
    required this.tooth,
    required this.selectedCondition,
    required this.isLoading,
    required this.onSelectCondition,
    required this.onSave
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Material(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      tooth.getTitle(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Image.network(
                      tooth.imagePath,
                      height: 250,
                      width: double.infinity,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Kondisi Gigi"),
                    ),
                    const SizedBox(height: 5),
                    InputDecorator(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 2.0,
                          horizontal: 10,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          value: selectedCondition,
                          items: ToothCondition.values.map((condition) => 
                            DropdownMenuItem(
                              value: condition.name,
                              child: Text(
                                condition.name,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ).toList(),
                          onChanged: (value) {
                            onSelectCondition(value.toString());
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 45),
                              backgroundColor: Colors.grey[100],
                              foregroundColor: Colors.blue[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () { Get.back(); },
                            child: const Text('Batalkan'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 45),
                              backgroundColor: Colors.blue[900],
                              foregroundColor: const Color(0xFFFFFFFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () { onSave(); },
                            child: (isLoading)
                              ? Transform.scale(
                                  scale: .75,
                                  child: const CircularProgressIndicator(
                                      color: Colors.white))
                              : const Text('Simpan'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}