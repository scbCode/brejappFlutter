import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firestore/animator.dart';
import 'package:flutter_firestore/main.dart';
import 'package:flutter_firestore/viewBusca.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:page_transition/page_transition.dart';

import 'User.dart';
import 'animationItem.dart';
import 'dropdownBasic.dart';

typedef BooleanValue = bool Function(bool);

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
  var Usuario;


  var top=0.0;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  final BooleanValue callback_click_busca;
  autenticacao (this.tipo, @required this.callback_click_busca);

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
  final myController = TextEditingController();
  var viewbtns=true;
  var h_pop=200.0;
  var marginbottom=40.0;
  var h_poplogin=375.0;
  var viewlogin=true;
  var viewloading=false;
  var viewemaillogin=false;
  var viewcadastro=false;
  var enableTexts=true;
  var op_card_cadastro=1.0;

  var fnome = new FocusNode();
  var ftell= new FocusNode();
  var femail= new FocusNode();
  var fsenha= new FocusNode();
  var fcsenha= new FocusNode();

  var refData = Firestore.instance;
  FirebaseUser user;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
        child:Container(alignment: Alignment.center, child: Stack( children: <Widget>[

           Visibility(visible: viewlogin, child: _login(context),),
           Opacity(opacity: op_card_cadastro, child: Visibility(visible: viewcadastro,child: _view_cadastro(context,myController))),
           Visibility(visible: viewloading,child:_load_view()),

        ]))) ;

  }




  _load_view(){
    return
      Container( alignment: Alignment.center, child:Loading(indicator: BallBeatIndicator() , size: 50.0,color: Colors.red),)
      ;
  }


