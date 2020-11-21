import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
import 'package:flutter_mobile_vision_example/main.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;

class Style {
  static final baseTextStyle = const TextStyle(fontFamily: 'Poppins');
  static final smallTextStyle = baseTextStyle.copyWith(
    fontSize: 7.0,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF12457A),
  );

  static final commonTextStyle = baseTextStyle.copyWith(
    color: const Color(0xffffffff), //colotr letra
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
  );
  static final commonTextStyle2 = baseTextStyle.copyWith(
      color: const Color(0xFF12457A), //colotr letra
      fontSize: 12.0,
      fontWeight: FontWeight.w400);
  static final commonTextStyle3 = baseTextStyle.copyWith(
      color: const Color(0xFF12457A), //colotr letra
      fontSize: 7.0,
      fontWeight: FontWeight.w400);
  static final titleTextStyle = baseTextStyle.copyWith(
      color: const Color(0xFF12457A), //colotr letra TITULO
      fontSize: 16.0,
      fontWeight: FontWeight.w600);
  static final headerTextStyle = baseTextStyle.copyWith(
      color: const Color(0xFFF7B234),
      fontSize: 18.0,
      fontWeight: FontWeight.w400);
}

Container _getToolbar(BuildContext context) {
  return new Container(
    margin: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
    child: new BackButton(color: Colors.white),
  );
}

class Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: new EdgeInsets.symmetric(vertical: 5.0),
        height: 2.0,
        width: 18.0,
        color: new Color(0xFFF7B234));
  }
}

class PlanetSummary extends StatelessWidget {
  final bool horizontal;
  final Libros libro;

  PlanetSummary(this.libro, {this.horizontal = true});

