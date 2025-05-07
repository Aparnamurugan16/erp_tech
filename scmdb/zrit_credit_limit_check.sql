
 
/*        
  
Amirtha P  19.07.2024  RITSL/UAT_Fix        
Suryakala A     18-12-2024     PJRMC-1194  
Gayathri   PJRMC-1548   15-04-2025
  
EXec zrit_credit_limit_check_rpt 'PJL','ALL','ALL','ALL','ALL'        
 --exec zrit_credit_limit_check_rpt @company=N'PJLRMC',@Division=N'CON'  ,''   
 exec zrit_credit_limit_check_rpt  '','',''  
*/        
        
        
CREATE      OR ALTER     procedure zrit_credit_limit_check      
@company      varchar(100)     ,        
@Division     varchar(100)     ,  
 @Cust_code  varchar(100)    --code added by suryakala against PJRMC-1194 on 18-12-2024   
/*,@Zone         varchar(100)    ,        
@Branch       varchar(100)     ,        
@plant        varchar(100)  --, */       
/*        
@from_date    date      ,        
@To_date      date         
*/        
as        
begin        
        
        
Declare @guid varchar(100)        
Declare @customer_code varchar(100)        
Declare @customer_name varchar(500)        
Declare @transaction_date date        
Declare @m_errorid int        
Declare @plantid int        
Declare @bu varchar(100)        
        
select @guid = newid()        
select @transaction_date = getdate()        
              
if @company  = 'ALL'   OR    @company=''  OR @company='%'  
select @company = null     
        
if @Division  = 'ALL'   OR    @Division=''  OR @Division='%'  
select @Division = null        
/*if @Zone = 'ALL'  or @Zone='%'      
select @Zone = null        
if @Branch = 'ALL'  or @Branch ='%'      
select @Branch = null        
if @plant = 'ALL'   or   @plant ='%'   
select @plant = null  */      
         
    if @Cust_code  = 'ALL'    or    @Cust_code='' or  @Cust_code='%'
   select @Cust_code = null    

/*Code added by Gayathri  against PJRMC-1548 starts */ 
create table #temp ( Custcode varchar(200))
insert into #temp(Custcode)




SELECT value 
FROM STRING_SPLIT(@Cust_code, ',')
/*Code added by Gayathri  against PJRMC-1548 Ends */ 




declare @a bigint
select @a = count(*) from #temp

/*Code added BY Aparna M against PJRMC-1594*/

if (@a=0)
begin
insert into #temp(Custcode)
select distinct cou_cust_code
from scmdb..cust_ou_info b (nolock)        
where cou_bu =isnull(@division,cou_bu)
end

/*Code added BY Aparna M against PJRMC-1594*/


Create table #custoutdtl        
(        
addnl_sanctn_limit numeric(28,2)  ,        
availb_cred_limit numeric(28,2)   ,        
cred_norm   numeric(28,2)    ,        
pend_so    numeric(28,2)    ,        
tot_expos_limit numeric(28,2)   ,        
unadj_inv   numeric(28,2)    ,        
unadj_recp    numeric(28,2)    ,        
undrcoll_recp numeric(28,2)       ,        
cust_code  varchar(100)           ,        
buid   varchar(100)        
)        
        
        
        
        
drop table if exists #creditdtl        
        
select         
Row_number() over(order by clo_cust_code)  'row_no',        
Company_Name               'Company Name'        ,                        
Bu_Name                    'Division'    ,        
Bu_id                      'BUID'                ,        
[Zone]                     'Zone'       ,        
Branch                     'Branch'         ,        
OUInstDesc                 'Plant Name'     ,        
a.cou_ou                   'plantid'             ,        
clo_cust_code              'Customer Account'  ,        
clo_cust_name              'Customer Name'   ,        
convert(numeric(28,2),0)  'Credit Limit'   ,        
convert(numeric(28,2),0)  'Receivables'    ,        
convert(numeric(28,2),0)  'Spl Liabilities'   ,        
convert(numeric(28,2),0)  'Open Delivery'   ,        
convert(numeric(28,2),0)  'Open SO'     ,        
convert(numeric(28,2),0)  'Open Invoice'   ,        
convert(numeric(28,2),0)  'Available Credit'   

