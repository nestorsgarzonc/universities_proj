import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universities_proj/universities/models/university_model.dart';
import 'package:universities_proj/universities/ui/widgets/item_tile.dart';

class UniversityDetailScreen extends ConsumerStatefulWidget {
  const UniversityDetailScreen({required this.university, super.key});

  final UniversityModel university;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UniversityDetailScreenState();
}

class _UniversityDetailScreenState extends ConsumerState<UniversityDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.university.name)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Información general',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ItemTile(title: 'Pais:', subtitle: widget.university.country),
                ItemTile(title: 'Abreviación:', subtitle: widget.university.alphaTwoCode),
                ItemTile(title: 'Estado:', subtitle: widget.university.stateProvince ?? 'N/A'),
                ItemTileUrl(title: 'Paginas web:', pages: widget.university.webPages),
                ItemTileUrl(title: 'Dominios:', pages: widget.university.domains),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                const Text(
                  'Numero de estudiantes:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _textController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese un valor';
                      }
                      return null;
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Ingresa el número de estudiantes',
                      hintText: 'Ejemplo: 10000',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Sube una foto o toma una foto:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                if (image == null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _handleOnAddPhoto(ImageSource.camera),
                        child: const Text('Subir foto'),
                      ),
                      ElevatedButton(
                        onPressed: () => _handleOnAddPhoto(ImageSource.gallery),
                        child: const Text('Tomar foto'),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      Image.file(File(image!.path), width: MediaQuery.of(context).size.width * 0.7),
                      ElevatedButton(
                        onPressed: () => setState(() => image = null),
                        child: const Text('Eliminar foto'),
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _handleOnSubmit,
              child: const Text('Enviar'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleOnSubmit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop();
  }

  void _handleOnAddPhoto(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image != null) setState(() => this.image = image);
  }
}
