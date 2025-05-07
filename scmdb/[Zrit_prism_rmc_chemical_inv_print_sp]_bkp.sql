Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*******************************************************************************           
   Procedure        : Zrit_prism_rmc_service_inv_print_sp
   Created By        : Vishnu Priya  
   Created Date        : 04-Jan-2024
   Rtrack id        : Prism RMC
  Description        : Chemical Invoice Print Report 
   Modified By      :  
   Modified Date    : 
*******************************************************************************/
--exec Zrit_prism_rmc_chemical_inv_print_sp  '6','RJT23/COB0000005','',''
--exec Zrit_prism_rmc_chemical_inv_print_sp  '121','CBPEN25COB000003','',''

--exec Zrit_prism_rmc_chemical_inv_print_sp  '230','CI4507260000003','',''
/*Narmadhadevi M  05/04/2025  RPRMCB-1(weight calculation changes)*/
/*Aparna M  09/04/2025  RPRMCB-1(weight calculation changes)*/

CREATE procedure [dbo].[Zrit_prism_rmc_chemical_inv_print_sp]
@_hiddenou              int,
@invoicenumber          varchar(200),
@_hidden2              varchar(255),
@_hidden3			   varchar(255)
As
Begin


Create Table #Zrit_prism_rmc_Chemical_tmp            
(            
wfdockey      nvarchar(240)            
,report_type1   nvarchar(80)            
,invoice_no    nvarchar(36)            
,packslipdate   nvarchar(20)            
,totaltimeml   nvarchar(24)            
,org_unit    int             
,currency_code   nvarchar(10)            
,modetransport   nvarchar(300)            
,destinationlocation nvarchar(510)            
,billtocustomercode  nvarchar(36)            
,billtocustomername  nvarchar(500)            
,billtoaddress1   nvarchar(510)            
,billtoaddress2   nvarchar(510)            
,billtoaddress3   nvarchar(510)            
,billstate    nvarchar(80)            
,billtocountry   nvarchar(60)            
,billtoph    nvarchar(510)            
,shipcustcodeml   nvarchar(36)            
,shiptocustomernameml   nvarchar(500) -- nvarchar(max)          
,shipaddress1   nvarchar(510)            
,shipaddress2   nvarchar(510)            
,shipaddress3   nvarchar(510)            
,shiptostate   nvarchar(80)            
,shiptoctry    varchar(100)            
,shiptoph    nvarchar(510)            
,linenumber    int             
,itemcode    nvarchar(64)            
,tcdtype    nvarchar(50)            
,itemdesc_ml   nvarchar(300)            
,itemvariantml   nvarchar(64)            
,itemvariantdesc  nvarchar(1500)            
,item_type    nvarchar(50)            
,unitprice    numeric (28,8)            
,uom     nvarchar(30)            
,invoicequantity  numeric (28,8)            
,invoicedamount   numeric (28,2)  --numeric (28,8)            
,invoicenetamount  numeric (28,8)            
,itemlevelcharge  numeric (28,8)            
,itemleveldiscount  numeric (28,8)            
,item_tax    numeric (28,8)            
,paytermdes    nvarchar(510)            
,shipremarks   nvarchar(512)            
,insuranceterm1   nvarchar(300)            
,companycode   nvarchar(20)            
,companyname   nvarchar(120)            
,companyaddress1  nvarchar(510)            
,companyaddress2  nvarchar(510)            
,companyaddress3  nvarchar(510)            
,[state]    nvarchar(80)            
,origincountry   nvarchar(510)            
,phoneno1    nvarchar(510)            
,narration    nvarchar(510)            
,extrachar1    nvarchar(80)            
,extrachar2    nvarchar(4)            
,extrachar3    nvarchar(4)            
,extrachar4    nvarchar(80)             
,extrachar5    nvarchar(80)   
,extrachar7    nvarchar(80)    
,extrachar8    nvarchar(50)  
,extrachar6    nvarchar(80)  
,extrachar9    nvarchar(510)            
,extrachar10   nvarchar(240)            
,extraamount1   numeric (28,8)            
,extraamount2   numeric (28,8)            
,extraamount3   numeric (28,8)            
,extraamount4   numeric (28,8)            
,extraamount5   numeric (28,8)            
,extraamount6   numeric (28,8)             
,extraamount7 numeric (28,8)     
,extraamount8   numeric (28,8)            
,extraamount9   numeric (28,8)             
,extraamount10   numeric (28,2)--numeric (28,8)            
,date1     nvarchar(40)         
,date2     date            
,date3     nvarchar(20)   
,date4 nvarchar(510)            
,date5     nvarchar(20)  --helan           
,Total_inv_amount  numeric (28,8)            
,Print_date    Date             
,Print_time    nvarchar(24)            
,invoicestatus_ml  varchar(1)            
,sequenceno    int             
,[guid]     nvarchar(256)            
,wfdockey2    nvarchar(240)            
,extraamount11   numeric(28,8)            
,extraamount12   numeric(28,8)            
,extraamount13   numeric (28,2)--numeric(28,8)             
,extraamount14   numeric (28,2)--numeric(28,8)             
,extraamount15  numeric(28,8)             
,extraamount16   numeric(28,8)             
,extraamount17   numeric(28,8)            
,extraamount18   numeric(28,8)            
,extraamount19   numeric(28,8)            
,extraamount20   numeric(28,8)            
,Extraint1    numeric(28,8)            
,Extraint2    numeric(28,8)            
,Extraint3  numeric(28,8)            
,Extraint4    numeric(28,8)            
,Extraint5    numeric(28,8)            
,extranumeric1   numeric(28,8)            
,extranumeric2   numeric(28,8)            
,extranumeric3   numeric(28,8)             
,extranumeric4   numeric(28,8)            
,extranumeric5   numeric(28,8)            
,extrachar11   nvarchar(240)            
,extrachar12   nvarchar(240)            
,EXTRACHAR13   nvarchar(10)             
,EXTRACHAR14   nvarchar(36)            
,EXTRACHAR15   nvarchar(80)            
,EXTRACHAR16   nvarchar(510)            
,EXTRACHAR17   nvarchar(510)            
,EXTRACHAR18   nvarchar(510)            
,EXTRACHAR19   nvarchar(510)            
,EXTRACHAR20   nvarchar(510)            
,EXTRACHAR21   nvarchar(510)            
,EXTRACHAR22   nvarchar(50)            
,EXTRACHAR23   nvarchar(36)            
,EXTRACHAR24   nvarchar(510)            
,EXTRACHAR25   nvarchar(510)            
,EXTRACHAR26   nvarchar(40)            
,EXTRACHAR27   nvarchar(300)            
,EXTRACHAR28   nvarchar(36)            
,EXTRACHAR29   nvarchar(40)            
,EXTRACHAR30   nvarchar(532)            
,EXTRACHAR31   nvarchar(510)            
,EXTRACHAR32   varchar (64)            
,EXTRACHAR33   nvarchar(80)            
,EXTRACHAR34   nvarchar(80)            
,EXTRACHAR35   nvarchar(50)            
,EXTRACHAR36   nvarchar(300)            
,EXTRACHAR37   int             
,EXTRACHAR38   nvarchar(1500)            
,EXTRACHAR39   nvarchar(1452)            
,EXTRACHAR40   nvarchar(510)            
,EXTRACHAR41   nvarchar(510)            
,EXTRACHAR42   nvarchar(510)            
,EXTRACHAR43   int             
,EXTRACHAR30_1   varchar(200)            
,extraamount21   int             
,extraamount22   int             
,Extraamount23   numeric(28,8)            
,extraamount24   numeric(28,8)      
  
)   
   
