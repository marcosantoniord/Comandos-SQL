--Dias de atrasado calculado de acordo com a data atual do sistema
--create view V_PREVENDA_VENCIDAS as
select 
	ENT.LOJCOD as LOJA,
	P.PRVCOD as PREVENDA,
	case 
		when P.CLICOD is null
			THEN 'SEM CLIENTE'
		else P.CLICOD + ' - ' + C.AGEFAN
		end as CLIENTE,
	FUNCODVEN + ' - ' + F.AGEFAN as FUNCIONARIO,
	coalesce(PRVDATETG, '') as DATA_ENTREGA_PREVENDA,
	ENT.ENTDATEMI as DATA_ENTREGA_EMISSAO,
	MODELO.MOPDES as MODELO_PROCESSAMENTO,
	datediff(DAY,P.PRVDATETG,ABERTURA.ABRDAT) as DIAS_ATRASO
from V_PREVENDA_SAIDA PS
inner join PREVENDA P with (nolock) on PS.LOJCOD = P.LOJCOD
	and PS.PRVCOD = P.PRVCOD
inner join (
	select 
		E.ENTCOD as COD_ENTREGA,
		E.LOJCOD,
		ED.DOCCOD,
		E.ENTDATEMI
	from ENTREGA E
	inner join ENTREGA_DOCUMENTO ED with (nolock) on E.ENTCOD = ED.ENTCOD
		and E.LOJCOD = ED.LOJCOD
	where ENTSTA IN (
			'R',
			'N'
			)
	group by 
		E.ENTCOD,
		E.LOJCOD,
		ED.DOCCOD,
		E.ENTDATEMI
	) as ENT on ENT.LOJCOD = PS.LOJCOD
	and ENT.DOCCOD = PS.SAICOD
inner join (
	select distinct 
		PRVCOD,
		M.MOPCOD,
		M.MOPDES
	from ITEM_PREVENDA_PROCESSAMENTO IPP
	inner join MODELO_PROCESSAMENTO M with (nolock) on IPP.MOPCOD = M.MOPCOD
	) as MODELO on MODELO.PRVCOD = P.PRVCOD
inner join V_CLIENTE C on C.CLICOD = P.CLICOD
inner join V_FUNCIONARIO F on F.FUNCOD = P.FUNCODVEN
inner join (select
         ABRDAT
      from
         ABERTURA 
      where
         ABRSTA = 'A') as ABERTURA on ABERTURA.ABRDAT >= P.PRVDATEMI
where PRVGERENT = 'S'
	and datediff(DAY, ENT.ENTDATEMI, PRVDATETG) > 0
order by p.PRVDATEMI


--ENTIDADES
INSERT INTO ENTIDADE (ENTNOM,ENTTIT)  VALUES ('V_PREVENDA_VENCIDAS', 'Relatório Pré-Vendas Vencidas')

--ATRIBUTOS 
INSERT INTO ATRIBUTO (ENTNOM,ATRNOM,ATRTIT,ATRTIP,ATRTMN,ATRMSK,ATRFMTZERESQ) VALUES ('V_PREVENDA_VENCIDAS','LOJA','Loja','S',6,'999999;0;_','S')
INSERT INTO ATRIBUTO (ENTNOM,ATRNOM,ATRTIT,ATRTIP,ATRTMN,ATRMSK,ATRFMTZERESQ) VALUES ('V_PREVENDA_VENCIDAS','PREVENDA','Código pré-venda','I',0,'','N')
INSERT INTO ATRIBUTO (ENTNOM,ATRNOM,ATRTIT,ATRTIP,ATRTMN,ATRMSK,ATRFMTZERESQ) VALUES ('V_PREVENDA_VENCIDAS','CLIENTE','Cliente','S',31,'','N')
INSERT INTO ATRIBUTO (ENTNOM,ATRNOM,ATRTIT,ATRTIP,ATRTMN,ATRMSK,ATRFMTZERESQ) VALUES ('V_PREVENDA_VENCIDAS','FUNCIONARIO','Funcionário','S',31,'','N')
INSERT INTO ATRIBUTO (ENTNOM,ATRNOM,ATRTIT,ATRTIP,ATRTMN,ATRMSK,ATRFMTZERESQ,ATRFMTEXB) VALUES ('V_PREVENDA_VENCIDAS','DATA_ENTREGA_PREVENDA','Entrega Pré-Venda','D',0,'99/99/9999;1;_','N','DD/MM/YYYY')
INSERT INTO ATRIBUTO (ENTNOM,ATRNOM,ATRTIT,ATRTIP,ATRTMN,ATRMSK,ATRFMTZERESQ,ATRFMTEXB) VALUES ('V_PREVENDA_VENCIDAS','DATA_ENTREGA_EMISSAO','Entrega Emissão','D',0,'99/99/9999;1;_','N','DD/MM/YYYY')
INSERT INTO ATRIBUTO (ENTNOM,ATRNOM,ATRTIT,ATRTIP,ATRTMN,ATRMSK,ATRFMTZERESQ) VALUES ('V_PREVENDA_VENCIDAS','MODELO_PROCESSAMENTO','Processamento','S',50,'','N')
INSERT INTO ATRIBUTO (ENTNOM,ATRNOM,ATRTIT,ATRTIP,ATRTMN,ATRMSK,ATRFMTZERESQ) VALUES ('V_PREVENDA_VENCIDAS','DIAS_ATRASO','Dias atrasos','I',4,'','N')


