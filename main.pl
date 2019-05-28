
 :- use_module(library(pce)).
 :- pce_image_directory('./img').
 :- use_module(library(pce_style_item)).
 :-consult('./conocimiento.pl').
 :-consult('./motorDeInferencia.pl').
 :- dynamic color/2.
 
resource(img_principal, image, image('fondo2.jpg')).
resource(portada, image, image('fondo2.jpg')).
resource(lupa,image,image('lupa.jpg')).
resource(a_traves_del_espejo_y_lo_que_alicia_encontro_alli,image,image('a_traves_del_espejo_y_lo_que_alicia_encontro_alli.jpg')).
resource(alicia_en_el_pais_de_las_maravillas_y_a_traves_del_espejo,image,image('alicia_en_el_pais_de_las_maravillas_y_a_traves_del_espejo.jpg')).
resource(asesino_en_el_oriente_express,image,image('asesino_en_el_oriente_express.jpg')).
resource(bajo_la_misma_estrella,image,image('bajo_la_misma_estrella.jpg')).
resource(el_dia_que_dejo_de_nevar_en_alaska,image,image('el_dia_que_dejo_de_nevar_en_alaska.jpg')).
resource(el_dia_que_el_oceano_te_mire_a_los_ojos,image,image('el_dia_que_el_oceano_te_mire_a_los_ojos.jpg')).
resource(el_principito,image,image('el_principito.jpg')).
resource(el_regreso_del_joven_principe,image,image('el_regreso_del_joven_principe.jpg')).
resource(eleanor_y_park,image,image('eleanor_y_park.jpg')).
resource(la_vuelta_al_mundo_en_ochenta_dias,image,image('la_vuelta_al_mundo_en_ochenta_dias.jpg')).
resource(los_miserables,image,image('los_miserables.jpg')).
resource(los_viajes_de_gulliver,image,image('los_viajes_de_gulliver.jpg')).
resource(maze_runner,image,image('maze_runner.jpg')).
resource(moby_dick,image,image('moby_dick.jpg')).
resource(si_entras_te_atrapara_el_sotano,image,image('si_entras_te_atrapara_el_sotano.jpg')).
resource(la_cabana,image,image('la_cabana.jpg')).
resource(orgullo_y_prejuicio,image).
 
 mostrar_imagen(Pantalla, Imagen) :- new(Figura, figure),
                                     new(Bitmap, bitmap(resource(Imagen),@on)),
                                     send(Bitmap, name, 1),
                                     send(Figura, display, Bitmap),
                                     send(Figura, status, 1),
                                     send(Pantalla, display,Figura,point(100,80)).
  mostrar_imagen_tratamiento(Pantalla, Imagen) :-new(Figura, figure),
                                     new(Bitmap, bitmap(resource(Imagen),@on)),
                                     send(Bitmap, name, 1),
                                     send(Figura, display, Bitmap),
                                     send(Figura, status, 1),
                                     send(Pantalla, display,Figura,point(20,100)).
 nueva_imagen(Ventana, Imagen) :-new(Figura, figure),
                                new(Bitmap, bitmap(resource(Imagen),@on)),
                                send(Bitmap, name, 1),
                                send(Figura, display, Bitmap),
                                send(Figura, status, 1),
                                send(Ventana, display,Figura,point(0,0)).
  imagen_pregunta(Ventana, Imagen) :-new(Figura, figure),
                                new(Bitmap, bitmap(resource(Imagen),@on)),
                                send(Bitmap, name, 1),
                                send(Figura, display, Bitmap),
                                send(Figura, status, 1),
                                send(Ventana, display,Figura,point(500,60)).
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
  botones:-borrado,
                send(@boton, free),
                send(@btntratamiento,free),
                mostrar_diagnostico(Enfermedad),
                send(@texto, selection('El libro recomendado a partir de los datos es:')),
                send(@resp1, selection(Enfermedad)),
                new(@boton, button('Iniciar consulta',
                message(@prolog, botones)
                )),

                new(@btntratamiento,button('Detalles y Tratamiento',
                message(@prolog, mostrar_tratamiento,Enfermedad)
                )),
                send(@main, display,@boton,point(20,450)),
                send(@main, display,@btntratamiento,point(138,450)).



  mostrar_tratamiento(X):-new(@tratam, dialog('Tratamiento')),
                          send(@tratam, append, label(nombre, 'Explicacion: ')),
                          send(@tratam, display,@lblExp1,point(70,51)),
                          send(@tratam, display,@lblExp2,point(50,80)),
                          tratamiento(X),
                          send(@tratam, transient_for, @main),
                          send(@tratam, open_centered).

tratamiento(X):- send(@lblExp1,selection('De Acuerdo a lo contestado, tu libro recomendado es:')),
                 mostrar_imagen_tratamiento(@tratam,X).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  

   preguntar(Preg,Resp):-new(Di,dialog('Colsultar Datos:')),
                        new(L2,label(texto,'Responde las siguientes preguntas')),
                        id_imagen_preg(Preg,Imagen),
                        imagen_pregunta(Di,Imagen),
                        new(La,label(prob,Preg)),
                        new(B1,button(si,and(message(Di,return,si)))),
                        new(B2,button(no,and(message(Di,return,no)))),
                        send(Di, gap, size(25,25)),
                        send(Di,append(L2)),
                        send(Di,append(La)),
                        send(Di,append(B1)),
                        send(Di,append(B2)),
                        send(Di,default_button,'si'),
                        send(Di,open_centered),get(Di,confirm,Answer),
                        free(Di),
                        Resp=Answer.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  interfaz_principal:-new(@main,dialog('Sistema Experto Para Recomendar Libros',
        size(1000,1000))),
        new(@texto, label(nombre,'El Diagnostico a partir de los datos es:',font('times','roman',18))),
        new(@resp1, label(nombre,'',font('times','roman',22))),
        new(@lblExp1, label(nombre,'',font('times','roman',14))),
        new(@lblExp2, label(nombre,'',font('times','roman',14))),
        new(@salir,button('SALIR',and(message(@main,destroy),message(@main,free)))),
        new(@boton, button('Iniciar consulta',message(@prolog, botones))),

        new(@btntratamiento,button('¿Libro?')),

        nueva_imagen(@main, img_principal),
        send(@main, display,@boton,point(138,450)),
        send(@main, display,@texto,point(20,130)),
        send(@main, display,@salir,point(300,450)),
        send(@main, display,@resp1,point(20,180)),
        send(@main,open_centered).

       borrado:- send(@resp1, selection('')).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  main:- new(@interfaz,dialog('Bienvenido al Sistema Experto Recomendador',
  size(1000,1000))),

  mostrar_imagen(@interfaz, portada),

  new(BotonComenzar,button('COMENZAR',and(message(@prolog,interfaz_principal) ,
  and(message(@interfaz,destroy),message(@interfaz,free)) ))),
  new(BotonSalir,button('SALIDA',and(message(@interfaz,destroy),message(@interfaz,free)))),
  send(@interfaz,append(BotonComenzar)),
  send(@interfaz,append(BotonSalir)),
  send(@interfaz,open_centered).

  :-main.