declare @Tran_type varchar(100) 

declare @date_tmp        udd_date ,@company_code varchar(100) ,@company_name varchar(100)                                 
 select @date_tmp = dbo.RES_Getdate(@_hiddenou)                                  

  select                            
 @company_code=company_code, 
  @company_name=company_name  
  from emod_ou_mst_vw(nolock)                                
where ou_id=@_hiddenou  

 Select @company_code = company_code                          
 From emod_lo_bu_ou_vw(nolock)                          
 Where ou_id   = @_hiddenou

 declare @left int
select @left =  (charindex('-',company_name))
 from emod_ou_mst_vw with (nolock)   
 where company_name =@company_name


select @company_name = SUBSTRING(company_name, 1,case when @left =0 then len (company_name ) else @left-1 end) 
  --Code added againt id:PJRMC-1204 ends
 from emod_ou_mst_vw with (nolock)   
  where company_name =@company_name

select          
@Tran_type = tran_type            
from Cobi_invoice_hdr with(nolock)            
where tran_no = @invoicenumber            
and tran_ou = @_hiddenou            
    
insert into #Zrit_prism_rmc_Chemical_tmp          
exec zrit_COBIPRINTSpfetDtl            
      @ctxt_ouinstance   =@_hiddenou                                       
     ,@ctxt_user         =@_hidden3                                                  
     ,@ctxt_language     =1                                               
     ,@ctxt_service   ='cobiprintsrfet'                                              
     ,@tranno            =@invoicenumber                                                 
     ,@tranou            =@_hiddenou                                        
     ,@guid              =@_hidden2                     
     ,@trantype          =@Tran_type                 
     ,@printlanguage     ='English'                         
     ,@m_errorid         =0       


	 
 
 /*
 insert into #Zrit_prism_rmc_Chemical_tmp(invoice_no,date1)  
 select tran_no, tran_date
 from Cobi_invoice_hdr with(nolock)
 where tran_no = @invoicenumber
 and tran_ou = @_hiddenou
 */
  
