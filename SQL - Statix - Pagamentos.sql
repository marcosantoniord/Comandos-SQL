SELECT 
* FROM EXTRATO_CARTAO_BRCONSULT ECB
INNER JOIN EXTRATO_PARCELA_VENDA_CARTAO_BRCONSULT EPV
ON ECB.ID = EPV.ID_EXT AND ECB.EXTBRCDAT = EPV.EXTPARVDABRCDATPAG
INNER JOIN VENDA_CARTAO_BRCONSULT V 
ON V.ID = EPV.ID_VDA
WHERE ECB.EXTBRCDAT = '2020/02/12' AND ECB.ID= '20200212#18279#29#6375#8'