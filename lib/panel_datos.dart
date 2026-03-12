import 'package:flutter/material.dart';

class PanelDatos extends StatelessWidget {
  const PanelDatos({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.orange.withOpacity(0.5), width: 2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.orange.withOpacity(0.1), blurRadius: 10, spreadRadius: 2)
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filaPanel("DESTINO", "FULL-STACK DEV"),
          _filaPanel("ESTADO", "BUSCANDO RETOS"),
          _filaPanel("VÍA", "01"),
        ],
      ),
    );
  }

  Widget _filaPanel(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$etiqueta: ", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          Text(valor, style: const TextStyle(color: Colors.orangeAccent, fontFamily: 'monospace')),
        ],
      ),
    );
  }
}