,cbu_cr_term_code   'termcode',
/*Code added by Aparna M starts*/
	CONVERT(NUMERIC(15,2),NULL)	totalexplmt	,	
	CONVERT(NUMERIC(15,2),NULL)	addlsanclmt,
	CONVERT(NUMERIC(15,2),NULL)Bank_Guarantee_Value,
	CONVERT(NUMERIC(15,2),NULL)Immovable_Property_Value,
	CONVERT(NUMERIC(15,2),NULL)Movable_Property_Value,
	CONVERT(NUMERIC(15,2),NULL)LC_Value,
	CONVERT(NUMERIC(15,2),NULL)Security_Cheque_Value,
	CONVERT(NUMERIC(15,2),NULL)Cust_CR_Limit_Value,
	CONVERT(NUMERIC(15,2),NULL)undercollamt,
	convert(numeric(15,2),null)totsal_amt,
	convert(numeric(15,2),null)totpacksal_amt,
	convert(numeric(15,2),null)totdcamt,
	convert(numeric(15,2),null)uninvoiced_amt,
	convert(numeric(15,2),null)opendebitbal_amt,
	convert(numeric(15,2),null)opencreditbal_amt,
	convert(numeric(15,2),null)ob_debit,
	convert(numeric(15,2),null)ob_credit,
	convert(numeric(15,2),null)totalamount
	,clo_cust_code    cust_code
	,convert(numeric(15,2),null) unadj_recp
	,convert(numeric(15,2),null) unadj_recp_pdc
	,convert(numeric(15,2),null)   unadj_inv
    --ROW_NUMBER() OVER (ORDER BY a.Cust_Code) AS seq
/*Code added by Aparna M ends*/

