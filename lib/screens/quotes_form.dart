import 'package:flutter/material.dart';
import 'package:readme_mobile/widgets/left_drawer.dart';
// import 'package:mytoko_stok/main.dart';
// import 'package:mytoko_stok/widgets/models.dart';

class QuotesFormPage extends StatefulWidget {
    const QuotesFormPage({super.key});

    @override
    State<QuotesFormPage> createState() => _QuotesFormPageState();
}

class _QuotesFormPageState extends State<QuotesFormPage> {
  final _formKey = GlobalKey<FormState>();
  //variabel untuk menyimpan input setiap field
  String _quotes = "";
  int _amount = 0;
  String _description = ""; 
  final _date = DateTime.now();
    @override
    Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text(
                'Daftarkan Item yang Ingin Kamu Simpan',
              ),
            ),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
          // Menambahkan drawer yang sudah dibuat
          drawer: const LeftDrawer(),
          body: Form( //tempat input field
          key: _formKey, //handler dari form state, validasi form, dan penyimpanan form
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Isi dengan quotes favoritmu!",
                        labelText: "Isi Quotes",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (String? value) { //handle setiap perubahan isi form
                        setState(() {
                          _quotes = value!;
                        });
                      },
                      validator: (String? value) { //validasi isi
                        if (value == null || value.isEmpty) {
                          return "Nama tidak boleh kosong!";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Isi jumlah barang yang ingin kamu simpan", 
                        labelText: "Jumlah",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _amount = int.parse(value!);
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Jumlah item tidak boleh kosong!";
                        }
                        if (int.tryParse(value) == null) {
                          return "Jumlah item harus berupa angka!";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Isi deskripsi stok barang yang ingin kamu simpan",
                        labelText: "Deskripsi",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _description = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Deskripsi tidak boleh kosong!";
                        }
                        return null;
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.indigo),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Item newItem = Item(
                            //   namaItem: _name,
                            //   amountItem: _amount, 
                            //   description: _description, 
                            //   dateAdded: _date
                            // );
                            // listItem.add(newItem);
                            showDialog(context: context,
                             builder: (context) {
                              return AlertDialog(
                                title: const Text('Item berhasil disimpan ke dalam stok'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: 
                                      CrossAxisAlignment.start,
                                    children: [
                                      //munculin value
                                      Text('Nama: $_quotes'),
                                      Text('Jumlah: $_amount'),
                                      Text('Deskripsi: $_description'),
                                      Text('Item added: $_date')
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                             });
                             _formKey.currentState!.reset();
                          }
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
            ),
          ),
        ),
      );
    }
}