update  #Zrit_prism_rmc_Chemical_tmp            
 set  date1=isnull(CONVERT(VARCHAR(10),cast(date1 as datetime), 104),date1)--helan

 update  #Zrit_prism_rmc_Chemical_tmp            
 set  date5=isnull(CONVERT(VARCHAR(10),cast(date5 as datetime), 105),date5)--helan


 alter table  #Zrit_prism_rmc_Chemical_tmp  add          
 CIN  varchar(2000),state_code varchar(2000),report_type  varchar(200),del_state_code varchar(200),          
 buy_ord_no  varchar(2000),batch_serial_no  varchar(2000),sales_eng  varchar(500),vehicle_no  varchar(200),          
 transport_mode varchar(2000),          
 cobi_extrachar1  varchar(2000),cobi_extrachar2  varchar(2000),           
cobi_extrachar3  varchar(2000),cobi_extrachar4  varchar(2000),cobi_extrachar5  varchar(2000),      
cobi_extrachar6  varchar(2000),cobi_extrachar7 varchar(2000),cobi_extrachar8  varchar(2000),          
cobi_extrachar9  varchar(200),cobi_extrachar10 varchar(200),cobi_extrachar11  varchar(200),          
cobi_numeric1 numeric(28,2) ,cobi_numeric2 numeric(28,2),cobi_numeric3 numeric(28,2),          
cobi_numeric4 numeric(28,2) ,cobi_numeric5 numeric(28,2),cobi_numeric6 numeric(28,2),          
cgst_char1 varchar(200),sgst_char2 varchar(200) ,igstchar3 varchar(200),cess_char3           
varchar(200),round_off numeric(28,2) ,total   numeric(28,2) ,amount_in_words          
varchar(2000),text1  varchar(8000),text2  varchar(8000),          
text3  varchar(8000),text4  varchar(8000),text5  varchar(8000),          
text6  varchar(8000),text7  varchar(8000),text8  varchar(8000),text9  varchar(8000)
,order_date date,po_ref_no varchar(200), shipment_no varchar(200)  




update #Zrit_prism_rmc_Chemical_tmp
set cobi_extrachar11 = @company_name --code added by Aparna M for subsidiary company    

   --update #Zrit_prism_rmc_Chemical_tmp
   --set date1=isnull(CONVERT(VARCHAR(10),cast(date1 as datetime), 105),date1) 
   
  --27082024
--UPDATE #Zrit_prism_rmc_Chemical_tmp
--SET date1 = FORMAT(CAST(date1 AS DATE), 'dd.MM.yyyy');
          
         
--Plantname & Addresss          
update #Zrit_prism_rmc_Chemical_tmp          
set cobi_extrachar6=isnull(company_name,'')+' & '+isnull(address1,'')+' '+isnull(address2,'')+','+isnull(city,'')+'-'+isnull(zip_code,'') ,          
/*cobi_extrachar7=m.[state],  *//*Gayathri on 05-01-2024*/         
cobi_extrachar8=phone_no  --Phone No          
from emod_company_mst m(nolock)          
left join #Zrit_prism_rmc_Chemical_tmp t 
on (m.company_code=t.companycode)   



 
 /*code commented and added Gayathri on 05-01-2024 starts*/         
         
  update #Zrit_prism_rmc_Chemical_tmp          
 set  cobi_extrachar6 =  case when  isnull(address_desc,'') <> '' then  isnull(address_desc,'')+', ' else '' end          
        + case when isnull(address1,'') <> '' then  isnull(address2,'')+', ' else '' end          
        + case when isnull(address2,'') <> '' then  isnull(address2,'')+', ' else '' end                            
        + case when isnull(address3,'') <> '' then  isnull(address3,'')+', ' else '' end       
        + case when isnull(city,'')     <> '' then  isnull(city,'')+',' else '' end                 
        + case when isnull(country,'')  <> '' then  isnull(country,'')+'-' else '' end            
        + case when isnull(zip_code,'')  <> '' then  isnull(zip_code,'')+' ' else '' end  ,        
  cobi_extrachar8=phone_no          
             
 from emod_ou_addr_map_vw(nolock)       
 where ou_id   =@_hiddenou          
          
        
 --state          
