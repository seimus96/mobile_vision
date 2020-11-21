import 'dart:async';
import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_mobile_vision_example/splash_screen.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
import 'package:flutter_mobile_vision_example/ocr_text_detail.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:http/http.dart' as http;

var routes = <String, WidgetBuilder>{
  "/home": (BuildContext context) => MyApp(),
};
Future<void> main() async => runApp(new MaterialApp(
      theme: ThemeData(
          primaryColor: amarilloUPS,
          accentColor: azulUPS,
          canvasColor: azulUPS),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: routes,
    ));

//Color Azul
Map<int, Color> colorAzul = {
  50: Color.fromRGBO(18, 69, 122, .1),
  100: Color.fromRGBO(18, 69, 122, .2),
  200: Color.fromRGBO(18, 69, 122, .3),
  300: Color.fromRGBO(18, 69, 122, .4),
  400: Color.fromRGBO(18, 69, 122, .5),
  500: Color.fromRGBO(18, 69, 122, .6),
  600: Color.fromRGBO(18, 69, 122, .7),
  700: Color.fromRGBO(18, 69, 122, .8),
  800: Color.fromRGBO(18, 69, 122, .9),
  900: Color.fromRGBO(18, 69, 122, 1),
};

MaterialColor azulUPS = MaterialColor(0xFF12457A, colorAzul); //12457A

//Color Amrillo
Map<int, Color> colorAmarillo = {
  50: Color.fromRGBO(247, 178, 52, .1),
  100: Color.fromRGBO(247, 178, 52, .2),
  200: Color.fromRGBO(247, 178, 52, .3),
  300: Color.fromRGBO(247, 178, 52, .4),
  400: Color.fromRGBO(247, 178, 52, .5),
  500: Color.fromRGBO(247, 178, 52, .6),
  600: Color.fromRGBO(247, 178, 52, .7),
  700: Color.fromRGBO(247, 178, 52, .8),
  800: Color.fromRGBO(247, 178, 52, .9),
  900: Color.fromRGBO(247, 178, 52, 1),
};

MaterialColor amarilloUPS = MaterialColor(0xFFF7B234, colorAmarillo); //F7B234

