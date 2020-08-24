//
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';


import 'package:flutter_firestore/main.dart';
import 'package:flutter_firestore/viewBusca.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/loading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';


import 'User.dart';
import 'animationItem.dart';
import 'dropdownBasic.dart';

typedef BooleanValue = bool Function(bool);
typedef restartCallback = Function();

class autenticacao extends StatefulWidget {

  var tipo;
  bool nome_=false;
  bool telefone_=false;
  bool viewpart2=false;
  var corNome= Colors.orange;
  var corTelefone= Colors.orange;
  var corForm= Colors.orange;
  var corSenha= Colors.orange;
  var corSenha_= Colors.orange;
  var corEmail= Colors.orange;
  User Usuario= new User(null,null,null,null,null);


  var top=0.0;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  restartCallback  restartUserLogin;
  final BooleanValue callback_click_busca;
  autenticacao (this.tipo,this.restartUserLogin, @required this.callback_click_busca);

  @override
  autenticacaoState createState() => autenticacaoState();

}


class autenticacaoState extends State<autenticacao> {

  TextEditingController c_nome = TextEditingController();
  TextEditingController c_tell = TextEditingController();
  TextEditingController c_email = TextEditingController();
  TextEditingController c_senha = TextEditingController();
  TextEditingController c_senha_ = TextEditingController();

  TextEditingController c_emaillogin = TextEditingController();
  TextEditingController c_senhalogin = TextEditingController();

  AnimationController rotationController;
  var checkboxvalue=false;
  var checkboxvalueidade=false;
  final myController = TextEditingController();
  var viewbtns=true;
  var h_pop=200.0;
  var marginbottom=40.0;
  var h_poplogin=375.0;
  var viewlogin=true;
  var viewloading=false;
  var viewpoptermos=false;
  var viewemaillogin=false;
  var view_recuperarsenha=true;
  var btn_retorno_login=false;
  var viewcadastro=false;
  var enableTexts=true;
  var op_card_cadastro=1.0;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  var fnome = new FocusNode();
  var ftell= new FocusNode();
  var femail= new FocusNode();
  var fsenha= new FocusNode();
  var fcsenha= new FocusNode();
  User myUser;

  var view_nometell=true;
  var view_email_senha;

  var view_form_final_gmail=false;
  var refData = Firestore.instance;
  FirebaseUser user;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    return
      SingleChildScrollView(
        child:

        Container(alignment: Alignment.center, child: Stack( children: <Widget>[

           Visibility(visible: viewlogin, child: _login(context),),
           Visibility(visible: viewcadastro,
                   child: _view_cadastro(context,myController)),
           Visibility(visible: viewloading,child:_load_view()),

          Visibility(visible: view_form_final_gmail,child:
          view_pop_completaCad()),

          Visibility(visible: false,child:
          Container(
              margin:EdgeInsets.all(20),
              padding:EdgeInsets.all(20),
              decoration: BoxDecoration(color:Colors.white),
              child:
              Container(child: Column(children: <Widget>[
            Container(
              height: 30, margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
              child:
            TextField(
              decoration: InputDecoration(hintText: "EMAIL"),
              controller: c_email,
              keyboardType: TextInputType.emailAddress ,
              style: TextStyle(fontSize: 14,color:Colors.orange,
                  fontFamily: 'RobotoLight'),),),
            Container(height: 30, margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
              child:
              TextField(
                controller: c_nome,
                decoration: InputDecoration(hintText: "NOME"),
                keyboardType: TextInputType.text ,
                style: TextStyle(fontSize: 14,color:Colors.orange,
                    fontFamily: 'RobotoLight'),),),
            Container(height: 30, margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
              child:
              TextField(decoration: InputDecoration(hintText: "TELL"),
                controller: c_tell,
                keyboardType: TextInputType.phone ,
                style: TextStyle(fontSize: 14,color:Colors.orange,
                    fontFamily: 'RobotoLight'),),),
              Container(
                  margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                decoration: BoxDecoration(color: Colors.orange),
                child:FlatButton(onPressed: (){_checkDadosGoogleSign();},color: Colors.transparent,
                  child: Text("SALVAR",style:TextStyle(color:Colors.white)),) )
            ],))
       )),

     ]))) ;

  }

  @override
  void initState() {
    super.initState();
  }

  _load_view(){
    return
      Container( alignment: Alignment.center, child:Loading(indicator: BallBeatIndicator() , size: 50.0,color: Colors.red),)
      ;
  }