into #creditdtl        
from scmdb..cust_ou_info a (nolock)        
join scmdb..cust_lo_info b (nolock)        
on a.cou_lo   = b.clo_lo        
and a.cou_cust_code = b. clo_cust_code        
join  scmdb..Zrit_Map_Zone_Branch_Nature_dtl c  (nolock)        
on  a.cou_ou   = c.ou_id        
and a.cou_bu =  c.Bu_id        
join scmdb..fw_admin_OUInstance d (nolock)        
on c.ou_id = D. OUInstId    
join scmdb..cust_bu_info f(nolock)
on cbu_cust_code =b.clo_cust_code
and cbu_bu = c.Bu_id
left join scmdb..cm_cust_bu_exp_limit e (nolock) 
on e.bu_code = c.Bu_id        
and e.cust_code = b. clo_cust_code        
and  convert(date,getdate()) between  isnull(fm_date_total_exp_limit,convert(date,getdate()))  and   isnull(to_date_total_exp_limit,convert(date,getdate()))         
where Company_Code =ISNULL(@company   ,Company_Code)     
and c.Bu_id = isnull(@Division,c.Bu_id )    
 and  clo_cust_code in(select Custcode from #temp )--Code added against PJRMC-1548
and  b. clo_cust_code =isnull(@Cust_code, b. clo_cust_code ) --code added by suryakala against PJRMC-1194 on 18-12-2024 
/*and [Zone] = isnull(@Zone,[Zone])        
and Branch  = isnull(@Branch,Branch)        
and a.cou_ou  = isnull(@plant,a.cou_ou)   */    

/*Code added by Aparna M starts*/
 
declare @Date date
select @Date =getdate()


delete from #creditdtl 
where termcode <>'ADV'
and not EXISTS (
    SELECT 1
    FROM scmdb..cm_cust_bu_exp_limit b WITH (NOLOCK)
    WHERE @Date BETWEEN b.fm_date_total_exp_limit AND ISNULL(b.to_date_total_exp_limit, '01/01/9999')
      AND b.cust_code = #creditdtl.[Customer Account]
      AND b.bu_code = #creditdtl.buid
)


update #creditdtl
set row_no =T.Sno
from (select [Customer Account], DENSE_RANK() over(order by [Customer Account]) 'sno'
from #creditdtl) as T
join #creditdtl tmp
on tmp. [Customer Account] = T. [Customer Account]
 


Declare @i int        
Declare @count int        
        
Select @i = 1        
select @count = count(*) from  #creditdtl        

UPDATE	tmp
	SET		totalexplmt	=	ISNULL(total_exp_limit,0)         
	FROM	#creditdtl tmp	,
			SCMDB..cm_cust_bu_exp_limit  a with (nolock)   
	WHERE	@Date between isnull(fm_date_total_exp_limit,@Date)         
	AND		isnull(to_date_total_exp_limit,@Date)        
	AND		tmp.cust_code   = a.Cust_Code        
	AND		bu_code			= tmp.buid 


	 UPDATE	tmp
	SET		addlsanclmt    = isnull(add_sanclimit,0)       
	from	#creditdtl tmp	,
			SCMDB..set_additional_sanc_lmt a(nolock)        
	where	@Date between isnull(from_date,@Date)         
	and		isnull(to_date,@Date)        
	and		tmp.cust_code     =  a.cust_code        
	and		sanclmt_bu   =  tmp.buid           
	--and		sanclmt_lo = @loid_tmp   

	UPDATE	tmp
	SET		totalexplmt	=	ISNULL(totalexplmt,0)	+	ISNULL(addlsanclmt,0)
	FROM	#creditdtl	tmp
	--WHERE	1	=	1

	UPDATE	TMP1
	SET		Bank_Guarantee_Value  = ISNULL(BG_Amount,0)
	FROM	#creditdtl TMP1,(
		SELECT	cust_code,SUM(ISNULL(BG_Amount,0)) 'BG_Amount'    
		FROM	#creditdtl	tmp,
				SCMDB..Cus_BankGuaranty_dtl_Vw (NOLOCK)  
		WHERE	--BG_lo		= @loid_tmp    
		 		BG_bu		= tmp.buid     
		AND		BG_Cust_code  = tmp.cust_code    
		AND		BG_CrlimitEle  in( 'YES','Y' )    
		AND		@Date BETWEEN  BG_ValidFrom AND BG_ValidTo    
		AND		(BG_Status   = 'OP'    
		OR		BG_Closedate > @Date  )
		GROUP BY cust_code
	) A
	WHERE	A.cust_code	=	tmp1.cust_code



	UPDATE tmp1
	set Immovable_Property_Value = ISNULL(Estimate_value,0)
	from #creditdtl TMP1,(SELECT cust_code, SUM(ISNULL(IMP_EstimatValue,0)) 'Estimate_value'   
                                  FROM #creditdtl	tmp,
								        scmdb..Cus_IMproperty_dtl_vw (NOLOCK)  
                                  WHERE --IMP_lo    = @loid_tmp    
                                       IMP_bu    = tmp.buid     
                                  AND  IMP_Cust_code  = tmp.cust_code     
                                  AND  IMP_CrLimitEligibil in( 'YES','Y' )   
                                  AND  (IMP_Status   = 'OP'    
                                  OR IMP_CloseDate > @Date    
                                  )   
								  group by cust_code)A
	where A.cust_code	=	tmp1.cust_code


	 
	UPDATE TMP1
	SET Movable_Property_Value = ISNULL(INSURED_VALUE,0)
	FROM  #creditdtl TMP1,(SELECT  cust_code,  SUM(ISNULL(MP_InsuredValue,0))  'INSURED_VALUE'  
                                       FROM #creditdtl	tmp ,
									        SCMDB..Cus_MOVproperty_dtl_vw (NOLOCK)  
                                       WHERE --MP_lo    = @loid_tmp    
                                            MP_bu    = tmp.buid      
                                       AND  MP_Cust_code  = tmp.cust_code       
                                       AND  MP_CrLimitEligibil  in( 'YES','Y' )   
                                       AND  (MP_Status   = 'OP'    
                                       OR MP_CloseDate > @Date   )
									   group by cust_code)A
	where A.cust_code	=	tmp1.cust_code
		
		
	UPDATE TMP1
	SET LC_Value = ISNULL(LC_AMNT,0)
	FROM #creditdtl TMP1,(SELECT  cust_code,  SUM(ISNULL(LC_Amount,0)) 'LC_AMNT' 
	                              FROM #creditdtl	tmp,
                                       SCMDB..Cus_LC_dtl_vw (NOLOCK)   
                                  WHERE-- LC_lo    = @loid_tmp    
                                       LC_bu    = tmp.buid    
             AND  LC_Cust_code  = tmp.cust_code      
                AND  @Date BETWEEN  LC_ValidFrom AND LC_ValidTo    
                                  AND  LC_CrLimitEligibil  in( 'YES','Y' )   
                                  AND  (LC_Status   = 'OP'    
                                  OR LC_CloseDate  >  @Date  )   
								  group by cust_code)A
	where A.cust_code	=	tmp1.cust_code
    
	UPDATE TMP1
	SET Security_Cheque_Value = ISNULL(SC_AMNT,0)
	FROM #creditdtl TMP1,(SELECT cust_code, SUM(ISNULL(SC_Amount,0)) 'SC_AMNT' 
	                              from #creditdtl	tmp,
                                  scmdb..Cus_Security_Cheque_dtl_vw (NOLOCK)  
                                  WHERE --SC_lo    = @loid_tmp    
                                       SC_bu    = tmp.buid        
                                  AND  SC_Cust_code  = tmp.cust_code       
 AND  SC_CrLimitEligibil  in( 'YES','Y' )   
                                  AND  (SC_Status   = 'OP'    
                     OR SC_CloseDate  >  @Date    
                                  )  
								   group by cust_code)A
	where A.cust_code	=	tmp1.cust_code


	 UPDATE TMP
	 SET Cust_CR_Limit_Value = ISNULL(Bank_Guarantee_Value,0) + ISNULL(Immovable_Property_Value,0) + ISNULL(Movable_Property_Value,0)    
                              + ISNULL(LC_Value,0) + ISNULL(Security_Cheque_Value,0)    
	 FROM	#creditdtl tmp
	 --WHERE	1	=	1


	 UPDATE TMP
	 SET totalexplmt = ISNULL(totalexplmt,0) + ISNULL(Cust_CR_Limit_Value,0)    
	 FROM	#creditdtl tmp
	 --WHERE	1	=	1

      
	update tmp
	set undercollamt = isnull(undercollamt,0)
	from #creditdtl	tmp
	--where 1 = 1

    
     UPDATE TMP1
	 SET undercollamt = ISNULL(UNDERCOL_AMT,0)
	 FROM	#creditdtl tmp1, (SELECT c.CUST_CODE, sum(isnull(undercoll_amount,0)) 'UNDERCOL_AMT'
	                                 from #creditdtl	tmp,
									      scmdb..ci_cust_undercoll_bal c (nolock),
										  scmdb..fin_processparam_sys k (nolock)
									where c.bu_id = tmp.buid 
									and c.cust_code = tmp.cust_code 
									--and tmp.tran_ou = c.ou_id
									and  fb_id  in ( select distinct fb_id from scmdb..emod_bu_ou_fb_map_vw (nolock) where c.bu_id = tmp.buid  )    
									and component_id  = 'CDI'    
                                    and  parameter_category = 'UDCAP'    
                                    and  parameter_type    = 'SYS'    
                                    and k.company_code  LIKE ISNULL(@company,k.company_code)
									and parameter_code = 'YES'
									
									group by c.cust_code)A
	where A.cust_code	=	tmp1.cust_code

	

	update tmp1
	set totsal_amt  = ISNULL(sotran_amnt,0)
	from #creditdtl tmp1, (select cust_code, sum(isnull(sotran_amt,0)) 'sotran_amnt'
	                                from #creditdtl	tmp,
                                    scmdb..tran_crchk_tbl (nolock)    
                                    where tran_bu   = tmp.buid     
                                    and  tran_cust  =tmp.cust_code
								    group by cust_code)A
	where A.cust_code	=	tmp1.cust_code