_login(context) {


  return new Container(alignment: Alignment.center, margin:EdgeInsets.fromLTRB(10, 0,10, 40),decoration: BoxDecoration(),
    width: MediaQuery
        .of(context)
        .size
        .width,
    child: Card(elevation:4,child: Column(children: <Widget>[
      GestureDetector(
        onTap: (){widget.callback_click_busca(false);},child:
      Container(margin:EdgeInsets.fromLTRB(0, 10,20,0),alignment: Alignment.centerRight, child:
      Text("X",textAlign: TextAlign.right,style: TextStyle(fontSize: 16,color:Colors.orange,fontFamily: 'RobotoLight'),),),
      ),
      Container(height: 30, margin: EdgeInsets.fromLTRB(0, 5, 0, 0), child:
      Text("Faça login",style: TextStyle(fontSize: 16,color:Colors.orange,fontFamily: 'RobotoBold'),)),
      Visibility(visible: viewemaillogin,child: Column(children: <Widget>[
        Container(height: 30, margin: EdgeInsets.fromLTRB(30, 0, 30, 10), child:
          TextField(decoration: InputDecoration(hintText: "EMAIL"), keyboardType: TextInputType.emailAddress ,style: TextStyle(fontSize: 14,color:Colors.orange,fontFamily: 'RobotoLight'),),),

          Container(height: 30, margin: EdgeInsets.fromLTRB(30, 0, 30, 10), child:
          TextField(onTap: (){}, decoration: InputDecoration(hintText: "SENHA"),obscureText: true ,style: TextStyle(fontSize: 14,color:Colors.orange,fontFamily: 'RobotoLight'),),),
          Container( alignment: Alignment.centerRight, child:
          Container(width: 105,height:20, decoration: BoxDecoration(border: Border.all(color: Colors.red[100]),borderRadius: BorderRadius.circular(20)), alignment: Alignment.center, margin: EdgeInsets.fromLTRB(0, 0, 30, 10), child:
          Text("Esqueci minha senha",style: TextStyle(fontSize: 10,color: Colors.red),))),
          btnrealizarloginemail(),
      ])),
      Visibility(visible: viewbtns,child: Column(children: <Widget>[
       _btnLogiEmail(),
      _btnGoogle(),
      Container(height: 0, margin: EdgeInsets.fromLTRB(30, 15, 30, 10), child:
      Divider(height: 2,color: Colors.orange,)),
        Container( margin: EdgeInsets.fromLTRB(30, 0, 30, 0), child:
        Text("OU",style: TextStyle(fontSize: 12,color:Colors.orange,fontFamily: 'RobotoBold'))
        ),
      _btnCadastro(),
        _btnCadastroGoogle(),
      ]))
    ],),),);
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

    if (c_tell.text.length > 8  && c_nome.text[index] != " ") {
      widget.viewpart2 = true;
      h_pop = 360;
      marginbottom=5;
    } else
      widget.viewpart2 = false;

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

  return new SingleChildScrollView(
      child:Container(height: h_pop, margin:EdgeInsets.fromLTRB(10, widget.top,10, marginbottom),decoration: BoxDecoration(

  ),
    width: MediaQuery
        .of(context)
        .size
        .width,
    child: Card(elevation:3,child: Column(children: <Widget>[
      Container(margin: EdgeInsets.fromLTRB(0, 5, 0, 0), child:
        Column( children: <Widget>[
        GestureDetector(
        onTap: (){widget.callback_click_busca(false);},child:
          Container(margin:EdgeInsets.fromLTRB(0, 10,20,0),alignment: Alignment.centerRight, child:
          Text("X",textAlign: TextAlign.right,style: TextStyle(fontSize: 16,color:Colors.orange,fontFamily: 'RobotoLight'),),),
         ),
          Container( child:
          Text("CADASTRO",style: TextStyle(fontSize: 16,color:Colors.orange,fontFamily: 'RobotoBold'),),),
     ],)),
      //TEXTFIEL NOME///////////////////
      Container(height: 30, margin: EdgeInsets.fromLTRB(30, 15, 30, 10), child:
      TextFormField(focusNode:fnome,textInputAction:  TextInputAction.next,
        onFieldSubmitted: (term) {
          _fieldFocusChange ( fnome , ftell);
        },
        enabled: enableTexts,controller:c_nome ,onTap: (){
        setState((){
          var index = c_nome.text.indexOf(" ");

          if (c_nome.text.split(" ").length>1 ) {
            widget.corNome = Colors.green;
            widget.nome_ = true;
          }  else
            widget.nome_=false;
          if (widget.telefone_ && widget.nome_) {
            widget.viewpart2 = true;
            h_pop=350;
          } else
            widget.viewpart2=false;
        });
      },
        onChanged: (text) {
        setState((){

          var index = text.indexOf(" ")+1;
          if (index==1)
            c_nome.text="";

          if ( text.split(" ").length>1 && text[index] != " ") {
            widget.nome_ = true;
          }
          else
            widget.nome_=false;
          if (widget.telefone_ && widget.nome_){
            widget.viewpart2=true;
            h_pop=350;}
         else
            widget.viewpart2=false;
        });
      },decoration: InputDecoration(hintText: "NOME E SOBRENOME*"),style: TextStyle(fontSize: 14,color:widget.corNome,fontFamily: 'RobotoLight'),),),
      //TEXTFIELD TELL
      Container(height: 30, margin: EdgeInsets.fromLTRB(30, 0, 30, 10), child:
      TextFormField(focusNode:ftell,textInputAction:  TextInputAction.next,
        onFieldSubmitted: (term) {
          _fieldFocusChange ( ftell , femail);
        },enabled: enableTexts, controller:c_tell,onTap: (){
        setState((){

          if (c_tell.text.length>5)
            widget.telefone_=true;
          else
            widget.telefone_=false;

          if (widget.telefone_ && widget.nome_){
            widget.viewpart2=true;  h_pop=350;}
          else
            widget.viewpart2=false;

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

          if (text.length>5)
            widget.telefone_=true;
          else
            widget.telefone_=false;

          if (widget.telefone_ && widget.nome_){
            widget.viewpart2=true;h_pop=350;}
          else
            widget.viewpart2=false;

        });

      },decoration: InputDecoration(hintText: "TELEFONE"),keyboardType:TextInputType.number ,style: TextStyle(fontSize: 14,color:widget.corTelefone,fontFamily: 'RobotoLight'),),),

      Container(height: 0, margin: EdgeInsets.fromLTRB(30, 15, 30, 10), child:
      Divider(height: 2,color: Colors.orange,)),

      Visibility(
          visible: widget.viewpart2,
          child:
        Column(children: <Widget>[

        //email
        Container(height: 30, margin: EdgeInsets.fromLTRB(30, 0, 30, 10), child:
         TextFormField(focusNode:femail,textInputAction:  TextInputAction.next,
           onFieldSubmitted: (term) {
             _fieldFocusChange ( femail , fsenha);
           },enabled: enableTexts,onChanged: (text){
            setState(() {
              if (c_email.text.contains("@")==true && c_email.text.contains(".com")==true){
                print("");

                widget.corEmail = Colors.green;
              }else
                widget.corEmail = Colors.orange;

            });
          }, controller: c_email, decoration: InputDecoration(hintText: "EMAIL"), keyboardType: TextInputType.emailAddress ,style: TextStyle(fontSize: 14,color:widget.corEmail,fontFamily: 'RobotoLight'),),),

        //senha
        Container(height: 30, margin: EdgeInsets.fromLTRB(30, 0, 30, 10), child:
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
          Container(height: 30, margin: EdgeInsets.fromLTRB(30, 0, 30, 10), child:
          TextField(enabled: enableTexts,onChanged: (text){setState(() {
              if ( c_senha.text==c_senha_.text){
                  widget.corSenha_=Colors.green;
              }else
                widget.corSenha_=Colors.orange;

          });},controller: c_senha_,decoration: InputDecoration(hintText: "SENHA NOVAMENTE*"),obscureText: true ,style: TextStyle(fontSize: 14,color:widget.corSenha_,fontFamily: 'RobotoLight'),),),


          Container(height: 35,width: 130, margin: EdgeInsets.fromLTRB(30, 5, 30, 10), child:
                  RaisedButton(onPressed: (){signUp();},disabledColor: Colors.orange,color:Colors.orange,child: Text("CADASTRAR",style: TextStyle(color:Colors.white),),))
              ]))
    ],),),));

}

_fieldFocusChange (FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus ();
    FocusScope.of (context) .requestFocus (nextFocus);
  }

btnrealizarloginemail(){
    return  GestureDetector(
        onTap: (){setState(() {
          if (c_emaillogin.text.length>0 && c_senhalogin.text.length>0)
              signIn(c_emaillogin.text,c_senhalogin.text);
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

          Container( margin: EdgeInsets.fromLTRB(0, 2,0, 2), child:
          Text("LOGIN",style: TextStyle(color: Colors.white),))
        ],)
    ));
  }


_btnLogiEmail(){
  return  GestureDetector(
      onTap: (){setState(() {
        viewemaillogin=true;
        viewbtns=false;
      });},child:    Container(width: 180,padding: EdgeInsets.fromLTRB(0, 5, 0, 5), alignment: Alignment.center,
      decoration:
      BoxDecoration( color: Colors.white, boxShadow:[BoxShadow(color: Colors.black12,blurRadius: 3.0, offset: Offset(0.0, // horizontal, move right 10
        1.0,  ),)
      ],
          borderRadius: BorderRadius.all(Radius.circular(30))), margin: EdgeInsets.fromLTRB(30, 10, 30, 10), child:
      Row( mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Container(margin: EdgeInsets.fromLTRB(15, 0,0, 0), child:
        Icon(Icons.supervised_user_circle ),),
        Container(margin: EdgeInsets.fromLTRB(10, 0,0, 0), child:
        Text("EMAIL E SENHA"))
      ],)
  ));
}

