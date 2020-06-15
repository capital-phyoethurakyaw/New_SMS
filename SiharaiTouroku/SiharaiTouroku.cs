﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Base.Client;
using BL;
using Entity;
using CKM_Controls;

namespace SiharaiTouroku
{
    public partial class FrmSiharaiTouroku : FrmMainForm
    {
        SiharaiTouroku_BL sibl = new SiharaiTouroku_BL();
        D_Pay_Entity dpe = new D_Pay_Entity();
        M_Staff_Entity mse = new M_Staff_Entity();
        M_MultiPorpose_Entity mmpe = new M_MultiPorpose_Entity();
        M_Kouza_Entity mke = new M_Kouza_Entity();
        M_Vendor_Entity mve = new M_Vendor_Entity();
        D_PayPlan_Entity dppe = new D_PayPlan_Entity();

        int type = 0; string mode = "0";
        string vendorCD = string.Empty;

        DataTable dtpayplan = new DataTable(); // data bind(insert mode) for Form1
        DataTable dtPay1 = new DataTable(); // data bind(update mode) for Form1
        DataTable dtPay1Detail = new DataTable();

        DataTable dtSiharai2 = new DataTable(); // checkbox click for form2
        DataTable dt2 = new DataTable(); // detail for form2(update mode)
        DataTable dt3 = new DataTable(); // Gridview bind for form2(update mode)
        DataTable dt4 = new DataTable(); // gridview bind for form2(insert mode)
        DataTable dt4Detail = new DataTable(); // detail for form2(insert mode)

        private string mOldPayNo = "";    //排他処理のため使用

        public FrmSiharaiTouroku()
        {
            InitializeComponent();
        }
        
        private void FrmSiharaiTouroku_Load(object sender, EventArgs e)
        {
            InProgramID = "SiharaiTouroku";

            SetFunctionLabel(EProMode.MENTE);
            StartProgram();

            ScPaymentProcessNum.Enabled = false;
            ScPaymentNum.Enabled = false;
            ScPaymentProcessNum.SearchEnable = false;
            ScPaymentNum.SearchEnable = false;

            Btn_F7.Enabled = false;
            Btn_F7.Text = "編集(F7)";
            //Btn_F10.Text = "";
            Btn_F11.Enabled = true;

            btnF11Show.Enabled = true;
            txtPaymentDate.Enabled = false;

            ScPayee.Value1 = "3";

            cboPaymentSourceAcc.Enabled = false;
            cboPaymentType.Enabled = false;
            txtBillSettleDate.Enabled = false;

            btnReleaseAll.Enabled = false;
            btnSelectAll.Enabled = false;

            txtDueDate1.Focus();

            BindCombo();
            SetRequireField();
           
        }

        #region Funtion For FormLoad

        private void SetRequireField()
        {
            ScPaymentNum.TxtCode.Require(true);
            ScPayee.TxtCode.Require(true);
            txtPaymentDate.Require(true);
            ScStaff.TxtCode.Require(true);
            txtDueDate2.Require(true);
            txtPaymentDate.Require(true);
        }

        private void BindCombo()
        {
            cboPaymentType.Bind(string.Empty);
            cboPaymentSourceAcc.Bind(string.Empty);
        }

        public override void FunctionProcess(int Index)
        {
            base.FunctionProcess(Index);

            switch (Index)
            {
                case 0: // F1:終了
                    {
                        break;
                    }
                case 1:     //F2:新規
                case 2:     //F3:変更
                case 3:     //F4:削除
                case 4:     //F5:照会
                    {
                        ChangeMode((EOperationMode)Index);

                        break;
                    }
                case 5: //F6:キャンセル
                    {
                        //Ｑ００４				
                        if (bbl.ShowMessage("Q004") != DialogResult.Yes)
                            return;

                        ChangeMode(base.OperationMode);

                        break;
                    }
                case 6:
                    F7();
                    break;
                case 10:
                    F11();
                    break;
                case 11:
                    F12();
                    break;
            }
        }

        #endregion