/*update #Zrit_prism_rmc_Chemical_tmp          
set cobi_extrachar9=region_code          
 from emod_region_vw r(nolock)          
left join  #Zrit_prism_rmc_Chemical_tmp t  
on r.region_desc=t.cobi_extrachar7  */        
update #Zrit_prism_rmc_Chemical_tmp          
 set cobi_extrachar7=isnull(region_desc,''),          
  cobi_extrachar9=isnull(region_code,'')          
 from emod_region_vw(nolock),          
   emod_ou_addr_map_vw a(nolock)          
 where ou_id   =@_hiddenou          
 and  a.state=region_desc          
          
/*code commented and added Gayathri on 03-01-2024 ends*/          
          
--plant Code           
update #Zrit_prism_rmc_Chemical_tmp          
set cobi_extrachar10=OUInstName        
/*OUInstDesc  *//*gayathri*/        
from fw_admin_OUInstance (nolock)          
where OUInstId=@_hiddenou          
          
  update  #Zrit_prism_rmc_Chemical_tmp          
  set  CIN= company_id          
 from emod_company_mst m (nolock)          
left join  #Zrit_prism_rmc_Chemical_tmp t          
on m.company_code=t.companycode          
          
update #Zrit_prism_rmc_Chemical_tmp          
set  cobi_numeric1=extraamount1          
,  cobi_numeric2=extraamount3          
,  cobi_numeric3=extraamount5          
,  cobi_numeric4=extraamount7          
          
update  #Zrit_prism_rmc_Chemical_tmp          
set  state_code=  region_code   
 from emod_region_vw r(nolock)       
left join  #Zrit_prism_rmc_Chemical_tmp t    
on r.region_desc=t.shiptostate          
 
 /*Aparna*/
 alter table #Zrit_prism_rmc_Chemical_tmp add cobi_numeric10  numeric(28,2)
 update #Zrit_prism_rmc_Chemical_tmp
 set cobi_numeric10 =cobi_numeric1+cobi_numeric2


 update #Zrit_prism_rmc_Chemical_tmp            
 set  buy_ord_no   = so_no/*sohdr_cust_po_no*/--sohdr_order_no 
     ,date5/*order_date*/        = convert(varchar(20),sohdr_order_date,104)--isnull(cast(sohdr_order_date as datetime), 111),sohdr_order_date)  
 from  #Zrit_prism_rmc_Chemical_tmp            
 join  cobi_item_dtl with (nolock) 
 on invoice_no =tran_no            
 join  so_order_hdr  with (nolock)            
 on  tran_ou = sohdr_ou            
 and so_no   = sohdr_order_no 







 update #Zrit_prism_rmc_Chemical_tmp          
 set  batch_serial_no   = psh_docket_no  ,          
 vehicle_no= psh_vehicleno,     