_btnGoogle(){
  return     Container(width: 180,padding: EdgeInsets.fromLTRB(0, 5, 0, 5), alignment: Alignment.center,
      decoration:
      BoxDecoration( color: Colors.white, boxShadow:[BoxShadow(color: Colors.black12,blurRadius: 3.0, offset: Offset(0.0, // horizontal, move right 10
        1.0,  ),)
      ],
          borderRadius: BorderRadius.all(Radius.circular(30))), margin: EdgeInsets.fromLTRB(30, 10, 30, 10), child:
      Row( mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Container( margin: EdgeInsets.fromLTRB(15, 0,0, 0), child:
        Image.asset("ic_google.png",width: 20,height: 20, fit: BoxFit.cover,
        ),),
        Container( margin: EdgeInsets.fromLTRB(30, 0,0, 0), child:
        Text("GOOGLE"))
      ],)
  );
}


_btnCadastro(){
  return  GestureDetector(
      onTap: (){setState(() {
            viewlogin=false;viewcadastro=true;
      }); },child: Container(width: 180,padding: EdgeInsets.fromLTRB(0, 5, 0, 5), alignment: Alignment.center,
      decoration:
      BoxDecoration( color: Colors.white, boxShadow:[BoxShadow(color: Colors.black12,blurRadius: 3.0, offset: Offset(0.0, // horizontal, move right 10
        1.0,  ),)
      ],
          borderRadius: BorderRadius.all(Radius.circular(30))), margin: EdgeInsets.fromLTRB(30, 10, 30, 15), child:
      Row( mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Container(margin: EdgeInsets.fromLTRB(20, 0,0, 0), child:
        Icon(Icons.contact_mail,color: Colors.orange[300], ),),
        Container(margin: EdgeInsets.fromLTRB(15, 0,0, 0), child:
        Text("CADASTRE-SE"))
      ],)
  ));
}