/*
	
	update tmp1
	set totsal_amt = pend_sal_amnt --isnull(pend_sal_amnt,0)
	from #creditdtl tmp1,(select cust_code, sum(isnull(pendsal,0)) 'pend_sal_amnt'
	                              from #creditdtl tmp2
								  ,
								  (select (sohdr_total_value/nullif(sohdr_order_total_qty,0))*sum( (sodtl_rem_qty))'pendsal'
                                  from  
								      scmdb..so_order_item_dtl(nolock)            
                                  join scmdb..so_order_hdr(nolock)          
                                  on sohdr_order_no=sodtl_order_no          
                                  and sohdr_ou=sodtl_ou          
                                  where  sodtl_ship_to_cust_dflt=tmp.cust_code          
       and sohdr_order_status='AU'
                          --and sohdr_lo = @loid_tmp  
                                  and sohdr_bu = @BU   
                                  and sohdr_company_code =@company 
                                  group by (sohdr_total_value/nullif(sohdr_order_total_qty,0)) )l
								
								  group by cust_code) A

	where A.cust_code	=	tmp1.cust_code

	*/
	--select @bu 'bu'
	SELECT sodtl_ship_to_cust_dflt,SUM(ISNULL(pendsal,0))'pendsal'
	into #temp_sal_amnt FROM(
	select sodtl_ship_to_cust_dflt,(sohdr_total_value/nullif(sohdr_order_total_qty,0))*sum( (sodtl_rem_qty))'pendsal'
	--into #temp_sal_amnt
                                  from 
								      scmdb..so_order_item_dtl(nolock)            
                                  join scmdb..so_order_hdr(nolock)          
                                  on sohdr_order_no=sodtl_order_no          
                                  and sohdr_ou=sodtl_ou          
                                  where  --sodtl_ship_to_cust_dflt='APCC000004'       
                                    sohdr_order_status='AU'
                                 --and sohdr_lo = @loid_tmp  
                               --and sohdr_bu    'con'   
                                  and sohdr_company_code LIKE ISNULL(@company ,sohdr_company_code)
                                  group by sodtl_ship_to_cust_dflt, (sohdr_total_value/nullif(sohdr_order_total_qty,0)))L
								  GROUP BY sodtl_ship_to_cust_dflt


  
 
 --   select  SUM(ISNULL(pendsal,0))'PENDSAL', sodtl_ship_to_cust_dflt 
	--INTO #TEMP7 FROM #temp_sal_amnt
	--,#creditdtl
	--WHERE sodtl_ship_to_cust_dflt = cust_code
	----WHERE sodtl_ship_to_cust_dflt = 'MHCC000188'
	--GROUP BY sodtl_ship_to_cust_dflt
	----AND TRAN_OU = 42


   	update tmp1
	set totsal_amt = ISNULL(pendsal,0) --isnull(pend_sal_amnt,0)
	from #temp_sal_amnt 
	, #creditdtl tmp1
	where sodtl_ship_to_cust_dflt = cust_code

	