_login(context) {
  return new Container(alignment: Alignment.center,
    margin:EdgeInsets.fromLTRB(10, 0,10, 40),decoration: BoxDecoration(),
    width: MediaQuery
        .of(context)
        .size
        .width,
    child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)))
      ,child: Column(children: <Widget>[
         Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween ,
             children: <Widget>[
           //RETORNA POP "ESQUECI A SENHA"
            Visibility(visible: true,child:
              GestureDetector(
                 onTap: (){
                   setState(() {
                     if(!view_recuperarsenha)
                      view_recuperarsenha=true;
                     else
                      if (btn_retorno_login)
                        {
                          btn_retorno_login=false;
                           viewemaillogin=false ;
                           viewbtns=true;
                        }else
                          {
                            widget.callback_click_busca(false);
                          }
                   });
                },child:
               Container(
                   decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.all(Radius.circular(50))),
                   padding:EdgeInsets.fromLTRB(8, 8,8,8),
                   margin:EdgeInsets.fromLTRB(10, 10,20,0),
                   alignment: Alignment.centerRight, child:
                Icon(Icons.arrow_back,size:30)
               ))),
      ]),

      Visibility(visible: !view_recuperarsenha,child:
        Container( margin: EdgeInsets.fromLTRB(0, 5, 0, 0), child:
        Text("Recuperar Senha",style: TextStyle(fontSize: 24,color:Colors.black,fontFamily: 'BreeSerif'),))),
      Visibility(visible: view_recuperarsenha,child:
      Container( margin: EdgeInsets.fromLTRB(0, 5, 0, 0), child:
      Text("Faça login",style: TextStyle(fontSize: 24,color:Colors.black,fontFamily: 'BreeSerif'),))),
      Visibility(visible: viewemaillogin,child: Column(children: <Widget>[
        Container(
          decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.all(Radius.circular(20)) ),
          margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
           child:
          TextField(controller:c_emaillogin,decoration: InputDecoration(hintText: "EMAIL"), keyboardType: TextInputType.emailAddress ,style: TextStyle(fontSize: 14,color:Colors.orange,fontFamily: 'RobotoLight'),),),
      Visibility(visible: view_recuperarsenha,child:
      Container(
            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
            decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.all(Radius.circular(20)) ),
            margin: EdgeInsets.fromLTRB(30, 0, 30, 10), child:
          TextField(controller: c_senhalogin,onTap: (){}, decoration: InputDecoration(hintText: "SENHA"),
            obscureText: true ,style: TextStyle(fontSize: 14,color:Colors.orange,fontFamily: 'RobotoLight'),),)),
        Visibility(visible: view_recuperarsenha,child:
          GestureDetector(
              onTap:(){
                setState(() {
                  view_recuperarsenha=false;
                });
              },
              child:
          Container(width: 170,
              decoration: BoxDecoration(border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(20)), alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5), child:
          Text("Esqueci a senha",style: TextStyle(fontSize: 14,color: Colors.red),)))),
            Visibility(visible: view_recuperarsenha,child:
            btnrealizarloginemail()),

      GestureDetector(
          onTap:(){
           resetSenha();
          },
          child:
      Visibility(visible: !view_recuperarsenha,child:
        Container(
           decoration: BoxDecoration( color: Colors.orange, boxShadow:[BoxShadow(color: Colors.black12,blurRadius: 3.0, offset: Offset(0.0, // horizontal, move right 10
              1.0,  ),)
            ],
            borderRadius: BorderRadius.all(Radius.circular(30))),
            margin: EdgeInsets.fromLTRB(0,10,0, 10),
            padding: EdgeInsets.fromLTRB(10,10,10, 10),
            child:
           Text("RECUPERAR",style: TextStyle(fontSize: 16,fontFamily: 'RobotoBold',color: Colors.white),))))
      ])),
      Visibility(visible: viewbtns,child: Column(children: <Widget>[
       _btnLogiEmail(),
      _btnGoogle(),
//      Container(height: 0, margin: EdgeInsets.fromLTRB(30, 15, 30, 10), child:
//      Divider(height: 2,color: Colors.orange,)),
        Container( margin: EdgeInsets.fromLTRB(30, 10, 30, 10), child:
        Text("OU",style: TextStyle(fontSize: 18,color:Colors.black,fontFamily: 'RobotoBold'))
        ),
      _btnCadastro(),
      ]))
    ],),),);
}

  Future<FirebaseUser> handleSignInEmail(String email, String password) async {
    try {
      AuthResult result = await auth.signInWithEmailAndPassword(email: email, password: password);

      final FirebaseUser user = result.user;

      widget.restartUserLogin();
      assert(user != null);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await auth.currentUser();
      assert(user.uid == currentUser.uid);
      print('signInEmail succeeded: $user');
    } catch(signUpError) {

      if(signUpError is PlatformException) {

        if(signUpError.code == 'ERROR_USER_NOT_FOUND') {
          /// `foo@bar.com` has alread been registered.
                _snackbar("Email não cadastrado");
        }
        if(signUpError.code == 'ERROR_INVALID_EMAIL ') {
          /// `foo@bar.com` has alread been registered.
          _snackbar("Email inválido");
        }
        if(signUpError.code == 'ERROR_WEAK_PASSWORD ') {
          /// `foo@bar.com` has alread been registered.
          _snackbar("Email ou senha incorreto");
        }
      }
    }

    return user;

  }

  resetSenha()async{
    FocusScope.of(context).requestFocus(FocusNode());
    var result = await FirebaseAuth.instance.sendPasswordResetEmail(email: c_emaillogin.text);
    _snackbar("Email de recuperação enviado para "+c_emaillogin.text);
  }


  view_pop_completaCad(){
    return
      Container(

          child:
         Stack(children:[
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IntrinsicHeight(child:
                Container(
                    margin:EdgeInsets.all(20),
                    padding:EdgeInsets.all(10),
                    decoration: BoxDecoration(color:Colors.white, boxShadow:[BoxShadow(color:Colors.grey)]),
                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        Container(height: 30, margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
                            child:Text("Complete seu cadastro",style: TextStyle(fontSize: 18,color:Colors.black,
                                fontFamily: 'BreeSerif'),)),

                        Container(height: 30, margin: EdgeInsets.fromLTRB(30, 20, 30, 10),
                          child:
                          TextField(decoration: InputDecoration(hintText: "EMAIL"),
                            controller: c_email,
                            keyboardType: TextInputType.emailAddress ,
                            style: TextStyle(fontSize: 16,color:Colors.black,
                                fontFamily: 'RobotoLight'),),),
                        Container(height: 30, margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                          child:
                          TextField(
                            controller: c_nome,
                            decoration: InputDecoration(hintText: "NOME"),
                            keyboardType: TextInputType.text ,
                            style: TextStyle(fontSize: 16,color:Colors.black,
                                fontFamily: 'RobotoLight'),),),
                        Container(height: 30, margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                          child:
                          TextField(decoration: InputDecoration(hintText: "TELL"),
                            controller: c_tell,
                            keyboardType: TextInputType.phone ,
                            style: TextStyle(fontSize: 16,color:Colors.black,
                                fontFamily: 'RobotoLight'),),),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                margin:EdgeInsets.fromLTRB(30, 0, 0, 0) ,
                                child:
                                Checkbox(checkColor: Colors.orange,value: checkboxvalueidade,
                                  onChanged: (value){
                                    setState(() {    checkboxvalueidade=value;});
                                  },) ),

                            GestureDetector(
                                onTap:(){
                                  setState((){
                                  });
                                },
                                child:
                                Container(
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    child:
                                    Text("Sou maior de 18 anos",
                                      style: TextStyle(fontFamily: 'RobotoBold',fontSize: 16,color: Colors.blue),) )),
                          ],),



                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(                  margin:EdgeInsets.fromLTRB(30, 0, 0, 0) ,
                            child:
                            Checkbox(checkColor: Colors.orange,value: checkboxvalue,
                              onChanged: (value){
                                setState(() {    checkboxvalue=value;});
                              },) ),

                        GestureDetector(
                            onTap:(){
                              setState((){
                                viewpoptermos=true;
                              });
                            },
                            child:
                            Container(
                                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child:
                                Text("Aceito os termos e\ncondições\nLeia aqui",
                                  style: TextStyle(fontFamily: 'RobotoBold',fontSize: 16,color: Colors.blue),) )),

                      ]),


                        Container(
                            margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                            decoration: BoxDecoration(color: Colors.orange),
                            child:FlatButton(onPressed: (){_checkDadosGoogleSign();},color: Colors.transparent,
                              child: Text("SALVAR",style:TextStyle(color:Colors.white)),) ),
                        Visibility(visible: true,child:
                        Container(height: 45)),
                      ],)))
              ]),

                Visibility(
                    visible: viewpoptermos,
                    child:
                    Container(
                        margin: EdgeInsets.fromLTRB(20, 20, 20,30),
                        padding: EdgeInsets.fromLTRB(20, 10, 20,40),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color:Colors.white,boxShadow: [BoxShadow(color:Colors.grey[400],blurRadius: 10)]),
                        alignment: Alignment.center,
                        child: Column(children: <Widget>[

                          Container(
                              padding: EdgeInsets.fromLTRB(20, 10, 20,10),
                              alignment: Alignment.center,
                              child:
                              Text("Termos e condições", style:
                              TextStyle(
                                  color: Colors.black, fontFamily: 'BreeSerif', fontSize: 20))),
                          Container(
                              padding: EdgeInsets.fromLTRB(20, 10, 20,10),
                              alignment: Alignment.center,
                              child:
                              Text("Ao se cadastrar o usuário concorda completamente com os termos e condições abaixo", style:
                              TextStyle(
                                  color: Colors.black, fontFamily: 'RobotoLight', fontSize: 14))),

//                     Text("Contrato versão 1.0.1"),

                          LimitedBox(
                              maxHeight: MediaQuery.of(context).size.height/2,
                              child:
                              SingleChildScrollView(
                                  child:
                                  StreamBuilder(
                                      stream:
                                      Firestore.instance      .collection('Docs').document("termosEcondicoes_loja")
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (ConnectionState.active== snapshot.connectionState) {
                                          return
                                            Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(color: Colors.white,
                                                    borderRadius: BorderRadius.all(Radius.circular(20))),
                                                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                child: Text(""+snapshot.data['text'].toString(),
                                                  textAlign: TextAlign.left, style:
                                                  TextStyle(
                                                      color: Colors.black, fontFamily: 'RobotoLight', fontSize: 20),));
                                        } else
                                          return Icon(Icons.update);}))),

                          GestureDetector(
                              onTap:(){
                                setState((){
                                  viewpoptermos=false;
                                  checkboxvalue=true;
                                });
                              },
                              child:

                              Container(
                                  margin: EdgeInsets.fromLTRB(20, 10, 20,10),
                                  padding: EdgeInsets.fromLTRB(20, 10, 20,10),
                                  decoration: BoxDecoration(
                                      border:Border.all(color: Colors.orange,width: 3),
                                      borderRadius: BorderRadius.all(Radius.circular(20),),
                                      color:Colors.white),
                                  alignment: Alignment.center,
                                  child:
                                  Text("Li e aceito",style:
                                  TextStyle(
                                      color: Colors.orange, fontFamily: 'BreeSerif', fontSize: 16)))),
                          GestureDetector(
                              onTap:(){
                                setState((){
                                  viewpoptermos=false;
                                });
                              },
                              child:

                              Container(
                                  margin: EdgeInsets.fromLTRB(20, 10, 20,10),
                                  padding: EdgeInsets.fromLTRB(20, 10, 20,10),
                                  decoration: BoxDecoration(
                                      border:Border.all(color: Colors.grey,width: 1),
                                      borderRadius: BorderRadius.all(Radius.circular(20),),
                                      color:Colors.white),
                                  alignment: Alignment.center,
                                  child:
                                  Text("VOLTAR",style:
                                  TextStyle(
                                      color: Colors.grey, fontFamily: 'BreeSerif', fontSize: 16)))),

                        ]))),
              ]));

  }

  _view_cadastro(context,myController){

  setState(() {

    var index = c_nome.text.indexOf(" ")+1;


    if (viewloading==true){
       enableTexts=false;
       op_card_cadastro=0.5;
    }else
      {
        op_card_cadastro=1.0;
        enableTexts=true;
      }

//    if (c_tell.text.length > 8  && c_nome.text[index] != " ") {
////      widget.viewpart2 = true;
////      h_pop = 360;
////      marginbottom=5;
//    } else
//      widget.viewpart2 = false;

    if (c_email.text.contains("@")==true && c_email.text.contains(".com")==true){
      widget.corEmail = Colors.green;
    }else
      widget.corEmail = Colors.orange;

    if (c_senha.text.length>6)
      widget.corSenha=Colors.green;
    else
      widget.corSenha=Colors.orange;

    if ( c_senha.text==( c_senha_.text) ){
      widget.corSenha_=Colors.green;
    }else
      widget.corSenha_=Colors.orange;

    var nomeSplit = c_nome.text.split(" ");
    if (nomeSplit.length>1){
        widget.corNome=Colors.green;
      }else
        widget.corNome=Colors.orange;
    if (c_tell.text.length > 8){
      widget.corTelefone=Colors.green;
    }else
      widget.corTelefone=Colors.orange;

  });

  return new
  LimitedBox(
      maxHeight: MediaQuery.of(context).size.height*.9,
      child:
  SingleChildScrollView(
      child:Container(
        alignment: Alignment.topCenter, width: MediaQuery
        .of(context)
        .size
        .width,
      child: Container(child:
      Stack(children:[
          Column(children: <Widget>[
      Container(margin: EdgeInsets.fromLTRB(0, 35, 0, 0), child:

         Column(

          children: <Widget>[
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween ,
          children: <Widget>[
           Visibility(visible: view_nometell,child:
              GestureDetector(
                onTap: (){
                  setState(() {
                    viewcadastro=false;
                    viewlogin=true;
                  });
                },child:
              Container(
                  padding:EdgeInsets.fromLTRB(8, 8,8,8),
                  margin:EdgeInsets.fromLTRB(10, 10,20,0),
                  decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.all(Radius.circular(20)) ),
                  alignment: Alignment.centerLeft, child:
              Icon(Icons.arrow_back,size:30)))),
              ],)
    ,
          Container( child:
          Text("CADASTRO",style: TextStyle(fontSize: 16,color:Colors.black,fontFamily: 'RobotoBold'),),),
     ],)),

      //TEXTFIEL NOME///////////////////
          Visibility(visible: true,child:
          Column( children: <Widget>[
        Container(
        padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
        decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.all(Radius.circular(20)) ),
        margin: EdgeInsets.fromLTRB(30, 10, 30, 10), child:
      TextFormField(focusNode:fnome,textInputAction:  TextInputAction.next,
        onFieldSubmitted: (term) {
          _fieldFocusChange ( fnome , ftell);
        },
        enabled: enableTexts,controller:c_nome ,onTap: (){
        setState((){
        });
      },
        onChanged: (text) {
        setState((){
        });
      },decoration: InputDecoration(hintText: "NOME E SOBRENOME*"),
        style: TextStyle(fontSize: 16,color:widget.corNome,fontFamily: 'RobotoLight'),),),
      //TEXTFIELD TELL
        Visibility(visible: true,child:
        Container(
          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
          decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.all(Radius.circular(20)) ),
          margin: EdgeInsets.fromLTRB(30, 0, 30, 10)
        , child:
      TextFormField(focusNode:ftell,textInputAction:  TextInputAction.next,
        onFieldSubmitted: (term) {
          _fieldFocusChange ( ftell , femail);
        },enabled: enableTexts, controller:c_tell,onTap: (){
        setState((){
//          if (c_tell.text.length>5)
//            widget.telefone_=true;
//          else
//            widget.telefone_=false;
//
//          if (widget.telefone_ && widget.nome_){
//            widget.viewpart2=true;  h_pop=350;}
//          else
//            widget.viewpart2=false;
        });
      },onChanged: (text) {
        setState((){

          if (text.contains("."))
            c_tell.text = c_tell.text.replaceAll(".","");
          if (text.contains(" "))
            c_tell.text = c_tell.text.replaceAll(" ","");
          if (text.contains("-"))
            c_tell.text = c_tell.text.replaceAll("-","");
          if (text.contains(","))
            c_tell.text = c_tell.text.replaceAll(",","");
          c_tell.selection = TextSelection.fromPosition(TextPosition(offset: c_tell.text.length));

//          if (text.length>5)
//            widget.telefone_=true;
//          else
//            widget.telefone_=false;
//
//          if (widget.telefone_ && widget.nome_){
//            widget.viewpart2=true;h_pop=350;}
//          else
//            widget.viewpart2=false;

        });

      },decoration: InputDecoration(hintText: "TELEFONE"),
        keyboardType:TextInputType.number ,
        style: TextStyle(fontSize: 16,color:widget.corTelefone,fontFamily: 'RobotoLight'),),)),


        ])),

        Visibility(visible: false,child:
        Container(padding: EdgeInsets.all(15),
            margin: EdgeInsets.fromLTRB(30, 5, 30, 10), child:
        RaisedButton(onPressed: (){
          setState(() {
            widget.viewpart2=true;
            view_nometell=false;
          });


        },disabledColor: Colors.orange,color:Colors.orange,
          child: Text("CONTINUAR",style: TextStyle(color:Colors.white),),))),

//      Container(height: 0, margin: EdgeInsets.fromLTRB(30, 15, 30, 10), child:
//      Divider(height: 2,color: Colors.orange,)),
        Visibility(
            visible: true,
            child:

           Column(children: <Widget>[
        Column(children: <Widget>[

        //email
        Container(        padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
          decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.all(Radius.circular(20)) ),
          margin: EdgeInsets.fromLTRB(30, 0, 30, 10), child:
         TextFormField(focusNode:femail,textInputAction:  TextInputAction.next,
           onFieldSubmitted: (term) {
             _fieldFocusChange ( femail , fsenha);
           },enabled: enableTexts,
           onChanged: (text){

          }, controller: c_email, decoration: InputDecoration(hintText: "EMAIL"), keyboardType: TextInputType.emailAddress ,style: TextStyle(fontSize: 14,color:widget.corEmail,fontFamily: 'RobotoLight'),),),

        //senha
        Container(        padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
          decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.all(Radius.circular(20)) ),
          margin: EdgeInsets.fromLTRB(30, 0, 30, 10), child:
        TextFormField(focusNode:fsenha,textInputAction:  TextInputAction.next,
                onFieldSubmitted: (term) {
                  _fieldFocusChange ( fsenha , fcsenha);
          },enabled: enableTexts,onChanged: (text){setState(() {
            if (c_senha.text.length>6)
                widget.corSenha=Colors.green;
              else
                widget.corSenha=Colors.orange;
            if (c_senha.text.length>6)
              if (c_senha.text == c_senha_.text ){
                  widget.corSenha_=Colors.green;
              }else
                widget.corSenha_=Colors.orange;
          });}, controller: c_senha,decoration: InputDecoration(hintText: "SENHA*"),obscureText: true ,style: TextStyle(fontSize: 14,color:widget.corSenha,fontFamily: 'RobotoLight'),),),

        //senha confirm
          Container(        padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
            decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.all(Radius.circular(20)) ),
            margin: EdgeInsets.fromLTRB(30, 0, 30, 10), child:
          TextField(enabled: enableTexts,onChanged: (text){setState(() {
              if ( c_senha.text==c_senha_.text){
                  widget.corSenha_=Colors.green;
              }else
                widget.corSenha_=Colors.orange;

          });},controller: c_senha_,decoration: InputDecoration(hintText: "SENHA NOVAMENTE*"),obscureText: true ,style: TextStyle(fontSize: 14,color:widget.corSenha_,fontFamily: 'RobotoLight'),),),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin:EdgeInsets.fromLTRB(30, 0, 30, 0) ,
                  child:
              Checkbox(checkColor: Colors.orange,value: checkboxvalueidade,
                onChanged: (value){
                  setState(() {    checkboxvalueidade=value;});
                },) ),

              GestureDetector(
                  onTap:(){
                    setState((){
                    });
                  },
                  child:
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child:
                      Text("Sou maior de 18 anos",
                        style: TextStyle(fontFamily: 'RobotoBold',fontSize: 18,color: Colors.blue),) )),
            ],),


          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
            Container(                  margin:EdgeInsets.fromLTRB(30, 0, 30, 0) ,
                child:
            Checkbox(checkColor: Colors.orange,value: checkboxvalue,
              onChanged: (value){
                setState(() {    checkboxvalue=value;});
            },) ),

            GestureDetector(
                onTap:(){
                  setState((){
                    viewpoptermos=true;
                  });
                },
                child:
            Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child:
            Text("Aceito os termos e condições\nLeia aqui",
              style: TextStyle(fontFamily: 'RobotoBold',fontSize: 18,color: Colors.blue),) )),
          ],),

          Container(height: 35,width: 130, margin: EdgeInsets.fromLTRB(30, 15, 30, 10), child:
                  RaisedButton(onPressed: (){signUp();},disabledColor: Colors.orange,color:Colors.orange,child:
                  Text("CADASTRAR",style: TextStyle(color:Colors.white),),)),


           Visibility(visible: true ,child:
           Container(height: 185))

        ])
      ],),





      ),

    ],),

          //pop termos
          Visibility(
            visible: viewpoptermos,
            child:
            Container(
                margin: EdgeInsets.fromLTRB(20, 20, 20,30),
                padding: EdgeInsets.fromLTRB(20, 10, 20,40),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color:Colors.white,boxShadow: [BoxShadow(color:Colors.grey[400],blurRadius: 10)]),
                alignment: Alignment.center,
                child: Column(children: <Widget>[

                  Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20,10),
                      alignment: Alignment.center,
                      child:
                      Text("Termos e condições", style:
                      TextStyle(
                          color: Colors.black, fontFamily: 'BreeSerif', fontSize: 20))),
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20,10),
                      alignment: Alignment.center,
                      child:
                      Text("Ao se cadastrar o usuário concorda completamente com os termos e condições abaixo", style:
                      TextStyle(
                          color: Colors.black, fontFamily: 'RobotoLight', fontSize: 14))),

