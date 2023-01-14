import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_1/models/predictions.dart';

class HomePage extends StatefulWidget {
  const HomePage ({Key? key}) : super (key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
//cambia el url de okteto a usar
class _HomePageState extends State<HomePage> {
  final url= Uri.parse("https://linear-model-service-obedhipolito.cloud.okteto.net/v1/models/linear-model:predict");
  final headers = {"Content-Type": "application/json"};
  late Future<Predictions> prediction;
  final value_to_predict = TextEditingController();
  int number = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 33, 214, 39),
        title: Text('Linear Model APP'),
      ), //Appbar
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Ingrese un número'),
              TextField(
                textAlign: TextAlign.center,
                controller: value_to_predict,
                decoration: const InputDecoration(hintText: "ingresar valor", border: OutlineInputBorder(),),
                
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  sendPrediction();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text('Calcular'),
              ),
            ],
          ),
      ),
    ); // Scaffold
  }

  void sendPrediction() async {
    var value = double.parse(value_to_predict.text);
    List<double> list_predictions=[];
    list_predictions.add(value);
    final prediction_instace = {"instances": [
      list_predictions
    ] };

    final res = await http.post(url,headers: headers, body: jsonEncode(prediction_instace));
    print(jsonEncode(prediction_instace));
    if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        print(json);

        final Predictions predictions = Predictions.fromJson(json);

        print(predictions.predictions);

        var result = predictions.predictions;
        showResult(result);
    }
    // return Future.error('No fue posible enviar La prediccion');
  }

  void showResult(result){
    print("Resultado alerta $result");
    showDialog(
        context: context,
        builder: (context) {
            return AlertDialog(
                title: Text("Resultado: $result"),

                actions: [
                    TextButton(
                        onPressed: () {
                            Navigator.of(context).pop();
                        },
                        child: const Text("Salida"),
                    ), // TextButton
                ],
            ); // AlertDialog
        });
  }
}