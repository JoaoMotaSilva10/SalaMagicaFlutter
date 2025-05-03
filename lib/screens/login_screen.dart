import 'package:flutter/material.dart';
import 'inicio_screen.dart';
import 'cadastro_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bem-vindo(a)!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nome de usuário',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            Row(
              children: [
                Checkbox(value: false, onChanged: (val) {}),
                Text('Manter conexão'),
                Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text('Esqueceu a senha?'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InicioScreen()),
              ),
              child: Text('Entrar'),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CadastroScreen()),
              ),
              child: Text('Não possui uma conta? Cadastre-se!'),
            ),
          ],
        ),
      ),
    );
  }
}