select sodtl_ship_to_cust_dflt,sum(isnull(pendsal,0))'pack_amt'
into #temp_pkd_amnt from(
select sodtl_ship_to_cust_dflt,(sohdr_total_value/nullif(sohdr_order_total_qty,0))*sum( (sodtl_direct_pack_qty-sodtl_invoiced_qty))pendsal
from scmdb..so_order_item_dtl(nolock)            
join scmdb..so_order_hdr(nolock)          
on sohdr_order_no=sodtl_order_no          
and sohdr_ou=sodtl_ou          
where -- sodtl_ship_to_cust_dflt=@customercode          
--and sohdr_order_status in('AU','CL')
 sohdr_order_status in('AU','CL','AM')--added by Sudhakar Pusala
   --and sohdr_lo = @loid_tmp  
   --and sohdr_bu = @buid_tmp  
   and sohdr_company_code LIKE ISNULL(@company,sohdr_company_code) 
group by sodtl_ship_to_cust_dflt,(sohdr_total_value/nullif(sohdr_order_total_qty,0))
)l group by sodtl_ship_to_cust_dflt

 	update tmp1
	set totpacksal_amt = pack_amt-- ISNULL(pack_amt,0) --isnull(pend_sal_amnt,0)
	from #temp_pkd_amnt 
	, #creditdtl tmp1
	where sodtl_ship_to_cust_dflt = cust_code


/*	
	update tmp1
	set totpacksal_amt = isnull(total_pack, 0)
	from #creditdtl tmp1,(select cust_code, sum(isnull(pendsal,0)) 'total_pack'
	                              from #creditdtl tmp2,
	                              (select (sohdr_total_value/nullif(sohdr_order_total_qty,0))*sum( (sodtl_direct_pack_qty-sodtl_invoiced_qty))'pendsal'
                                  from   #creditdtl	tmp,
								  scmdb..so_order_item_dtl(nolock)            
                                  join scmdb..so_order_hdr(nolock)          
                                  on sohdr_order_no=sodtl_order_no          
                                  and sohdr_ou=sodtl_ou          
                                  where  sodtl_ship_to_cust_dflt=tmp.cust_code           
                                  
                                  and sohdr_order_status in('AU','CL','AM')--added by Sudhakar Pusala
     --and sohdr_lo = @loid_tmp  
                                  and sohdr_bu = tmp.buid     
                                  and sohdr_company_code =@company 
 group by (sohdr_total_value/nullif(sohdr_order_total_qty,0))
                                   )l

								    group by cust_code) A

	where A.cust_code	=	tmp1.cust_code
	*/

	update tmp1
	set totdcamt = isnull(tot_tcd_amt,0)
	from #creditdtl tmp1, (select cust_code, sum(isnull(dctran_amt,0)) 'tot_tcd_amt'   
                                   from #creditdtl tmp,
								   scmdb..dc_crchk_tbl (nolock)    
                                   where tran_bu      = tmp.buid     
                                   and   tran_cust    = tmp.cust_code  
								   group by cust_code 
								   )A
	where A.cust_code	=	tmp1.cust_code

	update tmp
	set uninvoiced_amt = ISNULL(totsal_amt,0) + isnull(totdcamt,0)  
	from #creditdtl tmp
	where 1 = 1


	 declare @base_currency nvarchar(100)='INR'