//Inicio de la app
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _cameraOcr =
      FlutterMobileVision.CAMERA_BACK; //FlutterMobileVision.CAMERA_FRONT
  bool _autoFocusOcr = true;
  bool _torchOcr = false;
  bool _multipleOcr = true;
  bool _waitTapOcr = true;
  bool _showTextOcr = true;
  Size _previewOcr;
  List<OcrText> _textsOcr = [];

  @override
  void initState() {
    super.initState();
    FlutterMobileVision.start().then((previewSizes) => setState(() {
          _previewOcr = previewSizes[_cameraOcr].first;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: azulUPS,
        buttonColor: amarilloUPS,
      ),
      home: new DefaultTabController(
        length: 1,
        child: new Scaffold(
          backgroundColor: Color.fromRGBO(28, 69, 112, 1.0),
          appBar: new AppBar(
            /* bottom: new TabBar(
                indicatorColor: amarilloUPS,
                labelColor: amarilloUPS,
                tabs: [
                  new Tab(text: 'OCR'),
                ],
              ) ,*/
            title: new Text(
              "Book's Recognition",
              style: TextStyle(color: amarilloUPS),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _read,
            child: Icon(
              Icons.remove_red_eye,
              color: azulUPS,
            ),
            backgroundColor: amarilloUPS,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: new TabBarView(children: [
            _getOcrScreen(context),
          ]),
        ),
      ),
    );
  }

  // Camera list
  List<DropdownMenuItem<int>> _getCameras() {
    List<DropdownMenuItem<int>> cameraItems = [];

    cameraItems.add(new DropdownMenuItem(
      child: new Text('Trasera'),
      value: FlutterMobileVision.CAMERA_BACK,
    ));

    cameraItems.add(new DropdownMenuItem(
      child: new Text('Frontal'),
      value: FlutterMobileVision.CAMERA_FRONT,
    ));

    return cameraItems;
  }

  ///
  /// Preview sizes list
  ///
  List<DropdownMenuItem<Size>> _getPreviewSizes(int facing) {
    List<DropdownMenuItem<Size>> previewItems = [];

    List<Size> sizes = FlutterMobileVision.getPreviewSizes(facing);

    if (sizes != null) {
      sizes.forEach((size) {
        previewItems.add(
          new DropdownMenuItem(
            child: new Text(size.toString()),
            value: size,
          ),
        );
      });
    } else {
      previewItems.add(
        new DropdownMenuItem(
          child: new Text('Empty'),
          value: null,
        ),
      );
    }

    return previewItems;
  }

  List<String> instrucciones = [
    "1. Presionar en el boton",
    "",
    "2. Esperar que se detecten los textos",
    "",
    "3. Presionar en la pantalla para capturar todos los textos reconocidos",
    "",
    "4. Seleccionar el texto que desea buscar",
    "",
    "5. Disfrutar de la información del libro",
    "",
  ];

  // OCR Screen
  Widget _getOcrScreen(BuildContext context) {
    List<Widget> items = [];

    items.add(new Padding(
      padding: const EdgeInsets.only(
        top: 1.0, //75.0,
        left: 1.0, //18.0,
        right: 1.0, //18.0,
        bottom: 1.0, //75.0,
      ),
      child: Container(
        height: 250.0,
        child: Image.asset(
          'assets/img/scan_text.png',
          color: amarilloUPS,
        ),
      ),
    ));
/*
    items.add(
      new Padding(
          padding: const EdgeInsets.only(
            left: 40.0,
            right: 40.0,
          ),
          child: Container(
            child: new Text('Elija resolucion de camara.',
                style: TextStyle(
                    color: Colors.white, //Color.fromRGBO(0, 59, 70, 1),
                    fontSize: 17.0)),
          )),
    );
    items.add(new Padding(
      padding: const EdgeInsets.only(
        left: 40.0,
        right: 40.0,
      ),
      child: new DropdownButton(
        items: _getPreviewSizes(_cameraOcr),
        style: TextStyle(color: amarilloUPS, fontSize: 20),
        iconSize: 40.0,
        isExpanded: true,
        iconEnabledColor: amarilloUPS,
        elevation: 10,
        onChanged: (value) {
          setState(() => _previewOcr = value);
        },
        value: _previewOcr,
      ),
    ));*/
/*
    items.add(
      new Padding(
        padding: const EdgeInsets.only(
          left: 25.0,
          right: 25.0,
          bottom: 12.0,
        ),
        child: new RaisedButton(
          //color: Colors.blueGrey,
          onPressed: _read,
          child: new Text(
            'Reconocer', /*style: TextStyle(color: Colors.white),*/
          ),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0),
          ),
        ),
      ),
    );*/

    if (_textsOcr.length == 0) {
      items.add(
        Padding(
          padding: const EdgeInsets.only(
            top: 12.0,
            left: 25.0,
            right: 25.0,
            bottom: 12.0,
          ),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 12.0,
                left: 5.0,
                right: 5.0,
                bottom: 12.0,
              ),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: instrucciones.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Text(
                      instrucciones[index],
                      style: TextStyle(
                        color: Colors.white, //Color.fromRGBO(0, 59, 70, 1),
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
            ),
          ),
        ),
      );
    } else {
      items.addAll(
        ListTile.divideTiles(
          context: context,
          tiles: _textsOcr
              .map(
                (ocrText) => new OcrTextWidget(ocrText),
              )
              .toList(),
        ),
      );
    }

    return new ListView(
      padding: const EdgeInsets.only(
        top: 12.0,
      ),
      children: items,
      shrinkWrap: true,
    );
  }

  ///
  /// OCR Method
  ///
  Future<Null> _read() async {
    //read de ocr
    List<OcrText> texts = [];
    try {
      texts = await FlutterMobileVision.read(
        flash: _torchOcr,
        autoFocus: _autoFocusOcr,
        multiple: _multipleOcr,
        waitTap: _waitTapOcr,
        showText: _showTextOcr,
        preview: _previewOcr,
        camera: _cameraOcr,
        fps: 3.0,
      );
    } on PlatformException catch (e) {
      //texts.add(new OcrText('Failed to recognize text.'));
      //TO_DO Agregar alerta
      if (e.code.toString() ==
          'Intent is null (the camera permission may not be granted)') {
        Alert(
          context: context,
          type: AlertType.warning,
          title: "Permiso de acceso denegado",
          desc:
              "Estimado(a) usuario por favor active los permisos de su camara.",
          buttons: [
            DialogButton(
              child: Text(
                "Aceptar",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
        //pedirPermiso;
      } else {
        if (e.code.toString() != 'No text recognized, intent data is null') {
          _showDialog();
        }
      }
    }

    if (!mounted) return;

    setState(() => _textsOcr = texts);
  }

  void _showDialog() {
    // flutter defined function
    Alert(
      context: context,
      type: AlertType.error,
      title: "ERROR",
      desc: "Algo anda mal, intentelo mas tarde.",
      buttons: [
        DialogButton(
          child: Text(
            "Aceptar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }
}

// OcrTextWidget
class OcrTextWidget extends StatelessWidget {
  final OcrText ocrText;

  OcrTextWidget(this.ocrText);
  Future<http.Response> fetchPost(String dato) {
    try {
      return http
          //.get('https://apiqa.facturero.com.ec/consultar_libros?dato=$dato');
          //.get('https://booksrecognition.azurewebsites.net/consultaLibro.php?nombre=$dato');
          .get('http://ec2-13-59-126-166.us-east-2.compute.amazonaws.com/?data=$dato');
    } catch (e) {
      http.Client().close();
      return null;
    }
  }

  _onTimeout() => http.Client().close();
  Future<bool> dataMapLibro() async {
    bool mapData = false;
    var info;
    await fetchPost(ocrText.value).then((onValue) {
      info = json.decode(onValue.body).length;
      //print(info);
      if (info.toString() != '0') {
        mapData = true;
      } else {
        mapData = false;
        http.Client().close();
      }
    }).catchError((onError) {
      print(onError.toString());
    }).timeout(const Duration(seconds: 30), onTimeout: () => _onTimeout());
    return mapData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: dataMapLibro(),
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        //Color c;
        Icon avanzar;
        if (snapshot.data) {
          //c = const Color(0xFF32CD32); //const Color(0xFFBDEFFA); //
          avanzar = Icon(
            Icons.arrow_forward,
            color: Color(0xFF32CD32),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          //c = const Color(0xFFDEDDDD);
          avanzar = Icon(
            Icons.restore,
            color: Color(0xFFDEDDDD),
          );
        } else {
          //c = const Color(0xFFF08080);//const Color(0xFFFEC96C); //
          avanzar = Icon(
            Icons.not_interested,
            color: Color(0xFFF08080),
          );
        }
        void navegar() {
          if (snapshot.data) {
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (context) => new OcrTextDetail(ocrText),
              ),
            );
          }
        }

        return Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15.0,
          ),
          child: new Card(
            child: InkWell(
              onTap: navegar,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 55.0,
                          height: 55.0,
                          child: CircleAvatar(
                            backgroundColor: Color.fromRGBO(222, 221, 221, 1.0),
                            foregroundColor: Colors.black,
                            child: Icon(
                              Icons.library_books,
                              size: 30.0,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          ocrText.value,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: azulUPS,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      child: avanzar,
                    ),
                  ],
                ),
              ),
            ),
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.0),
            ),
          ),
        );
      },
    );
  }
}