        /// <summary>
        /// 排他処理データを削除する
        /// </summary>
        private void DeleteExclusive()
        {
            if (mOldPayNo == "")
                return;

            Exclusive_BL ebl = new Exclusive_BL();
            D_Exclusive_Entity dee = new D_Exclusive_Entity
            {
                DataKBN = (int)Exclusive_BL.DataKbn.Shiharai,
                Number = mOldPayNo,
            };

            bool ret = ebl.D_Exclusive_Delete(dee);

            mOldPayNo = "";
        }
        private bool SelectAndInsertExclusive()
        {
            if (OperationMode == EOperationMode.SHOW || OperationMode == EOperationMode.INSERT)
                return true;

            DeleteExclusive();

            if (string.IsNullOrWhiteSpace(ScPaymentNum.Text))
                return true;

            //排他Tableに該当番号が存在するとError
            //[D_Exclusive]
            Exclusive_BL ebl = new Exclusive_BL();
            D_Exclusive_Entity dee = new D_Exclusive_Entity
            {
                DataKBN = (int)Exclusive_BL.DataKbn.Shiharai,
                Number = ScPaymentNum.Text,
                Program = this.InProgramID,
                Operator = this.InOperatorCD,
                PC = this.InPcID
            };

            DataTable dt = ebl.D_Exclusive_Select(dee);

            if (dt.Rows.Count > 0)
            {
                bbl.ShowMessage("S004", dt.Rows[0]["Program"].ToString(), dt.Rows[0]["Operator"].ToString());
                ScPaymentNum.Focus();
                return false;
            }
            else
            {
                bool ret = ebl.D_Exclusive_Insert(dee);
                mOldPayNo = ScPaymentNum.Text;
                return ret;
            }
        }
        private void ChangeMode(EOperationMode OperationMode)
        {
            base.OperationMode = OperationMode;

            //排他処理を解除
            DeleteExclusive();

            switch (OperationMode)
            {
                case EOperationMode.INSERT:
                    Clear(PanelHeader);
                    Clear(PanelDetail);
                    EnablePanel(PanelHeader);
                    DisablePanel(PanelDetail);
                    ScPaymentProcessNum.Enabled = false;
                    ScPaymentNum.Enabled = false;
                    ScPayee.Enabled = true;
                    ScPayee.SearchEnable = true;
                    txtDueDate1.Focus();
                    F9Visible = false;
                    F12Enable = true;
                    F11Enable = true;
                    btnF11Show.Enabled = true;
                    //F11Visible = false;
                    Clear();
                    break;
                case EOperationMode.UPDATE:
                case EOperationMode.DELETE:
                case EOperationMode.SHOW:
                    Clear(PanelHeader);
                    Clear(PanelDetail);
                    EnablePanel(PanelHeader);
                    DisablePanel(PanelDetail);
                    ScPaymentProcessNum.Enabled = true;
                    ScPaymentProcessNum.SearchEnable = true;
                    ScPaymentNum.Enabled = true;
                    ScPaymentNum.SearchEnable = true;
                    ScPaymentProcessNum.SetFocus(1);
                    txtDueDate1.Enabled = false;
                    txtDueDate2.Enabled = false;
                    ScPayee.Enabled = false;
                    ScPayee.SearchEnable = false;
                    F12Enable = true;
                    F11Enable = false;
                    btnF11Show.Enabled = F11Enable = false;
                    //F11Visible = false;
                    Clear();
                    break;
            }
            ScPaymentProcessNum.SetFocus(1);
        }
        
        #region Function Click

        protected override void EndSec()
        {
            try
            {
                DeleteExclusive();
            }
            catch (Exception ex)
            {
                //例外は無視する
                System.Diagnostics.Debug.WriteLine(ex.Message);
            }

            this.Close();
        }

        private void F7()
        {
            if (dgvPayment.CurrentRow.Index >= 0)
            {
                DataGridViewRow row = dgvPayment.CurrentRow;
               
                DataRow[] rows = dtPay1Detail.Select("PayeeCD <> '" + row.Cells["colPayeeCD"].Value.ToString() + "' OR PayPlanDate <> '" + row.Cells["colPaymentdueDate"].Value.ToString() + "'");
                dt2 = dtPay1Detail.Copy();
                foreach (DataRow rw in rows)
                    dt2.Rows.Remove(rw);
                //dt2 = sibl.D_Pay_Select02(dpe);
              
                dppe.PayPlanDate = row.Cells["colPaymentdueDate"].Value.ToString();
                dppe.PayeeCD = row.Cells["colPayeeCD"].Value.ToString();

                dpe.PayeeCD = row.Cells["colPayeeCD"].Value.ToString();
                dpe.PayPlanDate = row.Cells["colPaymentdueDate"].Value.ToString();
                dpe.LargePayNO = ScPaymentProcessNum.TxtCode.Text;
                dpe.PayNo = ScPaymentNum.TxtCode.Text;
                mke.KouzaCD = cboPaymentSourceAcc.SelectedValue.ToString();
                             
                if (OperationMode == EOperationMode.INSERT)
                {
                    mode = "1";
                    //dt4 = sibl.D_Pay_SelectForPayPlanDate2(dppe);
                    if(dt4.Rows.Count > 0)
                    {
                        SiharaiTouroku_2 f2 = new SiharaiTouroku_2(mke.KouzaCD,dppe.PayeeCD, dppe.PayPlanDate, dt4, dt4Detail);
                        f2.ShowDialog();
                        dt4 = f2.dtGdv;
                        dt4Detail = f2.dtDetails;
                    }                  
                }
                else
                {
                    mode = "2";
                    dt2 = sibl.D_Pay_Select02(dpe);
                    dt3 = sibl.D_Pay_Select3(dpe);

                    if (dt3.Rows.Count > 0)
                    {
                        SiharaiTouroku_2 f2 = new SiharaiTouroku_2(mke.KouzaCD, dppe.PayeeCD, dppe.PayPlanDate, dt3, dt2);
                        f2.ShowDialog();
                        dt3 = f2.dtGdv;
                        dt2 = f2.dtDetails;
                    }                 
                }             
            }       
        }
        