/*
	update tmp1
	set opendebitbal_amt = isnull(period_debt,0)
	  ,opencreditbal_amt = isnull(period_crd,0)
	from #creditdtl tmp1, (select tmp.cust_code, sum(ISNULL(CI.period_debit,0)) 'period_debt', sum(ISNULL(CI.period_credit,0)) 'period_crd'
	                               from #creditdtl tmp,
								   scmdb..ci_cust_balance   CI (nolock),    
                                   scmdb..fcc_sysact_allperiod_vw fcc (nolock)    
               where CI.cust_code  = tmp.cust_code      
                                   and  fin_period_stdt  <= @Date    
                                   and  CI.balance_currency = @base_currency  --EPE-8050    
                                   and  CI.fin_year   = fcc.fin_year_code    
           and  CI.fin_period  = fcc.fin_period_code    
                                   and  CI.company_code  = fcc.company_code    
                      and  CI.fb_id   = fcc.fb_id    
                                   and  CI.account_type  in ( 'CCA'  , 'CPA'  ) 
                                   and  CI.fb_id   in ( select fb_id from scmdb..emod_bu_ou_fb_map (nolock) where bu_id = tmp.buid  and @Date between effective_from and isnull(effective_to,@Date))    
                                   -- Code Added for the DTS Id : 12I205_EXPQSO_00025 Starts Here    
                                   and exists ( select 'x' from scmdb..ard_customer_default_account_mst mst (nolock) ,scmdb..cust_comp_info(nolock)    
                                   where mst.company_code = @company     
                                   and comp_account_group_code = customer_group    
                                   and comp_cust_code = tmp.cust_code    
                                   and CI.fb_id = mst.fb_id     
                                   and ( custctrl_account = account_code   
                                   or custprepay_account	= account_code    )   
                                   and @Date between effective_from and isnull(effective_to, @Date))
								   group by tmp.cust_code)A

								where A.cust_code	=	tmp1.cust_code
*/
			select  CI.cust_code, sum(ISNULL(CI.period_debit,0)) 'period_debt', sum(ISNULL(CI.period_credit,0)) 'period_crd'
	                 into #temp_opendebit_credit              from 
								   scmdb..ci_cust_balance   CI with (nolock),    
                                   scmdb..fcc_sysact_allperiod_vw fcc with (nolock)    
               where --CI.cust_code  = 'MHCC000065' 
                                     fin_period_stdt  <= @Date    
                                   and  CI.balance_currency = @base_currency  --EPE-8050    
                                   and  CI.fin_year   = fcc.fin_year_code    
                                   and  CI.fin_period  = fcc.fin_period_code    
                                   and  CI.company_code  = fcc.company_code    
                                   and  CI.fb_id   = fcc.fb_id 
                  and  CI.account_type  in ( 'CCA'  , 'CPA'  ) 
                           and  CI.fb_id   in ( select fb_id from scmdb..emod_bu_ou_fb_map with (nolock) where /*bu_id = 'con' */  @Date between effective_from and isnull(effective_to,@Date))    
                                   -- Code Added for the DTS Id : 12I205_EXPQSO_00025 Starts Here    
                                   and exists ( select 'x' from scmdb..ard_customer_default_account_mst mst with (nolock) ,scmdb..cust_comp_info with (nolock)    
                                   where mst.company_code LIKE ISNULL( @company,mst.company_code)     
                                   and comp_account_group_code = customer_group    
                                   --and comp_cust_code = 'MHCC000065'
                                   and CI.fb_id = mst.fb_id     
                         and ( custctrl_account = account_code   
                                   or custprepay_account	= account_code    )   
                                   and @Date between effective_from and isnull(effective_to, @Date))
								  group by CI.cust_code

      	update tmp1
	set opendebitbal_amt = ISNULL(period_debt,0) --isnull(pend_sal_amnt,0)
	,opencreditbal_amt = isnull(period_crd,0)
	from #temp_opendebit_credit a 
	, #creditdtl tmp1 
	where a.cust_code = tmp1.cust_code





	declare @fin_prd varchar(200)
	select top 1 @fin_prd = finprd_code from scmdb..as_finperiod_dtl with (nolock) where legacy_date = 'NO' and finprd_status = 'A' order by finprd_startdt    


	select CI.cust_code,sum(ISNULL(CI.ob_credit,0))'ob_credt_amt', sum(ISNULL(CI.ob_debit,0)) 'ob_debit_amt'   
	 into #temp_opendebit_credit_1 
