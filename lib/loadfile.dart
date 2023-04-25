import 'package:data_vis/main.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class Load extends StatelessWidget {
  const Load({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: loadfile(),
    );
  }
}

class loadfile extends StatefulWidget {
  const loadfile({Key? key}) : super(key: key);

  @override
  State<loadfile> createState() => _loadfileState();
}

class _loadfileState extends State<loadfile> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result =
                  await FilePicker.platform.pickFiles();

                  if (result != null) {
                    PlatformFile file = result.files.first;

                    print(file.name);
                    print(file.bytes);
                    print(file.size);
                    print(file.extension);
                    print(file.path);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Charts(file.path.toString())),
                    );
                  } else {
                    // User canceled the picker
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.folder_open),
                    SizedBox(width: 8),
                    Text("Open"),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                "This is an application made by Atharva Jadhav(2020BTEME00014)",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
