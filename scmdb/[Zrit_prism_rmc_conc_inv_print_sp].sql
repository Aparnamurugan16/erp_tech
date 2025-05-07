Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*******************************************************************************                          
Procedure   : Zrit_prism_rmc_conc_inv_print_sp               
report name   : zrit_prism_rmc_concer_inv_rpt              
Created By   : Saravanakumar                   
Created Date        : 22-Dec-2023                 
Rtrack id   : Prism RMC                
Description   : Concerte Invoice Print Report               
Modified By   :   Gayathri p                
Modified Date  : 05-01-2024              
Samyuktha    18.07.2024   RITSL/UAT_Fix    
/* RITSL/UAT_Fix  Amirtha P    31.07.2024 */    
/* assessee type handle  Paulesakki v  31.07.2024 */   
/*Vasanthi K  06.03.2025  PJRMC-1204*/  
/* Amirtha P.  01.04.2025   RPRMCB-1 (Delivery State Logic Change) */  
/*anulakshmi  03.04.2025   RPRMCB-1 ( logic change)*/  
/*Sasi Rekha	08-04-2025 RPRMCB_1 (logic change)*/
/*Aparna M		09-04-2025	RPRMCB-1 (logic change)*/
/*Vasanthi K	11-04-2025  RPRMCB-1 (logic change)*/
*******************************************************************************/                
  
--exec Zrit_prism_rmc_conc_inv_print_sp  19,'CCMOH25COB000004','ABD','test'                                 
--exec Zrit_prism_rmc_conc_inv_print_sp  48,'MLD24/COB0000038','',''     
--exec Zrit_prism_rmc_conc_inv_print_sp 105,'CI2601260000148','',''    
--exec Zrit_prism_rmc_conc_inv_print_sp 110,'CI2684260000011','',''    

  
CREATE     Procedure [dbo].[Zrit_prism_rmc_conc_inv_print_sp]    
@_hiddenou              int,                
@invoicenumber          varchar(200),                
@_hidden2              varchar(255),                
@_hidden3      varchar(255)                
                  
As                  
Begin                 
        
drop table if exists #Zrit_prism_rmc_Cobi_tmp         
        
/* code added by Vasanthi K begins*/        
 declare @lo    udd_loid                                          
   declare @gtaxtyp varchar(100)          
   Declare @bu varchar(50)---Code Added by paul Cause of GUID need to pass in hidden2 on 05/02/2023     
  declare @date_tmp        udd_date ,@company_code varchar(100)                                         
 declare @return_val  udd_int,@company_name varchar(100)                                        
 select @date_tmp = dbo.RES_Getdate(@_hiddenou)                                          
      
    
  /*RITSL/UAT_Fix*/    
  If isnull(@_hidden2,'')=''    
  Select @_hidden2 = newid()    
             
 select        
 @bu=bu_id ,                             ---Code Modfied by paul Cause of GUID need to pass in hidden2 on 05/02/2023        
 @company_code=company_code,  
 --Code added againt id:PJRMC-1204 begins  
 -- @company_name=company_name    
 @company_name=company_name  
  --Code added againt id:PJRMC-1204 ends  
 from emod_ou_mst_vw with (nolock)                                        
where ou_id=@_hiddenou     
  
  
  
  
declare @left int  
select @left =  (charindex('-',company_name))  
 from emod_ou_mst_vw with (nolock)     
 where company_name =@company_name  
  
  
select @company_name = SUBSTRING(company_name, 1,case when @left =0 then len (company_name ) else @left-1 end)   
  --Code added againt id:PJRMC-1204 ends  
 from emod_ou_mst_vw with (nolock)     
  where company_name =@company_name  
  
  
  
                                
 exec  scm_get_emod_details @_hiddenou,@date_tmp ,@lo out, @bu out, @return_val out   ---Code Modfied by paul Cause of GUID need to pass in hidden2 on 05/02/2023          
                 
                                   
 Select @company_code = company_code                                  
 From emod_lo_bu_ou_vw with (nolock)                                  
 Where ou_id   = @_hiddenou          
                  
 /* code added by Vasanthi K ends*/                 
