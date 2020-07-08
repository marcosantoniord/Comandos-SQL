begin try
  declare @CodigoLocalPrincipal char(3)
  set @CodigoLocalPrincipal = '001'

  begin tran 
	if not exists (SELECT * FROM SYSOBJECTS WHERE NAME = 'COMPOSTO_LOCAL_TEMP') 
	  select * into COMPOSTO_LOCAL_TEMP from COMPOSTO_LOCAL

	insert into COMPOSTO_LOCAL 
	select
	  L.LOJCOD, 
	  L.LOCCOD, 
	  C.REFPLU,
	  NULL,
	  NULL
	from 
	  COMPOSTO C cross join
	  LOCAL L 
	where
	  L.LOCCOD = @CodigoLocalPrincipal and 
	  isnull(L.LOCVDA, 'N') = 'S' and
	  not exists
	  (
		select 
		  * 
		from 
		  COMPOSTO_LOCAL CL 
		where 
		  CL.REFPLU = C.REFPLU and
		  CL.LOJCOD = L.LOJCOD and
		  CL.LOCCOD = L.LOCCOD
	  )
	  
	commit
    print 'comando aplicado com sucesso!'
end try
begin catch
    rollback
    print error_message()
end catch