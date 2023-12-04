/* O código abaixo poderá ser executado no sas on demand*/
/* https://welcome.oda.sas.com/ */

/*******************************/
/* Criando uma nova biblioteca */
/*******************************/
%let user = u63683433; *Digite aqui o seu usuário;
libname pgl "/home/&user./EPG1V2/data"; * cria biblioteca pgl;

/*******************************/
/* Criando um dataset (tabela) na nova biblioteca*/
/*******************************/
data NovoDataset pgl.NovoDataset_1;
	set sashelp.class;
run;
/* Resultado: Criou dois novos datasets NovoDataset (biblioteca work que é a padrão) e NovoDataset_1 (biblioteca pgl que foi criada) a partir da tabela class da biblioteca sashelp*/

/*******************************/
/* Como acessar os dados de um dataset (tabela)
/*******************************/
proc print data=pgl.NovoDataset_1;
run;
/* Resultado: Todos os dados do dataset*/

proc print data = pgl.NovoDataset_1 (obs=10);
run;
/* Resultado: Retorna as 10 primeiras linhas do dataset*/

proc print data = pgl.NovoDataset_1;
     var  Age Height Weight;
run;
/* Resultado: Retorna os campos  Age, Height e Weight  do dataset*/

proc print data = pgl.NovoDataset_1 (obs=5 firstobs=5);
run;
/* Resultado: Retorna especificamente a linha 5 do dataset*/

proc means data = pgl.NovoDataset_1;
     var  Age;
run;
/* Resultado: Calcula um sumário de estatísticas da coluna Age*/

proc univariate data=pgl.NovoDataset_1;
	var Age;
run;
/* Resultado: Examina os valores extremos da coluna Age*/

proc freq data=pgl.NovoDataset_1;
     tables age;
run;
/* Resultado: Lista valores únicos e frequencias da coluna Age*/

proc print data=pgl.NovoDataset_1;
	* where age <= 14 and name = "Thomas";
	* where age in (10, 11, 12, 13);
	* where 11< age <14;
	* where age between 11 and 14;
	* where data >= "01jan2021"d;
	* where name like "T%";
	* where name like "T_%";
	* where name is missing;
	* where name is not missing;
	* where name is null;
run;
/* Resultado: Utilizando a cláusula where com algumas restrições na consulta*/

proc print data=pgl.NovoDataset_1;
	 format  Height 2.;
run;
/* Resultado: Formata o campo Height com 2 dígitos*/

proc sort data=pgl.NovoDataset_1 
	out=OrdenandoNovoDataset_1;
	by name descending age;
run;
/* Resultado: Ordena o resultado da tabela NovoDataset por name de forma crescente e age de forma decrescente*/
/* Dica: Utilizar o comando out para não modificar a tabela original*/

proc sort data=pgl.NovoDataset_1 
	out = SemDuplicados
	nodupkey 
	dupout=Duplicados;
	* by _all_;
	by age;
run;
proc print data=SemDuplicados; run; *Visualiza dados não duplicados;
proc print data=Duplicados; run; *Visualiza dados duplicados;
/* Resultado: Gera os resultados não duplicados em SemDuplicados e os duplicados em Duplicados. */

/*******************************/
/* Criando um dataset (tabela) a partir de outra tabela com condições*/
/*******************************/

Data ExercicioCriandoDataset;
	set sashelp.class;
	where age > 14;
	format  Height 2.1; * formata campo para nova tabela;
	keep  Age Name Sex Height; * mantem estas colunas (vars) na tabela nova criada;
	drop  Weight; * retira coluna (vars) "Weight" na tabela nova criada;
run;
Proc print data=ExercicioCriandoDataset; run;
/* Resultado: Cria nova tabela ExercicioCriandoDataset com restrições a partir da tabela sashelp.class */


Data ExercicioCriandoDataset;
	set sashelp.class;
	Coluna_nova = "Teste de coluna nova"; *Criando nova coluna;
	/*No exemplo abaixo o campo valor é criado na tabela respeitando a condição*/
	if age > 12 
	then 
			do; 
				Valor = 'MAIOR 12';
			end;
	else 
			do;
				Valor = 'MENOR IGUAL 12';
			end;
