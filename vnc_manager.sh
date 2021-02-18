#!/bin/bash



DISPLAY_DEFAUT_='1'
GEOMETRIA_DEFAUT_='480x720'
GERENCIADOR_JANELAS_DEFAULT_='fluxbox -display'

# Função para iniciar display especificado e geometria indicada

iniciar_display() {


	echo "Iniciar display em: (default = :1)"
	if [ -z `read ABRIR_DISPLAY` ];
	then
		DISPLAY_=$DISPLAY_DEFAUT_
	else
		DISPLAY_=$ABRIR_DISPLAY_
	fi

	echo "Tamanho do display: (default 480x720)"
	 
	if [ -z `read $GEOMETRIA_` ];
	then
		GEOMETRIA_=$GEOMETRIA_DEFAUT_
	else
		GEOMETRIA_=$GEOMETRIA_
	fi

	echo "Abrir gerenciador de janelas? (default sim)"
	if [ -z `read GERENCIADOR_JANELAS` ]; 
	then 
		GERENCIADOR_JANELAS="$GERENCIADOR_JANELAS_DEFAULT_ :$DISPLAY_"
	else
		unset GERENCIADOR_JANELAS
	fi


vncserver :$DISPLAY_ -geometry $GEOMETRIA_ -autokill  -xstartup /usr/bin/xterm && $GERENCIADOR_JANELAS_ &



}

# Funcão que cria a lista de display e os processos. Salva em um arquivo temporario e exibe o resultado após procewwamento do texto

lista_display() {
vncserver -list > lista_display.txt

awk '/^[:[:digit:]]/ { print("DISPLAY\t" $1, "PID\t", $2)}' lista_display.txt
cat lista_display.txt

}



# Funcão queh seleciona ação a ser tomada com o display

escolhe_display(){


        echo "Deseja matar display?: (a/y/n)"
        read MATAR_DISPLAY_

        while   [  $MATAR_DISPLAY_ != 'a'  -a  $MATAR_DISPLAY_ != 'A'  -a  $MATAR_DISPLAY_ != 'y'   -a   $MATAR_DISPLAY_ != 'Y'  -a  $MATAR_DISPLAY_ != 'n' -a  $MATAR_DISPLAY_ != 'N' ];
	do
		echo 'Opção invalida'
		echo 'Deseja matar display: (a/y/n)'
		read MATAR_DISPLAY_
	
done


}

matar_display() {

# Mata todos os displays

        if [ $MATAR_DISPLAY_ = 'a'  -o  $MATAR_DISPLAY_ = 'A' ];
then
	awk '/^[:[:digit:]]/ {print($1)}' lista_display.txt |xargs -I % sh -c 'vncserver -kill %'
# Mata display especifico
        elif [ $MATAR_DISPLAY_ = 'y'  -o $MATAR_DISPLAY_ = 'Y' ];
then
        echo 'Matar display:'
        read DISPLAY_
        vncserver -kill :$DISPLAY_

# Sai sem matar display
        else [ $MATAR_DISPLAY_ = 'n' -o $MATAR_DISPLAY_ = 'N' ];
                echo 'Saindo do script'
fi
}


menu_() {
	echo "Script de gerenciamento VNC"
	PS3="Selecione a opção desejada"
	select SELECT_ in 'Listar Displays' 'Criar Display' 'Matar Displays'
	do
		`$SELECT_` 
		break;
	done
}
# menu

menu(){
	echo "Script de gerenciamento VNC\n\n"
	echo "(L)istar displays"
	echo "(I)niciar displays"
	echo "(M)atar display"
	read SELECT_


	while   [[  $SELECT_ != 'l'  &&  $SELECT_ != 'L'  && $SELECT_  != 'i'   &&  $SELECT_ != 'I'  &&  $SELECT_ != 'm' &&  $SELECT_ != 'M' ]] ;
	do

	echo 'Opção invalida'
	echo "Script de gerenciamento VNC\n\n"
	echo "(L)istar displays"
	echo "(I)niciar displays"
	read SELECT_
done

	if [ $SELECT_ = 'l'  -o  $SELECT_ = 'L' ];
	then
		lista_display
		
	elif [ $SELECT_ = 'i'  -o  $SELECT_ = 'L' ];
	then
		iniciar_display
	elif [ $SELECT_ = 'm'  -o  $SELECT_ = 'M' ]
	then
		lista_display
		escolhe_display
		matar_display

	fi
}
menu