from  
								scmdb..ci_cust_balance CI with (nolock)    
                                where         1=1
                                and  CI.account_type  in ( 'CCA'  , 'CPA'  )
                                and  CI.balance_currency = @base_currency  
                                and  ci.fin_period  = @fin_prd    
                                and exists ( select 'x' from scmdb..ard_customer_default_account_mst mst with (nolock) ,scmdb..cust_comp_info with (nolock)    
                                where mst.company_code LIKE ISNULL(@company ,mst.company_code)    
                                and comp_account_group_code = customer_group    
                                --and comp_cust_code =tmp.cust_code 
                                and CI.fb_id = mst.fb_id     
                                and ( custctrl_account = account_code   
                                or custprepay_account	= account_code    ) 
                                and @Date between effective_from and isnull(effective_to, @Date))  
								group by CI.cust_code
	
	update tmp1
	set ob_credit = ISNULL(ob_credt_amt,0) --isnull(pend_sal_amnt,0)
	,ob_debit = isnull(ob_debit_amt,0)
	from #temp_opendebit_credit_1 a 
	, #creditdtl tmp1 
	where a.cust_code = tmp1.cust_code

	--select @fin_prd '@fin_prd'
	/*update tmp1
	set ob_credit = isnull(ob_credt_amt,0)
	   ,ob_debit  = isnull(ob_debit_amt,0)
	from #creditdtl tmp1,(select tmp.cust_code,sum(ISNULL(CI.ob_credit,0))'ob_credt_amt', sum(ISNULL(CI.ob_debit,0)) 'ob_debit_amt'   
                                  from  #creditdtl tmp ,
								  scmdb..ci_cust_balance CI (nolock)    
                                  where CI.cust_code  = tmp.cust_code          
                                  and  CI.account_type  in ( 'CCA'  , 'CPA'  )
                                  and  CI.balance_currency = @base_currency  
                                  and  ci.fin_period  = @fin_prd    
                                  and exists ( select 'x' from scmdb..ard_customer_default_account_mst mst (nolock) ,scmdb..cust_comp_info(nolock)    
                                  where mst.company_code LIKE ISNULL(@company ,mst.company_code)    
                                  and comp_account_group_code = customer_group    
        and comp_cust_code =tmp.cust_code 
  and CI.fb_id = mst.fb_id     
                                  and ( custctrl_account = account_code   
                                  or custprepay_account	= account_code    ) 
                                  and @Date between effective_from and isnull(effective_to, @Date))  
								  group by tmp.cust_code)A
								  where A.cust_code	=	tmp1.cust_code*/


	 update tmp
	-- set totalamount = isnull(totalexplmt,0) - isnull(uninvoiced_amt,0)-isnull(totpacksal_amt,0)  - (ISNULL(isnull(opendebitbal_amt,0) + isnull(ob_debit,0),0)) - (ISNULL(isnull(opencreditbal_amt,0) + isnull(ob_credit,0),0))- isnull(undercollamt,0)   
	 	-- set totalamount = totalexplmt - uninvoiced_amt-totpacksal_amt  - ((opendebitbal_amt+ ob_debit )-(opencreditbal_amt+ ob_credit))- undercollamt 
		set totalamount = isnull(totalexplmt ,0)- ISNULL(uninvoiced_amt,0)-totpacksal_amt  - ((isnull(opendebitbal_amt,0) + isnull(ob_debit,0)) - (isnull(opencreditbal_amt,0) + isnull(ob_credit,0))) - isnull(undercollamt,0)    

	 from #creditdtl tmp
	 where 1=1

 update t1
 set unadj_recp  = baseamt
 from (select tmp.cust_code,tmp.buid,sum(base_outstanding_amt) 'baseamt'                   
 from scmdb..ci_doc_balance a(nolock)      
 --code added for PJRMC-1277 starts here   
 join scmdb..emod_ou_mst (nolock)  
 on tran_ou=ou_id  
  --code added for PJRMC-1277 Ends here   
  join #creditdtl tmp
  on   a.cust_code =tmp. cust_code   
  and bu_id=buid 
 and  tran_date <=  @date                    
 and     doc_status not in ('RV','RVD')                    
 and  tran_type in ('RM_CCA','RM_CCI','RM_CPI','RM_CTC','RM_RV')                     
 and  term_no  = '0'         
 and  tran_no not in(select isnull(receipt_no,'') from SCMDB..rpt_mass_receipt_dtl(nolock))
 group by tmp.cust_code,tmp.buid) as T
 JOIN #creditdtl T1
 ON T.cust_code =T1.cust_code
 AND T.buid =T1.buid
   --code added for PJRMC-1277     

 UPDATE #creditdtl
 SET unadj_inv  = AMT
 FROM (SELECT tmp.cust_code,tmp.buid,sum(base_outstanding_amt)    'AMT'                
 from scmdb..ci_doc_balance a(nolock)   
 --code added for PJRMC-1277 starts here   
 join scmdb..emod_ou_mst (nolock)  
 on tran_ou=ou_id  
 JOIN #creditdtl TMP
  --code added for PJRMC-1277 Ends here   
ON a.cust_code = TMP.cust_code      
 and bu_id=BUID  --code added for PJRMC-1277     
 and  tran_date <=  @DATE                    
 and     doc_status not in ('RV','RVD')                     
 and  tran_type in ('RM_CDA','RM_CDI','RM_CDIN','RM_CMI','RM_CPI','RM_CPIN','RM_CPV','RM_CTD','RM_SI')                     
 and  term_no  = '0' 
 group by tmp.cust_code,tmp.buid) AS t
 join #creditdtl t1
 on t.cust_code =t1.cust_code
 and t.buid =t1.buid

 
  --select * from #creditdtl