transport_mode=psh_carriercode--psh_shipmentmode  
--,EXTRACHAR21 = ref_doc_no  
,EXTRACHAR21=sohdr_cust_po_no
,text6 = psh_pkslipno       
 ,text5 = cast(psh_netweight as numeric(28,2))--psh_weightuom 
 , Print_date =psh_docket_date  /*code added by M.Helan on Aug 22 2024 for Rtrack ID : PJRMC-425 */
 --Code added against id:PJRMC-1204 BEGINS
 ,print_time=concat(case when len(replace(left(psh_shipmenttime,2),':','')) = 1 then concat('0',left(psh_shipmenttime,1)) else left(psh_shipmenttime,2) end,':',case when len(replace(substring(psh_shipmenttime,charindex(':',psh_shipmenttime)+1,2),':',''))=
 1 then concat('0',substring(psh_shipmenttime,charindex(':',psh_shipmenttime)+1,1)) else substring(psh_shipmenttime,charindex(':',psh_shipmenttime)+1,2) end ,':',case when len(replace(right(psh_shipmenttime,2),':','')) = 1 then concat('0',right(psh_shipme
nttime,1)) else right(psh_shipmenttime,2) end )
 --Code added against id:PJRMC-1204 ENDS
 from  #Zrit_prism_rmc_Chemical_tmp            
 join  cobi_item_dtl with (nolock)            
 on invoice_no =tran_no            
 join  so_order_hdr  with (nolock)            
 on  tran_ou = sohdr_ou            
 and so_no   = sohdr_order_no            
  join  ps_pack_slip_hdr with (nolock)            
  on psh_ou=sohdr_ou          
  and  psh_pkslipno=ref_doc_no 

/*code added against  RPRMCB-1 starts*/

   UPDATE #Zrit_prism_rmc_Chemical_tmp          
   SET text5=CASE 
        WHEN (
            SELECT COUNT(DISTINCT cid2.uom)  
            FROM cobi_item_dtl cid2 WITH (NOLOCK)
            WHERE cid2.tran_no = tmp.invoice_no AND cid2.line_no = tmp.linenumber
        ) = 1
        THEN (
            SELECT CAST(CAST(SUM(cid3.item_qty) AS NUMERIC(28,2)) AS VARCHAR(30)) + ' ' + MAX(cid3.uom)
            FROM cobi_item_dtl cid3 WITH (NOLOCK)
            WHERE cid3.tran_no = tmp.invoice_no 
        )
        ELSE '0.00'
    END
FROM #Zrit_prism_rmc_Chemical_tmp tmp
JOIN cobi_item_dtl cid WITH (NOLOCK)
    ON tmp.invoice_no = cid.tran_no
    AND tmp.linenumber = cid.line_no
	and tran_ou   =@_hiddenou  
/*code added against  RPRMCB-1 ends*/

 
 update #Zrit_prism_rmc_Chemical_tmp     
 set transport_mode =  car_carrier_name
from car_carrier_lo_hdr
where car_carrier_code = transport_mode

  
  /*Gayathri added starts*/  
   update #Zrit_prism_rmc_Chemical_tmp          
set EXTRACHAR18=null  
--c.car_carrier_name  
--from ps_pack_slip_hdr p(nolock)  
--left join  #Zrit_prism_rmc_Chemical_tmp t  
--on (p.psh_pkslipno=t.STN_PACKSLIP_NO)  
--left join car_carrier_lo_hdr c(nolock)  
--on (p.psh_carriercode=c.car_carrier_code)  
  
  /*Gayathri added ends*/  
          
   update #Zrit_prism_rmc_Chemical_tmp            
 set sales_eng =spm_sp_firstname+' '+spm_sp_lastname          
          
 from   #Zrit_prism_rmc_Chemical_tmp           
 join    cobi_item_dtl with (nolock)            
 on invoice_no =tran_no            
 join  so_order_hdr  with (nolock)            
 on  tran_ou = sohdr_ou            
 and so_no   = sohdr_order_no           
join sp_sales_person_lo_hdr with (nolock)            
on spm_sales_person_code=sohdr_sales_person_dflt          
          
  
          
          
update  #Zrit_prism_rmc_Chemical_tmp          
set del_state_code=region_code          
 from emod_region_vw r(nolock) 
left join  #Zrit_prism_rmc_Chemical_tmp t          
on r.region_desc=/*t.state*/t.shiptostate --pjrmc-425
   
          
update  #Zrit_prism_rmc_Chemical_tmp          
set   cgst_char1='CGST'+'  @'+convert(varchar(100),cobi_numeric1)+'%'          
        
update  #Zrit_prism_rmc_Chemical_tmp          
set   sgst_char2='SGST'+'  @'+convert(varchar(100),cobi_numeric2)+'%'          
          
          
declare @a numeric(28,2)          
, @b numeric(28,2)      
          
