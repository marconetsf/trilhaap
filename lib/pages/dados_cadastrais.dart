import 'package:flutter/material.dart';
import '../repositories/nivel_repository.dart';
import '../repositories/linguagens_repository.dart';

class DadosCadastraisPage extends StatefulWidget {
  const DadosCadastraisPage({Key? key}) : super(key: key);

  @override
  State<DadosCadastraisPage> createState() => _DadosCadastraisPageState();
}

class _DadosCadastraisPageState extends State<DadosCadastraisPage> {
  TextEditingController nomeController = TextEditingController(text: "");
  TextEditingController dataNascimentoController =
      TextEditingController(text: "");
  DateTime? dataNascimento;
  var nivelRepository = NivelRepository();
  var niveis = [];
  var nivelSelecionado;

  var linguagens = [];
  var linguagemRepository = LinguagensRepository();
  var linguagensSelecionadas = [];
  String texto = "Meus Dados";

  double salarioEscolhido = 0;
  int tempoExperiencia = 0;
  List<DropdownMenuItem> rangeDeExperiencia = [];

  void initState() {
    niveis = nivelRepository.retornaNiveis();
    linguagens = linguagemRepository.retornaLinguagens();
    rangeDeExperiencia = returnItens(50);
    super.initState();
  }

  List<DropdownMenuItem> returnItens(int quantiradeMaxima) {
    List<DropdownMenuItem> items = [];
    for (int w = 0; w < quantiradeMaxima; w++) {
      items.add(DropdownMenuItem(child: Text(w.toString()), value: w,));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(texto),
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nome: ",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              TextField(
                controller: nomeController,
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Data de Nascimento: ",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              TextField(
                readOnly: true,
                controller: dataNascimentoController,
                onTap: () async {
                  var data = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000, 1, 1),
                      firstDate: DateTime(1900, 5, 20),
                      lastDate: DateTime(2023, 10, 23));
                  if (data != null) {
                    dataNascimentoController.text = data.toString();
                    dataNascimento = data;
                  }
                },
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Nível de experiência: ",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              Column(
                children: niveis
                    .map((nivel) => RadioListTile(
                        title: Text(nivel.toString()),
                        selected: nivelSelecionado == nivel,
                        value: nivel.toString(),
                        groupValue: nivelSelecionado,
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            nivelSelecionado = value.toString();
                          });
                        }))
                    .toList(),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Linguagens preferidas: ",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              Column(
                children: linguagens
                    .map(
                      (linguagem) => CheckboxListTile(
                          title: Text(linguagem),
                          value: linguagensSelecionadas
                              .toSet()
                              .contains(linguagem),
                          onChanged: (value) {
                            setState(() {
                              if (linguagensSelecionadas.contains(linguagem)) {
                                linguagensSelecionadas.remove(linguagem);
                              } else {
                                linguagensSelecionadas.add(linguagem);
                              }
                            });
                            print(linguagensSelecionadas.toSet());
                            print(linguagensSelecionadas);
                          }),
                    )
                    .toList(),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Tempo de experiência: ",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              DropdownButton(
                  isExpanded: true,
                  value: tempoExperiencia,
                  items: rangeDeExperiencia,
                  onChanged: (value) {
                    setState(() {
                      tempoExperiencia = int.parse(value.toString());
                    });
                  }),
              SizedBox(
                height: 25,
              ),
              Text(
                "Pretenção salarial: R\$ ${salarioEscolhido.round()}",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              Slider(
                  divisions: 10,
                  min: 0,
                  max: 10000,
                  value: salarioEscolhido,
                  onChanged: (double value) {
                    print(value);
                    setState(() {
                      salarioEscolhido = value;
                    });
                  }),
              SizedBox(
                height: 25,
              ),
              TextButton(
                  onPressed: () {
                    print(nomeController.text);
                    print(dataNascimento.toString());
                  },
                  child: Text(
                    "Salvar",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.blue),
                      textStyle: MaterialStatePropertyAll(
                        TextStyle(backgroundColor: Colors.blue),
                      ))),
            ],
          ),
        ),
      ]),
    );
  }
}