/*Code added by Aparna M ends*/

 /*

while @i <=@count        
begin        
        
        
Select  @plantid = plantid ,        
        @bu  =  BUID ,        
  @customer_code = [Customer Account] ,        
  @customer_name = [Customer Name]         
from #creditdtl    
where row_no = @i        
        

insert into #custoutdtl (addnl_sanctn_limit,availb_cred_limit,cred_norm,pend_so,tot_expos_limit,unadj_inv,unadj_recp,undrcoll_recp)        
EXEc scmdb..CRMVwCrLm_Sp_srcGrid1spO        
@ctxt_ouinstance =  @plantid                  ,        
@ctxt_user      =  'superuser'      ,        
@ctxt_language = 1         ,        
@ctxt_service = null        ,     
@business_unit = @bu        ,        
@customer_code = @customer_code      ,        
@customer_name  = @customer_name     ,        
@hdnguid   =  @guid         ,        
@transaction_date  =  @transaction_date    ,        
@m_errorid   =   @m_errorid        
        
    
update #custoutdtl         
set  cust_code = @customer_code ,        
     buid =  @bu        
where isnull(cust_code,'') = ''        
        
        
set @i=@i+1        
        
end        
 */       
        
update  #creditdtl        
set [Credit Limit] = isnull(totalexplmt,0)+isnull(addlsanclmt,0),        
 --Receivables = unadj_inv, --availb_cred_limit ,     /*Code Commented and Added for RITSL/UAT_Fix*/   
 [Spl Liabilities] = b.unadj_recp ,        
 [Open SO]      = b.uninvoiced_amt,--pend_so ,        
 [Open Invoice]   = b.unadj_inv        
from  #custoutdtl a  
join #creditdtl b (nolock)        
on  a.[BUID]      = b.buid        
and  a.cust_code = b.[Customer Account]         
        
    
/*    
update  #creditdtl        
set [Open Delivery] = isnull(penqty,0)*isnull(price,0)        
from  #creditdtl a  (nolock) join        
(select sum (isnull(sodtl_shipped_qty,0)- isnull(sodtl_invoiced_qty,0))  'penqty',sum(sodtl_unit_price) 'price' ,sohdr_bill_to_cust 'custcode',sohdr_bu        
from scmdb..so_order_hdr  a (nolock)        
join scmdb..so_order_item_dtl b  (nolock)        
on a.sohdr_ou  = b.sodtl_ou        
and a.sohdr_order_no  = b.sodtl_order_no        
and isnull(sodtl_shipped_qty,0)- isnull(sodtl_invoiced_qty,0) >0        
group by sohdr_bill_to_cust ,sohdr_bu) c        
on a.BUID = c.sohdr_bu        
and a.[Customer Account]  = c.custcode     
*/  
     
        
   
update  #creditdtl        
set [Open Delivery] = penpackslip  
from (  
select sum(penpackslip)penpackslip,custcode from (  
  
select (sohdr_total_value/nullif(sohdr_order_total_qty,0))*sum( (sodtl_direct_pack_qty-sodtl_invoiced_qty))penpackslip,sohdr_bill_to_cust custcode  
from scmdb..so_order_item_dtl(nolock)              
join scmdb..so_order_hdr(nolock)            
on sohdr_order_no=sodtl_order_no            
and sohdr_ou=sodtl_ou            
where  sohdr_order_status in('AU','CL','AM')--added for IDS_INT  
group by (sohdr_total_value/nullif(sohdr_order_total_qty,0)),sohdr_bill_to_cust)l  
group by custcode)k  
where  [Customer Account]  = custcode    
        
        
update  #creditdtl        
set [Available Credit] = isnull([Credit Limit],0) -(isnull(Receivables,0) +isnull([Open Delivery],0) +isnull([Open SO],0) +isnull([Open Invoice],0)-isnull([Spl Liabilities],0))        
from  #creditdtl        
        
        
        
/*        
----- Credit Limit -----------------------------        
        
        
update  #creditdtl        
set [Credit Limit] = total_exp_limit        
from #creditdtl  a          
join scmdb..cm_cust_bu_exp_limit b (nolock)        
on  a.Division = b.bu_code        
and a.[Customer Account] = b.cust_code        
and convert(date,getdate()) between  isnull(fm_date_addl_limit,convert(date,getdate()))  and   isnull(to_date_addl_limit,convert(date,getdate()))         
        
update  #creditdtl        
set [Credit Limit] = [Credit Limit]+isnull(add_sanclimit,0)        
from #creditdtl  a         
join scmdb..set_additional_sanc_lmt b (nolock)        
on a.BUID = b.sanclmt_bu        
and a.[Customer Account] = b.cust_code        
and   convert(date,getdate()) between isnull(from_date,convert(date,getdate()))  and isnull(to_date,convert(date,getdate()))         
        
----------receivables -------------------------        
*/        
        
        
  update #creditdtl set [zone] = paramdesc 
   FROM  #creditdtl c  
   join scmdb..component_metadata_table with(nolock)   
    on C.Zone = paramcode and componentname = 'EMOD'    
    and paramcategory = 'COMBO'    
    and paramtype = 'ZONE'  
  
  
  

        
        
select * from #creditdtl where isnull([Available Credit],0) <> 0        
        
               
        
end   
  
  
  