run;
Proc print data=ExercicioCriandoDataset; run;
/* Resultado: Cria nova tabela ExercicioCriandoDataset com criação de novas colunas, inclusive utilizando cláusula IF*/
/* Dica bônus, caso precise de mais de uma condição para rodar, utilizar o do/end*/

Data Condicoes;
	set sashelp.airline;
	if Region = "ALL" and Air < 300 then Tipo=1;
	else Tipo=2;
* também dá para usar ELSE IF para demais opções de ELSE;
run;
proc print data=Condicoes; run;
/* Resultado: Cria nova tabela Condicoes avaliando as condicoes e definindo a coluna Tipo*/

Data ExercicioFuncoes;
Set sashelp.class;
	NameMaiusculo = upcase (Name); * uppercase;
	NameMinusculo = lowcase(Name); * lowercase;
	NameTruncadoIdade = cats (Name, age); * concatena;
	NameSubstring = Substr(Name, 1,2); * substring;
run;
/* Resultado: Cria nova tabela ExercicioFuncoes com funções uppercase, lowercase, concatenação e substring*/

* Trabalha com cálculos de datas;
data CalcNumDias;
	set sashelp.airline;
	AnosPassados=yrdif(date, today());
	Date1=mdy(month(date), day(date), year(date));
	format date1 MMDDYY10.;
run;
/* Resultado: Cria nova tabela CalcNumDias com:
 AnosPassados - sendo a diferença da coluna (variável como é chamado pelo sas) date (da tabela sashelp.airline) e a data atual
 Date2 - formata a data em mês, dia e ano
 Por último date1 é formatado para MMDDYY10 (ex: 01/01/2010)
*/

data LimitacaoTamanho;
	set sashelp.class;
	length Nome $ 2;
	Nome=Name;
	keep Name Age Nome;
run;
/* Resultado: cria nova tabela LimitacaoTamaho com uma nova coluna chamada Nome e tamanho de 2 caracteres */

/*******************************/
/* Analisando e reportando dados*/
/*******************************/
/* Aqui vamos declarar 3 variáveis e utilizá-las a seguir para titulo, subtitulo e rodapé*/
%LET Titulo=TITULO;
%LET SubTitulo=SUBTITULO;
%LET Rodape=FIM DE RELATÓRIO;

TITLE1 &Titulo.;
TITLE2 &SubTitulo.;
FOOTNOTE &Rodape.;

PROC PRINT DATA=SASHELP.CLASS;
RUN;
TITLE; *LIMPA TÍTULO;
FOOTNOTE; *LIMPA RODAPÉ;
/* Resultado: Configura título, subtitulo e rodapé*/

proc print data=sashelp.class label;
	where name="Thomas";
	var name age;
	label name =  "Nome do aluno"
		  age = "Idade do aluno";
run;
/* Resultado: Utiliza cláusula where para restringir resultado, define os campos a serem exibidos (var) e configura o nome da coluna a ser exibido*/


proc sort data = sashelp.class
	out = ClasseOrdenada; * usar out para não modificar o dataset original;
	by Name ;
run;
/* Resultado: ordena o dataset ClasseOrdenada por Name */
proc freq data=ClasseOrdenada;
	by name;
	tables Name;
run;
/* Resultado: utiliza o dataset ClasseOrdenada que havia sido criado e agrupa por nome os indicadores através do FREQ*/


ods graphics on;
ods noproctitle on;
proc freq data=sashelp.class order=freq;
	tables Name Age / nocum plots=freqplot;
run;
* Resultado: Gera indicadores e gráficos a partir das colunas Name e Age da tabela sashelp.class;


proc freq data=sashelp.class order=freq; *NOPRINT suprime os resultados em "results";
	tables Name*Age / out=RelatorioClass; * out cria uma nova tabela;
	label Name= "Nome"
		  Age= "Idade";
run;
proc print data=RelatorioClass; run;
/* Resultado: Cria dataset RelatorioClass com as colunas Name e Idade com informações de count e percentual*/

proc means data=sashelp.class noprint;
	var age;
	output out=Media_Idade mean=age; 
run;
proc print data=Media_Idade; run;
/* Resultado: Gera uma média para o dataset Media_Idade a partir da idade*/