//                     Text("Contrato versão 1.0.1"),

                  LimitedBox(
                      maxHeight: MediaQuery.of(context).size.height/2,
                      child:
                      SingleChildScrollView(
                          child:
                          StreamBuilder(
                              stream:
                              Firestore.instance      .collection('Docs').document("termosEcondicoes_loja")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (ConnectionState.active== snapshot.connectionState) {
                                  return
                                    Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(20))),
                                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                        child: Text(""+snapshot.data['text'].toString(),
                                          textAlign: TextAlign.left, style:
                                          TextStyle(
                                              color: Colors.black, fontFamily: 'RobotoLight', fontSize: 20),));
                                } else
                                  return Icon(Icons.update);}))),

                  GestureDetector(
                      onTap:(){
                          setState((){
                            viewpoptermos=false;
                            checkboxvalue=true;
                          });
                      },
                      child:

                      Container(
                          margin: EdgeInsets.fromLTRB(20, 10, 20,10),
                          padding: EdgeInsets.fromLTRB(20, 10, 20,10),
                          decoration: BoxDecoration(
                              border:Border.all(color: Colors.orange,width: 3),
                              borderRadius: BorderRadius.all(Radius.circular(20),),
                              color:Colors.white),
                          alignment: Alignment.center,
                          child:
                          Text("Li e aceito",style:
                          TextStyle(
                              color: Colors.orange, fontFamily: 'BreeSerif', fontSize: 16)))),
                  GestureDetector(
                      onTap:(){
                        setState((){
                          viewpoptermos=false;
                        });
                      },
                      child:

                      Container(
                          margin: EdgeInsets.fromLTRB(20, 10, 20,10),
                          padding: EdgeInsets.fromLTRB(20, 10, 20,10),
                          decoration: BoxDecoration(
                              border:Border.all(color: Colors.grey,width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(20),),
                              color:Colors.white),
                          alignment: Alignment.center,
                          child:
                          Text("VOLTAR",style:
                          TextStyle(
                              color: Colors.grey, fontFamily: 'BreeSerif', fontSize: 16)))),

                ]))),])

      ),)));

}

