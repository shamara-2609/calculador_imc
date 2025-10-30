import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora de IMC',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const CalculadoraIMC(),
    );
  }
}

class CalculadoraIMC extends StatefulWidget {
  const CalculadoraIMC({super.key});

  @override
  State<CalculadoraIMC> createState() => _CalculadoraIMCState();
}

class _CalculadoraIMCState extends State<CalculadoraIMC> {
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();

  double peso = 0;
  double altura = 0;
  String resultado = '';

  void calcularIMC() {
    if (peso <= 0 || altura <= 0) {
      setState(() => resultado = 'Por favor, insira valores válidos.');
      return;
    }

    // Impede o cálculo se a altura for maior que 2.5 m
    if (!_validarAlturaMaxima(altura)) {
      setState(() {
        resultado = 'Altura inválida. Corrija antes de calcular.';
      });
      return;
    }

    double imc = peso / (altura * altura);
    String classificacao = '';

    if (imc < 18.5) {
      classificacao = 'Abaixo do peso';
    } else if (imc < 24.9) {
      classificacao = 'Peso normal';
    } else if (imc < 29.9) {
      classificacao = 'Sobrepeso';
    } else if (imc < 34.9) {
      classificacao = 'Obesidade grau I';
    } else if (imc < 39.9) {
      classificacao = 'Obesidade grau II';
    } else {
      classificacao = 'Obesidade grau III';
    }

    setState(() {
      resultado =
          'Seu IMC é ${imc.toStringAsFixed(2)}\nClassificação: $classificacao';
    });
  }

  double _converterAltura(String valor) {
    valor = valor.trim().replaceAll(',', '.');
    if (valor.isEmpty) return 0;

    double? altura = double.tryParse(valor);
    if (altura == null) return 0;

    // Se o usuário digitar em centímetros (ex: 175), converte para metros (1.75)
    if (altura > 10) {
      altura = altura / 100;
    }

    return altura;
  }

  // Retorna false se a altura for inválida (> 2.5), true se estiver ok
  bool _validarAlturaMaxima(double altura) {
    if (altura > 2.5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Altura máxima permitida é 2.50 metros'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false; // bloqueia o cálculo
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora de IMC')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: pesoController,
              decoration: const InputDecoration(
                labelText: 'Peso (kg)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (valor) {
                setState(() {
                  peso = double.tryParse(valor.replaceAll(',', '.')) ?? 0;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: alturaController,
              decoration: const InputDecoration(
                labelText: 'Altura (m)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (valor) {
                setState(() {
                  altura = _converterAltura(valor);
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: calcularIMC,
              child: const Text('Calcular'),
            ),
            const SizedBox(height: 20),
            Text(
              resultado,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
