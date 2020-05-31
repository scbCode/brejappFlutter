
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'Loja.dart';
import 'Produto_cesta.dart';
import 'enderecoUser.dart';
import 'enderecoUserSnapShot.dart';


class BlocAll {

  int _total = 0;
  enderecoUserSnapShot enderecoUser_;
  enderecoUserSnapShot enderecoUser_temp;
  int get total => _total;

  List<Produto_cesta> listaCesta= new List<Produto_cesta> ();
  final control_check = StreamController< List<Produto_cesta> >.broadcast();
  final  control_get_loja  = StreamController< Loja>.broadcast();
  final  control_get_endereco_rua  = StreamController< String>.broadcast();
  final  control_get_endereco_salvo  = StreamController< enderecoUserSnapShot>.broadcast();
  final  control_get_endereco_temp  = StreamController< enderecoUserSnapShot>.broadcast();
  Stream <List<Produto_cesta>> get check => control_check.stream;
  Stream <List>  check2 ;
  Stream <Loja> get get_loja => control_get_loja.stream;
  Stream <String> get get_rua_end => control_get_endereco_rua.stream;
  Stream <enderecoUserSnapShot> get get_endereco_temp => control_get_endereco_temp.stream;
  Stream <enderecoUserSnapShot> get get_endereco_salvo=> control_get_endereco_temp.stream;

  Future getCesta() async{


    print ("BLOC - getCesta ");
    listaCesta=[];
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user!=null){
         Firestore.instance      .collection('Usuarios').document(user.uid)
         .collection("cesta").orderBy('preco').snapshots()
        .listen((data) =>  _checkreresult(data))   ;
        }else
        {
          control_check.sink.add([]);
        }

  }



  _checkreresult(QuerySnapshot data) async{
    listaCesta=[];
    var loja="";
    if (data.documents.isEmpty==false) {
        print ("BLOC - getCesta EXIXST");
        await data.documents.forEach((p) {
          print ("BLOC - getCesta EXIXST - "+ p.data['loja']);
          Produto_cesta produto = new Produto_cesta(p);
          print(produto.loja);
          loja = produto.loja;
          listaCesta.add(produto);
          control_check.sink.add(listaCesta);
          print ("BLOC - _checkreresult "+produto.quantidade.toString());
      });
      getLojaCesta(loja);
    }else
      control_check.sink.add(listaCesta);
  }


  checklist(  Produto_cesta produto){
    var c = false;
    print ("BLOC - checklist "+listaCesta.length.toString());
    for (int i=0;i<listaCesta.length;i++){

      if (produto.id==listaCesta[i].id){
        c = true;
      }
    }
  }


  getLojaCesta(loja) async{

    print ("BLOC - getLoja "+loja);
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var doc = await Firestore.instance
        .collection('Perfil_loja').where("nome",isEqualTo: loja).
          snapshots()
        .listen((data) =>_checkreresultLoja(data) );

  }


  _checkreresultLoja(QuerySnapshot data) async {
    listaCesta = [];
    if (data.documents.isEmpty == false) {
      await data.documents.forEach((p) {
        Loja loja = Loja(p);
        control_get_loja.sink.add(loja);
      });
      print("BLOC - _checkreresultLoja ");
    }
  }


  void getEnderecoUser() async {

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user!=null){
    var uid = user.uid;
    var document = await Firestore.instance.collection('Usuarios').document(uid);
    document.collection("endereco").document("Entrega").snapshots()
        .listen((data) => {
      setUiEndereco(data)
    });}

  }

  void setUiEndereco(var data){

      if (data.exists) {
        enderecoUser_ = new enderecoUserSnapShot(data);
        control_get_endereco_rua.sink.add(enderecoUser_.rua);
        control_get_endereco_salvo.sink.add(enderecoUser_);
      }else {
        getEnderecoTemp();
      }
  }

  void getEnderecoTemp() async {

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    var document = await Firestore.instance.collection('Usuarios').document(uid);
    document.collection("endereco").document("Entrega_temp").snapshots()
        .listen((data) => {
      setUiEndereco_temp(data)
    });

  }

  void setUiEndereco_temp(var data){
    if (data.exists) {
      enderecoUser_temp = new enderecoUserSnapShot(data);
      control_get_endereco_rua.sink.add(enderecoUser_temp.rua+", "+enderecoUser_temp.bairro);
      control_get_endereco_temp.sink.add(enderecoUser_);

    }else {
      control_get_endereco_rua.sink.add("");
    }
  }

  initBloc(){
    print("Iniciando Bloc All");
    getCesta();
    getEnderecoUser();
  }

  callTokenrizarCartao() async {

    print("callTokenrizarCartao");
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'criarToken',
    );
    dynamic resp = await callable.call(<String, dynamic>{
      'YOUR_PARAMETER_NAME': 'YOUR_PARAMETER_VALUE',
    });
    print("callTokenrizarCartaofinal");

  }

}