Create Table #Zrit_prism_rmc_Cobi_tmp                  
(                  
wfdockey    nvarchar(240)                  
,report_type1   nvarchar(80)                  
,invoice_no    nvarchar(36)                  
,packslipdate   nvarchar(20)                  
,totaltimeml   nvarchar(24)                  
,org_unit int                   
,currency_code   nvarchar(10)                  
,modetransport   nvarchar(300)                  
,destinationlocation nvarchar(510)                  
,billtocustomercode  nvarchar(36)       
,billtocustomername  nvarchar(120)                  
,billtoaddress1   nvarchar(510)        
,billtoaddress2   nvarchar(510)                  
,billtoaddress3   nvarchar(510)           
,billstate    nvarchar(80)            
,billtocountry   nvarchar(60)                  
,billtoph nvarchar(510)                  
,shipcustcodeml   nvarchar(36)                  
,shiptocustomernameml nvarchar(120)                  
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
,unitprice    numeric (28,2)                  
,uom    nvarchar(30)       /*Decimal Changed*/              
,invoicequantity  numeric (28,3)  /*Decimal Changed*/               
,invoicedamount   numeric (28,2)   /*Decimal Changed*/                   
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
,extraamount2   numeric (28,2)   /*Decimal Changed*/                   
,extraamount3   numeric (28,8)                  
,extraamount4   numeric (28,2)  /*Decimal Changed*/                    
,extraamount5   numeric (28,8)                  
,extraamount6   numeric (28,8)                   
,extraamount7   numeric (28,8)                  
,extraamount8   numeric (28,8)                 
,extraamount9   numeric (28,2)                   
,extraamount10   numeric (28,2)    /*Decimal Changed*/     
/*code commented and added by vasanthi K begins*/    
--,date1     date                  
--,date2     date     
,date1     nvarchar(510)                   
,date2     nvarchar(510)     
/*code commented and added by vasanthi K begins*/    
,date3     nvarchar(20)                  
,date4     nvarchar(510)                  
,date5     nvarchar(510)                              
,Total_inv_amount  numeric (28,2)     /*Decimal Changed*/                 
,Print_date    Date                   
,Print_time    nvarchar(50)                  
,invoicestatus_ml  varchar(1)                  
,sequenceno    int                   
,[guid]     nvarchar(256)                  
,wfdockey2    nvarchar(240)                
,extraamount11   numeric(28,8)                  
,extraamount12   numeric(28,8)            
,extraamount13   numeric(28,8)                   
,extraamount14   numeric(28,8)                   
,extraamount15   numeric(28,8)      
,extraamount16   numeric(28,8)                   
,extraamount17   numeric(28,8)                  
,extraamount18   numeric(28,8)    
,extraamount19   numeric(28,8)                  
,extraamount20   numeric(28,8)                 
,Extraint1   numeric(28,8)               
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
select                
@Tran_type = tran_type                  
from Cobi_invoice_hdr with(nolock)                  
where tran_no = @invoicenumber                  
and tran_ou = @_hiddenou                  
      
insert into #Zrit_prism_rmc_Cobi_tmp                
exec zrit_COBIPRINTSpfetDtl                  
      @ctxt_ouinstance   =@_hiddenou                                                        
     ,@ctxt_user         =@_hidden3                                                        
     ,@ctxt_language     =1                                                     
     ,@ctxt_service      ='cobiprintsrfet'                                                     
     ,@tranno            =@invoicenumber                                                       
     ,@tranou            =@_hiddenou                                              
     ,@guid              =@_hidden2                           
     ,@trantype          =@Tran_type                       
     ,@printlanguage     ='English'                               
     ,@m_errorid         =0                   
           
      
          
          
 alter table  #Zrit_prism_rmc_Cobi_tmp  add                
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
text6 varchar(8000),text7  varchar(8000)          
  
  
update #Zrit_prism_rmc_Cobi_tmp  
  
set cobi_extrachar11 = case when @company_name like '%Johnson%' then replace (@company_name,'Johnson',concat('<font color="red">','Johnson' ,'</font>') )  
    else  @company_name end,  
 companycode=@company_code --code added by Aparna M for subsidiary company      
/* code added by Vasanthi K begins*/              
  ;        
with cte  (hsn_code,line_no) as         
 (             
 Select max(commoditycode),line_no                                
 From cobi_item_dtl with (nolock),                                      
   trd_tax_group_dtl d with (nolock),                         
   trd_tax_group_hdr h with (nolock)           
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
 from #Zrit_prism_rmc_Cobi_tmp A                            
 join Cte On (A.linenumber = cte.line_no)         
    
          
 UPDATE A        
SET extraamount2 = (        
    SELECT ABS(SUM(ISNULL(DTL.comp_tax_amt, 0) * CASE WHEN ISNULL(DR_CR_Flag, 'D') IN ('C', 'Cr') THEN -1 ELSE 1 END))        
    FROM tcal_tax_hdr HDR with (NOLOCK)        
    INNER JOIN tcal_tax_dtl DTL with (NOLOCK) ON HDR.tran_no = DTL.tran_no   
        AND HDR.tran_type = DTL.tran_type        
        AND HDR.tran_ou = DTL.tran_ou        
        AND HDR.tax_type = DTL.tax_type        
        AND HDR.tran_line_no = DTL.tran_line_no        
  and dtl.tax_type='GST'        
    JOIN cobi_item_dtl itm with (NOLOCK) ON itm.tran_no = DTL.tran_no        
        AND itm.line_no = DTL.tran_line_no        
        AND itm.tran_ou = DTL.tran_ou        
        --AND itm.tran_type = DTL.tax_type        
    WHERE DTL.tran_no = @invoicenumber        
        AND DTL.tran_ou = @_hiddenou        
     and code_type = 'CGST' /*Code Added by Amirtha P on 26.03.2024*/     
)        
FROM #Zrit_prism_rmc_Cobi_tmp A;        
          
/*Code Added by Amirtha P on 26.03.2024 Begins*/    
 UPDATE A        
SET extraamount10 = (        
    SELECT ABS(SUM(ISNULL(DTL.comp_tax_amt, 0) * CASE WHEN ISNULL(DR_CR_Flag, 'D') IN ('C', 'Cr') THEN -1 ELSE 1 END))        
    FROM tcal_tax_hdr HDR with (NOLOCK)        
    INNER JOIN tcal_tax_dtl DTL with (NOLOCK) ON HDR.tran_no = DTL.tran_no     
        AND HDR.tran_type = DTL.tran_type        
        AND HDR.tran_ou = DTL.tran_ou        
        AND HDR.tax_type = DTL.tax_type       
        AND HDR.tran_line_no = DTL.tran_line_no   
  and dtl.tax_type='GST'        
    JOIN cobi_item_dtl itm with (NOLOCK) ON itm.tran_no = DTL.tran_no        
    AND itm.line_no = DTL.tran_line_no        
        AND itm.tran_ou = DTL.tran_ou        
   --AND itm.tran_type = DTL.tax_type        
    WHERE DTL.tran_no = @invoicenumber        
        AND DTL.tran_ou = @_hiddenou     
and code_type = 'IGST'    
)        
FROM #Zrit_prism_rmc_Cobi_tmp A;       
/*Code Added by Amirtha P on 26.03.2024 Ends*/    
    
   UPDATE A        
SET extraamount4 = (        
    SELECT ABS(SUM(ISNULL(DTL.comp_tax_amt, 0) * CASE WHEN ISNULL(DR_CR_Flag, 'D') IN ('C', 'Cr') THEN -1 ELSE 1 END))        
    FROM tcal_tax_hdr HDR with (NOLOCK)     
    INNER JOIN tcal_tax_dtl DTL with (NOLOCK) ON HDR.tran_no = DTL.tran_no        
        AND HDR.tran_type = DTL.tran_type        
        AND HDR.tran_ou = DTL.tran_ou        
        AND HDR.tax_type = DTL.tax_type        
        AND HDR.tran_line_no = DTL.tran_line_no        
  and dtl.tax_type='GST'        
    JOIN cobi_item_dtl itm with (NOLOCK) ON itm.tran_no = DTL.tran_no        
        AND itm.line_no = DTL.tran_line_no        
        AND itm.tran_ou = DTL.tran_ou        
     --AND itm.tran_type = DTL.tax_type        
    WHERE DTL.tran_no = @invoicenumber        
        AND DTL.tran_ou = @_hiddenou        
      and code_type = 'SGST' /*Code Added by Amirtha P on 26.03.2024*/    
)        
FROM #Zrit_prism_rmc_Cobi_tmp A;        
     
 UPDATE A        
 SET extraamount1= (SELECT(MIN(tax_rate))        
 FROM tcal_tax_hdr HDR with (NOLOCK)        
    INNER JOIN tcal_tax_dtl DTL with (NOLOCK) ON HDR.tran_no = DTL.tran_no        
        AND HDR.tran_type = DTL.tran_type        
        AND HDR.tran_ou = DTL.tran_ou        
        AND HDR.tax_type = DTL.tax_type        
        AND HDR.tran_line_no = DTL.tran_line_no        
  and dtl.tax_type='GST'        
    JOIN cobi_item_dtl itm with (NOLOCK) ON itm.tran_no = DTL.tran_no        
        AND itm.line_no = DTL.tran_line_no        
        AND itm.tran_ou = DTL.tran_ou        
        --AND itm.tran_type = DTL.tax_type        
    WHERE DTL.tran_no = @invoicenumber        
        AND DTL.tran_ou = @_hiddenou      
  and code_type = 'CGST' /*Code Added by Amirtha P on 26.03.2024*/    
)        
FROM #Zrit_prism_rmc_Cobi_tmp A;      
    
        
UPDATE A        
 SET extraamount3= (SELECT(MIN(tax_rate))        
 FROM tcal_tax_hdr HDR with (NOLOCK)        
    INNER JOIN tcal_tax_dtl DTL with (NOLOCK) ON HDR.tran_no = DTL.tran_no        
        AND HDR.tran_type = DTL.tran_type        
        AND HDR.tran_ou = DTL.tran_ou        
        AND HDR.tax_type = DTL.tax_type        
        AND HDR.tran_line_no = DTL.tran_line_no        
  and dtl.tax_type='GST'        
    JOIN cobi_item_dtl itm with (NOLOCK) ON itm.tran_no = DTL.tran_no        
 AND itm.line_no = DTL.tran_line_no        
        AND itm.tran_ou = DTL.tran_ou        
        --AND itm.tran_type = DTL.tax_type        
    WHERE DTL.tran_no = @invoicenumber        
        AND DTL.tran_ou = @_hiddenou       
  and code_type = 'SGST'/*Code Added by Amirtha P on 26.03.2024*/    
)        
FROM #Zrit_prism_rmc_Cobi_tmp A;        
    
/*Code Added by Amirtha P on 26.03.2024 Begins*/    
UPDATE A        
 SET extraamount5= (SELECT(MIN(tax_rate))        
 FROM tcal_tax_hdr HDR with (NOLOCK)        
    INNER JOIN tcal_tax_dtl DTL with (NOLOCK) ON HDR.tran_no = DTL.tran_no        
        AND HDR.tran_type = DTL.tran_type        
        AND HDR.tran_ou = DTL.tran_ou        
        AND HDR.tax_type = DTL.tax_type        
        AND HDR.tran_line_no = DTL.tran_line_no        
  and dtl.tax_type='GST'        
    JOIN cobi_item_dtl itm with (NOLOCK) ON itm.tran_no = DTL.tran_no        
        AND itm.line_no = DTL.tran_line_no        
    AND itm.tran_ou = DTL.tran_ou        
        --AND itm.tran_type = DTL.tax_type        
    WHERE DTL.tran_no = @invoicenumber        
        AND DTL.tran_ou = @_hiddenou       
  and code_type = 'IGST'     
)        
FROM #Zrit_prism_rmc_Cobi_tmp A;        
 /*Code Added by Amirtha P on 26.03.2024 Ends*/    
       
 /* code added by Vasanthi K ends*/            
   /*Code Commented and by Amirtha P on 02.08.2024 Begins*/      
   /*    
--Plantname & Addresss   
update #Zrit_prism_rmc_Cobi_tmp                
set cobi_extrachar6=isnull(company_name,'')+' & '+isnull(address1,'')+' '+isnull(address2,'')+','+isnull(city,'')+'-'+isnull(zip_code,'') ,                
/*cobi_extrachar7=m.[state],  *//*Gayathri on 05-01-2024*/               
cobi_extrachar8=phone_no  --Phone No                
from emod_company_mst m(nolock)                
left join #Zrit_prism_rmc_Cobi_tmp t                 
on (m.company_code=t.companycode)         
  
 /*code commented and added Gayathri on 05-01-2024 starts*/               
               
  update #Zrit_prism_rmc_Cobi_tmp                
 set  cobi_extrachar6 =  case when  isnull(address_desc,'') <> '' then  isnull(address_desc,'')+', ' else '' end               
        + case when isnull(address1,'') <> '' then  isnull(address1,'')+', ' else '' end                
        + case when isnull(address2,'') <> '' then  isnull(address2,'')+', ' else '' end          
        + case when isnull(address3,'') <> '' then isnull(address3,'')+', ' else '' end                                  
        + case when isnull(city,'')     <> '' then  isnull(city,'')+',' else '' end              
 + case when isnull(country,'') <> '' then  isnull(country,'')+'-' else '' end                  
        + case when isnull(zip_code,'')  <> '' then  isnull(zip_code,'')+' ' else '' end  ,              
  cobi_extrachar8=phone_no      
 from emod_ou_addr_map_vw(nolock)                
 where ou_id   =@_hiddenou        
     
 */    
 update #Zrit_prism_rmc_Cobi_tmp                
set cobi_extrachar6 =    
 case when  isnull(address_desc,'') <> '' then  isnull(address_desc,'')+', ' else '' end      
  + case when isnull(company_name,'') <> '' then  isnull(company_name,'')+', ' else '' end      
        + case when isnull(a.address1,'') <> '' then  isnull(a.address1,'')+', ' else '' end                
        + case when isnull(a.address2,'') <> '' then  isnull(a.address2,'')+', ' else '' end          
        + case when isnull(a.address3,'') <> '' then isnull(a.address3,'')+', ' else '' end                                  
        + case when isnull(a.city,'')  <> '' then  isnull(a.city,'')+',' else '' end              
  + case when isnull(a.country,'') <> '' then  isnull(a.country,'')+'-' else '' end                  
        + case when isnull(a.zip_code,'') <> '' then  isnull(a.zip_code,'')+' ' else '' end        
,cobi_extrachar8=a.phone_no --code added by Aparna M  
 from emod_ou_addr_map_vw a with (nolock)       
 Join emod_company_mst c with (nolock)    
 On a.company_code =c.company_code    
 where ou_id   =@_hiddenou     
      /*Code Commented by Amirtha P on 02.08.2024 Begins*/           
 --state                
/*update #Zrit_prism_rmc_Cobi_tmp                
set cobi_extrachar9=region_code                
 from emod_region_vw r(nolock)                
left join  #Zrit_prism_rmc_Cobi_tmp t                
on r.region_desc=t.cobi_extrachar7  */  
  
  
update #Zrit_prism_rmc_Cobi_tmp                
 set cobi_extrachar7=isnull(region_desc,''),                
  cobi_extrachar9=isnull(region_code,'')                
 from emod_region_vw with (nolock),                
   emod_ou_addr_map_vw a with (nolock)                
 where ou_id   =@_hiddenou     
 /*code commented and added by anulakshmi on 03.04.2025 RPRMCB-1 starts*/  
 /*and  a.state=lower(replace(region_desc,' ',''))*/--region_desc   
 and  replace(a.state,' ','')=replace(region_desc ,' ','') 
 /*code commented and added by anulakshmi on 03.04.2025 RPRMCB-1 ends*/  
                
/*code commented and added Gayathri on 03-01-2024 ends*/      
  
  
  
  
             
  
    
  update  #Zrit_prism_rmc_Cobi_tmp                
  set  CIN= company_id           
 from emod_company_mst m with (nolock)                
left join  #Zrit_prism_rmc_Cobi_tmp t                
on m.company_code=t.companycode                
                
update #Zrit_prism_rmc_Cobi_tmp                
set  cobi_numeric1=extraamount1     
,  cobi_numeric2=extraamount3    
,  cobi_numeric3=extraamount5              
,  cobi_numeric4=extraamount7    
    
update T                
set  EXTRACHAR16 = so_no                
from #Zrit_prism_rmc_Cobi_tmp t      
Join cobi_item_dtl c with (nolock)    
on  c.tran_no = t.invoice_no      
And  org_unit = tran_ou     
and  linenumber = visible_line_no --code added by aparna M  
    
/*Code Commented and Added for RITSL/UAT_Fix begins*/                
--update  #Zrit_prism_rmc_Cobi_tmp                
--set  state_code=  region_code         
-- from emod_region_vw r(nolock)                
--left join  #Zrit_prism_rmc_Cobi_tmp t            
--on r.region_desc=t.shiptostate    
  
  
--code added By Aparna M against PJRMC-1276  
  ALTER table #Zrit_prism_rmc_Cobi_tmp add unitclass varchar(100) 
  
  --code added  for RPRMCB_1 Starts here 

  Declare @count_ou int

  select @count_ou=count (distinct ouid)   from interfacedb.dbo.zrit_ids_ou_vw_email_bot(nolock) where ouinstid =@_hiddenou
  
    --code added  for RPRMCB_1 Ends  here 

  
  
   update #Zrit_prism_rmc_Cobi_tmp              
set unitclass=/*zrit_unit_class */ouid  --code added  for RPRMCB_1         
/*OUInstDesc  *//*gayathri*/            
from zrit_so_additional_hdr (nolock)    
join #Zrit_prism_rmc_Cobi_tmp  
on extrachar16   =zrit_sohdr_order_no  
and org_unit  = zrit_sohdr_ou  
join interfacedb.dbo.zrit_ids_ou_vw_email_bot(nolock) --code added  for RPRMCB_1
on zrit_unit_class=pep_phy_ele_name --code added  for RPRMCB_1
and OUInstId=@_hiddenou --code added  for RPRMCB_1
where org_unit=@_hiddenou 


  
  --code commented by Aparna M               
--plant Code                 
update #Zrit_prism_rmc_Cobi_tmp                
set cobi_extrachar10= case when @count_ou >1 then unitclass else OUInstName    end    --code added  for RPRMCB_1 
   /*OUInstDesc  *//*gayathri*/              
from fw_admin_OUInstance with (nolock)            
where OUInstId=@_hiddenou       
  --code commented by Aparna M  

  
  
/*update #Zrit_prism_rmc_Cobi_tmp              
set cobi_extrachar10=pep_value            
/*OUInstDesc  *//*gayathri*/            
from mpmx_prp_phy_ele_typ_prop (nolock)    
join mpmx_pep_phy_ele_prop  
on pep_ou_code = prp_ou_code  
and  prp_property = 'IDS_SAP_OU'   
and  prp_property =  pep_property   
join #Zrit_prism_rmc_Cobi_tmp  
on  pep_phy_ele_name = unitclass  
where pep_ou_code=@_hiddenou   
and  prp_status = 'A'  
  */
--code added By Aparna M against PJRMC-1276  
    
declare @BillToID fin_customer_id     
    
select  @BillToID  =  sohdr_bill_to_id    
from  so_sales_order_hdr_vw with (nolock)    
Join #Zrit_prism_rmc_Cobi_tmp    
On   sohdr_order_no   = EXTRACHAR16    
    
update  T    
set  state_code=  addr_state         
from #Zrit_prism_rmc_Cobi_tmp     T           
Join cobi_invoice_hdr with (nolock)    
On  invoice_no = tran_no    
And  org_unit = tran_ou    
Join cust_addr_details_vw with (nolock)    
On  addr_cust_code = bill_to_cust    
Where addr_address_id = @BillToID    
    
    
/*Code Commented and Added for RITSL/UAT_Fix begins*/    
                
 update #Zrit_prism_rmc_Cobi_tmp                  
 set  buy_ord_no   = sohdr_cust_po_no                  
 from  #Zrit_prism_rmc_Cobi_tmp                  
 join  cobi_item_dtl with (nolock)                  
 on invoice_no =tran_no                  
 join  so_order_hdr  with (nolock)                  
 on  tran_ou = sohdr_ou       
 and so_no   = sohdr_order_no                                
                
     
 update #Zrit_prism_rmc_Cobi_tmp                
 set  batch_serial_no   = psh_docket_no  ,                
 vehicle_no= psh_vehicleno,         
 EXTRACHAR18 = psh_remark1 ,/*Code Added by Amirtha P on 15.02.2024*/        
transport_mode=psh_shipmentmode    
,print_time=concat(case when len(replace(left(psh_shipmenttime,2),':','')) = 1 then concat('0',left(psh_shipmenttime,1)) else left(psh_shipmenttime,2) end,':',case when len(replace(substring(psh_shipmenttime,charindex(':',psh_shipmenttime)+1,2),':','')) 
=1 then concat('0',substring(psh_shipmenttime,charindex(':',psh_shipmenttime)+1,1)) else substring(psh_shipmenttime,charindex(':',psh_shipmenttime)+1,2) end ,':',case when len(replace(right(psh_shipmenttime,2),':','')) = 1 then concat('0',right(psh_shipme
nttime,1)) else right(psh_shipmenttime,2) end )--psh_shipmenttime/*Code added By Vasanthi K On 20.12.2024*/  
 from  #Zrit_prism_rmc_Cobi_tmp                  
 join  cobi_item_dtl with (nolock)           
on invoice_no =tran_no                  
 join  so_order_hdr  with (nolock)                  
 on tran_ou = sohdr_ou         
 and so_no   = sohdr_order_no                  
  join  ps_pack_slip_hdr with (nolock)                  
  on psh_ou=sohdr_ou             
  and  psh_pkslipno=ref_doc_no          
          
  
  /*Gayathri added starts*/        
  /*Code commented by Amirtha P on 15.02.2024 Begins*/        
  /*        
   update #Zrit_prism_rmc_Cobi_tmp       
set EXTRACHAR18=null        
--c.car_carrier_name        
--from ps_pack_slip_hdr p(nolock)        
--left join  #Zrit_prism_rmc_Cobi_tmp t        
--on (p.psh_pkslipno=t.STN_PACKSLIP_NO)        
--left join car_carrier_lo_hdr c(nolock)        
--on (p.psh_carriercode=c.car_carrier_code)        
*/        
  /*Code commented by Amirtha P on 15.02.2024 Ends*/       
  /*Gayathri added ends*/        
                
   update #Zrit_prism_rmc_Cobi_tmp     
   /*Code Commented and Added for RITSL/UAT_Fix Begins*/    
 --set sales_eng =spm_sp_firstname+' '+spm_sp_lastname      
 set sales_eng =Isnull(spm_sp_firstname,' ') +' '+ Isnull(spm_sp_lastname,' ')    
 /*Code Commented and Added for RITSL/UAT_Fix Ends*/    
 from   #Zrit_prism_rmc_Cobi_tmp                 
 join    cobi_item_dtl with (nolock)                  
 on invoice_no =tran_no         
 join  so_order_hdr  with (nolock)                  
 on  tran_ou = sohdr_ou                  
 and so_no   = sohdr_order_no                 
join sp_sales_person_lo_hdr with (nolock)                  
on spm_sales_person_code=sohdr_sales_person_dflt   
  
  
  
  
declare @shiptoid varchar(20)  
declare @shiptocust varchar(100)  
declare @destou int  
  
declare @custcode varchar(200)  
select @destou = destinationouinstid from fw_view_comp_intxn_model where sourcecomponentname = 'COBI' And  destinationcomponentname = 'CU' And  sourceouinstid = @_hiddenou  
  
   select @custcode  = supp_cust_code    
   from tcal_tran_hdr(nolock)    
   where tran_ou   = @_hiddenou    
   and  tran_no  = @invoicenumber    
   and  tran_type  = @Tran_type    
       
  
  select @shiptoid  = isnull(@shiptoid,cou_dflt_shipto_id),    
  @shiptocust = isnull(@shiptocust,cou_dflt_shipto_cust)  
   from cust_ou_info(nolock)    
   where cou_cust_code = @custcode    
   and  cou_ou   = @destou   
  
  
update #Zrit_prism_rmc_Cobi_tmp   
set shiptostate = addr_state  
from cust_addr_details_vw cust  
WHERE   cust.addr_cust_code   = @shiptocust  
AND     cust.addr_address_id  = @shiptoid   
                        
  
update  #Zrit_prism_rmc_Cobi_tmp 
set del_state_code=region_desc      
from emod_region_vw r(nolock)                
left join  #Zrit_prism_rmc_Cobi_tmp t        
--Code Commented and added by Vasanthi K begins    
--on r.region_desc=t.state     
--on r.region_desc=shiptostate    
on r.region_code = shiptostate  
--Code Commented and added by Vasanthi K ends   
  
  
  
update  #Zrit_prism_rmc_Cobi_tmp                
set   cgst_char1=case when isnull(cobi_numeric1,0.00) = 0.00 then Null Else'CGST'+' @'+convert(varchar(100),cobi_numeric1)+'%:' End    
              
update  #Zrit_prism_rmc_Cobi_tmp                
set   sgst_char2=case when isnull(cobi_numeric2,0.00) = 0.00 then Null Else 'SGST'+' @'+convert(varchar(100),cobi_numeric2)+'%:'  End    
    
update  #Zrit_prism_rmc_Cobi_tmp                
set  igstchar3 = case when isnull(cobi_numeric3,0.00) = 0.00 then Null Else 'IGST'+' @'+convert(varchar(100),cobi_numeric3)+'%: '  End    
                
    
/*Code Added for RITSL/UAT_Fix begins*/    
    
/*Code Commented by Amirtha P. on 16.12.2024 Begins*/  
/*  
Update T    
Set  extraamount2 = round(extraamount2,1),    
  extraamount4 = round(extraamount4,1) --convert(numeric(28,2),isnull(extraamount4,0.00))    
from #Zrit_prism_rmc_Cobi_tmp T    
*/   
/*Code Commented by Amirtha P. on 16.12.2024 Ends*/  
  
  
Update T    
Set  cobi_extrachar6 = replace (cobi_extrachar6,',,',','),    
  billtoaddress1 = replace (billtoaddress1,',,',','),    
  shipaddress1 = replace (shipaddress1,',,',',')    
From #Zrit_prism_rmc_Cobi_tmp T    
    
update #Zrit_prism_rmc_Cobi_tmp                
 set  batch_serial_no   = case when len(batch_serial_no) = 1 then concat('00000',batch_serial_no)    
        when len(batch_serial_no) = 2 then concat('0000',batch_serial_no)    
        when len(batch_serial_no) = 3 then concat('000',batch_serial_no)    
        when len(batch_serial_no) = 4 then concat('00',batch_serial_no)    
        when len(batch_serial_no) = 5 then concat('0',batch_serial_no)    
        Else batch_serial_no end    
    
  
update #Zrit_prism_rmc_Cobi_tmp                
 set  extrachar23 =  shiptostate + '(' + del_state_code + ')',    
   EXTRACHAR20 =  case when isnull(EXTRACHAR20,'')='' then null else EXTRACHAR20 end    
  
  
    
  --select shiptostate,* from #Zrit_prism_rmc_Cobi_tmp  
  
  
/*Code Added for RITSL/UAT_Fix Ends*/    
    
declare @a numeric(28,2) , @b numeric(28,2)        
                
select @a=isnull(InvoicedAmount,0.00)+isnull(extraamount2,0.00)+isnull(extraamount4,0.00)+isnull(extraamount10,0.00)                
from #Zrit_prism_rmc_Cobi_tmp                
                         
--select @b=floor(isnull(InvoicedAmount,0.00))+floor(isnull(extraamount2,0.00))+ floor(isnull(extraamount4,0.00))                
--from #Zrit_prism_rmc_Cobi_tmp      
    
select @b=floor(isnull(InvoicedAmount,0.00)+isnull(extraamount2,0.00)+isnull(extraamount4,0.00)+isnull(extraamount10,0.00) )    
from #Zrit_prism_rmc_Cobi_tmp     
           
update  #Zrit_prism_rmc_Cobi_tmp                
set round_off=@a-@b    /*order changed by Amirtha P on 04.08.2024 for RITSL/UAT_Fix*/       
  
/*Code Added by Amirtha P. on 16.12.2024 Begins*/ 
  
  
  
--If (Select round_off from #Zrit_prism_rmc_Cobi_tmp) > 0.5  
  
if exists (select '*' from #Zrit_prism_rmc_Cobi_tmp where round_off>0.5)--PJRMC-1276  
begin 
 Update T   
 Set  round_off = 1.0-round_off  
 From #Zrit_prism_rmc_Cobi_tmp T  
  
 update  #Zrit_prism_rmc_Cobi_tmp                
 set  total  =isnull(/*InvoicedAmount*/extraamount9,0.00)+isnull(extraamount2,0.00)+         
   isnull(extraamount4,0.00)+isnull(extraamount10,0.00)+isnull(round_off,0.00)   
  
End  
Else  
begin  
/*Code Added by Amirtha P. on 16.12.2024 Begins*/  
                       
update  #Zrit_prism_rmc_Cobi_tmp                
set  total  =isnull(/*InvoicedAmount*/extraamount9,0.00)+isnull(extraamount2,0.00)+         
   isnull(extraamount4,0.00)+isnull(extraamount10,0.00)-isnull(round_off,0.00)     
     
/*Code Added by Amirtha P. on 16.12.2024 Begins*/  
End     
  
  Update T  
  Set  Total_inv_amount = total  
  From  #Zrit_prism_rmc_Cobi_tmp T  
  
/*Code Added by Amirtha P. on 16.12.2024 Ends*/  
    
/*Code Commented by Amirtha P on 26.03.2024 Begins*/          
    
--update  #Zrit_prism_rmc_Cobi_tmp                
--set  total  =isnull(InvoicedAmount,0.00)+isnull(extraamount2,0.00)+                
--isnull(extraamount4,0.00)+isnull(round_off,0.00)      
    
/*Code Commented by Amirtha P on 26.03.2024 Ends*/    
                
                
update  #Zrit_prism_rmc_Cobi_tmp                
set amount_in_words=scmdb.dbo.fnAmountToWords(total)                 
from #Zrit_prism_rmc_Cobi_tmp                
                
/*code Added and commented by Vasanthi K  */               
----GSTIN                
--  update  #Zrit_prism_rmc_Cobi_tmp                
--set  cobi_extrachar1=  extrachar1--registration_no  /*code modified by Gayathri on 05-01-2024*/              
-- from cps_taxparam_sys s (nolock)                
--,  #Zrit_prism_rmc_Cobi_tmp t                
--where s.company_code=t.companycode                
--and   tax_type='GST'                 
--and  s.tax_community='INDIA'               
--and   ou_id=@_hiddenou               
        
 --GSTN NO company           
 --UPDATE #Zrit_prism_rmc_Cobi_tmp                                  
 --SET cobi_extrachar1 = REGD_NO     
 --FROM tset_tax_region_vw v(NOLOCK)    
 --,#Zrit_prism_rmc_Cobi_tmp t(NOLOCK)        
 --      WHERE v.COMPANY_CODE = companycode                                  
 --      AND v.tax_community = 'INDIA'                     
 --      AND v.tax_type = 'GST'            
    
       
 UPDATE T        
 SET cobi_extrachar1 = own_regd_no                                  
 FROM #Zrit_prism_rmc_Cobi_tmp T        
 Join tcal_tax_hdr with (nolock)        
 on  invoice_no = tran_no           
 /* code commented and added By paul starts here on 28-03-2024*/    
 --and extrachar2 = own_tax_region        
 and extrachar1 = own_regd_no--own_tax_region        
 /* code commented and added By paul ends here on 28-03-2024*/    
 where  tran_no  = @invoicenumber        
 and tran_ou  = @_hiddenou       
 and tax_type='GST'    
/*code Added and commented by Vasanthi K*/                
                
--TAN                 
  update  #Zrit_prism_rmc_Cobi_tmp             
set  cobi_extrachar2=notes_desc                  
   FROM   not_std_notes  with(NOLOCK)  ,              
   #Zrit_prism_rmc_Cobi_tmp              
 Where  /* ou_id = @_hiddenou                  
 AND */  /*Gayathri MODIFIED*/    
 /*Code Commented and Added by Amirtha P on 02.08.2024 Begins*/    
 --notes_id = 'TAN NUMBER'     
 notes_id = 'TANNO'      
 /*Code Commented and Added by Amirtha P on 02.08.2024 Ends*/    
                
           
 --Customer GSTIN and PAN No.                
   update  #Zrit_prism_rmc_Cobi_tmp                
set  cobi_extrachar3=ctds_regd_no,                
cobi_extrachar4=Pan_No     
from cust_tds_info c with(NOLOCK)                  
left join #Zrit_prism_rmc_Cobi_tmp t                
on (c.ctds_comp_code=t.companycode                
and  c.ctds_cust_code=t.billtocustomercode                
and  ctds_tax_type ='GST'              
and  ctds_tax_community='INDIA')                
                
                
                
update  #Zrit_prism_rmc_Cobi_tmp                
set  billtocustomername=clo_cust_name      
from cust_lo_info c with(NOLOCK)                  
left join #Zrit_prism_rmc_Cobi_tmp t                
on (c.clo_cust_code=t.billtocustomercode)           
      
                
update  #Zrit_prism_rmc_Cobi_tmp                
set  shiptocustomernameml=clo_cust_name                
from cust_lo_info c with(NOLOCK)                  
left join #Zrit_prism_rmc_Cobi_tmp t           
on (c.clo_cust_code=t.shipcustcodeml)                
        
declare @asee_typ varchar(100)     
    
/* Code Commented by Amirtha P on 07.08.2024 Begins    
select @asee_typ = a.assessee_type                        
from tset_tax_region a with (nolock)                  
left join #Zrit_prism_rmc_Cobi_tmp  t                    
on (a.COMPANY_CODE=t.companycode                
and  a.TAX_REGION_DESC=t.shiptostate)                
*/    
    
Select @asee_typ  =  assessee_type    
From tcal_tran_hdr   with (nolock)    
Join #Zrit_prism_rmc_Cobi_tmp with (nolock)    
On  invoice_no  =  tran_no    
And  tran_ou   =  org_unit    
And  tax_type  =  'GST'    
                
                
if @asee_typ = 'Registered'         
begin                
update #Zrit_prism_rmc_Cobi_tmp             
set cobi_extrachar5 = 'B2B'          
from #Zrit_prism_rmc_Cobi_tmp                      
end                    
else if @asee_typ = 'UnRegistered' /*Code Added by Amirtha P on 07.08.2024*/                    
begin                        
update #Zrit_prism_rmc_Cobi_tmp                
set cobi_extrachar5 = 'B2C'                       
from #Zrit_prism_rmc_Cobi_tmp                
end       
    
/* added by paul from as per SAP maintain assessee type */     
update t    
set cobi_extrachar5=    
     Case When CustMst.ctds_assessee_type = 'Government' Then 'B2G'    
     When CustMst.ctds_assessee_type = 'Registered' Then 'B2B'    
     When CustMst.ctds_assessee_type = 'Unregistered' Then 'B2C'    
     When CustMst.ctds_assessee_type = 'SEZ' and CustMst.ctds_taxrate_appl='NO'  Then 'SEZWP'    
  When CustMst.ctds_assessee_type = 'SEZ' and CustMst.ctds_taxrate_appl<>'NO' Then 'SEZWOP'    
  else CustMst.ctds_assessee_type end   
  from #Zrit_prism_rmc_Cobi_tmp t    
  join interfacedb..Zrit_rmcl_eInvoice_Cust_Dtls  CustMst     
  on  billtocustomercode=Cust_Code    
  where isBillTo='Y'    
/* added by paul from as per SAP maintain assessee type */    
  
declare @bill_to_id varchar(20)  
declare @bill_to_cust varchar(200)  
  
declare @txreg varchar(200)  
select  @bill_to_id  =   isnull(@bill_to_id,cou_dflt_billto_id)  
,@bill_to_cust =cou_dflt_billto_cust  
from cust_ou_info(nolock)    
   where cou_cust_code = @custcode    
   and  cou_ou   = @destou      
  
  
   declare @billtostate varchar(100)  
  
   select @billtostate =addr_state  
   FROM    cust_addr_details_vw cust(NOLOCK)     
   WHERE   cust.addr_cust_code   = @bill_to_cust    
   AND     cust.addr_address_id  = ISNULL(@bill_to_id, addr_address_id)   
  
  
  
select @txreg= tax_region_desc     
     from tset_tax_region_vw     
     where   tax_region         = @billtostate    
     --a--nd     company_code       = @company_code    
     and  tax_type     = 'GST'    
        and  tax_community    = 'INDIA'         
    
  
  /*Code Commented for RPRMCB-1 Begins*/    
  /*  
 update #Zrit_prism_rmc_Cobi_tmp                
 set  extrachar23 =  case when @asee_typ = 'UnRegistered' then extrachar23    
       when @asee_typ = 'Registered' then isnull(@txreg,'')/*billstate*/ + '(' + state_code + ')' end    
  */  
  /*Code Commented for RPRMCB-1 Ends*/    
      
 update #Zrit_prism_rmc_Cobi_tmp                                
 set text1='Do not pay cash to any of our employee towards company`s due as company accepts payments only through normal banking channels. All payments to the company shall be mandatorily required to be made by way of crossed CHEQUE/RTGS/NEFT, in favor o

f the company in it`s designated bank account.Therefore, if any cash is paid to any of our employees, it will be at customer`s risk and company shall not be liable for the same.'                        
                          
 update #Zrit_prism_rmc_Cobi_tmp                                
 set text2='Time at site : ____________ Return site : _______________ Time of unloading :_______________    Pour Location :___________________Water and/or other Material added at time:_______________                    
<br> I confirm that, I have received and accepted quantity and grade of the concrete ordered as above.The time shown above is correct. I have authorized the addition on site of any water and / or materials specified at our own risk.'                      




  
                          
 update #Zrit_prism_rmc_Cobi_tmp                                
 set text3='Terms & conditions:              
 <br>                          
 1. Cheque`s dishonored due to any reason attributable to customer will attract charges of Rs.1500 +GST, without prejudice of our rights as contemplated under the provisions of section 138 of Negotiable Instruments Act.For information on our value added p

roducts / special concretes. Kindly visit our website as given below.<br>                           
 '+--2. Pursuant to section 206C(1H) of Income Tax Act,1961, TCS shall be levied on all collections / sale consideration received / due to be received from customers on or after 01.10.2020 including the sales made on or before 30.09.2020. Accordingly w.e.
f April 01,2021, TCS @ 0.10% for customers having PAN and 1% for not having PAN will be applicable.<br>        --code commented by Aparna M against RPRMCB-1      
 +'2. In case of any discrepancy in the invoice we request you to get back to our Accounts Dept. at the phone no''s given above within 48 hours. <br>  
 3. Simple Interest @18%p.a. will be levied in case payments are delayed beyond the agreed terms of payment.<br> "If any disputes arise about this transaction, the same shall have to be referred tho the Hindustan Chamber of Commerce, Mumbai for decision u
nder its arbitration rules and Awards made there under shall be binding upon the parties and ''subject to Mumbai Jurisdiction only.''"  <br> <br>Certified that the particulars given above are true and correct and the amount indicated represents the price 
actually charged and that there is no flow of additional consideration directly or indirectly from the buyer.'    
       
               
        
 --Code Commented and Added Vasanthi for e-mudhra sign begins    
 -- update #Zrit_prism_rmc_Cobi_tmp                        
 --set text4= 'PRISM JOHNSON LIMITED <BR> RMC(INDIA) DIVISION'                          
      
    update #Zrit_prism_rmc_Cobi_tmp            
 /*Code Commented and Added for RPRMCB-1 Begins*/    
 /*set text4= 'PRISM JOHNSON LIMITED RMC(INDIA) DIVISION'  */  
 Set text4 = companyname  
 /*Code Commented and Added for RPRMCB-1 Ends*/    
 --Code Commented and Added Vasanthi for e-mudhra sign ends    
    
  update #Zrit_prism_rmc_Cobi_tmp              
 set text5='Signature (Of/on Behalf of Customer) <br> Subject to ' + city + ' and Jurisdiction'     
  from emod_ou_addr_map_vw v with (nolock)      
 where ou_id   =@_hiddenou        
    
 update #Zrit_prism_rmc_Cobi_tmp     
 set text6='                
 Please Note : <br>    
 A) The time allowed for unloading this vehicle is ten minutes plus five Minutes per cum or part there of this load. Any detention in excess of Allowable time shall be charged extra. <br>  
 B) We are not responsible for slump, loss of strength or quality of the concrete when water and / or any other materials have been added on site by or at the request of the customer. <br>  
 C) This concrete is sold on and subject to the conditions of sales mention on our quotation. <br>   
 D) You must ensure timely wetting and proper covering of placed concrete Before it dries to avoid plastic shrinkage cracks. RMC India Division will not be responsible for any such cracks developed in in-situ concrete. <br> Caution : Please warn concrete
 users that, to avoid any risk of serious skin injury, they should minimize contact with wet cement and wet Concrete(e.g: wear suitable protective clothing) and where contact  occurs, should, without delay wash thoroughly.'           
        
        
/*Code Added  by Amirtha P on 15.02.2024 Begins*/        
if exists (Select 'x' from  #Zrit_prism_rmc_Cobi_tmp with (nolock) where transport_mode is not null )        
begin    
 Update T        
 Set  transport_mode = concat('BY ',transport_mode)      
 From #Zrit_prism_rmc_Cobi_tmp T        
 where transport_mode is not null        
End        
        
 update T    
 set extrachar19  = method        
 from   #Zrit_prism_rmc_Cobi_tmp   T            
 join    cobi_item_dtl with (nolock)                  
 on invoice_no =tran_no     
 join  so_order_hdr  with (nolock)                  
 on  tran_ou = sohdr_ou                  
 and so_no   = sohdr_order_no                 
join zrit_recepe_code_tbl_iedk R with (nolock)            
 on  ORDER_OU = sohdr_ou                
 and ORDER_NO   = sohdr_order_no       
 and   so_line_no= R.Line_no--added here    
        
 update T                  
 set extrachar24  = ackno  ,      
  date5   = CONVERT(VARCHAR(10), ackdt, 104) + ' '  + convert(VARCHAR(8), ackdt, 14)--ackdt /*Code Added by Vasanthi K on 18.12.2024*/        
 from   #Zrit_prism_rmc_Cobi_tmp    T       
 join    cobi_item_dtl c with (nolock)                  
 on  invoice_no =c.tran_no                  
 join interfacedb..zrit_mcl_etoken_dtl m  with (nolock)                  
 on  m.tran_ou = c.tran_ou                  
 and m.tran_no   = c.tran_no      
   
    
 /*Due_Date Logic based on Pay term*/    
 update T                  
 set  date2  = dateadd(day,pt_duedays,date1)    
 from  #Zrit_prism_rmc_Cobi_tmp    T       
 join  cobi_invoice_hdr c  with (nolock)                  
 on   c.tran_no   =  invoice_no        
 And  org_unit   =  tran_ou    
 Join  pt_payterm_details   with (nolock)     
 On   pt_paytermcode  =  pay_term    
    
 update  #Zrit_prism_rmc_Cobi_tmp                
 set  packslipdate=isnull(CONVERT(VARCHAR(10),cast(packslipdate as datetime), 105),packslipdate)     
  ,date1=isnull(CONVERT(VARCHAR(10),cast(date1 as datetime), 104/*105*/),date1)  --modified by Aparna M against PJRMC-1204      
   ,date2=isnull(CONVERT(VARCHAR(10),cast(date2 as datetime), 104/*105*/),date2)   --modified by Aparna M against PJRMC-1204          
   ,date3=isnull(CONVERT(VARCHAR(10),cast(date3 as datetime), 104/*105*/),date3)        --modified by Aparna M against PJRMC-1204  
   ,date4=isnull(CONVERT(VARCHAR(10),cast(date4 as datetime), 104/*105*/),date4)    --modified by Aparna M against PJRMC-1204  
   --code commented and added by vasanthi begins    
  --,date5=isnull(CONVERT(VARCHAR(10),cast(date5 as datetime), 103),date5)    
   --,date5=isnull(CONVERT(VARCHAR(10),cast(date5 as datetime), 105),date5)     
  --,date5=isnull(CONVERT(VARCHAR(19),cast(date5 as datetime), 29),date5)  
  --code commented and added by vasanthi begins    
    
   /*Due_Date Logic based on Customer receipt*/    
 --update T                  
 --set  date2  = isnull(CONVERT(VARCHAR(10),cast(due_date as datetime), 105),due_date)         
 --from  #Zrit_prism_rmc_Cobi_tmp    T       
 --join  ci_doc_balance c with (nolock)      
 --on   invoice_no = c.tran_no        
 --And  org_unit = tran_ou    
 --Where  pay_term <> 'NA'    
    
    
 --PJRMC-1113 begins    
  /*Due_Date Logic based on Credit term*/    
update T    
set Date2=''    
from  #Zrit_prism_rmc_Cobi_tmp    T       
 join  cobi_invoice_hdr c  with (nolock)                  
 on   c.tran_no   =  invoice_no        
join cust_BU_info b with (nolock)    
on b.cbu_cust_code= c.bill_to_cust    
where cbu_cr_term_code='ADV'    
    
 --PJRMC-1113 ends    
    
    
 ALTER TABLE #Zrit_prism_rmc_Cobi_tmp ADD Agg_msa varchar(80),Cement varchar(94),Target_Slump varchar(86),Max_Ratio varchar(98),Admix varchar(87),Spe_Reg varchar(98),Ex_Char1 varchar(255),Ex_Char2 varchar(255),Ex_Char3 varchar(255),Ex_Char4 varchar(255) ,
EX_char5 varchar(max) --Vasanthi K  
  
/*Code Added by Vasanthi K on 19.12.2024 Begins*/  
if exists ( select 'X'  
   FROM #Zrit_prism_rmc_Cobi_tmp t  
   JOIN cust_tds_info info with (NOLOCK)  
   ON  info.ctds_cust_code = t.billtocustomercode  
   where ctds_assessee_type ='Sez')  
  
begin  
UPDATE T  
SET EX_char5 =   
    'THE SAID SUPPLY OF MATERIAL IS MEANT FOR EXPORT/ SUPPLY TO SEZ UNIT OR SEZ DEVELOPER ' +  
    'FOR AUTHORISED OPERATIONS WITHOUT PAYMENT OF IGST UNDER LUT /ARN NO.' +   
    ISNULL(info.ctds_remarks, '') + ' ' + 'VALID UPTO 31.03.2025 In case SEZ Tax amount specified below even if zero rated as'+'  '+ ISNULL(t.igstchar3, '')+'on'+' '+''+ISNULL(CAST(convert(numeric(28,2),extraamount10) AS NVARCHAR(50)), '0.00')+' '+   +' o
n assessable value of Rs.'+ISNULL(CAST(convert(numeric(28,2),invoicedamount) AS NVARCHAR(50)), '0.00')+'.'  
FROM #Zrit_prism_rmc_Cobi_tmp t  
JOIN cust_tds_info info with (NOLOCK)  
ON  info.ctds_cust_code = t.billtocustomercode  
where ctds_assessee_type = 'Sez'  
And  ctds_tax_type  = 'GST'  
And  ctds_tax_community = 'India'   
end  
/*Code Added by Vasanthi K on 19.12.2024 Ends*/  
    
 Update T    
 Set Agg_msa   = isnull(null,RMCMXAGGSIZE),   
  Cement   = isnull(null,RMCCEMENT),    
  Target_Slump = isnull(null,RMCSLUMP),    
  Max_Ratio  = isnull(null,RMCMAXWC),    
  Admix   = isnull(null,RMCADMIXTURE),    
  Spe_Reg   = isnull(null,RMCSPECIALREQUIREMENT),    
  text7 = 'FN_' + cobi_extrachar10 + '_' + isnull(batch_serial_no,'') + '_' + replace(isnull(date1,''),'.','')    
 From #Zrit_prism_rmc_Cobi_tmp T    
 Join interfacedb..zrit_ids_inv_gen2_tbl I    
 On  I.INVOICE_NO = T.invoice_no    
  
   
  /*Code Added by Amirtha P. on 16.12.2024 Begins*/  
  
  Declare @ouname varchar(255)  
  
  Select @ouname = cobi_extrachar10  
  From  #Zrit_prism_rmc_Cobi_tmp with (nolock)  
  
  Select @ouname = concat(left(cobi_extrachar10,5),right(cobi_extrachar10,4))  
  from  #Zrit_prism_rmc_Cobi_tmp with (nolock)  
  
  Update T  
  Set  text7  = 'FN_' + @ouname + '_' + isnull(batch_serial_no,'') + '_' + replace(isnull(date1,''),'.','')    
  From  #Zrit_prism_rmc_Cobi_tmp T  
  
  /*Code Added by Amirtha P. on 16.12.2024 Ends*/  
    
  
  update t  
  set itemvariantdesc=isnull(item_trade_mark,itemvariantdesc)  
  from #Zrit_prism_rmc_Cobi_tmp t  
  join Zrit_itm_ibu_itemvarhdr  b with (nolock)   
  on t.itemcode= b.itemcode  
  and   Material_Type='YRMS'   
  where invoice_no=@invoicenumber  
   
  
 update t  
set Ex_Char1=case when d.companycode like '%PJLRMC%' then footeraddress else footeraddress+' CIN NO:'+CIN END  
,Ex_Char2 = 'Website : '+website+',Toll Free Number: '+tollfree  
from #Zrit_prism_rmc_Cobi_tmp  t  
join zrit_footer_address_dw d  
on d.companycode=@company_code  
  
update #Zrit_prism_rmc_Cobi_tmp  
set Ex_Char3 =concat(logo_path,logo_name)  
from zrit_logo_details  
where company_code=@company_code  
    
  
  declare @ship_to_cust varchar(100),@ship_to_id varchar(50)  
  
  
  
  select @ship_to_cust =ship_to_cust  
  
 , @ship_to_id =ship_to_id  
from  cobi_item_dtl  
join #Zrit_prism_rmc_Cobi_tmp  
on tran_no = invoice_no  
and org_unit =tran_ou  
and linenumber = line_no  
  
  update  tmp         
  set  --shipstate  = ISNULL(addr_state, ''),    
    shipaddress1 = isnull(addr_addrline1, '') + case isnull(addr_addrline2, '')    
                 when '' then ' '    
         else ','    
               end + isnull(addr_addrline2, '')   ,    
      shipaddress2 = isnull(addr_addrline3, '') ,    
      shipaddress3 = isnull(addr_state, '') + case isnull(addr_state, '')    
                 when '' then ' '    
                 else ','    
               end    
         + isnull(addr_zip, '') + case isnull(addr_city, '')    
          when '' then ' '    
            else '- '    
          end  
    + isnull(addr_city, '')  /*+ isnull(addr_email,'')+ nchar(13),*/ --EPE-16574  /*Code Commented for RITSL/UAT_Fix*/    
       ,shiptoph  = ltrim(rtrim(addr_phone))    
  FROM    cust_addr_details_vw cust(NOLOCK),    
    #Zrit_prism_rmc_Cobi_tmp tmp    
  WHERE   cust.addr_cust_code   = @ship_to_cust    
  AND     cust.addr_address_id  = ISNULL(@ship_to_id, addr_address_id)    
  and  tmp.invoice_no     = @invoicenumber     
  and  tmp.org_unit     = @_hiddenou     
  --and  tmp.tran_type     = @trantype     
  --and tmp.guid  = @guid/*Code added by Shri */  
  
 /*Code Added  by Amirtha P on 15.02.2024 Ends*/     
--Code added by Vasanthi against:RPRMCB-1 update the value extrachar9 since this field is not use in design level 
 update t
 set extrachar9='RAMCO'
 from #Zrit_prism_rmc_Cobi_tmp  t  
--Code added by Vasanthi against: update the value extrachar9 since this field is not use in design level 
--Code Commented and Added by Vasanthi K for RPRMCB-1 begins 
 select        
 wfdockey             
,report_type1              
,invoice_no                
,packslipdate                
,totaltimeml        
,org_unit                
,currency_code                
,modetransport                
,destinationlocation                
,billtocustomercode                
,billtocustomername                
,billtoaddress1     
,billtoaddress2                
,billtoaddress3        
,billstate                
,billtocountry              
,billtoph                
,shipcustcodeml                
,shiptocustomernameml                
,shipaddress1                
,shipaddress2                
,shipaddress3                
,shiptostate                
,shiptoctry                
,shiptoph                
--,linenumber                
,itemcode                
,tcdtype                
,itemdesc_ml                
,itemvariantml                
--,itemcode +'-'+ itemvariantdesc     'itemvariantdesc'     
,itemvariantdesc  
,item_type  
,unitprice             
/*code commented and added by Vasanthi K against id:PJRMC-1204 begins*/  
,uom  
--ISNULL(new_uom,uom) 'UOM'   -- code added by K Vishnupriya  
/*code commented and added by Vasanthi K against id:PJRMC-1204 ends*/  
,isnull(sum(invoicequantity  ),'0') 'invoicequantity'          
,isnull(sum(invoicedamount   ),'0') 'invoicedamount'           
,isnull(sum(invoicenetamount ),'0')  'invoicenetamount'            
,itemlevelcharge                
,itemleveldiscount                
,item_tax                
,paytermdes                
,shipremarks     
,insuranceterm1                
,companycode              
,companyname        
,companyaddress1              
,companyaddress2                
,companyaddress3           
,state                
,origincountry                
,phoneno1                
,narration                
,extrachar1   
,extrachar2       
,extrachar3                
,extrachar4                
,extrachar5      
,extrachar6                
,extrachar7   
,extrachar8                
,extrachar9                
,extrachar10              
,isnull(sum(extraamount1) ,'0')   'extraamount1'          
,extraamount2               
,isnull(sum(extraamount3) ,'0')  'extraamount3'             
,extraamount4         
,isnull(sum(extraamount5) ,'0')   'extraamount5'            
,isnull(sum(extraamount6) ,'0')    'extraamount6'           
,isnull(sum(extraamount7) ,'0')   'extraamount7'            
,isnull(sum(extraamount8) ,'0')      'extraamount8'         
,extraamount9             
,extraamount10          
,date1      
,date2                
,date3                
,date4       
,date5       
,Total_inv_amount            
,Print_date      
,Print_time/*Convert Added by Vasanthi K on 18.12.2024*/  
,invoicestatus_ml                
,sequenceno                
,guid                
,wfdockey2                
,isnull(sum(extraamount11),'0')    'extraamount11'           
,isnull(sum(extraamount12),'0')    'extraamount12'            
,isnull(sum(extraamount13),'0')    'extraamount13'            
,isnull(sum(extraamount14),'0')    'extraamount14'            
,isnull(sum(extraamount15),'0')    'extraamount15'
,isnull(sum(extraamount16),'0')    'extraamount16'            
,isnull(sum(extraamount17),'0')    'extraamount17'            
,isnull(sum(extraamount18),'0')    'extraamount18'            
,isnull(sum(extraamount19),'0')    'extraamount19'   
,isnull(sum(extraamount20),'0')    'extraamount20'    
,Extraint1                
,Extraint2                
,Extraint3              
,Extraint4                
,Extraint5                
,isnull(sum(extranumeric1),'0')  'extranumeric1'             
,isnull(sum(extranumeric2),'0')  'extranumeric2'              
,isnull(sum(extranumeric3),'0')  'extranumeric3'              
,isnull(sum(extranumeric4),'0')  'extranumeric4'              
,isnull(sum(extranumeric5),'0')  'extranumeric5'            
,extrachar11              
,extrachar12                
,EXTRACHAR13                
,EXTRACHAR14                
,EXTRACHAR15                
,EXTRACHAR16                
,EXTRACHAR17                
,EXTRACHAR18                
,EXTRACHAR19                
,EXTRACHAR20                
,EXTRACHAR21                
,EXTRACHAR22                
,EXTRACHAR23         
,EXTRACHAR24                
,EXTRACHAR25                
,EXTRACHAR26                
,EXTRACHAR27                
,EXTRACHAR28                
,EXTRACHAR29                
,EXTRACHAR30                
,EXTRACHAR31                
,EXTRACHAR32                
,EXTRACHAR33                
,EXTRACHAR34                
,EXTRACHAR35                
,EXTRACHAR36                
,EXTRACHAR37                
,EXTRACHAR38                
,EXTRACHAR39                
,EXTRACHAR40                
,EXTRACHAR41                
,EXTRACHAR42                
,EXTRACHAR43                
,EXTRACHAR30_1            
,isnull(sum(extraamount21),'0')  'extraamount21'        
,isnull(sum(extraamount22),'0')   'extraamount22'             
,isnull(sum(Extraamount23),'0')   'extraamount23'             
,isnull(sum(extraamount24),'0')   'extraamount24'             
,CIN                
,state_code              
,'ORIGINAL FOR RECIPIENT' AS'report_type'                
,del_state_code                
,buy_ord_no     
,batch_serial_no                
,sales_eng                
 ,vehicle_no                
,transport_mode                
,cobi_extrachar1             
,cobi_extrachar2            
,cobi_extrachar3                
,cobi_extrachar4                
,cobi_extrachar5                
,cobi_extrachar6                
,cobi_extrachar7                
,cobi_extrachar8                
,cobi_extrachar9                
,cobi_extrachar10                
,cobi_extrachar11                
,isnull(sum(cobi_numeric1) ,'0')'cobi_numeric1'               
,isnull(sum(cobi_numeric2) ,'0')'cobi_numeric2'               
,isnull(sum(cobi_numeric3) ,'0')'cobi_numeric3'               
,isnull(sum(cobi_numeric4) ,'0')'cobi_numeric4'               
,isnull(sum(cobi_numeric5) ,'0')'cobi_numeric5'               
,isnull(sum(cobi_numeric6) ,'0')'cobi_numeric6'               
,cgst_char1                
,sgst_char2                
,igstchar3                
,cess_char3                
,round_off            
,total                
,amount_in_words                
,text1                
,text2                
,text3                
,text4                
,text5                
,text6                
,text7     
,Agg_msa,Cement,Target_Slump,Max_Ratio,Admix,Spe_Reg,Ex_Char1,Ex_Char2,Ex_Char3,Ex_Char4    
,EX_char5 --Vasanthi
 into #temp_final
from  #Zrit_prism_rmc_Cobi_tmp              
group by
wfdockey             
,report_type1              
,invoice_no                
,packslipdate                
,totaltimeml        
,org_unit                
,currency_code                
,modetransport                
,destinationlocation                
,billtocustomercode                
,billtocustomername                
,billtoaddress1     
,billtoaddress2                
,billtoaddress3        
,billstate                
,billtocountry              
,billtoph                
,shipcustcodeml                
,shiptocustomernameml                
,shipaddress1                
,shipaddress2                
,shipaddress3                
,shiptostate                
,shiptoctry                
,shiptoph                
--,linenumber                
,itemcode                
,tcdtype                
,itemdesc_ml                
,itemvariantml                
,itemvariantdesc  
,item_type  
,uom                 
,itemlevelcharge                
,itemleveldiscount                
,item_tax                
,paytermdes                
,shipremarks     
,insuranceterm1                
,companycode              
,companyname        
,companyaddress1              
,companyaddress2                
,companyaddress3           
,state                
,origincountry                
,phoneno1                
,narration                
,extrachar1   
,extrachar2       
,extrachar3                
,extrachar4                
,extrachar5      
,extrachar6                
,extrachar7   
,extrachar8                
,extrachar9                
,extrachar10                    
,date1      
,date2                
,date3                
,date4       
,date5       
,Print_date      
,Print_time
,invoicestatus_ml                
,sequenceno                
,guid                
,wfdockey2                 
,Extraint1                
,Extraint2                
,Extraint3              
,Extraint4                
,Extraint5                          
,extrachar11              
,extrachar12                
,EXTRACHAR13                
,EXTRACHAR14                
,EXTRACHAR15                
,EXTRACHAR16                
,EXTRACHAR17                
,EXTRACHAR18                
,EXTRACHAR19                
,EXTRACHAR20                
,EXTRACHAR21                
,EXTRACHAR22                
,EXTRACHAR23         
,EXTRACHAR24                
,EXTRACHAR25                
,EXTRACHAR26                
,EXTRACHAR27                
,EXTRACHAR28                
,EXTRACHAR29                
,EXTRACHAR30                
,EXTRACHAR31                
,EXTRACHAR32                
,EXTRACHAR33                
,EXTRACHAR34                
,EXTRACHAR35                
,EXTRACHAR36                
,EXTRACHAR37                
,EXTRACHAR38                
,EXTRACHAR39                
,EXTRACHAR40                
,EXTRACHAR41                
,EXTRACHAR42                
,EXTRACHAR43                
,EXTRACHAR30_1                           
,CIN                
,state_code              
,del_state_code                
,buy_ord_no     
,batch_serial_no                
,sales_eng                
 ,vehicle_no                
,transport_mode                
,cobi_extrachar1             
,cobi_extrachar2            
,cobi_extrachar3                
,cobi_extrachar4                
,cobi_extrachar5                
,cobi_extrachar6                
,cobi_extrachar7                
,cobi_extrachar8                
,cobi_extrachar9                
,cobi_extrachar10                
,cobi_extrachar11                
,cgst_char1                
,sgst_char2                
,igstchar3                
,cess_char3                
,round_off                
,total                
,amount_in_words                
,text1                
,text2                
,text3                
,text4                
,text5                
,text6                
,text7     
,Agg_msa,Cement,Target_Slump,Max_Ratio,Admix,Spe_Reg,Ex_Char1,Ex_Char2,Ex_Char3,Ex_Char4    
,EX_char5 ,extraamount2,extraamount4,extraamount9,extraamount10,Total_inv_amount,unitprice
/*code commented and added by Vasanthi K against id:PJRMC-1204 begins*/  
--/* code added by K Vishnupriya starts here */     
--LEFT JOIN zrit_uom_execption_tbl    
--ON ramco_uom = UOM    
--/* code added by K Vishnupriya ends here */    
/*code commented and added by Vasanthi K against id:PJRMC-1204 ends*/  

union All
select        
 wfdockey             
,report_type1              
,invoice_no                
,packslipdate                
,totaltimeml        
,org_unit                
,currency_code                
,modetransport                
,destinationlocation                
,billtocustomercode                
,billtocustomername                
,billtoaddress1     
,billtoaddress2                
,billtoaddress3        
,billstate                
,billtocountry              
,billtoph                
,shipcustcodeml                
,shiptocustomernameml                
,shipaddress1                
,shipaddress2                
,shipaddress3                
,shiptostate                
,shiptoctry                
,shiptoph                
--,linenumber                
,itemcode                
,tcdtype                
,itemdesc_ml                
,itemvariantml                
--,itemcode +'-'+ itemvariantdesc     'itemvariantdesc'     
,itemvariantdesc  
,item_type  
,unitprice              
/*code commented and added by Vasanthi K against id:PJRMC-1204 begins*/  
,uom  
--ISNULL(new_uom,uom) 'UOM'   -- code added by K Vishnupriya  
/*code commented and added by Vasanthi K against id:PJRMC-1204 ends*/  
,isnull(sum(invoicequantity  ),'0')   'invoicequantity'           
,isnull(sum(invoicedamount   ),'0')   'invoicedamount'          
,isnull(sum(invoicenetamount ),'0')     'invoicenetamount'          
,itemlevelcharge                
,itemleveldiscount                
,item_tax                
,paytermdes                
,shipremarks     
,insuranceterm1                
,companycode              
,companyname        
,companyaddress1              
,companyaddress2                
,companyaddress3           
,state                
,origincountry                
,phoneno1                
,narration                
,extrachar1   
,extrachar2       
,extrachar3                
,extrachar4                
,extrachar5      
,extrachar6                
,extrachar7   
,extrachar8                
,extrachar9                
,extrachar10              
,isnull(sum(extraamount1) ,'0')  'extraamount1'             
,extraamount2               	
,isnull(sum(extraamount3) ,'0')  'extraamount3'             
,extraamount4         			
,isnull(sum(extraamount5) ,'0')  'extraamount5'             
,isnull(sum(extraamount6) ,'0')  'extraamount6'             
,isnull(sum(extraamount7) ,'0')  'extraamount7'             
,isnull(sum(extraamount8) ,'0')  'extraamount8'             
,extraamount9             
,extraamount10          
,date1      
,date2                
,date3                
,date4       
,date5       
,Total_inv_amount            
,Print_date      
,Print_time/*Convert Added by Vasanthi K on 18.12.2024*/  
,invoicestatus_ml                
,sequenceno                
,guid                
,wfdockey2                
,isnull(sum(extraamount11),'0')   'extraamount11'  
,isnull(sum(extraamount12),'0')   'extraamount12'             
,isnull(sum(extraamount13),'0')   'extraamount13'             
,isnull(sum(extraamount14),'0')   'extraamount14'             
,isnull(sum(extraamount15),'0')   'extraamount15' 
,isnull(sum(extraamount16),'0')   'extraamount16'             
,isnull(sum(extraamount17),'0')   'extraamount17'             
,isnull(sum(extraamount18),'0')   'extraamount18'             
,isnull(sum(extraamount19),'0')   'extraamount19'    
,isnull(sum(extraamount20),'0')   'extraamount20'     
,Extraint1                
,Extraint2                
,Extraint3              
,Extraint4                
,Extraint5                
,isnull(sum(extranumeric1),'0')  'extranumeric1'             
,isnull(sum(extranumeric2),'0')  'extranumeric2'              
,isnull(sum(extranumeric3),'0')  'extranumeric3'              
,isnull(sum(extranumeric4),'0')  'extranumeric4'              
,isnull(sum(extranumeric5),'0')  'extranumeric5'            
,extrachar11              
,extrachar12                
,EXTRACHAR13                
,EXTRACHAR14                
,EXTRACHAR15                
,EXTRACHAR16                
,EXTRACHAR17                
,EXTRACHAR18                
,EXTRACHAR19                
,EXTRACHAR20                
,EXTRACHAR21                
,EXTRACHAR22                
,EXTRACHAR23         
,EXTRACHAR24                
,EXTRACHAR25                
,EXTRACHAR26                
,EXTRACHAR27                
,EXTRACHAR28                
,EXTRACHAR29                
,EXTRACHAR30                
,EXTRACHAR31                
,EXTRACHAR32                
,EXTRACHAR33                
,EXTRACHAR34                
,EXTRACHAR35                
,EXTRACHAR36                
,EXTRACHAR37                
,EXTRACHAR38                
,EXTRACHAR39                
,EXTRACHAR40                
,EXTRACHAR41                
,EXTRACHAR42                
,EXTRACHAR43                
,EXTRACHAR30_1            
,isnull(sum(extraamount21),'0') 'extraamount21'         
,isnull(sum(extraamount22),'0') 'extraamount22'               
,isnull(sum(Extraamount23),'0') 'extraamount23'               
,isnull(sum(extraamount24),'0') 'extraamount24'               
,CIN                
,state_code              
,'DUPLICATE FOR TRANSPORTER' AS'report_type'                
,del_state_code                
,buy_ord_no     
,batch_serial_no                
,sales_eng                
 ,vehicle_no                
,transport_mode                
,cobi_extrachar1             
,cobi_extrachar2            
,cobi_extrachar3                
,cobi_extrachar4                
,cobi_extrachar5                
,cobi_extrachar6                
,cobi_extrachar7                
,cobi_extrachar8                
,cobi_extrachar9                
,cobi_extrachar10                
,cobi_extrachar11                
,isnull(sum(cobi_numeric1) ,'0')  'cobi_numeric1'             
,isnull(sum(cobi_numeric2) ,'0')  'cobi_numeric2'             
,isnull(sum(cobi_numeric3) ,'0')  'cobi_numeric3'             
,isnull(sum(cobi_numeric4) ,'0')  'cobi_numeric4'             
,isnull(sum(cobi_numeric5) ,'0')  'cobi_numeric5'             
,isnull(sum(cobi_numeric6) ,'0')  'cobi_numeric6'             
,cgst_char1                
,sgst_char2                
,igstchar3                
,cess_char3                
,round_off                
,total                
,amount_in_words                
,text1                
,text2                
,text3                
,text4                
,text5                
,text6                
,text7     
,Agg_msa,Cement,Target_Slump,Max_Ratio,Admix,Spe_Reg,Ex_Char1,Ex_Char2,Ex_Char3,Ex_Char4    
,EX_char5 --Vasanthi
from  #Zrit_prism_rmc_Cobi_tmp              
group by
wfdockey             
,report_type1              
,invoice_no                
,packslipdate                
,totaltimeml        
,org_unit                
,currency_code                
,modetransport                
,destinationlocation                
,billtocustomercode                
,billtocustomername                
,billtoaddress1     
,billtoaddress2                
,billtoaddress3        
,billstate                
,billtocountry              
,billtoph                
,shipcustcodeml                
,shiptocustomernameml                
,shipaddress1                
,shipaddress2                
,shipaddress3                
,shiptostate                
,shiptoctry                
,shiptoph                
--,linenumber                
,itemcode                
,tcdtype                
,itemdesc_ml                
,itemvariantml                
,itemvariantdesc  
,item_type  
,uom                 
,itemlevelcharge                
,itemleveldiscount                
,item_tax                
,paytermdes                
,shipremarks     
,insuranceterm1                
,companycode              
,companyname        
,companyaddress1              
,companyaddress2                
,companyaddress3           
,state                
,origincountry                
,phoneno1                
,narration                
,extrachar1   
,extrachar2       
,extrachar3                
,extrachar4                
,extrachar5      
,extrachar6                
,extrachar7   
,extrachar8                
,extrachar9                
,extrachar10                    
,date1      
,date2                
,date3                
,date4       
,date5       
,Print_date      
,Print_time
,invoicestatus_ml                
,sequenceno                
,guid                
,wfdockey2                 
,Extraint1                
,Extraint2                
,Extraint3              
,Extraint4                
,Extraint5                          
,extrachar11              
,extrachar12                
,EXTRACHAR13                
,EXTRACHAR14                
,EXTRACHAR15                
,EXTRACHAR16                
,EXTRACHAR17                
,EXTRACHAR18                
,EXTRACHAR19                
,EXTRACHAR20                
,EXTRACHAR21                
,EXTRACHAR22                
,EXTRACHAR23         
,EXTRACHAR24                
,EXTRACHAR25                
,EXTRACHAR26                
,EXTRACHAR27                
,EXTRACHAR28                
,EXTRACHAR29                
,EXTRACHAR30                
,EXTRACHAR31                
,EXTRACHAR32                
,EXTRACHAR33                
,EXTRACHAR34                
,EXTRACHAR35                
,EXTRACHAR36                
,EXTRACHAR37                
,EXTRACHAR38                
,EXTRACHAR39                
,EXTRACHAR40                
,EXTRACHAR41                
,EXTRACHAR42                
,EXTRACHAR43                
,EXTRACHAR30_1                           
,CIN                
,state_code              
,del_state_code                
,buy_ord_no     
,batch_serial_no                
,sales_eng                
 ,vehicle_no                
,transport_mode                
,cobi_extrachar1             
,cobi_extrachar2            
,cobi_extrachar3                
,cobi_extrachar4                
,cobi_extrachar5                
,cobi_extrachar6                
,cobi_extrachar7                
,cobi_extrachar8                
,cobi_extrachar9                
,cobi_extrachar10                
,cobi_extrachar11                
,cgst_char1                
,sgst_char2                
,igstchar3                
,cess_char3                
,round_off                
,total                
,amount_in_words                
,text1                
,text2                
,text3                
,text4                
,text5                
,text6                
,text7     
,Agg_msa,Cement,Target_Slump,Max_Ratio,Admix,Spe_Reg,Ex_Char1,Ex_Char2,Ex_Char3,Ex_Char4    
,EX_char5 ,extraamount2,extraamount4,extraamount9,extraamount10,Total_inv_amount,unitprice
union All
select  
 wfdockey             
,report_type1              
,invoice_no                
,packslipdate                
,totaltimeml        
,org_unit                
,currency_code                
,modetransport                
,destinationlocation                
,billtocustomercode                
,billtocustomername                
,billtoaddress1     
,billtoaddress2                
,billtoaddress3        
,billstate                
,billtocountry              
,billtoph                
,shipcustcodeml                
,shiptocustomernameml                
,shipaddress1                
,shipaddress2                
,shipaddress3                
,shiptostate                
,shiptoctry                
,shiptoph                
--,linenumber                
,itemcode                
,tcdtype                
,itemdesc_ml                
,itemvariantml                
--,itemcode +'-'+ itemvariantdesc     'itemvariantdesc'     
,itemvariantdesc  
,item_type  
,unitprice              
/*code commented and added by Vasanthi K against id:PJRMC-1204 begins*/  
,uom  
--ISNULL(new_uom,uom) 'UOM'   -- code added by K Vishnupriya  
/*code commented and added by Vasanthi K against id:PJRMC-1204 ends*/  
,isnull(sum(invoicequantity  ),'0')  'invoicequantity'            
,isnull(sum(invoicedamount   ),'0')   'invoicedamount'          
,isnull(sum(invoicenetamount ),'0')    'invoicenetamount'           
,itemlevelcharge                
,itemleveldiscount                
,item_tax                
,paytermdes                
,shipremarks     
,insuranceterm1                
,companycode              
,companyname        
,companyaddress1              
,companyaddress2                
,companyaddress3           
,state                
,origincountry                
,phoneno1                
,narration                
,extrachar1   
,extrachar2       
,extrachar3                
,extrachar4                
,extrachar5      
,extrachar6                
,extrachar7   
,extrachar8                
,extrachar9                
,extrachar10              
,isnull(sum(extraamount1) ,'0')  'extraamount1'            
,extraamount2               	 
,isnull(sum(extraamount3) ,'0')  'extraamount3'            
,extraamount4         			
,isnull(sum(extraamount5) ,'0')  'extraamount5'            
,isnull(sum(extraamount6) ,'0')  'extraamount6'            
,isnull(sum(extraamount7) ,'0')  'extraamount7'            
,isnull(sum(extraamount8) ,'0')  'extraamount8'            
,extraamount9             
,extraamount10          
,date1      
,date2                
,date3                
,date4       
,date5       
,Total_inv_amount            
,Print_date      
,Print_time/*Convert Added by Vasanthi K on 18.12.2024*/  
,invoicestatus_ml                
,sequenceno                
,guid                
,wfdockey2                
,isnull(sum(extraamount11),'0')   'extraamount11'            
,isnull(sum(extraamount12),'0')   'extraamount12'             
,isnull(sum(extraamount13),'0')   'extraamount13'             
,isnull(sum(extraamount14),'0')   'extraamount14'             
,isnull(sum(extraamount15),'0')   'extraamount15' 
,isnull(sum(extraamount16),'0')   'extraamount16'             
,isnull(sum(extraamount17),'0')   'extraamount17'             
,isnull(sum(extraamount18),'0')   'extraamount18'             
,isnull(sum(extraamount19),'0')   'extraamount19'    
,isnull(sum(extraamount20),'0')   'extraamount20'     
,Extraint1                
,Extraint2                
,Extraint3              
,Extraint4                
,Extraint5                
,isnull(sum(extranumeric1),'0')  'extranumeric1'             
,isnull(sum(extranumeric2),'0')  'extranumeric2'              
,isnull(sum(extranumeric3),'0')  'extranumeric3'              
,isnull(sum(extranumeric4),'0')  'extranumeric4'              
,isnull(sum(extranumeric5),'0')  'extranumeric5'            
,extrachar11              
,extrachar12                
,EXTRACHAR13                
,EXTRACHAR14                
,EXTRACHAR15                
,EXTRACHAR16                
,EXTRACHAR17                
,EXTRACHAR18                
,EXTRACHAR19                
,EXTRACHAR20                
,EXTRACHAR21                
,EXTRACHAR22                
,EXTRACHAR23         
,EXTRACHAR24                
,EXTRACHAR25                
,EXTRACHAR26                
,EXTRACHAR27                
,EXTRACHAR28                
,EXTRACHAR29                
,EXTRACHAR30                
,EXTRACHAR31                
,EXTRACHAR32                
,EXTRACHAR33                
,EXTRACHAR34                
,EXTRACHAR35                
,EXTRACHAR36                
,EXTRACHAR37                
,EXTRACHAR38                
,EXTRACHAR39                
,EXTRACHAR40                
,EXTRACHAR41                
,EXTRACHAR42                
,EXTRACHAR43                
,EXTRACHAR30_1            
,isnull(sum(extraamount21),'0') 'extraamount21'         
,isnull(sum(extraamount22),'0') 'extraamount22'               
,isnull(sum(Extraamount23),'0') 'extraamount23'               
,isnull(sum(extraamount24),'0') 'extraamount24'               
,CIN                
,state_code              
,'TRIPLICATE OF SUPPLIER' AS'report_type'                
,del_state_code                
,buy_ord_no     
,batch_serial_no                
,sales_eng                
 ,vehicle_no                
,transport_mode                
,cobi_extrachar1             
,cobi_extrachar2            
,cobi_extrachar3                
,cobi_extrachar4                
,cobi_extrachar5                
,cobi_extrachar6                
,cobi_extrachar7                
,cobi_extrachar8                
,cobi_extrachar9                
,cobi_extrachar10                
,cobi_extrachar11                
,isnull(sum(cobi_numeric1) ,'0')  'cobi_numeric1'             
,isnull(sum(cobi_numeric2) ,'0')  'cobi_numeric2'             
,isnull(sum(cobi_numeric3) ,'0')  'cobi_numeric3'             
,isnull(sum(cobi_numeric4) ,'0')  'cobi_numeric4'             
,isnull(sum(cobi_numeric5) ,'0')  'cobi_numeric5'             
,isnull(sum(cobi_numeric6) ,'0')  'cobi_numeric6'             
,cgst_char1                
,sgst_char2                
,igstchar3                
,cess_char3                
,round_off                
,total                
,amount_in_words                
,text1                
,text2                
,text3                
,text4                
,text5                
,text6                
,text7     
,Agg_msa,Cement,Target_Slump,Max_Ratio,Admix,Spe_Reg,Ex_Char1,Ex_Char2,Ex_Char3,Ex_Char4    
,EX_char5 --Vasanthi
from  #Zrit_prism_rmc_Cobi_tmp              
group by
wfdockey             
,report_type1              
,invoice_no                
,packslipdate                
,totaltimeml        
,org_unit                
,currency_code                
,modetransport                
,destinationlocation                
,billtocustomercode                
,billtocustomername                
,billtoaddress1     
,billtoaddress2                
,billtoaddress3        
,billstate                
,billtocountry              
,billtoph                
,shipcustcodeml                
,shiptocustomernameml                
,shipaddress1                
,shipaddress2                
,shipaddress3                
,shiptostate                
,shiptoctry                
,shiptoph                
--,linenumber                
,itemcode                
,tcdtype                
,itemdesc_ml                
,itemvariantml                
,itemvariantdesc  
,item_type  
,uom                 
,itemlevelcharge                
,itemleveldiscount                
,item_tax                
,paytermdes                
,shipremarks     
,insuranceterm1                
,companycode   
,companyname        
,companyaddress1              
,companyaddress2                
,companyaddress3           
,state                
,origincountry                
,phoneno1                
,narration                
,extrachar1   
,extrachar2       
,extrachar3                
,extrachar4                
,extrachar5      
,extrachar6                
,extrachar7   
,extrachar8                
,extrachar9                
,extrachar10                    
,date1      
,date2                
,date3                
,date4       
,date5       
,Print_date      
,Print_time
,invoicestatus_ml                
,sequenceno                
,guid                
,wfdockey2                 
,Extraint1                
,Extraint2                
,Extraint3              
,Extraint4                
,Extraint5                          
,extrachar11              
,extrachar12                
,EXTRACHAR13                
,EXTRACHAR14                
,EXTRACHAR15                
,EXTRACHAR16                
,EXTRACHAR17                
,EXTRACHAR18                
,EXTRACHAR19                
,EXTRACHAR20                
,EXTRACHAR21                
,EXTRACHAR22                
,EXTRACHAR23         
,EXTRACHAR24                
,EXTRACHAR25                
,EXTRACHAR26                
,EXTRACHAR27                
,EXTRACHAR28                
,EXTRACHAR29                
,EXTRACHAR30                
,EXTRACHAR31                
,EXTRACHAR32                
,EXTRACHAR33                
,EXTRACHAR34                
,EXTRACHAR35                
,EXTRACHAR36                
,EXTRACHAR37                
,EXTRACHAR38                
,EXTRACHAR39                
,EXTRACHAR40                
,EXTRACHAR41                
,EXTRACHAR42                
,EXTRACHAR43                
,EXTRACHAR30_1                           
,CIN                
,state_code              
,del_state_code                
,buy_ord_no     
,batch_serial_no                
,sales_eng                
 ,vehicle_no                
,transport_mode                
,cobi_extrachar1             
,cobi_extrachar2            
,cobi_extrachar3                
,cobi_extrachar4                
,cobi_extrachar5                
,cobi_extrachar6                
,cobi_extrachar7                
,cobi_extrachar8                
,cobi_extrachar9                
,cobi_extrachar10                
,cobi_extrachar11                
,cgst_char1                
,sgst_char2                
,igstchar3                
,cess_char3                
,round_off                
,total                
,amount_in_words                
,text1                
,text2                
,text3                
,text4                
,text5                
,text6                
,text7     
,Agg_msa,Cement,Target_Slump,Max_Ratio,Admix,Spe_Reg,Ex_Char1,Ex_Char2,Ex_Char3,Ex_Char4    
,EX_char5 ,extraamount2,extraamount4,extraamount9,extraamount10,Total_inv_amount,unitprice
Union all
select        
 wfdockey             
,report_type1              
,invoice_no                
,packslipdate                
,totaltimeml        
,org_unit                
,currency_code                
,modetransport                
,destinationlocation                
,billtocustomercode                
,billtocustomername                
,billtoaddress1     
,billtoaddress2                
,billtoaddress3        
,billstate                
,billtocountry              
,billtoph                
,shipcustcodeml                
,shiptocustomernameml                
,shipaddress1                
,shipaddress2                
,shipaddress3                
,shiptostate                
,shiptoctry                
,shiptoph                
--,linenumber                
,itemcode                
,tcdtype                
,itemdesc_ml                
,itemvariantml                
--,itemcode +'-'+ itemvariantdesc 'itemvariantdesc'     
,itemvariantdesc  
,item_type  
,unitprice            
/*code commented and added by Vasanthi K against id:PJRMC-1204 begins*/  
,uom  
--ISNULL(new_uom,uom) 'UOM'   -- code added by K Vishnupriya  
/*code commented and added by Vasanthi K against id:PJRMC-1204 ends*/  
,isnull(sum(invoicequantity  ),'0')  'invoicequantity'            
,isnull(sum(invoicedamount   ),'0')   'invoicedamount'          
,isnull(sum(invoicenetamount ),'0')    'invoicenetamount'           
,itemlevelcharge                
,itemleveldiscount                
,item_tax                
,paytermdes                
,shipremarks     
,insuranceterm1                
,companycode              
,companyname        
,companyaddress1              
,companyaddress2                
,companyaddress3           
,state                
,origincountry                
,phoneno1                
,narration                
,extrachar1   
,extrachar2       
,extrachar3                
,extrachar4                
,extrachar5      
,extrachar6                
,extrachar7   
,extrachar8                
,extrachar9                
,extrachar10              
,isnull(sum(extraamount1) ,'0') 'extraamount1'              
,extraamount2               	
,isnull(sum(extraamount3) ,'0') 'extraamount3'              
,extraamount4         			
,isnull(sum(extraamount5) ,'0') 'extraamount5'              
,isnull(sum(extraamount6) ,'0') 'extraamount6'              
,isnull(sum(extraamount7) ,'0') 'extraamount7'              
,isnull(sum(extraamount8) ,'0') 'extraamount8'              
,extraamount9             
,extraamount10          
,date1      
,date2                
,date3                
,date4       
,date5       
,Total_inv_amount            
,Print_date      
,Print_time/*Convert Added by Vasanthi K on 18.12.2024*/  
,invoicestatus_ml                
,sequenceno                
,guid                
,wfdockey2                
,isnull(sum(extraamount11),'0')   'extraamount11'            
,isnull(sum(extraamount12),'0')   'extraamount12'             
,isnull(sum(extraamount13),'0')   'extraamount13'             
,isnull(sum(extraamount14),'0')   'extraamount14'             
,isnull(sum(extraamount15),'0')   'extraamount15' 
,isnull(sum(extraamount16),'0')   'extraamount16'             
,isnull(sum(extraamount17),'0')   'extraamount17'             
,isnull(sum(extraamount18),'0')   'extraamount18'             
,isnull(sum(extraamount19),'0')   'extraamount19'    
,isnull(sum(extraamount20),'0')   'extraamount20'     
,Extraint1                
,Extraint2                
,Extraint3              
,Extraint4                
,Extraint5                
,isnull(sum(extranumeric1),'0') 'extranumeric1'              
,isnull(sum(extranumeric2),'0') 'extranumeric2'               
,isnull(sum(extranumeric3),'0') 'extranumeric3'               
,isnull(sum(extranumeric4),'0') 'extranumeric4'               
,isnull(sum(extranumeric5),'0') 'extranumeric5'             
,extrachar11              
,extrachar12                
,EXTRACHAR13                
,EXTRACHAR14                
,EXTRACHAR15                
,EXTRACHAR16                
,EXTRACHAR17                
,EXTRACHAR18                
,EXTRACHAR19                
,EXTRACHAR20                
,EXTRACHAR21                
,EXTRACHAR22                
,EXTRACHAR23         
,EXTRACHAR24                
,EXTRACHAR25                
,EXTRACHAR26                
,EXTRACHAR27                
,EXTRACHAR28                
,EXTRACHAR29                
,EXTRACHAR30                
,EXTRACHAR31                
,EXTRACHAR32                
,EXTRACHAR33                
,EXTRACHAR34                
,EXTRACHAR35                
,EXTRACHAR36                
,EXTRACHAR37                
,EXTRACHAR38                
,EXTRACHAR39                
,EXTRACHAR40                
,EXTRACHAR41                
,EXTRACHAR42                
,EXTRACHAR43                
,EXTRACHAR30_1            
,isnull(sum(extraamount21),'0')    'extraamount21'      
,isnull(sum(extraamount22),'0')    'extraamount22'            
,isnull(sum(Extraamount23),'0')    'extraamount23'            
,isnull(sum(extraamount24),'0')    'extraamount24'            
,CIN                
,state_code              
,'ACKNOWLEDGEMENT COPY' AS'report_type'                
,del_state_code                
,buy_ord_no     
,batch_serial_no                
,sales_eng                
 ,vehicle_no                
,transport_mode                
,cobi_extrachar1             
,cobi_extrachar2            
,cobi_extrachar3                
,cobi_extrachar4                
,cobi_extrachar5                
,cobi_extrachar6                
,cobi_extrachar7                
,cobi_extrachar8                
,cobi_extrachar9                
,cobi_extrachar10                
,cobi_extrachar11                
,isnull(sum(cobi_numeric1) ,'0') 'cobi_numeric1'              
,isnull(sum(cobi_numeric2) ,'0') 'cobi_numeric2'              
,isnull(sum(cobi_numeric3) ,'0') 'cobi_numeric3'              
,isnull(sum(cobi_numeric4) ,'0') 'cobi_numeric4'              
,isnull(sum(cobi_numeric5) ,'0') 'cobi_numeric5'              
,isnull(sum(cobi_numeric6) ,'0') 'cobi_numeric6'              
,cgst_char1                
,sgst_char2                
,igstchar3                
,cess_char3                
,round_off                
,total                
,amount_in_words                
,text1                
,text2                
,text3                
,text4                
,text5                
,text6                
,text7     
,Agg_msa,Cement,Target_Slump,Max_Ratio,Admix,Spe_Reg,Ex_Char1,Ex_Char2,Ex_Char3,Ex_Char4    
,EX_char5 --Vasanthi
from  #Zrit_prism_rmc_Cobi_tmp              
group by
wfdockey             
,report_type1              
,invoice_no                
,packslipdate                
,totaltimeml        
,org_unit                
,currency_code                
,modetransport                
,destinationlocation                
,billtocustomercode                
,billtocustomername                
,billtoaddress1     
,billtoaddress2                
,billtoaddress3        
,billstate                
,billtocountry              
,billtoph                
,shipcustcodeml                
,shiptocustomernameml                
,shipaddress1                
,shipaddress2                
,shipaddress3                
,shiptostate                
,shiptoctry                
,shiptoph                
--,linenumber                
,itemcode                
,tcdtype                
,itemdesc_ml                
,itemvariantml                
,itemvariantdesc  
,item_type  
,uom                 
,itemlevelcharge                
,itemleveldiscount                
,item_tax                
,paytermdes                
,shipremarks     
,insuranceterm1                
,companycode              
,companyname        
,companyaddress1              
,companyaddress2                
,companyaddress3           
,state                
,origincountry                
,phoneno1                
,narration                
,extrachar1   
,extrachar2       
,extrachar3                
,extrachar4                
,extrachar5      
,extrachar6                
,extrachar7   
,extrachar8                
,extrachar9                
,extrachar10                    
,date1      
,date2                
,date3                
,date4       
,date5       
,Print_date      
,Print_time
,invoicestatus_ml                
,sequenceno                
,guid                
,wfdockey2                 
,Extraint1                
,Extraint2                
,Extraint3              
,Extraint4                
,Extraint5                          
,extrachar11              
,extrachar12                
,EXTRACHAR13        
,EXTRACHAR14           
,EXTRACHAR15                
,EXTRACHAR16                
,EXTRACHAR17                
,EXTRACHAR18                
,EXTRACHAR19                
,EXTRACHAR20                
,EXTRACHAR21                
,EXTRACHAR22                
,EXTRACHAR23         
,EXTRACHAR24                
,EXTRACHAR25                
,EXTRACHAR26                
,EXTRACHAR27                
,EXTRACHAR28                
,EXTRACHAR29                
,EXTRACHAR30                
,EXTRACHAR31                
,EXTRACHAR32                
,EXTRACHAR33                
,EXTRACHAR34                
,EXTRACHAR35                
,EXTRACHAR36                
,EXTRACHAR37                
,EXTRACHAR38                
,EXTRACHAR39                
,EXTRACHAR40                
,EXTRACHAR41                
,EXTRACHAR42                
,EXTRACHAR43                
,EXTRACHAR30_1                           
,CIN                
,state_code              
,del_state_code                
,buy_ord_no     
,batch_serial_no                
,sales_eng                
 ,vehicle_no                
,transport_mode                
,cobi_extrachar1             
,cobi_extrachar2            
,cobi_extrachar3                
,cobi_extrachar4                
,cobi_extrachar5                
,cobi_extrachar6                
,cobi_extrachar7                
,cobi_extrachar8                
,cobi_extrachar9                
,cobi_extrachar10                
,cobi_extrachar11                
,cgst_char1                
,sgst_char2                
,igstchar3                
,cess_char3                
,round_off                
,total                
,amount_in_words                
,text1                
,text2                
,text3                
,text4                
,text5                
,text6                
,text7     
,Agg_msa,Cement,Target_Slump,Max_Ratio,Admix,Spe_Reg,Ex_Char1,Ex_Char2,Ex_Char3,Ex_Char4    
,EX_char5 ,extraamount2,extraamount4,extraamount9,extraamount10,Total_inv_amount,unitprice
UNION ALL
select        
 wfdockey             
,report_type1              
,invoice_no                
,packslipdate                
,totaltimeml        
,org_unit                
,currency_code                
,modetransport                
,destinationlocation                
,billtocustomercode                
,billtocustomername                
,billtoaddress1     
,billtoaddress2                
,billtoaddress3        
,billstate                
,billtocountry              
,billtoph                
,shipcustcodeml                
,shiptocustomernameml                
,shipaddress1                
,shipaddress2                
,shipaddress3                
,shiptostate                
,shiptoctry                
,shiptoph                
--,linenumber                
,itemcode                
,tcdtype                
,itemdesc_ml                
,itemvariantml                
--,itemcode +'-'+ itemvariantdesc     'itemvariantdesc'     
,itemvariantdesc  
,item_type  
,unitprice             
/*code commented and added by Vasanthi K against id:PJRMC-1204 begins*/  
,uom  
--ISNULL(new_uom,uom) 'UOM'   -- code added by K Vishnupriya  
/*code commented and added by Vasanthi K against id:PJRMC-1204 ends*/  
,isnull(sum(invoicequantity  ),'0') 'invoicequantity'             
,isnull(sum(invoicedamount   ),'0')'invoicedamount'             
,isnull(sum(invoicenetamount ),'0')  'invoicenetamount'             
,itemlevelcharge                
,itemleveldiscount                
,item_tax                
,paytermdes                
,shipremarks     
,insuranceterm1                
,companycode              
,companyname        
,companyaddress1              
,companyaddress2                
,companyaddress3           
,state                
,origincountry                
,phoneno1                
,narration        
,extrachar1   
,extrachar2       
,extrachar3                
,extrachar4                
,extrachar5      
,extrachar6                
,extrachar7   
,extrachar8                
,extrachar9                
,extrachar10              
,isnull(sum(extraamount1) ,'0')    'extraamount1'           
,extraamount2               	   
,isnull(sum(extraamount3) ,'0')    'extraamount3'           
,extraamount4         			   
,isnull(sum(extraamount5) ,'0')    'extraamount5'           
,isnull(sum(extraamount6) ,'0')    'extraamount6'           
,isnull(sum(extraamount7) ,'0')    'extraamount7'           
,isnull(sum(extraamount8) ,'0')    'extraamount8'           
,extraamount9             
,extraamount10          
,date1      
,date2                
,date3                
,date4       
,date5       
,Total_inv_amount            
,Print_date      
,Print_time/*Convert Added by Vasanthi K on 18.12.2024*/  
,invoicestatus_ml                
,sequenceno                
,guid                
,wfdockey2                
,isnull(sum(extraamount11),'0')  'extraamount11'             
,isnull(sum(extraamount12),'0')  'extraamount12'              
,isnull(sum(extraamount13),'0')  'extraamount13'              
,isnull(sum(extraamount14),'0')  'extraamount14'              
,isnull(sum(extraamount15),'0')  'extraamount15'  
,isnull(sum(extraamount16),'0')  'extraamount16'              
,isnull(sum(extraamount17),'0')  'extraamount17'              
,isnull(sum(extraamount18),'0')  'extraamount18'              
,isnull(sum(extraamount19),'0')  'extraamount19'     
,isnull(sum(extraamount20),'0')  'extraamount20'      
,Extraint1                
,Extraint2                
,Extraint3              
,Extraint4                
,Extraint5                
,isnull(sum(extranumeric1),'0')  'extranumeric1'             
,isnull(sum(extranumeric2),'0')  'extranumeric2'              
,isnull(sum(extranumeric3),'0')  'extranumeric3'              
,isnull(sum(extranumeric4),'0')  'extranumeric4'              
,isnull(sum(extranumeric5),'0')  'extranumeric5'            
,extrachar11              
,extrachar12                
,EXTRACHAR13                
,EXTRACHAR14                
,EXTRACHAR15                
,EXTRACHAR16                
,EXTRACHAR17                
,EXTRACHAR18                
,EXTRACHAR19                
,EXTRACHAR20                
,EXTRACHAR21                
,EXTRACHAR22                
,EXTRACHAR23         
,EXTRACHAR24                
,EXTRACHAR25                
,EXTRACHAR26                
,EXTRACHAR27                
,EXTRACHAR28                
,EXTRACHAR29                
,EXTRACHAR30                
,EXTRACHAR31                
,EXTRACHAR32                
,EXTRACHAR33                
,EXTRACHAR34                
,EXTRACHAR35                
,EXTRACHAR36                
,EXTRACHAR37                
,EXTRACHAR38                
,EXTRACHAR39                
,EXTRACHAR40                
,EXTRACHAR41                
,EXTRACHAR42                
,EXTRACHAR43                
,EXTRACHAR30_1            
,isnull(sum(extraamount21),'0')  'extraamount21'        
,isnull(sum(extraamount22),'0')  'extraamount22'              
,isnull(sum(Extraamount23),'0')  'extraamount23'              
,isnull(sum(extraamount24),'0')  'extraamount24'              
,CIN                
,state_code              
,'ADDITIONAL COPY' AS'report_type'                
,del_state_code                
,buy_ord_no     
,batch_serial_no                
,sales_eng                
 ,vehicle_no                
,transport_mode                
,cobi_extrachar1             
,cobi_extrachar2            
,cobi_extrachar3                
,cobi_extrachar4                
,cobi_extrachar5                
,cobi_extrachar6                
,cobi_extrachar7                
,cobi_extrachar8                
,cobi_extrachar9                
,cobi_extrachar10                
,cobi_extrachar11                
,isnull(sum(cobi_numeric1) ,'0')               
,isnull(sum(cobi_numeric2) ,'0')               
,isnull(sum(cobi_numeric3) ,'0')               
,isnull(sum(cobi_numeric4) ,'0')               
,isnull(sum(cobi_numeric5) ,'0')               
,isnull(sum(cobi_numeric6) ,'0')               
,cgst_char1                
,sgst_char2                
,igstchar3                
,cess_char3                
,round_off                
,total                
,amount_in_words                
,text1                
,text2                
,text3                
,text4                
,text5                
,text6                
,text7     
,Agg_msa,Cement,Target_Slump,Max_Ratio,Admix,Spe_Reg,Ex_Char1,Ex_Char2,Ex_Char3,Ex_Char4    
,EX_char5 --Vasanthi
from  #Zrit_prism_rmc_Cobi_tmp              
group by
wfdockey             
,report_type1              
,invoice_no                
,packslipdate                
,totaltimeml        
,org_unit                
,currency_code                
,modetransport                
,destinationlocation                
,billtocustomercode                
,billtocustomername                
,billtoaddress1     
,billtoaddress2                
,billtoaddress3        
,billstate                
,billtocountry              
,billtoph                
,shipcustcodeml                
,shiptocustomernameml                
,shipaddress1                
,shipaddress2                
,shipaddress3                
,shiptostate                
,shiptoctry                
,shiptoph                
--,linenumber                
,itemcode                
,tcdtype                
,itemdesc_ml                
,itemvariantml                
,itemvariantdesc  
,item_type  
,uom                 
,itemlevelcharge                
,itemleveldiscount                
,item_tax                
,paytermdes                
,shipremarks     
,insuranceterm1                
,companycode              
,companyname        
,companyaddress1              
,companyaddress2                
,companyaddress3           
,state                
,origincountry                
,phoneno1                
,narration                
,extrachar1   
,extrachar2       
,extrachar3                
,extrachar4                
,extrachar5      
,extrachar6                
,extrachar7   
,extrachar8                
,extrachar9                
,extrachar10                    
,date1      
,date2                
,date3                
,date4       
,date5       
,Print_date      
,Print_time
,invoicestatus_ml                
,sequenceno                
,guid                
,wfdockey2                 
,Extraint1                
,Extraint2                
,Extraint3              
,Extraint4                
,Extraint5                          
,extrachar11              
,extrachar12                
,EXTRACHAR13                
,EXTRACHAR14                
,EXTRACHAR15                
,EXTRACHAR16                
,EXTRACHAR17                
,EXTRACHAR18                
,EXTRACHAR19                
,EXTRACHAR20                
,EXTRACHAR21                
,EXTRACHAR22                
,EXTRACHAR23         
,EXTRACHAR24                
,EXTRACHAR25                
,EXTRACHAR26                
,EXTRACHAR27                
,EXTRACHAR28                
,EXTRACHAR29                
,EXTRACHAR30                
,EXTRACHAR31                
,EXTRACHAR32                
,EXTRACHAR33                
,EXTRACHAR34                
,EXTRACHAR35                
,EXTRACHAR36                
,EXTRACHAR37                
,EXTRACHAR38                
,EXTRACHAR39                
,EXTRACHAR40                
,EXTRACHAR41                
,EXTRACHAR42                
,EXTRACHAR43                
,EXTRACHAR30_1                           
,CIN                
,state_code              
,del_state_code                
,buy_ord_no     
,batch_serial_no                
,sales_eng            
 ,vehicle_no                
,transport_mode                
,cobi_extrachar1             
,cobi_extrachar2            
,cobi_extrachar3                
,cobi_extrachar4                
,cobi_extrachar5                
,cobi_extrachar6                
,cobi_extrachar7                
,cobi_extrachar8                
,cobi_extrachar9                
,cobi_extrachar10                
,cobi_extrachar11                
,cgst_char1                
,sgst_char2                
,igstchar3                
,cess_char3                
,round_off                
,total                
,amount_in_words                
,text1                
,text2                
,text3                
,text4                
,text5                
,text6                
,text7     
,Agg_msa,Cement,Target_Slump,Max_Ratio,Admix,Spe_Reg,Ex_Char1,Ex_Char2,Ex_Char3,Ex_Char4    
,EX_char5 ,extraamount2,extraamount4,extraamount9,extraamount10,Total_inv_amount,unitprice

alter table #temp_final add linenumber int

Update #Temp_Final
Set  linenumber = T.sno    
from (select itemvariantdesc,EXTRACHAR19,report_type,DENSE_RANK()  over (  order by itemvariantdesc,EXTRACHAR19 ) 'sno'    
From #Temp_Final     
) as T    
JOIN #Temp_Final tmp    
ON tmp.itemvariantdesc =T.itemvariantdesc  
and tmp.EXTRACHAR19 = T.EXTRACHAR19
and tmp.report_type =T.report_type    
    

SELECT * FROM  #temp_final
--Code Commented and Added by Vasanthi K for RPRMCB-1 ends 
/*
union all                              
 select                 
 wfdockey                
,report_type1             
,invoice_no                
,packslipdate                
,totaltimeml                
,org_unit              
,currency_code                
,modetransport                
,destinationlocation                
,billtocustomercode                
,billtocustomername                
,billtoaddress1                
,billtoaddress2                
,billtoaddress3                
,billstate         
,billtocountry                
,billtoph                
,shipcustcodeml                
,shiptocustomernameml     
,shipaddress1     
,shipaddress2                
,shipaddress3                
,shiptostate                
,shiptoctry                
,shiptoph                
,linenumber                
,itemcode                
,tcdtype                
,itemdesc_ml                
,itemvariantml                
--,itemcode +'-'+ itemvariantdesc     'itemvariantdesc'     
,itemvariantdesc,item_type                
,unitprice                
/*code commented and added by Vasanthi K against id:PJRMC-1204 begins*/  
,uom  
--ISNULL(new_uom,uom)      'UOM'    --code added by K Vishnupriya     
/*code commented and added by Vasanthi K against id:PJRMC-1204 ends*/  
,invoicequantity                
,invoicedamount           
,invoicenetamount          
,itemlevelcharge            
,itemleveldiscount                
,item_tax                
,paytermdes                
,shipremarks                
,insuranceterm1            
,companycode                
,companyname           
,companyaddress1                
,companyaddress2                
,companyaddress3                
,state                
,origincountry      
,phoneno1                
,narration                
,extrachar1                
,extrachar2     
,extrachar3     
,extrachar4            
,extrachar5                
,extrachar6                
,extrachar7               
,extrachar8                
,extrachar9                
,extrachar10        
,extraamount1                
,extraamount2                
,extraamount3             
,extraamount4                
,extraamount5                
,extraamount6                
,extraamount7                
,extraamount8                
,extraamount9                
,extraamount10        
,date1                
,date2               
,date3                
,date4  
,date5          
,Total_inv_amount                
,Print_date                
,Print_time  /*Convert Added by Vasanthi K on 18.12.2024*/                    
,invoicestatus_ml                
,sequenceno                
,guid                
,wfdockey2                
,extraamount11                
,extraamount12                
,extraamount13                
,extraamount14                
,extraamount15                
,extraamount16                
,extraamount17                
,extraamount18                
,extraamount19                
,extraamount20                
,Extraint1                
,Extraint2                
,Extraint3                
,Extraint4                
,Extraint5                
,extranumeric1                
,extranumeric2                
,extranumeric3                
,extranumeric4                
,extranumeric5                
,extrachar11                
,extrachar12                
,EXTRACHAR13                
,EXTRACHAR14                
,EXTRACHAR15                
,EXTRACHAR16                
,EXTRACHAR17                
,EXTRACHAR18                
,EXTRACHAR19         
,EXTRACHAR20             
,EXTRACHAR21                
,EXTRACHAR22                
,EXTRACHAR23                
,EXTRACHAR24                
,EXTRACHAR25                
,EXTRACHAR26                
,EXTRACHAR27              
,EXTRACHAR28             
,EXTRACHAR29                
,EXTRACHAR30                
,EXTRACHAR31                
,EXTRACHAR32                
,EXTRACHAR33                
,EXTRACHAR34                
,EXTRACHAR35                
,EXTRACHAR36               
,EXTRACHAR37                
,EXTRACHAR38                
,EXTRACHAR39                
,EXTRACHAR40                
,EXTRACHAR41                
,EXTRACHAR42          
,EXTRACHAR43     
,EXTRACHAR30_1                
,extraamount21                
,extraamount22                
,Extraamount23                
,extraamount24                
,CIN            
,state_code          
,'DUPLICATE FOR TRANSPORTER' AS'report_type'                
,del_state_code                
,buy_ord_no                
,batch_serial_no      
,sales_eng      
 ,vehicle_no                
,transport_mode      
,cobi_extrachar1                
,cobi_extrachar2                
,cobi_extrachar3            
,cobi_extrachar4                
,cobi_extrachar5                
,cobi_extrachar6                
,cobi_extrachar7                
,cobi_extrachar8                
,cobi_extrachar9                
,cobi_extrachar10                
,cobi_extrachar11                
,cobi_numeric1                
,cobi_numeric2                
,cobi_numeric3                
,cobi_numeric4                
,cobi_numeric5                
,cobi_numeric6                
,cgst_char1                
,sgst_char2                
,igstchar3                
,cess_char3                
,round_off                
,total                
,amount_in_words                
,text1                
,text2                
,text3                
,text4                
,text5                
,text6     
,text7           
,Agg_msa,Cement,Target_Slump,Max_Ratio,Admix,Spe_Reg,Ex_Char1,Ex_Char2,Ex_Char3,Ex_Char4    
,EX_char5 --Vasanthi  
from  #Zrit_prism_rmc_Cobi_tmp                
/*code commented and added by Vasanthi K against id:PJRMC-1204 begins*/  
--/* code added by K Vishnupriya starts here */    
--LEFT JOIN zrit_uom_execption_tbl    
--ON ramco_uom = UOM    
--/* code added by K Vishnupriya ends here */    
/*code commented and added by Vasanthi K against id:PJRMC-1204 ends*/  
union all                
     
select                 
 wfdockey                
,report_type1                
,invoice_no                
,packslipdate                
,totaltimeml       
,org_unit      
,currency_code                
,modetransport                
,destinationlocation                
,billtocustomercode           
,billtocustomername                
,billtoaddress1                
,billtoaddress2                
,billtoaddress3                
,billstate                
,billtocountry                
,billtoph                
,shipcustcodeml      
,shiptocustomernameml            
,shipaddress1                
,shipaddress2                
,shipaddress3                
,shiptostate                
,shiptoctry                
,shiptoph                
,linenumber         
,itemcode                
,tcdtype         
,itemdesc_ml                
,itemvariantml                
--,itemcode +'-'+ itemvariantdesc     'itemvariantdesc'     
,itemvariantdesc,item_type                
,unitprice                
/*code commented and added by Vasanthi K against id:PJRMC-1204 begins*/  
,uom  
--ISNULL(new_uom,uom) 'UOM'   --code added by K Vishnupriya        
/*code commented and added by Vasanthi K against id:PJRMC-1204 ends*/  
,invoicequantity                
,invoicedamount                
,invoicenetamount                
,itemlevelcharge                
,itemleveldiscount                
,item_tax                
,paytermdes                
,shipremarks                
,insuranceterm1                
,companycode                
,companyname                
,companyaddress1        
,companyaddress2                
,companyaddress3                
,state                
,origincountry                
,phoneno1                
,narration                
,extrachar1                
,extrachar2                
,extrachar3                
,extrachar4                
,extrachar5                
,extrachar6                
,extrachar7          
,extrachar8                
,extrachar9         
,extrachar10                
,extraamount1                
,extraamount2                
,extraamount3                
,extraamount4       
,extraamount5                
,extraamount6                
,extraamount7                
,extraamount8                
,extraamount9                
,extraamount10                
,date1                
,date2                
,date3                
,date4                
,date5                
,Total_inv_amount      
,Print_date            
,Print_time  /*Convert Added by Vasanthi K on 18.12.2024*/                 
,invoicestatus_ml                
,sequenceno       
,guid                
,wfdockey2         
,extraamount11          
,extraamount12                
,extraamount13                
,extraamount14                
,extraamount15                
,extraamount16                
,extraamount17                
,extraamount18                
,extraamount19                
,extraamount20    
,Extraint1                
,Extraint2                
,Extraint3                
,Extraint4              ,Extraint5                
,extranumeric1                
,extranumeric2                
,extranumeric3        
,extranumeric4                
,extranumeric5                
,extrachar11                
,extrachar12                
,EXTRACHAR13                
,EXTRACHAR14                
,EXTRACHAR15                
,EXTRACHAR16                
,EXTRACHAR17                
,EXTRACHAR18                
,EXTRACHAR19               
,EXTRACHAR20                
,EXTRACHAR21                
,EXTRACHAR22                
,EXTRACHAR23                
,EXTRACHAR24                
,EXTRACHAR25                
,EXTRACHAR26                
,EXTRACHAR27                
,EXTRACHAR28                
,EXTRACHAR29                
,EXTRACHAR30                
,EXTRACHAR31                
,EXTRACHAR32                
,EXTRACHAR33    
,EXTRACHAR34          
,EXTRACHAR35                
,EXTRACHAR36                
,EXTRACHAR37              
,EXTRACHAR38                
,EXTRACHAR39                
,EXTRACHAR40                
,EXTRACHAR41                
,EXTRACHAR42                
,EXTRACHAR43      
,EXTRACHAR30_1                
,extraamount21                
,extraamount22             
,Extraamount23                
,extraamount24                
,CIN                
,state_code                
,'TRIPLICATE OF SUPPLIER' AS'report_type'               
,del_state_code                
,buy_ord_no                
,batch_serial_no                
,sales_eng             
 ,vehicle_no        
,transport_mode                
,cobi_extrachar1                
,cobi_extrachar2            
,cobi_extrachar3      
,cobi_extrachar4            
,cobi_extrachar5                
,cobi_extrachar6                
,cobi_extrachar7                
,cobi_extrachar8      
,cobi_extrachar9                
,cobi_extrachar10                
,cobi_extrachar11                
,cobi_numeric1                
,cobi_numeric2                
,cobi_numeric3                
,cobi_numeric4                
,cobi_numeric5                
,cobi_numeric6                
,cgst_char1                
,sgst_char2                
,igstchar3      
,cess_char3                
,round_off                
,total                
,amount_in_words                
,text1               
,text2                
,text3         
,text4                
,text5                
,text6                
,text7        
,Agg_msa,Cement,Target_Slump,Max_Ratio,Admix,Spe_Reg,Ex_Char1,Ex_Char2,Ex_Char3,Ex_Char4    
,EX_char5 --Vasanthi  
from  #Zrit_prism_rmc_Cobi_tmp                
/*code commented and added by Vasanthi K against id:PJRMC-1204 begins*/  
--/* code added by K Vishnupriya starts here */    
--LEFT JOIN zrit_uom_execption_tbl    
--ON ramco_uom = UOM    
--/* code added by K Vishnupriya ends here */  
/*code commented and added by Vasanthi K against id:PJRMC-1204 ends*/  
union all                
     
 select                 
 wfdockey                
,report_type1                
,invoice_no        
,packslipdate                
,totaltimeml                
,org_unit                
,currency_code                
,modetransport                
,destinationlocation                
,billtocustomercode                
,billtocustomername                
,billtoaddress1                
,billtoaddress2                
,billtoaddress3                
,billstate         
,billtocountry                
,billtoph              
,shipcustcodeml                
,shiptocustomernameml   
,shipaddress1                
,shipaddress2                
,shipaddress3                
,shiptostate                
,shiptoctry                
,shiptoph     
,linenumber                
,itemcode           
,tcdtype                
,itemdesc_ml          
,itemvariantml                
--,itemcode +'-'+ itemvariantdesc     'itemvariantdesc'     
,itemvariantdesc,item_type                
,unitprice                
/*code commented and added by Vasanthi K against id:PJRMC-1204 begins*/  
,uom  
--ISNULL(new_uom,uom)  'UOM'       -- code added by K Vishnupriya     
/*code commented and added by Vasanthi K against id:PJRMC-1204 ends*/  
,invoicequantity                
,invoicedamount                
,invoicenetamount   
,itemlevelcharge                
,itemleveldiscount    
,item_tax                
,paytermdes                
,shipremarks                
,insuranceterm1                
,companycode                
,companyname                
,companyaddress1                
,companyaddress2                
,companyaddress3      
,state     
,origincountry                
,phoneno1                
,narration                
,extrachar1                
,extrachar2          
,extrachar3                
,extrachar4                
,extrachar5                
,extrachar6                
,extrachar7                
,extrachar8                
,extrachar9                
,extrachar10                
,extraamount1                
,extraamount2                
,extraamount3      
,extraamount4                
,extraamount5                
,extraamount6                
,extraamount7              
,extraamount8                
,extraamount9                
,extraamount10                
,date1                
,date2    
,date3                
,date4                
,date5                
,Total_inv_amount                
,Print_date                
,Print_time  /*Convert Added by Vasanthi K on 18.12.2024*/                            
,invoicestatus_ml    
,sequenceno            
,guid                
,wfdockey2                
,extraamount11        
,extraamount12                
,extraamount13                
,extraamount14                
,extraamount15                
,extraamount16                
,extraamount17                
,extraamount18                
,extraamount19                
,extraamount20            
,Extraint1                
,Extraint2                
,Extraint3                
,Extraint4                
,Extraint5                
,extranumeric1                
,extranumeric2                
,extranumeric3            
,extranumeric4                
,extranumeric5                
,extrachar11                
,extrachar12                
,EXTRACHAR13                
,EXTRACHAR14                
,EXTRACHAR15                
,EXTRACHAR16                
,EXTRACHAR17                
,EXTRACHAR18                
,EXTRACHAR19                
,EXTRACHAR20                
,EXTRACHAR21                
,EXTRACHAR22                
,EXTRACHAR23                
,EXTRACHAR24                
,EXTRACHAR25       
,EXTRACHAR26          
,EXTRACHAR27        
,EXTRACHAR28                
,EXTRACHAR29           
,EXTRACHAR30                
,EXTRACHAR31                
,EXTRACHAR32      
,EXTRACHAR33                
,EXTRACHAR34                
,EXTRACHAR35               
,EXTRACHAR36                
,EXTRACHAR37                
,EXTRACHAR38                
,EXTRACHAR39                
,EXTRACHAR40                
,EXTRACHAR41                
,EXTRACHAR42                
,EXTRACHAR43               
,EXTRACHAR30_1       
,extraamount21          
,extraamount22                
,Extraamount23                
,extraamount24                
,CIN              
,state_code                
,'ACKNOWLEDGEMENT COPY' AS'report_type'               
,del_state_code     
,buy_ord_no                
,batch_serial_no                
,sales_eng                
 ,vehicle_no                
,transport_mode                
,cobi_extrachar1                
,cobi_extrachar2                
,cobi_extrachar3          
,cobi_extrachar4                
,cobi_extrachar5        
,cobi_extrachar6                
,cobi_extrachar7                
,cobi_extrachar8                
,cobi_extrachar9            
,cobi_extrachar10             
,cobi_extrachar11                
,cobi_numeric1                
,cobi_numeric2                
,cobi_numeric3                
,cobi_numeric4       
,cobi_numeric5                
,cobi_numeric6                
,cgst_char1                
,sgst_char2                
,igstchar3                
,cess_char3                
,round_off                
,total                
,amount_in_words                
,text1          
,text2                
,text3                
,text4                
,text5                
,text6                
,text7     
,Agg_msa,Cement,Target_Slump,Max_Ratio,Admix,Spe_Reg,Ex_Char1,Ex_Char2,Ex_Char3,Ex_Char4    
,EX_char5 --Vasanthi  
from  #Zrit_prism_rmc_Cobi_tmp                
/*code commented and added by Vasanthi K against id:PJRMC-1204 begins*/  
--/* code added by K Vishnupriya starts here */    
--LEFT JOIN zrit_uom_execption_tbl    
--ON ramco_uom = UOM    
--/* code added by K Vishnupriya ends here */  
/*code commented and added by Vasanthi K against id:PJRMC-1204 ends*/  
    
union all                
                
 select        
 wfdockey                
,report_type1                
,invoice_no                
,packslipdate                
,totaltimeml                
,org_unit                
,currency_code                
,modetransport                
,destinationlocation                
,billtocustomercode                
,billtocustomername              
,billtoaddress1                
,billtoaddress2                
,billtoaddress3                
,billstate        
,billtocountry                
,billtoph              
,shipcustcodeml                
,shiptocustomernameml                
,shipaddress1                
,shipaddress2              
,shipaddress3                
,shiptostate         
,shiptoctry                
,shiptoph                
,linenumber                
,itemcode                
,tcdtype      
,itemdesc_ml                
,itemvariantml            
--,itemcode +'-'+ itemvariantdesc     'itemvariantdesc'     
,itemvariantdesc,item_type                
,unitprice                
/*code commented and added by Vasanthi K against id:PJRMC-1204 begins*/  
,uom  
--ISNULL(new_uom,uom)    'UOM'         --code modified by K Vishnupriya     
/*code commented and added by Vasanthi K against id:PJRMC-1204 ends*/  
,invoicequantity                
,invoicedamount                
,invoicenetamount                
,itemlevelcharge                
,itemleveldiscount                
,item_tax                
,paytermdes                
,shipremarks                
,insuranceterm1                
,companycode                
,companyname                
,companyaddress1                
,companyaddress2                
,companyaddress3                
,state                
,origincountry                
,phoneno1                
,narration                
,extrachar1                
,extrachar2                
,extrachar3           
,extrachar4                
,extrachar5                
,extrachar6                
,extrachar7                
,extrachar8                
,extrachar9                
,extrachar10     
,extraamount1                
,extraamount2                
,extraamount3                
,extraamount4                
,extraamount5                
,extraamount6               
,extraamount7                
,extraamount8                
,extraamount9                
,extraamount10                
,date1                
,date2                
,date3                
,date4                
,date5                
,Total_inv_amount                
,Print_date                
,Print_time  /*Convert Added by Vasanthi K on 18.12.2024*/ 
,invoicestatus_ml      
,sequenceno                
,guid                
,wfdockey2         
,extraamount11                
,extraamount12                
,extraamount13                
,extraamount14                
,extraamount15                
,extraamount16               
,extraamount17             
,extraamount18                
,extraamount19          
,extraamount20      
,Extraint1    
,Extraint2              
,Extraint3                
,Extraint4                
,Extraint5                
,extranumeric1      
,extranumeric2               
,extranumeric3                
,extranumeric4                
,extranumeric5                
,extrachar11                
,extrachar12                
,EXTRACHAR13                
,EXTRACHAR14     
,EXTRACHAR15                
,EXTRACHAR16                
,EXTRACHAR17                
,EXTRACHAR18                
,EXTRACHAR19          
,EXTRACHAR20                
,EXTRACHAR21                
,EXTRACHAR22                
,EXTRACHAR23                
,EXTRACHAR24                
,EXTRACHAR25                
,EXTRACHAR26          
,EXTRACHAR27                
,EXTRACHAR28                
,EXTRACHAR29           
,EXTRACHAR30                
,EXTRACHAR31                
,EXTRACHAR32                
,EXTRACHAR33         
,EXTRACHAR34   
,EXTRACHAR35                
,EXTRACHAR36                
,EXTRACHAR37                
,EXTRACHAR38                
,EXTRACHAR39                
,EXTRACHAR40                
,EXTRACHAR41             
,EXTRACHAR42                
,EXTRACHAR43                
,EXTRACHAR30_1                
,extraamount21                
,extraamount22                
,Extraamount23                
,extraamount24                
,CIN                
,state_code    
,'ADDITIONAL COPY' AS'report_type'                
,del_state_code                
,buy_ord_no                
,batch_serial_no                
,sales_eng           
 ,vehicle_no                
,transport_mode                
,cobi_extrachar1                
,cobi_extrachar2                
,cobi_extrachar3                
,cobi_extrachar4           
,cobi_extrachar5                
,cobi_extrachar6                
,cobi_extrachar7             
,cobi_extrachar8                
,cobi_extrachar9                
,cobi_extrachar10         
,cobi_extrachar11               
,cobi_numeric1      
,cobi_numeric2                
,cobi_numeric3                
,cobi_numeric4                
,cobi_numeric5                
,cobi_numeric6                
,cgst_char1                
,sgst_char2                
,igstchar3                
,cess_char3                
,round_off                
,total                
,amount_in_words                
,text1          
,text2                
,text3                
,text4      
,text5                
,text6                
,text7        
,Agg_msa,Cement,Target_Slump,Max_Ratio,Admix,Spe_Reg,Ex_Char1,Ex_Char2,Ex_Char3,Ex_Char4    
,EX_char5 --Vasanthi  
from  #Zrit_prism_rmc_Cobi_tmp   
*/
/*code commented and added by Vasanthi K against id:PJRMC-1204 begins*/  
--/* code added by K Vishnupriya starts here */    
--LEFT JOIN zrit_uom_execption_tbl    
--ON ramco_uom = UOM        
--/* code added by K Vishnupriya ends here */            
/*code added by Esakkiraja on 24DEC23 for schedule report starts here*/   
/*code commented and added by Vasanthi K against id:PJRMC-1204 ends*/  
                
if exists(select 'X' from Zrit_prism_rmc_conc_inv_print_tbl with(nolock)                
   where                 
   _hiddenou         =@_hiddenou                
   and invoicenumber =@invoicenumber                
   and _hidden2 = @_hidden2                
   and gen_flag='N'   
  )                
          begin                
                
update Zrit_prism_rmc_conc_inv_print_tbl                
set gen_flag='Y',                
gen_date=getdate()          
where                 
_hiddenou         =@_hiddenou                
and invoicenumber =@invoicenumber               
and  _hidden2 = @_hidden2           
and  gen_flag='N'                
end                
/*code added by Esakkiraja on 24DEC23 for schedule report ends here*/                
              
-- select * from #Zrit_prism_rmc_Cobi_tmp                
                
 end 


Completion time: 2025-04-17T16:03:21.0861924+05:30