select @a=isnull(InvoicedAmount,0.00)+isnull(extraamount2,0.00)+          
isnull(extraamount4,0.00)          
from #Zrit_prism_rmc_Chemical_tmp          
          
          
select @b=floor(isnull(InvoicedAmount,0.00))+floor(isnull(extraamount2,0.00))+          
floor(isnull(extraamount4,0.00))          
from #Zrit_prism_rmc_Chemical_tmp        

 
--27082024		
--UPDATE #Zrit_prism_rmc_Chemical_tmp
--SET date5 = FORMAT(CAST(date5 AS DATE), 'dd.MM.yyyy')

 -- update   #Zrit_prism_rmc_Chemical_tmp
 --set date5=isnull(CONVERT(VARCHAR(19),cast(date5 as date), 105),date5)         
          
          
update  #Zrit_prism_rmc_Chemical_tmp          
set  round_off=@b-@a 
          
declare @total numeric(28,2)
select @total = isnull(sum(InvoicedAmount),0.00) 
from #Zrit_prism_rmc_Chemical_tmp
update  #Zrit_prism_rmc_Chemical_tmp          
set  total  = @total
--+isnull(extraamount2,0.00)+          isnull(extraamount4,0.00)-isnull(round_off,0.00)          
  
declare @subtotal numeric(28,2)
select @subtotal = isnull(sum(invoicequantity),0.00) 
from #Zrit_prism_rmc_Chemical_tmp  
update  #Zrit_prism_rmc_Chemical_tmp          
set  cobi_numeric5  =@subtotal      
          
--update  #Zrit_prism_rmc_Chemical_tmp          
--set  total  =isnull(InvoicedAmount,0.00)+isnull(extraamount2,0.00)+          
--isnull(extraamount4,0.00)+isnull(round_off,0.00) 
declare @tcstax numeric(28,2)
select @tcstax = taxable_amt FROM  tcal_tax_hdr hdr (NOLOCK)   
 WHERE  hdr.tran_no    = @invoicenumber 
 and  hdr.tran_ou    = @_hiddenou   
 --and  hdr.tran_type    = @trantype   
 and     hdr.tax_type      = 'TCS'  
 and     hdr.tax_community ='INDIA' 

 UPDATE #Zrit_prism_rmc_Chemical_tmp
 SET  cobi_numeric6   = @tcstax  

 UPDATE #Zrit_prism_rmc_Chemical_tmp
 SET  extraamount10   = isnull(total,0.00)+isnull(extraamount13,0.00)+
 isnull(extraamount14,0.00)+isnull(extraamount15,0.00)++isnull(cobi_numeric6,0.00)  
 
          
update  #Zrit_prism_rmc_Chemical_tmp          
set amount_in_words=scmdb.dbo.fnAmountToWords(extraamount10/*total*/)           
from #Zrit_prism_rmc_Chemical_tmp          
          
          
--GSTIN 
  update  #Zrit_prism_rmc_Chemical_tmp          
set  cobi_extrachar1=  extrachar1,--registration_no  /*code modified by Gayathri on 05-01-2024*/ 
--cobi_extrachar2=Pan_No 
cobi_extrachar2=cobi_extrachar4 
--cobi_extrachar4 =Pan_No
 from cps_taxparam_sys s (nolock)          
,  #Zrit_prism_rmc_Chemical_tmp t          
where s.company_code=t.companycode          
and   tax_type='GST'           
and  s.tax_community='INDIA'         
and   ou_id=@_hiddenou       


update #Zrit_prism_rmc_Chemical_tmp
set cobi_extrachar1 =own_regd_no
from tcal_tax_hdr
join #Zrit_prism_rmc_Chemical_tmp
on tran_no=invoice_no
and tran_ou =org_unit
where tax_type='GST'

          
/*          
--TAN           
  update  #Zrit_prism_rmc_Chemical_tmp          
set  cobi_extrachar2=notes_desc            
   FROM   not_std_notes  with(NOLOCK)  ,        
   #Zrit_prism_rmc_Chemical_tmp        
 Where  /* ou_id = @_hiddenou            
 AND */  /*Gayathri MODIFIED*/        
 notes_id = 'TAN NUMBER'            
 */         
          
 --Customer GSTIN and PAN No.          
   update  #Zrit_prism_rmc_Chemical_tmp 
set  cobi_extrachar3=ctds_regd_no,          
--cobi_extrachar4=Pan_No  
--cobi_extrachar2=cobi_extrachar4 
cobi_extrachar4 = Pan_No

from cust_tds_info c with(NOLOCK)            
left join #Zrit_prism_rmc_Chemical_tmp t          
on (c.ctds_comp_code=t.companycode          
and  c.ctds_cust_code=t.billtocustomercode          
and  ctds_tax_type ='GST'          
and  ctds_tax_community='INDIA')          
          
 
          
