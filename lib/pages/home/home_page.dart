import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/data_structure_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 64,
          ),
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/neurology.png', width: 36, height: 36, color: Colors.black, fit: BoxFit.cover),
                      const SizedBox(width: 8),
                      const SelectableText(
                        'Visualizador de Estrutura de Dados',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const SelectableText(
                    'Visualizações interativas para ajudar você a entender estruturas de dados e algoritmos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
          
              const SizedBox(height: 64),
          
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SelectableText(
                    'Estruturas de Dados',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          
                  const SizedBox(height: 16),
          
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      DataStructureItem(
                        title: 'Pilha',
                        subtitle: 'Estrutura de dados Primeiro a Entrar, Último a Sair (LIFO).',
                        icon: Icons.swap_vert,
                        onTap: () => context.push('/simulation/pilha'),
                      ),
                      
                      DataStructureItem(
                        title: 'Fila',
                        subtitle: 'Estrutura de dados Primeiro a Entrar, Primeiro a Sair (FIFO)',
                        icon: Icons.swap_horiz_rounded,
                        onTap: () => context.push('/simulation/fila'),
                      ),
                
                      DataStructureItem(
                        title: 'Árvore Binária',
                        subtitle: 'Estrutura de dados hierárquica onde cada nó tem no máximo dois filhos.',
                        icon: Icons.park_outlined,
                        onTap: () => context.push('/simulation/árvore binária'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

