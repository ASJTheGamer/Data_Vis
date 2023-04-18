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
    return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();

              if (result != null) {
                PlatformFile file = result.files.first;

                print(file.name);
                print(file.bytes);
                print(file.size);
                print(file.extension);
                print(file.path);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Charts(file.path.toString())),
                );
              } else {
                // User canceled the picker
              }
            },
            child: Text("Open"),

          ),
        ),
    );
  }
}