_fieldFocusChange (FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus ();
    FocusScope.of (context) .requestFocus (nextFocus);
  }

btnrealizarloginemail(){
    return  GestureDetector(
        onTap: (){setState(() {
          if (c_emaillogin.text.length>0 && c_senhalogin.text.length>0)
              handleSignInEmail(c_emaillogin.text,c_senhalogin.text);
          else
            _snackbar("Complete os campos");

          viewemaillogin=true;
          viewbtns=false;
        });},child:    Container(width: 180,padding: EdgeInsets.fromLTRB(0, 5, 0, 5), alignment: Alignment.center,
        decoration:
        BoxDecoration( color: Colors.orange, boxShadow:[BoxShadow(color: Colors.black12,blurRadius: 3.0, offset: Offset(0.0, // horizontal, move right 10
          1.0,  ),)
        ],
            borderRadius: BorderRadius.all(Radius.circular(30))), margin: EdgeInsets.fromLTRB(30, 10, 30, 20), child:
        Row( mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[

          Container( margin: EdgeInsets.fromLTRB(0,10,0, 10), child:
          Text("LOGIN",style: TextStyle(fontSize: 16,fontFamily: 'RobotoBold',color: Colors.white),))
        ],)
    ));
  }


_btnLogiEmail(){

  return
    GestureDetector(
      onTap: (){setState(() {
        viewemaillogin=true;
        viewbtns=false;
        btn_retorno_login=true;
      });},child:
     Container(padding: EdgeInsets.fromLTRB(0, 5, 0, 5), alignment: Alignment.center,
      decoration:
      BoxDecoration( color: Colors.white, boxShadow:[BoxShadow(color: Colors.black12,blurRadius: 3.0, offset: Offset(0.0, // horizontal, move right 10
        1.0,  ),)
      ],borderRadius: BorderRadius.all(Radius.circular(30))), margin: EdgeInsets.fromLTRB(30, 10, 30, 10), child:
      Row( mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Container(margin: EdgeInsets.fromLTRB(15, 0,0, 0), child:
        Icon(Icons.supervised_user_circle ,size: 35,),),
        Container(
            margin: EdgeInsets.fromLTRB(0, 0,0, 0),
            padding: EdgeInsets.fromLTRB(5, 10, 25, 10),
            child:
        Text("EMAIL E SENHA",style: TextStyle(fontSize: 16)))
      ],)
  ));

}


  _handleSignIn() async {

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser
        .authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await auth.signInWithCredential(credential))
        .user;

    myUser = new User(user.displayName,user.phoneNumber,user.email,user.uid,null);
    var document = await Firestore.instance.collection('Usuarios').document(user.uid);
    document.snapshots()
        .listen((data) => {
        checkusergmail(data)
      });

    return true;
  }


  checkusergmail(var data){
    print("checkusergmail");
    print(data.data);
    if (data.data==null) {
      showFormUser(myUser);
    }else
    setState((){
          viewlogin=false;
          widget.restartUserLogin();
          _screen_loading_out(true);

    });
  }