        private void F11()
        {
            type = 3;
            if (ErrorCheck(11))
            {
                dppe.PayPlanDateFrom = txtDueDate1.Text;
                dppe.PayPlanDateTo = txtDueDate2.Text;
                dppe.PayeeCD = ScPayee.TxtCode.Text;
                dppe.Operator = InOperatorCD;
                
                dtpayplan = sibl.D_PayPlan_Select(dppe);
                if (dtpayplan.Rows.Count > 0)
                {
                    txtPaymentDate.Text = sibl.GetDate();
                    ScStaff.TxtCode.Text = InOperatorCD;
                    ScStaff.LabelText = dtpayplan.Rows[0]["StaffName"].ToString();
                    cboPaymentType.SelectedValue = 1;   //振込
                    cboPaymentSourceAcc.SelectedValue = dtpayplan.Rows[0]["KouzaCD"].ToString();
                    txtBillSettleDate.Text = string.Empty;
                    dgvPayment.DataSource = dtpayplan;
                    dgvPayment.Rows[0].Selected = true;
                    Checkstate(true);
                    LabelDataBind();
                    Btn_F7.Enabled = true;

                    //DataGridViewRow row = this.dgvPayment.SelectedRows[0];
                    //dppe.PayPlanDate = row.Cells["colPaymentdueDate"].Value.ToString();
                    //dppe.PayeeCD = row.Cells["colPayeeCD"].Value.ToString();
                    dtPay1Detail = sibl.D_PayPlan_SelectDetail(dppe);
                    //if (dtPay1Detail.Rows.Count > 0)
                    //{
                    //    dt4Detail = dtPay1Detail.Copy();
                    //    dt4Detail.Columns.Remove("Number");
                    //    dt4Detail.Columns.Remove("RecordedDate");
                    //    dt4Detail.Columns.Remove("PayPlanGaku");
                    //    dt4Detail.Columns.Remove("PayConfirmGaku");
                    //    dt4Detail.Columns.Remove("UnpaidAmount1");
                    //    dt4Detail.Columns.Remove("UnpaidAmount2");
                    //    dt4Detail.Columns.Remove("PayPlanNO");


                    //    dt4.Columns.Remove("TransferGaku");
                    //    //dt4.Columns.Remove("TransferFeeGaku");
                    //    dt4.Columns.Remove("VendorName");
                    //    dt4.Columns.Remove("BankCD");
                    //    dt4.Columns.Remove("BankName");
                    //    dt4.Columns.Remove("BranchCD");
                    //    dt4.Columns.Remove("BranchName");
                    //    dt4.Columns.Remove("KouzaKBN");
                    //    dt4.Columns.Remove("KouzaNO");
                    //    dt4.Columns.Remove("KouzaMeigi");
                    //    dt4.Columns.Remove("FeeKBN");
                    //    dt4.Columns.Remove("Fee");
                    //    dt4.Columns.Remove("CashGaku");
                    //    dt4.Columns.Remove("OffsetGaku");
                    //    dt4.Columns.Remove("BillGaku");
                    //    dt4.Columns.Remove("BillDate");
                    //    dt4.Columns.Remove("BillNO");
                    //    dt4.Columns.Remove("ERMCGaku");
                    //    dt4.Columns.Remove("ERMCNO");
                    //    dt4.Columns.Remove("ERMCDate");
                    //    dt4.Columns.Remove("OtherGaku1");
                    //    dt4.Columns.Remove("Account1");
                    //    dt4.Columns.Remove("start1");
                    //    dt4.Columns.Remove("SubAccount1");
                    //    dt4.Columns.Remove("end1label");
                    //    dt4.Columns.Remove("OtherGaku2");
                    //    dt4.Columns.Remove("Account2");
                    //    dt4.Columns.Remove("start2");
                    //    dt4.Columns.Remove("SubAccount2");
                    //    dt4.Columns.Remove("end2label");

                    //}                  
                }

                //txtPaymentDate.ReadOnly = true;
                //ScStaff.TxtCode.ReadOnly = true;
                //ScStaff.SearchEnable = false;
                EnablePanel(PanelDetail);             
                btnSelectAll.Enabled = true;
                btnReleaseAll.Enabled = true;

                txtPaymentDate.Focus();
            }
        }

        private void F12()
        {
            if (ErrorCheck(12))
            {
                dpe = GetPayData();
                if (bbl.ShowMessage(OperationMode == EOperationMode.DELETE ? "Q102" : "Q101") == DialogResult.Yes)
                {

                    DataTable dt = GetGridEntity();

                    if (sibl.D_Siharai_Exec(dpe, dt, (short)OperationMode))
                    {
                        sibl.ShowMessage("I101");

                        //更新後画面クリア
                        ChangeMode(OperationMode);
                    }
                }
                else
                    PreviousCtrl.Focus();
            }
        }
        
        #endregion

        #region btnClick
        private void btnSelectAll_Click(object sender, EventArgs e)
        {
            try {
                Checkstate(true);
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
                //EndSec();
            }
        }