update  #Zrit_prism_rmc_Chemical_tmp
--set  billtocustomername= clo_cust_name + isnull(clo_addrline1,clo_addrline2) + isnull(clo_addrline2,clo_addrline3) + isnull(clo_addrline3,'')
set  billtocustomername= clo_cust_name +nchar(13)+ isnull(clo_addrline1,clo_addrline2) + isnull(clo_addrline2,clo_addrline3) + isnull(clo_addrline3,'')--code commented and added against RPRMCB-1
from cust_lo_info c with(NOLOCK)  
left join #Zrit_prism_rmc_Chemical_tmp t
on (c.clo_cust_code=t.billtocustomercode)    

    

          


--1204
declare @ship_to_cust varchar(100),@ship_to_id varchar(50)



  select @ship_to_cust =ship_to_cust

 , @ship_to_id =ship_to_id
from  cobi_item_dtl
join #Zrit_prism_rmc_Chemical_tmp
on tran_no = invoice_no
and org_unit =tran_ou
and linenumber = line_no

 update  tmp       
  set  --shipstate  = ISNULL(addr_state, ''),  
    shipaddress1 = isnull(addr_addrline1, '')+ isnull(addr_addrline2, '')   ,  
      shipaddress2 = isnull(addr_addrline3, '') ,  
      shipaddress3 = isnull(addr_state, '') + case isnull(addr_state, '')  
                 when '' then ' '  
    else ','  
               end  
         + isnull(addr_zip, '') + case isnull(addr_city, '')  
          when '' then ' '  
            else '- '  
          end
		  + isnull(addr_city, '')  +','
       ,shiptoph  = ltrim(rtrim(addr_phone))  
  FROM    cust_addr_details_vw cust(NOLOCK),  
    #Zrit_prism_rmc_Chemical_tmp tmp  
  WHERE   cust.addr_cust_code   = @ship_to_cust  
  AND     cust.addr_address_id  = ISNULL(@ship_to_id, addr_address_id)  
  and  tmp.invoice_no     = @invoicenumber   
  and  tmp.org_unit     = @_hiddenou   
  ---Code added against r-track id:PJRMC-1204 ends


  update  #Zrit_prism_rmc_Chemical_tmp       
  --set  shiptocustomernameml=clo_cust_name +',' shipaddress1 + shipaddress2 + shipaddress3 + shiptostate  
set  shiptocustomernameml='Delivery At :'+ clo_cust_name +',' +nchar(13)+nchar(13)+ shipaddress1 + shipaddress2 + shipaddress3 + shiptostate      --code commented and added against RPRMCB-1
from cust_lo_info c with(NOLOCK)            
left join #Zrit_prism_rmc_Chemical_tmp t     
on (c.clo_cust_code=t.shipcustcodeml) 

          
declare @asee_typ varchar(100)                  
select @asee_typ = a.assessee_type                  
from tset_tax_region a with (nolock)            
join #Zrit_prism_rmc_Chemical_tmp  t              
on (a.COMPANY_CODE=t.companycode          
and  a.TAX_REGION_DESC=t.shiptostate)   


          
   /*       
          
if @asee_typ = 'Corporate'                  
begin                  
update #Zrit_prism_rmc_Chemical_tmp          
set cobi_extrachar5 = 'B2B'                   
from #Zrit_prism_rmc_Chemical_tmp                
end         
else                  
begin                  
update #Zrit_prism_rmc_Chemical_tmp          
set cobi_extrachar5 = 'B2C'                 
from #Zrit_prism_rmc_Chemical_tmp          
end                  
 */
 
 if @asee_typ = 'Registered'     
begin                    
update #Zrit_prism_rmc_Chemical_tmp            
set cobi_extrachar5 = 'B2B'      
from #Zrit_prism_rmc_Chemical_tmp                  
end                
else if @asee_typ = 'UnRegistered' /*Code Added by Amirtha P on 07.08.2024*/                
begin                    
update #Zrit_prism_rmc_Chemical_tmp            
set cobi_extrachar5 = 'B2C'                   
from #Zrit_prism_rmc_Chemical_tmp            
end 
          
          
update #Zrit_prism_rmc_Chemical_tmp          
set EXTRACHAR16 =so_no          
from  cobi_item_dtl c(nolock)          
left join #Zrit_prism_rmc_Chemical_tmp t          
on (c.tran_no=t.invoice_no)          
          
  
  