_btnGoogle(){
  return
    GestureDetector(
        onTap:(){
          _handleSignIn();
        },
        child:
    Container(padding: EdgeInsets.fromLTRB(0, 5, 0, 5), alignment: Alignment.center,
      decoration:
      BoxDecoration( color: Colors.white, boxShadow:[BoxShadow(color: Colors.black12,blurRadius: 3.0, offset: Offset(0.0, // horizontal, move right 10
        1.0,  ),)
      ],
          borderRadius: BorderRadius.all(Radius.circular(30))), margin: EdgeInsets.fromLTRB(30, 10, 30, 10), child:
      Row( mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Container( margin: EdgeInsets.fromLTRB(0, 0,10, 0), child:
        Image.asset("ic_google.png",width: 30,height: 30, fit: BoxFit.cover,
        ),),
        Container(
          alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(0, 10, 15, 10),
            margin: EdgeInsets.fromLTRB(5, 0,20, 0), child:
        Text("GOOGLE",style: TextStyle(fontSize: 16),))
      ],)
    ));
}


_btnCadastro(){
  return  GestureDetector(
      onTap: (){setState(() {
            viewlogin=false;viewcadastro=true;
      }); },child: Container(padding: EdgeInsets.fromLTRB(20, 15, 20, 15), alignment: Alignment.center,
      decoration:
      BoxDecoration( color: Colors.white, boxShadow:[BoxShadow(color: Colors.black12,blurRadius: 3.0, offset: Offset(0.0, // horizontal, move right 10
        1.0,  ),)
      ],
          borderRadius: BorderRadius.all(Radius.circular(30))), margin: EdgeInsets.fromLTRB(30, 10, 30, 15), child:
      Row( mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Container(margin: EdgeInsets.fromLTRB(20, 0,0, 0), child:
        Icon(Icons.contact_mail,color: Colors.orange[300], ),),
        Container(margin: EdgeInsets.fromLTRB(5, 0,20, 0), child:
        Text("CADASTRE-SE",style: TextStyle(fontSize: 16)))
      ],)
  ));
}


