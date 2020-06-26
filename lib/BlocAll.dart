
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firestore/prePedido.dart';
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
  final  streamControl_Pedidos  = StreamController< List<Pedido>>.broadcast();
  final  streamControl_PrePedidos  = StreamController< Pedido>.broadcast();
  final  control_get_endereco_temp  = StreamController< enderecoUserSnapShot>.broadcast();
  Stream <List<Produto_cesta>> get check => control_check.stream;
  Stream <List>  check2 ;
  Stream <Loja> get get_loja => control_get_loja.stream;
  Stream <String> get get_rua_end => control_get_endereco_rua.stream;
  Stream <enderecoUserSnapShot> get get_endereco_temp => control_get_endereco_temp.stream;
  Stream <enderecoUserSnapShot> get get_endereco_salvo=> control_get_endereco_temp.stream;
  Stream <List<Pedido>> get stream_pedido => streamControl_Pedidos.stream;
  Stream <Pedido> get stream_Prepedido => streamControl_PrePedidos.stream;

  var pedidoExist=false;
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

 Future<Loja>getLojaPedido(var loja)async{
    Loja returnloja;
     await Firestore.instance
        .collection('Perfil_loja').document(loja).get().
      then
        ((data)   {
       Loja loja = Loja(data);
       returnloja=loja;
       print("LOJA GET "+loja.nome);
       return loja;
        }
      );

     return returnloja;
  }
  getLojareturn(QuerySnapshot data)  {
    if (data.documents.isEmpty == false) {
       data.documents.forEach((p) {
        Loja loja = Loja(p);
        return (loja);
      });
    }
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
    StreamPedidos();
    StreamPrePedidos();
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


  Future<bool> savePrePedido(var uid, var pedido) async {
      var refData = Firestore.instance;
      var ctrol=false;
      await refData.collection("Usuarios")
          .document(uid).collection('prePedidos')
          .add(pedido)
          .then((v){
        print("SAVE PRE-PEDIDO");
        ctrol=true;
        return  true;
      }).catchError((erro){
        print("SAVE PRE-PEDIDO - ERROR");
      });

      return ctrol;

    }

  Future<bool> jachego(var uid, var pedido) async {
    var refData = Firestore.instance;
    var ctrol=false;
    await refData.collection("Usuarios")
        .document(uid).collection('Pedidos')
        .document(pedido).setData({"time_nao_aceito_visto":FieldValue.serverTimestamp(),"status":"finalizado",},merge: true)
        .then((v){
      print("SAVE CANCEL-PEDIDO");
      ctrol=true;
      return  true;
    }).catchError((erro){
      print("SAVE CANCEL-PEDIDO - ERROR");
    });

    return ctrol;

  }

  Future<bool> cancelPedido_nao_aceito(var uid, var pedido) async {
    var refData = Firestore.instance;
    var ctrol=false;
    await refData.collection("Usuarios")
        .document(uid).collection('Pedidos')
        .document(pedido).setData({"time_nao_aceito_visto":FieldValue.serverTimestamp(),"status":"nao_aceito_visto",},merge: true)
        .then((v){
      print("SAVE CANCEL-PEDIDO");
      ctrol=true;
      return  true;
    }).catchError((erro){
      print("SAVE CANCEL-PEDIDO - ERROR");
    });

    return ctrol;

  }


  Future<bool> cancelPedido(var uid, var pedido) async {
    var refData = Firestore.instance;
    var ctrol=false;
    await refData.collection("Usuarios")
        .document(uid).collection('Pedidos')
        .document(pedido).setData({"timecancel":FieldValue.serverTimestamp(),"status":"cancelado_user",},merge: true)
        .then((v){
      print("SAVE CANCEL-PEDIDO");
      ctrol=true;
      return  true;
    }).catchError((erro){
      print("SAVE CANCEL-PEDIDO - ERROR");
    });

    return ctrol;

  }

  Future<bool> cancelPedido_reembolso(var uid, var pedido) async {
    var refData = Firestore.instance;
    var ctrol=false;
    await refData.collection("Usuarios")
        .document(uid).collection('Pedidos')
        .document(pedido).setData({"timecancel":FieldValue.serverTimestamp(),"status":"cancelado_user_reembolso",},merge: true)
        .then((v){
      print("SAVE CANCEL-PEDIDO");
      ctrol=true;
      return  true;
    }).catchError((erro){
      print("SAVE CANCEL-PEDIDO - ERROR");
    });

    return ctrol;

  }


  Future<bool> enviarDenuncia(Pedido pedido,var origemDenuncia, var msg) async {
    var refData = Firestore.instance;
    var ctrol=false;
    await refData.collection("Denuncias").document(origemDenuncia)
        .collection("Geral")
        .add({"time":FieldValue.serverTimestamp(),
              "origemDenuncia":origemDenuncia,
              "loja":pedido.idloja,
              "emailUser":pedido.emailUser,
              "msg": msg,
         })
        .then((v){
        print("SAVE CANCEL-PEDIDO");
        ctrol=true;
      return  true;
    }).catchError((erro){
      print("SAVE CANCEL-PEDIDO - ERROR");
    });

    return ctrol;

  }

  Future<bool> sendMsgAjuda(var uid, var pedido,var msg) async {
    var refData = Firestore.instance;
    var ctrol=false;
    await refData.collection("Usuarios")
        .document(uid).collection('Pedidos')
        .document(pedido).collection("chat")
        .add(
        {"time":FieldValue.serverTimestamp(),
          "msg":msg,
          "remetente":"user-auto-pedidoErrado"

        }
        )
        .then((v){
      print("SAVE MSG-PEDIDO");
      ctrol=true;
      return  true;
    }).catchError((erro){
      print("SAVE MSG-PEDIDO - ERROR");
    });

    return ctrol;

  }

  Future<bool> savePedidoFinal(var uid, var pedido) async {
    var refData = Firestore.instance;
    var ctrol=false;
    await refData.collection("Usuarios")
        .document(uid).collection('prePedidos')
        .add(pedido.getPedidoMap())
        .then((v){
      print("SAVE PRE-PEDIDO");
      ctrol=true;

       refData.collection("Usuarios")
          .document(uid).collection('cesta').snapshots().listen((event) {
            for(int i =0;i<event.documents.length;i++) {
              event.documents[i].reference.delete();
            }
       });

      return  true;
    }).catchError((erro){
      print("SAVE PRE-PEDIDO - ERROR "+erro.toString());
    });

    return ctrol;

  }

  Future<bool> remove(var uid, var pedido) async {
    var refData = Firestore.instance;
    var ctrol=false;
    await refData.collection("Usuarios")
        .document(uid).collection('Pedidos')
        .add(pedido)
        .then((v){
      print("SAVE PRE-PEDIDO");
      ctrol=true;
      return  true;
    }).catchError((erro){
      print("SAVE PRE-PEDIDO - ERROR");
    });

    return ctrol;

  }



  void StreamPedidos() async {


    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user!=null){
      var uid = user.uid;
      var document = await Firestore.instance.collection('Usuarios').document(uid);
      document.collection("Pedidos").snapshots()
          .listen((data) => {
            setUiPedido(data)
      });
    }

  }

  void setUiPedido(var data)async{

    print("GET PEDIDO ");
    List<Pedido> pedidos= [];
    print(data);
    if (data!=null) {
      if (data.documents.isEmpty==false) {
         await data.documents.forEach((p) {
            Pedido pd = new Pedido();
            print ("BLOC - getPedido EXIXST ");
            pd.setPedido(p);
            pedidos.add(pd);
         });
          streamControl_Pedidos.sink.add(pedidos);
         pedidoExist=true;
      }
    }else {
      StreamPedidos();
      pedidoExist=false;

    }
  }



  void StreamPrePedidos() async {

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user!=null){
      var uid = user.uid;
      var document = await Firestore.instance.collection('Usuarios').document(uid);
      document.collection("prePedidos").orderBy('idloja').snapshots()
          .listen((data) => {
        setUiPrePedido(data)
      });
    }

  }

   getPedidoExist(){
    return pedidoExist;
  }

  void setUiPrePedido(var data){

    print("GET PEDIDO ");
    print(data);
    if (data!=null) {
      if (data.documents.isEmpty==false) {
        data.documents.forEach((p) {
          Pedido pd = new Pedido();
          print ("BLOC - getPedido EXIXST");
          pd.setPedido(p);
          streamControl_PrePedidos.sink.add(pd);

        });
      }
    }else {
      StreamPedidos();
    }
  }



}