        private void btnReleaseAll_Click(object sender, EventArgs e)
        {
            try
            {
                Checkstate(false);
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
                //EndSec();
            }
        }
       
        #endregion

        #region KeyEvent
        private void FrmSiharaiTouroku_KeyUp(object sender, KeyEventArgs e)
        {
            MoveNextControl(e);
        }

        private void ScPaymentNum_CodeKeyDownEvent(object sender, KeyEventArgs e)
        {
            //Enterキー押下時処理
            //Returnキーが押されているか調べる
            //AltかCtrlキーが押されている時は、本来の動作をさせる
            if ((e.KeyCode == Keys.Return) &&
                    ((e.KeyCode & (Keys.Alt | Keys.Control)) == Keys.None))
            {
                type = 2;
                if (ErrorCheck(11))
                {
                    if(DataDisplay())
                    {

                    }
                }
            }
        }

        private void ScPaymentProcessNum_CodeKeyDownEvent(object sender, KeyEventArgs e)
        {
            //Enterキー押下時処理
            //Returnキーが押されているか調べる
            //AltかCtrlキーが押されている時は、本来の動作をさせる
            if ((e.KeyCode == Keys.Return) &&
                    ((e.KeyCode & (Keys.Alt | Keys.Control)) == Keys.None))
            {
                type = 1;
                ErrorCheck(11);
            }
        }

        private void ScPayee_CodeKeyDownEvent(object sender, KeyEventArgs e)
        {
            //Enterキー押下時処理
            //Returnキーが押されているか調べる
            //AltかCtrlキーが押されている時は、本来の動作をさせる
            if ((e.KeyCode == Keys.Return) &&
                    ((e.KeyCode & (Keys.Alt | Keys.Control)) == Keys.None))
            {
                F11();
            }
        }

        private void ScStaff_CodeKeyDownEvent(object sender, KeyEventArgs e)
        {
            //Enterキー押下時処理
            //Returnキーが押されているか調べる
            //AltかCtrlキーが押されている時は、本来の動作をさせる
            if ((e.KeyCode == Keys.Return) &&
                    ((e.KeyCode & (Keys.Alt | Keys.Control)) == Keys.None))
            {

                if(!CheckStaff())
                {
                    ScStaff.SetFocus(1);
                }
            }
        }

        private void btnF11Show_Click(object sender, EventArgs e)
        {
            try { 
                F11();
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
                //EndSec();
            }
        }

        #endregion