  @override
  Widget build(BuildContext context) {
    final planetThumbnail = new Container(
      margin: new EdgeInsets.symmetric(vertical: 16.0),
      alignment:
          horizontal ? FractionalOffset.centerLeft : FractionalOffset.center,
      child:
          /* new Hero(
        tag: "planet-hero-${libro.codLibro}",
        child: */
          new Image(
        image: new NetworkImage(libro.imagen),
        height: 72.0,
        width: 92.0,
      ),
      /*),*/
    );

    Widget _planetValue({String value, Icon icono}) {
      return new Container(
        child: new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          icono,
          //new Image.asset(image, height: 12.0),
          new Container(width: 8.0),
          new Text(
            value,
            style: Style.commonTextStyle2,
          ),
        ]),
      );
    }

    final planetCardContent = new Container(
      margin:
          new EdgeInsets.fromLTRB(horizontal ? 76.0 : 16.0, 16.0, 16.0, 12.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment:
            horizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: <Widget>[
          new AutoSizeText(
            libro.nombre.trim(),
            style: Style.titleTextStyle,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          new Separator(),
          _planetValue(
            value: libro.autor.trim(),
            icono: Icon(
              Icons.person_outline,
              color: azulUPS,
              size: 12.0,
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                  //Text(planet.distance,style: Style.commonTextStyle3),
                  flex: horizontal ? 1 : 0,
                  child: _planetValue(
                    value: libro.fechaPublicacion.trim(),
                    icono: Icon(
                      Icons.date_range,
                      color: azulUPS,
                      size: 10.0,
                    ),
                  )),
              new Container(
                width: 8.0,
              ),
              new Expanded(
                  flex: horizontal ? 1 : 0,
                  child: _planetValue(
                    value: libro.idioma.trim(),
                    icono: Icon(
                      Icons.language,
                      color: azulUPS,
                      size: 10.0,
                    ),
                  )),
            ],
          ),
          new Separator(),
          new Expanded(
            flex: 1,
            child: new SingleChildScrollView(
              child: Text(
                libro.descripcion,
                style: Style.commonTextStyle2,
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );

    final planetCard = new Container(
      child: planetCardContent,
      height: horizontal ? 154.0 : 223.0,
      margin: horizontal
          ? new EdgeInsets.only(left: 10.0)
          : new EdgeInsets.only(top: 7.0),
      decoration: new BoxDecoration(
        color: new Color(0xFFf5f5f5), //color del card
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
    );

    return /*new GestureDetector(
        onTap: horizontal
            ? () => Navigator.of(context).push(
                  new PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        new OcrTextDetail(ocrText), //DetailPage(libro),
                    transitionsBuilder: (context, animation, secondaryAnimation,
                            child) =>
                        new FadeTransition(opacity: animation, child: child),
                  ),
                )
            : null,
        child: */
        new Container(
      margin: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      child: new Stack(
        children: <Widget>[
          planetCard,
          //planetThumbnail,
        ],
      ),
    );
    //);
  }
}

//FIN DE PAGE 2

class OcrTextDetail extends StatefulWidget {
  final OcrText ocrText;

  OcrTextDetail(this.ocrText);

  @override
  _OcrTextDetailState createState() => new _OcrTextDetailState();
}

class _OcrTextDetailState extends State<OcrTextDetail> {
  //final OcrText ocrText;

  Future<http.Response> fetchPost(String dato) {
    return http
        //.get('https://booksrecognition.azurewebsites.net/consultaLibro.php?nombre=$dato');
        //.get('https://apiqa.facturero.com.ec/consultar_libros?dato=$dato');
        .get('http://ec2-13-59-126-166.us-east-2.compute.amazonaws.com/?data=$dato');
  }

  Future<List<Libros>> dataListLibro() async {
    List<Libros> mapData = new List<Libros>();
    await fetchPost(widget.ocrText.value).then((onValue) {

      for (var i = 0; i < json.decode(onValue.body).length; i++) {
        mapData.add(Libros.fromMappedJson(json.decode(onValue.body)[i]));
      }
      //}
    }).catchError((onError) {
      print(onError.toString());
    });

    return mapData;
  }

  Widget _pagCargando() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: amarilloUPS,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        constraints: new BoxConstraints.expand(),
        color: new Color(0xFF12457A),
        child: new Stack(
          children: <Widget>[
            _getBackground(),
            _getGradient(),
            _getContent(context),
            _getToolbar(context),
          ],
        ),
      ),
    );
  }

  Container _getBackground() {
    return new Container(
      child: new Image.asset(
        'assets/img/wallpaper_libro.jpg',
        fit: BoxFit.cover,
        height: 300.0,
      ),
      constraints: new BoxConstraints.expand(height: 295.0),
    );
  }

  Container _getGradient() {
    return new Container(
      margin: new EdgeInsets.only(top: 295.0),
      height: 110.0,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: <Color>[new Color(0xffb8d6f4), new Color(0xFF12457A)],
          stops: [0.0, 0.9],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        ),
      ),
    );
  }

  Widget _getContent(BuildContext context) {
    List<Libros> data = new List<Libros>();
    //String dato = widget.ocrText.value;
    return FutureBuilder(
      future: dataListLibro(),
      initialData: data,
      builder: (BuildContext context, AsyncSnapshot<List<Libros>> snapshot) {
        List<Libros> value = snapshot.data;
        if (snapshot.hasData && snapshot.data != null) {
          //print('project snapshot data is: ${projectSnap.data}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _pagCargando();
          } else {
            if (value.length == 0) {
              data.add(Libros('1', 'Libro no existe', 'Pruebe con otro texto', '', '', '', '', ''));
              return Container(
                child: new ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return PlanetSummary(
                        data[index],
                        horizontal: false,
                      );
                    }
                  ),
              );
              /*return Center(
                  child: Text(
                  'Lo sentimos, registro no encontrado.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                )
              );*/
            } else {
              return Container(
                child: new ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return PlanetSummary(
                        value[index],
                        horizontal: false,
                      );
                    }),
              );
            }
          }
        } else {
          return _pagCargando();
        }
      },
    );
  }

}

class Libros {
  final String codLibro;
  final String nombre;
  final String descripcion;
  final String autor;
  final String imagen;
  final String idioma;
  final String fechaPublicacion;
  final String tema;

  Libros(this.codLibro, this.nombre, this.descripcion, this.autor, this.imagen,
      this.idioma, this.fechaPublicacion, this.tema);

  Libros.fromMappedJson(Map<String, dynamic> json)
      : codLibro = json['cod_libro'],
        nombre = json['nombre'],
        descripcion = json['descripcion'],
        autor = json['autor'],
        imagen = json['imagen'],
        idioma = json['idioma'],
        fechaPublicacion = json['fecha_publicacion'],
        tema = json['tema'];

  Map<String, dynamic> toJson() => {
        'cod_libro': codLibro,
        'nombre': nombre,
        'descripcion': descripcion,
        'autor': autor,
        'imagen': imagen,
        'idioma': idioma,
        'fecha_publicacion': fechaPublicacion,
        'tema': tema
      };
}