/* code added by Vasanthi K begins*/      
  ;
with cte  (hsn_code,line_no) as                              
 (                              
 Select max(commoditycode),line_no                        
 From cobi_item_dtl (nolock),                              
   trd_tax_group_dtl d (nolock),                              
   trd_tax_group_hdr h(nolock)                              
 where d.company_code  = h.company_code                              
 and  d.tax_group_code = h.tax_group_code                              
 and  h.tax_type   = 'GST'                              
 and  h.tax_community  = 'INDIA'                              
 and  d.company_code  = @company_code                
 and  d.commoditycode is not null                               
 and  @date_tmp   between isnull(d.effective_from_date,@date_tmp) and isnull(d.effective_to_date,@date_tmp)    
 and  item_tcd_code     = d.item_code                          
   and  isnull(item_tcd_var,'##') = isnull(d.variant,'##')                          
   and  tran_no     = @invoicenumber      
   and  tran_ou       = @_hiddenou                     
 group by line_no                              
 )                             
                       
 --HSN code                
  update A                            
 set A.extrachar6=cte.hsn_code    
 from #Zrit_prism_rmc_Chemical_tmp A                    
 join Cte                            
  On (A.linenumber = cte.line_no)  
 
 
          
            
 update #Zrit_prism_rmc_Chemical_tmp 
 set text1 = 'Certified that the particulars given above are true and correct and the amount indicated represents the price actually charged and that there is no flow of additional consideration directly or indirectly from the buyer'

  
 update #Zrit_prism_rmc_Chemical_tmp              
 set text2=
'Note:All Payments should be made by way of crossed cheque/Demand Draft/NEFT/RTGS in favour of "PRISM JOHNSON LIMITED"only.Corporate Office: Windsor,7th Floor, C.S.T. Road, Kalina, Santacruz East, Mumbai- 400078, India.
   Tel: +91-22-26547000 / 49447000/ 26526171/2/3/4; Fax: +91-22-26547111/26547123;Email:endura.customercare@prismjohnson.in Website http://www.rmcindia.com 
     Regd Office 305, Laxmi Niwas Apartments, Ameerpat, Hyderabad - 500 016. Telangana 
		Note: FOR TERMS AND CONDITIONS PLEASE SEE ANNEXURE'
 
 update #Zrit_prism_rmc_Chemical_tmp                          
 set text3= '
1. Do not pay cash to any of our employees towards company''s dues as company accepts payments only through normal banking channels. All payments to the company shall be mandatorily required to be made by way of crossed cheque /rtgs/neft, in favor of the


 company in it''s designated bank account. Therefore, if any cash is paid to any of our employees, it will be at customer''s risk and company shall not be liable for the same.

2. We here by certify that our Registration Certificate under the Central Goods & Service Tax Act, 2017 is in force on the date on which the sale of the goods specified in the Bill / Invoice is made by us and the transaction of sales covered by us has bee


n effected by us in the regular course of our business.

3. Pursuant to Section 206C(1H) of Income Tax Act, 1961, TCS, shall be levied on all collections/sale consideration received / due to be received from customers on or after 01.10.2020 including the sales made on or before 30.09.2020. Accordingly, wef, Apr


il 01, 2021, TCS @ 0.10% for Customers having PAN

4 Our responsibility ceases once the goods leave our premises. Products/goods sold confim to the quality specifications agreed. Discrepancy, if any, to the agreed quality specifications should without delay be

5. Bill remaining unpaid beyond agreed due date will attract overdue interest. @ 18% per anmum.

6. Disputes if any, subject to Mumbai Jurisdiction only.'
 
  update #Zrit_prism_rmc_Chemical_tmp                          
 set text4= 'PRISM JOHNSON LIMITED <BR> RMC(INDIA) DIVISION'                    
  
  update #Zrit_prism_rmc_Chemical_tmp
set text7 =concat(logo_path,logo_name)
from zrit_logo_details
where company_code=@company_code 

--1204         
update #Zrit_prism_rmc_Chemical_tmp
set text8=shiptostate + '(' + del_state_code + ')'

select * from #Zrit_prism_rmc_Chemical_tmp          
         
 end 


Completion time: 2025-04-17T14:17:54.0557588+05:30