_btnCadastroGoogle(){

  }


_buscar(context){
  Navigator.push(
    context,
    PageTransition(
      curve: Curves.bounceIn,
      duration: Duration(milliseconds:500),
      alignment: Alignment.center,
      type: PageTransitionType.downToUp,
      child: viewBusca(),
    ),
  );
}


_home(context){
  Navigator.push(
    context,
    PageTransition(
      curve: Curves.bounceIn,
      duration: Duration(milliseconds:500),
      alignment: Alignment.center,
      type: PageTransitionType.downToUp,
      child: MyHomePage(),
    ),
  );
}

_viewBusca(isView){
  if (!isView){
    return true;
  }else
    return false;
}



_checkDadosGoogleSign() async{

    var email = c_email.text;
    var tell = c_tell.text;
    var nome = c_nome.text;
    var nomeSplit = nome.split(" ");
    var erro = false;

    if(checkboxvalue==false) {
      _snackbar("Você não aceitou os termos e condições");
      erro = true;
    }  else
    if(checkboxvalueidade==false) {
      _snackbar("Este app é para maiores de 18 anos");
      erro = true;
    }  else
    if (email.length < 7 || email.contains("@")==false || email.contains(".com")==false
    ){
      _snackbar("email incorreto");
      erro=true;
    }else
    if (tell.length < 8){  _snackbar("Telefone incorreto"); erro= true;}
    if (nome.length < 3){_snackbar("Nome incompleto");erro= true;}
    if (nomeSplit.length==1){_snackbar("Coloque um sobrenome"); erro= true;}

    print(myUser.uid);
    myUser.tell=tell;
    if (!erro){
      criarUser(myUser);

    }
  }


 _checkDados(){

  var email = c_email.text;
  var senha = c_senha.text;
  var senha_ = c_senha_.text;
  var tell = c_tell.text;
  var nome = c_nome.text;
  var nomeSplit = nome.split(" ");

  if (email.length < 7 || email.contains("@")==false || email.contains(".com")==false
  ){
    _snackbar("email incorreto");
    return false;
  }else
  if (senha.length < 6){
    _snackbar("senha incorreta");
    return false;
  }
  if ( senha !=  senha_ ){   _snackbar("confirmação de senha incorreto");return false;}
  if (tell.length < 8){  _snackbar("Telefone incorreto"); return false;}
  if (nome.length < 3){_snackbar("Nome incompleto");return false;}
  if (nomeSplit.length==1){_snackbar("Coloque um sobrenome"); return false;}
  if (checkboxvalue==false){_snackbar("Você deve aceitar os termos e condições para continuar"); return false;}
  if (checkboxvalueidade==false){_snackbar("Este app é destinado para maiores de 18 anos"); return false;}

  return true;

}