_btnCadastroGoogle(){
    return  GestureDetector(
        onTap: (){setState(() {
          viewlogin=false;viewcadastro=true;
        }); },child: Container(width: 180,padding: EdgeInsets.fromLTRB(0, 5, 0, 5), alignment: Alignment.center,
        decoration:
        BoxDecoration( color: Colors.white, boxShadow:[BoxShadow(color: Colors.black12,blurRadius: 3.0, offset: Offset(0.0, // horizontal, move right 10
          1.0,  ),)
        ],
            borderRadius: BorderRadius.all(Radius.circular(30))), margin: EdgeInsets.fromLTRB(30, 10, 30, 15), child:
        Row( mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Container(margin: EdgeInsets.fromLTRB(20,0,0,0), child:
          Image.asset("ic_google.png",width: 20,height: 20, fit: BoxFit.cover,
          ),),
          Container(margin: EdgeInsets.fromLTRB(20,0,0,0), child:
          Text("CADASTRE-SE\nCOM GMAIL",style: TextStyle(fontSize: 12),textAlign: TextAlign.center,))
        ],)
    ));
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


Future  signUp() async {
  _screen_loading_in();
  bool check = _checkDados();
    if (check==true){
      try {
          var email = c_email.text;
          var password = c_senha.text;
          var nome = c_nome.text;
          var tell= c_tell.text;
          var user = (await auth.createUserWithEmailAndPassword(email: email, password: password)) ;
          var us = await auth.currentUser();
          widget.Usuario = new User(nome,tell,email, us.uid,null);

          print(email);

          if (user!=null)
             criarUser(widget.Usuario);

        } catch (e) {
          _snackbarcor("Erro ao registrar email ",Colors.red);
          _screen_loading_out(false);
      }
    }else
      {
        _screen_loading_out(false);
      }
}


void criarUser(User muser) async {
    await refData.collection("Usuarios")
        .document(muser.uid)
        .setData({"nome":widget.Usuario.nome,"tell":widget.Usuario.tell,"email":widget.Usuario.email,'uid':widget.Usuario.uid});
    _screen_loading_out(true);
    _snackbarcor("Bem vindo, "+widget.Usuario.nome,Colors.green);
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
