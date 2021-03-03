
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cargar archivos',
      theme: ThemeData(        
        primarySwatch: Colors.blue,        
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(        
        title: Text(widget.title),
      ),
      body: Center(
        
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            RaisedButton(onPressed: () => _cargaArchivo(),
              child: Text("Agregar archivo")),
          ],
        ),
      ),      
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _cargaArchivo() async {

        FilePickerResult result = await FilePicker.platform.pickFiles();

        if(result != null) {
          PlatformFile file = result.files.first;
          
          print(file.name);
          print(file.bytes);
          print(file.size);
          print(file.extension);
          print(file.path);         
          var url = 'https://TUURL/cargar.php';          
          var postUri = Uri.parse(url);
          var request = http.MultipartRequest('POST', postUri);
          request.files.add(await http.MultipartFile.fromPath("archivo", file.path));
          var res = await request.send().then((response){
            http.Response.fromStream(response).then((onValue){
              print(response.statusCode);                             
            });
          });
          print(res.reasonPharse);          
          return res.reasonPhrase;
        } else {
          // Usuario cancela carga
        }
 }

  
  Future<String> uploadImage(url, path) async {
          //var request = http.MultipartRequest('POST', Uri.parse(url));
          
          var postUri = Uri.parse(url);
          var request = http.MultipartRequest('POST', postUri);
          request.files.add(await http.MultipartFile.fromPath("archivoCargado", path));
          var res = await request.send().then((response){
            http.Response.fromStream(response).then((onValue){
              try{
                print("awiwi");
              }catch(e){                
                print("caca");
              }
            });
          });
          return res.reasonPhrase;
/*
          var postUri = Uri.parse(url);
          var request = new http.MultipartRequest("POST", postUri);
          //request.fields['user'] = 'blah';
          request.files.add(new http.MultipartFile.fromBytes('file', await File.fromUri(path).readAsBytes(), contentType: new MediaType('image', 'jpeg')))

          request.send().then((response) {
            if (response.statusCode == 200) print("Uploaded!");
          });*/
  }
  
  /*
  Future<Uint8List> _getHtmlFileContent(html.File blob) async {
    Uint8List file;
    final reader = FileReader();
    reader.readAsDataUrl(blob.slice(0, blob.size, blob.type));
    reader.onLoadEnd.listen((event) {
      Uint8List data =
          Base64Decoder().convert(reader.result.toString().split(",").last);
      file = data;
    }).onData((data) {
      file = Base64Decoder().convert(reader.result.toString().split(",").last);
      return file;
    });
    while (file == null) {
      await new Future.delayed(const Duration(milliseconds: 1));
      if (file != null) {
        break;
      }
    }
    return file;
  }*/

}