bool checkLogado(){
  FirebaseAuth.instance.currentUser().then((firebaseUser){
    if(firebaseUser == null)
    {
      //signed out
      return true;
    }
    else{
      //signed in
      return false;
    }
  });
}


_snackbar(text){
  final snackBar = SnackBar(content: Text(text));
  Scaffold.of(context).showSnackBar(snackBar);

}


_snackbarcor(text,cor){
    final snackBar = SnackBar(backgroundColor: cor, content: Text(text));
    Scaffold.of(context).showSnackBar(snackBar);
}


_screen_loading_in(){
  setState(() {
    viewloading=true;
  });
}


_screen_loading_out(c){
    setState(() {
      viewloading=false;
      op_card_cadastro=1;
      widget.callback_click_busca(c);
    });
 }


showFormUser(var user){

    setState(() {
    view_form_final_gmail=true;
    viewlogin=false;
    c_email.text=user.email;
    c_nome.text=user.nome;
    c_tell.text=user.tell;
    });
}
  void getDadosUser(var uid) async {

    var document = await Firestore.instance.collection('Usuarios').document(uid);
    document.snapshots()
        .listen((data) => {

    });

  }
Future  signUp() async {
  _screen_loading_in();
  bool check = _checkDados();
  print(check);

  if (check==true){
      try {
          var email = c_email.text;
          var password = c_senha.text;
          var nome = c_nome.text;
          var tell= c_tell.text;
          var user = (await auth.createUserWithEmailAndPassword(email: email, password: password)) ;
          var us = await auth.currentUser();
          widget.Usuario = new User(nome,tell,email, us.uid,null);

          if (user!=null)
             criarUser(widget.Usuario);

        } catch (e) {
          _snackbarcor("Erro ao registrar email ",Colors.red);
          _screen_loading_out(false);
      }
    }else
      {
        viewloading=false;
//        _screen_loading_out(false);
      }
}


void criarUser(User muser) async {

    await refData.collection("Usuarios")
        .document(muser.uid)
        .setData({"nome":muser.nome,"tell":muser.tell,'maior18':checkboxvalueidade,'termosEcondicoes':checkboxvalue,
                  "email":muser.email,'uid':muser.uid});

    _screen_loading_out(true);
//    _snackbarcor("Bem vindo, "+widget.Usuario.nome,Colors.green);

}


Future < FirebaseUser > signIn(String email, String password) async {

    try {
      FirebaseUser user = (await auth.signInWithEmailAndPassword(email: email, password: password)) as FirebaseUser;
      FirebaseUser currentUser = await auth.currentUser();
      if (currentUser!=null){
          widget.callback_click_busca(true);
          _snackbar("Login realizado");
      }
      else
        _snackbar("Erro, senha ou email incorreto.");


      return user;
    } catch (e) {
      return null;
    }
  }

}