        #region GridView Cell Click
        private void dgvPayment_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                F7();
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
                //EndSec();
            }
        }

        private void dgvPayment_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if ((Convert.ToBoolean(dgvPayment.Rows[e.RowIndex].Cells["colChk"].EditedFormattedValue) == true))
            {   
                if(!string.IsNullOrWhiteSpace(cboPaymentType.SelectedValue.ToString()))
                {
                    if (cboPaymentType.SelectedValue.ToString() == "1")
                    {
                        //foreach (DataGridViewRow row in dgvPayment.Rows)
                        //{
                        //    row.Cells["colPaymenttime"].Value = Convert.ToInt32(row.Cells["colScheduledPayment"].Value) - Convert.ToInt32(row.Cells["colAmountPaid"].Value);
                        //    row.Cells["colTransferAmount"].Value = Convert.ToInt32(row.Cells["colScheduledPayment"].Value) - Convert.ToInt32(row.Cells["colAmountPaid"].Value);
                        //    row.Cells["colUnpaidAmount"].Value = "0";
                        //    row.Cells["colOtherThanTransfer"].Value = "0";
                        //}
                        dppe.PayPlanDate = dgvPayment.Rows[e.RowIndex].Cells["colPaymentdueDate"].Value.ToString();
                        dppe.PayeeCD = dgvPayment.Rows[e.RowIndex].Cells["colPayeeCD"].Value.ToString();

                        if (dt4Detail != null)
                        {
                            DataRow[] tblROWS1 = dt4Detail.Select("PayeeCD = '" + dppe.PayeeCD + "'" + "and PayPlanDate = '" + dppe.PayPlanDate + "'");
                            if (tblROWS1.Length > 0)
                                dtSiharai2 = tblROWS1.CopyToDataTable();

                            mke = new M_Kouza_Entity
                            {
                                KouzaCD = cboPaymentSourceAcc.SelectedValue.ToString(),
                                BankCD = dtSiharai2.Rows[0]["BankCD"].ToString(),
                                BranchCD = dtSiharai2.Rows[0]["BranchCD"].ToString(),
                                Amount = lblPayGaku.Text.Replace(",", ""),
                            };
                            DataTable dt = sibl.M_Kouza_FeeSelect(mke);
                            dgvPayment.Rows[e.RowIndex].Cells["colTransferFee"].Value = dt.Rows[0]["Fee"].ToString();
                        }

                        dgvPayment.Rows[e.RowIndex].Cells["colPaymenttime"].Value = Convert.ToInt32(dgvPayment.Rows[e.RowIndex].Cells["colScheduledPayment"].Value) - Convert.ToInt32(dgvPayment.Rows[e.RowIndex].Cells["colAmountPaid"].Value);
                        dgvPayment.Rows[e.RowIndex].Cells["colTransferAmount"].Value = Convert.ToInt32(dgvPayment.Rows[e.RowIndex].Cells["colScheduledPayment"].Value) - Convert.ToInt32(dgvPayment.Rows[e.RowIndex].Cells["colAmountPaid"].Value);

                        dgvPayment.Rows[e.RowIndex].Cells["colUnpaidAmount"].Value = "0";
                        dgvPayment.Rows[e.RowIndex].Cells["colOtherThanTransfer"].Value = "0";

                        if (dt4 != null)
                        {
                            for (int i = 0; i < dt4.Rows.Count; i++)
                            {
                                double a = Convert.ToDouble(dt4.Rows[i]["PayPlanGaku"].ToString());
                                double b = Convert.ToDouble(dt4.Rows[i]["PayConfirmGaku"].ToString());
                                double result = a - b;

                                dt4.Rows[i]["UnpaidAmount1"] = result.ToString();
                                dt4.Rows[i]["UnpaidAmount2"] = "0";
                            }
                        }

                    }
                    else
                    {
                        //foreach (DataGridViewRow row in dgvPayment.Rows)
                        //{
                        //    row.Cells["colPaymenttime"].Value = Convert.ToInt32(row.Cells["colScheduledPayment"].Value) - Convert.ToInt32(row.Cells["colAmountPaid"].Value);
                        //    row.Cells["colTransferAmount"].Value = "0";
                        //    row.Cells["colTransferFee"].Value = "0";
                        //    row.Cells["colUnpaidAmount"].Value = "0";
                        //    row.Cells["colOtherThanTransfer"].Value = Convert.ToInt32(row.Cells["colScheduledPayment"].Value) - Convert.ToInt32(row.Cells["colAmountPaid"].Value);
                        //}
                        if (dt4 != null)
                        {
                            for (int i = 0; i < dt4.Rows.Count; i++)
                            {
                                dt4.Rows[i]["UnpaidAmount1"] = Convert.ToInt32(dt4.Rows[i]["PayPlanGaku"].ToString()) - Convert.ToInt32(dt4.Rows[i]["PayConfirmGaku"].ToString());
                                dt4.Rows[i]["UnpaidAmount2"] = "0";
                            }
                        }

                        dgvPayment.Rows[e.RowIndex].Cells["colPaymenttime"].Value = Convert.ToInt32(dgvPayment.Rows[e.RowIndex].Cells["colScheduledPayment"].Value) - Convert.ToInt32(dgvPayment.Rows[e.RowIndex].Cells["colAmountPaid"].Value);
                        dgvPayment.Rows[e.RowIndex].Cells["colTransferAmount"].Value = "0";
                        dgvPayment.Rows[e.RowIndex].Cells["colTransferFee"].Value = "0";
                        dgvPayment.Rows[e.RowIndex].Cells["colUnpaidAmount"].Value = "0";
                        dgvPayment.Rows[e.RowIndex].Cells["colOtherThanTransfer"].Value = Convert.ToInt32(dgvPayment.Rows[e.RowIndex].Cells["colScheduledPayment"].Value) - Convert.ToInt32(dgvPayment.Rows[e.RowIndex].Cells["colAmountPaid"].Value);
                    }

                    LabelDataBind();
                }
               
                
               
            }
        }

        #endregion

        /// <summary>
        /// Error Check for the whole form
        /// </summary>
        /// <param name="index"></param>
        /// <returns></returns>
        private bool ErrorCheck(int index)
        {            
            if(index == 11)
            {
                if (type == 1)
                {
                    DataTable dtpay = new DataTable();
                    dpe.LargePayNO = ScPaymentProcessNum.TxtCode.Text;
                    dtpay = sibl.D_Pay_LargePayNoSelect(dpe);
                    if (dtpay.Rows.Count == 0)
                    {
                        sibl.ShowMessage("138");
                        ScPaymentProcessNum.SetFocus(1);
                        return false;
                    }
                    else
                    {
                        if (!string.IsNullOrWhiteSpace(dtpay.Rows[0]["DeleteDateTime"].ToString()))
                        {
                            sibl.ShowMessage("140");
                            ScPaymentProcessNum.SetFocus(1);
                            return false;
                        }
                    }
                }

                else if (type == 2)
                {
                    //支払処理番号未入力時、入力必須(Entry required)

                    if (!RequireCheck(new Control[] { ScPaymentNum.TxtCode }))
                        return false;

                    dpe.PayNo = ScPaymentNum.TxtCode.Text;
                    dpe.LargePayNO = ScPaymentProcessNum.TxtCode.Text;
                    //dtpayno = sibl.D_Pay_PayNoSelect(dpe);
                    dtPay1 = sibl.D_Pay_Select01(dpe);
                    if (dtPay1.Rows.Count == 0)
                    {
                        bbl.ShowMessage("E138", "支払番号");
                        ScPaymentNum.SetFocus(1);
                        return false;
                    }
                    else
                    {
                        if (!string.IsNullOrWhiteSpace(dtPay1.Rows[0]["DeleteDateTime"].ToString()))
                        {
                            sibl.ShowMessage("E140");
                            ScPaymentNum.SetFocus(1);
                            return false;
                        }
                        if (!string.IsNullOrWhiteSpace(dtPay1.Rows[0]["FBCreateDate"].ToString()))
                        {
                            sibl.ShowMessage("E144");
                            ScPaymentNum.SetFocus(1);
                            return false;
                        }
                        txtPaymentDate.Text = dtPay1.Rows[0]["PayDate"].ToString();
                        //入力できる範囲内の日付であること
                        if (!bbl.CheckInputPossibleDate(txtPaymentDate.Text))
                        {
                            //Ｅ１１５
                            bbl.ShowMessage("E115");
                            return false;
                        }                        

                        //排他処理
                        bool ret = SelectAndInsertExclusive();
                        if (!ret)
                            return false;

                        dtPay1Detail = sibl.D_Pay_Select02(dpe);
                    }
                }

                else if (type == 3)
                {
                    if(!CheckDate2())
                    {
                        return false;
                    }
                    
                    if (!RequireCheck(new Control[] { ScPayee.TxtCode }))
                        return false;
                    else
                    {
                        mve.VendorCD = ScPayee.TxtCode.Text;
                        mve.ChangeDate = sibl.GetDate();
                        mve.MoneyPayeeFlg = "1";
                        DataTable dtvendor = new DataTable();
                        dtvendor = sibl.M_Vendor_Select(mve);
                        if (dtvendor.Rows.Count == 0)
                        {
                            sibl.ShowMessage("E101");
                            ScPayee.SetFocus(1);
                            return false;
                        }
                        else
                        {
                            ScPayee.LabelText = dtvendor.Rows[0]["VendorName"].ToString();
                        }
                    }
                }
            }
            else if (index == 12)
            {
                if (!CheckPaymentDate())
                    return false;
                
                if (!CheckStaff())
                    return false;                

                //if (!RequireCheck(new Control[] {cboPaymentType}))
                if (string.IsNullOrWhiteSpace(cboPaymentType.SelectedValue.ToString()))
                {
                    sibl.ShowMessage("E102");
                    cboPaymentType.Focus();
                    return false;
                }
                else
                {
                    mmpe.ID = "314";
                    DataTable dtmulti = new DataTable();
                    dtmulti = sibl.M_MultiPorpose_Select(mmpe);
                    if (dtmulti.Rows.Count == 0)
                    {
                        sibl.ShowMessage("E128");
                        cboPaymentType.Focus();
                        return false;
                    }
                    else
                    {
                        string name = dtmulti.Rows[0]["Char1"].ToString();
                    }
                }
               
                if (string.IsNullOrWhiteSpace(cboPaymentSourceAcc.SelectedValue.ToString()))
                {
                    sibl.ShowMessage("E102");
                    cboPaymentSourceAcc.Focus();
                    return false;
                }
                mke.ChangeDate = txtPaymentDate.Text;
                DataTable dtkouza = new DataTable();
                dtkouza = sibl.M_Kouza_SelectByDate(mke);
                if (dtkouza.Rows.Count == 0)
                {
                    sibl.ShowMessage("E128");
                    cboPaymentSourceAcc.Focus();
                    return false;
                }
                else
                {
                    cboPaymentSourceAcc.SelectedValue = dtkouza.Rows[0]["KouzaCD"].ToString();
                }
                if (string.IsNullOrWhiteSpace(txtBillSettleDate.Text))
                {
                    sibl.ShowMessage("E102");
                    txtBillSettleDate.Focus();
                    return false;
                }

            }
            
            return true;
        }

        private bool CheckStaff()
        {
            ScStaff.LabelText = "";

            if (!RequireCheck(new Control[] { ScStaff.TxtCode }))
                return false;
            else
            {
                mse.StaffCD = ScStaff.TxtCode.Text;
                mse.ChangeDate = txtPaymentDate.Text;
                DataTable dtstaff = new DataTable();
                dtstaff = sibl.M_Staff_Select(mse);
                if (dtstaff.Rows.Count == 0)
                {
                    sibl.ShowMessage("E101");
                    ScStaff.SetFocus(1);
                }
                else
                {
                    ScStaff.LabelText = dtstaff.Rows[0]["StaffName"].ToString();
                }
            }

            return true;
        }
        private bool CheckDate2()
        {
            if (!RequireCheck(new Control[] { txtDueDate2 }))
                return false;
            else
            {
                int result = txtDueDate1.Text.CompareTo(txtDueDate2.Text);
                if (result > 0)
                {
                    sibl.ShowMessage("E104");
                    txtDueDate2.Focus();
                    return false;
                }
            }

            return true;
        }

        private bool CheckPaymentDate()
        {
            if (!RequireCheck(new Control[] { txtPaymentDate }))
                return false;

            //入力できる範囲内の日付であること
            if (!bbl.CheckInputPossibleDate(txtPaymentDate.Text))
            {
                //Ｅ１１５
                bbl.ShowMessage("E115");
                txtPaymentDate.Focus();
                return false;
            }

            //店舗の締日チェック
            //店舗締マスターで判断
            M_StoreClose_Entity msce = new M_StoreClose_Entity
            {
                StoreCD = StoreCD,
                FiscalYYYYMM = txtPaymentDate.Text.Replace("/", "").Substring(0, 6)
            };
            bool ret = bbl.CheckStoreClose(msce, false, false, false, true, false);
            if (!ret)
            {
                txtPaymentDate.Focus();
                return false;
            }
            return true;
        }
        /// <summary>
        /// Show Data in DataArea
        /// </summary>
        private bool DataDisplay()
        {
            txtDueDate1.Enabled = false;
            txtDueDate2.Enabled = false;
            ScPayee.Enabled = false;
            btnF11Show.Enabled = false;

            cboPaymentType.Enabled = false;
            cboPaymentSourceAcc.Enabled = false;
            txtBillSettleDate.Enabled = false;

            btnSelectAll.Enabled = true;
            btnReleaseAll.Enabled = true;
            //dpe.PayNo = ScPaymentNum.TxtCode.Text;
            //dpe.LargePayNO = ScPaymentProcessNum.TxtCode.Text;

            //dtPay1 = sibl.D_Pay_Select01(dpe);
            if (dtPay1.Rows.Count > 0)
            {   
                dgvPayment.DataSource = dtPay1;
                txtPaymentDate.Text = dtPay1.Rows[0]["PayDate"].ToString();
                ScStaff.TxtCode.Text = dtPay1.Rows[0]["StaffCD"].ToString();
                ScStaff.LabelText = dtPay1.Rows[0]["StaffName"].ToString();
                Checkstate(true);
                dgvPayment.Rows[0].Selected = true;
                LabelDataBind();

                Btn_F7.Enabled = true;

                //vendorCD = dtPay1.Rows[0]["PayeeCD"].ToString();
                EnablePanel(PanelDetail);
            }
            return true;
        }

        /// <summary>
        /// to show total data with Label below gridview
        /// </summary>
        public void LabelDataBind()
        {
            int sum1 = 0, sum2 = 0, sum3 = 0, sum4 = 0, sum5 = 0, sum6 = 0, sum7 = 0;
            for (int i = 0; i < dgvPayment.Rows.Count; ++i)
            {
                sum1 += Convert.ToInt32(dgvPayment.Rows[i].Cells[4].Value);
                sum2 += Convert.ToInt32(dgvPayment.Rows[i].Cells[5].Value);
                sum3 += Convert.ToInt32(dgvPayment.Rows[i].Cells[6].Value);
                sum4 += Convert.ToInt32(dgvPayment.Rows[i].Cells[7].Value);
                sum5 += Convert.ToInt32(dgvPayment.Rows[i].Cells[8].Value);
                sum6 += Convert.ToInt32(dgvPayment.Rows[i].Cells[10].Value);
                sum7 += Convert.ToInt32(dgvPayment.Rows[i].Cells[11].Value);

            }
            lblPayPlanGaku.Text = sum1.ToString("#,##0");
            lblPayConfirmGaku.Text = sum2.ToString("#,##0");
            lblPayGaku.Text = sum3.ToString("#,##0");
            lblTransferGaku.Text = sum4.ToString("#,##0");
            lblTransferFeeGaku.Text = sum5.ToString("#,##0");
            lblGakuTotal.Text = sum6.ToString("#,##0");
            lblPayPlan.Text = sum7.ToString("#,##0");
        }

        private void cboPaymentType_SelectedIndexChanged(object sender, EventArgs e)
        {
            //if (cboPaymentType.SelectedValue.ToString() == "1")
            //{
            //    foreach (DataGridViewRow row in dgvPayment.Rows)
            //    {
            //        row.Cells["colPaymenttime"].Value = Convert.ToInt32(row.Cells["colScheduledPayment"].Value) - Convert.ToInt32(row.Cells["colAmountPaid"].Value);
            //        row.Cells["colTransferAmount"].Value = Convert.ToInt32(row.Cells["colScheduledPayment"].Value) - Convert.ToInt32(row.Cells["colAmountPaid"].Value);
            //        row.Cells["colUnpaidAmount"].Value = "0";
            //        row.Cells["colOtherThanTransfer"].Value = "0";
            //    }
            //}
            //else
            //{
            //    foreach (DataGridViewRow row in dgvPayment.Rows)
            //    {
            //        row.Cells["colPaymenttime"].Value = Convert.ToInt32(row.Cells["colScheduledPayment"].Value) - Convert.ToInt32(row.Cells["colAmountPaid"].Value);
            //        row.Cells["colTransferAmount"].Value = "0";
            //        row.Cells["colTransferFee"].Value = "0";
            //        row.Cells["colUnpaidAmount"].Value = "0";
            //        row.Cells["colOtherThanTransfer"].Value = Convert.ToInt32(row.Cells["colScheduledPayment"].Value) - Convert.ToInt32(row.Cells["colAmountPaid"].Value);
            //    }
            //}
        }

        /// <summary>
        /// For Gridview CheckBox checked or not
        /// </summary>
        /// <param name="flag"></param>
        private void Checkstate(bool flag)
        {
            foreach (DataGridViewRow row1 in dgvPayment.Rows)
            {
                row1.Cells["colChk"].Value = flag;
            }
        }

        /// <summary>
        /// Get D_Pay_Entity
        /// </summary>
        /// <returns></returns>
        private D_Pay_Entity GetPayData()
        {
            dpe = new D_Pay_Entity()
            {
                StaffCD = ScStaff.TxtCode.Text,
                StoreCD = InOperatorCD,
                PayDate = txtPaymentDate.Text,
                Operator = InOperatorCD,
                ProgramID = InProgramID,
                PayGakuTotol = lblPayGaku.Text.Replace(",",""),
                PC = InPcID,
                PayNo = ScPaymentNum.TxtCode.Text,
                LargePayNO  = ScPaymentProcessNum.TxtCode.Text,
                dtTemp1 = dtpayplan,
                dtTemp2 = dt4Detail,
                dtTemp3 = dt4,
                dtTemp4 = dtPay1,
                dtTemp5 = dt2,
                dtTemp6 = dt3
            };
            return dpe;
        }

        private void Clear()
        {
            lblPayPlan.Text = string.Empty;
            lblGakuTotal.Text = string.Empty;
            lblPayConfirmGaku.Text = string.Empty;
            lblPayGaku.Text = string.Empty;
            lblPayPlanGaku.Text = string.Empty;
            lblTransferFeeGaku.Text = string.Empty;
            lblTransferGaku.Text = string.Empty;
        }


        // -----------------------------------------------------------
        // パラメータ設定
        // -----------------------------------------------------------
        private void Para_Add(DataTable dt)
        {
            dt.Columns.Add("PurchaseRows", typeof(int));
            dt.Columns.Add("DisplayRows", typeof(int));
            dt.Columns.Add("SKUCD", typeof(string));
            dt.Columns.Add("AdminNO", typeof(int));
            dt.Columns.Add("JanCD", typeof(string));
            dt.Columns.Add("MakerItem", typeof(string));
            dt.Columns.Add("ItemName", typeof(string));
            dt.Columns.Add("ColorName", typeof(string));
            dt.Columns.Add("SizeName", typeof(string));
            dt.Columns.Add("PurchaseSu", typeof(int));
            dt.Columns.Add("OldPurchaseSu", typeof(int));
            dt.Columns.Add("TaniCD", typeof(string));
            dt.Columns.Add("TaniName", typeof(string));

            dt.Columns.Add("PurchaserUnitPrice", typeof(decimal));
            dt.Columns.Add("CalculationGaku", typeof(decimal));
            dt.Columns.Add("AdjustmentGaku", typeof(decimal));
            dt.Columns.Add("PurchaseGaku", typeof(decimal));
            dt.Columns.Add("PurchaseTax", typeof(decimal));
            dt.Columns.Add("TaxRitsu", typeof(int));
            dt.Columns.Add("CommentOutStore", typeof(string));
            dt.Columns.Add("CommentInStore", typeof(string));
            dt.Columns.Add("WarehousingNO", typeof(string));
            dt.Columns.Add("StockNO", typeof(string));
            dt.Columns.Add("ReserveNO", typeof(string));
            dt.Columns.Add("UpdateFlg", typeof(int));
        }
        private DataTable GetGridEntity()
        {
            DataTable dt = new DataTable();
            Para_Add(dt);

            foreach (DataRow row in dtPay1.Rows)
            {
                if (bbl.Z_Set(row["ShippingSu"]) > 0)
                    dt.Rows.Add(row["JuchuuRows"]
                        , bbl.Z_Set(row["ShippingSu"])
                        , 0     //bbl.Z_Set(row["SalesSU"]) 未使用
                        , bbl.Z_Set(row["SalesGaku"])
                        , bbl.Z_Set(row["SalesTax"])
                        , bbl.Z_Set(row["ZaikoKBN"])
                        , 0
                        );

            }

            return dt;
        }
        private void txtDueDate2_KeyDown(object sender, KeyEventArgs e)
        {
            try
            {
                //Enterキー押下時処理
                //Returnキーが押されているか調べる
                //AltかCtrlキーが押されている時は、本来の動作をさせる
                if ((e.KeyCode == Keys.Return) &&
                        ((e.KeyCode & (Keys.Alt | Keys.Control)) == Keys.None))
                {
                    if (!CheckDate2())
                    {
                        return;
                    }
                }
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
                //EndSec();
            }
        }

        private void txtPaymentDate_KeyDown(object sender, KeyEventArgs e)
        {
            try
            {
                //Enterキー押下時処理
                //Returnキーが押されているか調べる
                //AltかCtrlキーが押されている時は、本来の動作をさせる
                if ((e.KeyCode == Keys.Return) &&
                        ((e.KeyCode & (Keys.Alt | Keys.Control)) == Keys.None))
                {
                    if (!CheckPaymentDate())
                    {
                        return;
                    }
                }
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
                //EndSec();
            }
        }
    }
}