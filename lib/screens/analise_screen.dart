import 'package:flutter/material.dart';
import 'inicio_screen.dart';

class AnaliseScreen extends StatelessWidget {
  const AnaliseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.access_time, size: 60, color: Colors.blue),
              SizedBox(height: 20),
              Text(
                'A reserva será analisada!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Aguarde o administrador aprovar seu pedido.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => InicioScreen()),
                ),
                child: Text('Voltar ao início'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}