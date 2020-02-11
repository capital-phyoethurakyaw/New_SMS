﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Base.Client;
using BL;
using Entity;
using System.Diagnostics;
using System.IO;
using CrystalDecisions.Shared;

namespace ZaikoMotochouInsatsu
{
    public partial class ZaikoMotochouInsatsu : FrmMainForm
    {
        ZaikoMotochouInsatsu_BL zmibl;
       // CrystalDecisions.Windows.Forms.CrystalReportViewer crv;
        Viewer vr;
        DataTable dtReport;
        M_SKU_Entity sku_data;
        D_MonthlyStock_Entity dms;
        int chk = 0;
        public ZaikoMotochouInsatsu()
        {
            InitializeComponent();
            zmibl = new ZaikoMotochouInsatsu_BL();
            vr = new Viewer();
        }
        private void ZaikoMotochouInsatsu_Load(object sender, EventArgs e)
        {
            InProgramID = Application.ProductName;
            StartProgram();
            SetFunctionLabel(EProMode.PRINT);
            SetRequireField();
            cboSouko.Bind(string.Empty);
            cboSouko.SelectedValue = SoukoCD;

            Btn_F11.Text = string.Empty;
            Btn_F10.Text = string.Empty;
        }
        private void SetRequireField()
        {
            txtTargetPeriodF.Require(true);
            txtTargetPeriodT.Require(true);
            cboSouko.Require(true);
        }

        private void ZaikoMotochouInsatsu_KeyUp(object sender, KeyEventArgs e)
        {
            MoveNextControl(e);
        }
        protected override void EndSec()
        {
            this.Close();
        }

        /// <summary>
        /// Clear data of Panel Detail 
        /// </summary>
        public void Clear()
        {
            Clear(panelDetail);
            txtTargetPeriodF.Focus();
        }

        /// <summary>
        /// Functions processes for F1,F6
        /// </summary>
        /// <param name="index"></param>
        public override void FunctionProcess(int index)
        {
            base.FunctionProcess(index);
            switch (index + 1)
            {
                case 6: //F6:キャンセル
                    {
                        //Ｑ００４				
                        if (bbl.ShowMessage("Q004") != DialogResult.Yes)
                            return;

                        break;

                    }
                //case 11:
                //    PrintSec();
                //    break;
            }
        }

        /// <summary>
        /// Check Errors before Export Report
        /// </summary>
        private bool ErrorCheck()
        {
            if (!RequireCheck(new Control[] { txtTargetPeriodF, txtTargetPeriodT, cboSouko }))
                return false;
            
            if(Convert.ToInt32((txtTargetPeriodF.Text.ToString().Replace("/",""))) > Convert.ToInt32(txtTargetPeriodT.Text.ToString().Replace("/",""))) //対象期間(From)の方が大きい場合Error
            {
                zmibl.ShowMessage("E103");
                return false;
            }

            //ErrorChecks for cboSouko (倉庫) are left
            //if (!base.CheckAvailableStores(cboSouko.SelectedValue.ToString())) // Check for 店舗 (ComboBox)
            //{
            //    zmibl.ShowMessage("E141");
            //    cboSouko.Focus();
            //    return false;
            //}

            if ((chkPrintRelated.Checked == true) )
            {
                if (!((rdoITEM.Checked == true) || (rdoMakerShohinCD.Checked == true)))
                {
                    zmibl.ShowMessage("E102");
                    return false;
                }
            }
            return true;
        }

        /// <summary>
        /// Print Report on F12 Click
        /// </summary>
        protected override void PrintSec()
        {
            if (PrintMode != EPrintMode.DIRECT)
                return;

            if (ErrorCheck())
            {
                sku_data = M_SKU_data();
                dms = D_MonthlyStock_data();

                chk = Check_ITemORMakerItem();
                dtReport = new DataTable();
                dtReport = zmibl.ZaikoMotochoulnsatsu_Report(sku_data, dms, chk);

                if (dtReport.Rows.Count > 0)
                {
                    //CheckBeforeExport();
                    try
                    {
                        ZaikoMotochoulnsatsu_Report zm_report = new ZaikoMotochoulnsatsu_Report();
                        DialogResult DResult;
                        switch (PrintMode)
                        {
                            case EPrintMode.DIRECT:
                                DResult = bbl.ShowMessage("Q201");
                                if (DResult == DialogResult.Cancel)
                                {
                                    return;
                                }
                                // 印字データをセット
                                zm_report.SetDataSource(dtReport);
                                zm_report.Refresh();
                                zm_report.SetParameterValue("lblYearMonth", txtTargetPeriodF.Text + "  ～  " + txtTargetPeriodT.Text);
                                zm_report.SetParameterValue("lblSouko", cboSouko.SelectedValue.ToString() + " " + cboSouko.AccessibilityObject.Name);
                                zm_report.SetParameterValue("lblToday", dtReport.Rows[0]["Today"].ToString() + "  " + dtReport.Rows[0]["Now"].ToString());
                                zm_report.SetParameterValue("lblSKU", dtReport.Rows[0]["SKUCD"].ToString() + " " + dtReport.Rows[0]["SKUName"].ToString());
                                zm_report.SetParameterValue("lblJANCD", dtReport.Rows[0]["JANCD"].ToString());
                                zm_report.SetParameterValue("lblCSB", dtReport.Rows[0]["ColorName"].ToString() + " " + dtReport.Rows[0]["SizeName"].ToString() + " " + dtReport.Rows[0]["BrandName"].ToString());

                                vr.CrystalReportViewer1.ReportSource = zm_report;
                                //vr.ShowDialog();

                                try
                                {

                                    //  crv = vr.CrystalReportViewer1;
                                }
                                catch (Exception ex)
                                {
                                    var msg = ex.Message;
                                }
                                //out log before print
                                if (DResult == DialogResult.Yes)
                                {

                                    //印刷処理プレビュー
                                    vr.CrystalReportViewer1.ShowPrintButton = true;
                                    vr.CrystalReportViewer1.ReportSource = zm_report;

                                    vr.ShowDialog();

                                }
                                else
                                {
                                    //int marginLeft = 360;
                                    CrystalDecisions.Shared.PageMargins margin = zm_report.PrintOptions.PageMargins;
                                    margin.leftMargin = DefaultMargin.Left; // mmの指定をtwip単位に変換する
                                    margin.topMargin = DefaultMargin.Top;
                                    margin.bottomMargin = DefaultMargin.Bottom;//mmToTwip(marginLeft);
                                    margin.rightMargin = DefaultMargin.Right;
                                    zm_report.PrintOptions.ApplyPageMargins(margin);     /// Error Now
                                    // プリンタに印刷
                                    System.Drawing.Printing.PageSettings ps;
                                    try
                                    {
                                        System.Drawing.Printing.PrintDocument pDoc = new System.Drawing.Printing.PrintDocument();

                                        CrystalDecisions.Shared.PrintLayoutSettings PrintLayout = new CrystalDecisions.Shared.PrintLayoutSettings();

                                        System.Drawing.Printing.PrinterSettings printerSettings = new System.Drawing.Printing.PrinterSettings();



                                        zm_report.PrintOptions.PrinterName = "\\\\dataserver\\Canon LBP2900";
                                        System.Drawing.Printing.PageSettings pSettings = new System.Drawing.Printing.PageSettings(printerSettings);

                                        zm_report.PrintOptions.DissociatePageSizeAndPrinterPaperSize = true;

                                        zm_report.PrintOptions.PrinterDuplex = PrinterDuplex.Simplex;

                                        zm_report.PrintToPrinter(printerSettings, pSettings, false, PrintLayout);
                                        // Print the report. Set the startPageN and endPageN 
                                        // parameters to 0 to print all pages. 
                                        //Report.PrintToPrinter(1, false, 0, 0);
                                    }
                                    catch (Exception ex)
                                    {

                                    }
                                }
                                break;

                        }
                        //プログラム実行履歴
                        InsertLog(Get_L_Log_Entity());
                    }
                    finally
                    {
                        //画面はそのまま
                        txtTargetPeriodF.Focus();
                    }
                }
            
            }
        }

        private void cboSouko_SelectedIndexChanged(object sender, EventArgs e)
        {
            //if (!base.CheckAvailableStores(cboSouko.SelectedValue.ToString()))
            //{
            //    zmibl.ShowMessage("E141");
            //    cboSouko.Focus();
            //}
        }

        private M_SKU_Entity M_SKU_data()
        {
            sku_data = new M_SKU_Entity()
            {
                MakerItem = scMakerShohinCD.Code,
                ITemCD = scITEM.Code,
                SKUCD = scSKUCD.Code,
                JanCD = scJANCD.Code,
                SKUName = txtSKUName.Text
            };
            return sku_data;
        }

        private D_MonthlyStock_Entity D_MonthlyStock_data()
        {
            int year = Convert.ToInt32(txtTargetPeriodT.Text.Substring(0, 4));
            int month = Convert.ToInt32(txtTargetPeriodT.Text.Substring(5, 2));
            string lastday = "/" + DateTime.DaysInMonth(year, month).ToString();
            dms = new D_MonthlyStock_Entity()
            {
                YYYYMMFrom = txtTargetPeriodF.Text.Replace("/", ""),
                YYYYMMTo = txtTargetPeriodT.Text.Replace("/",""),
                SoukoCD = cboSouko.SelectedValue.ToString(),
                TargetDateFrom = txtTargetPeriodF.Text + "/01",
                TargetDateTo = txtTargetPeriodT.Text + lastday
            };
            return dms;
        }

        private int Check_ITemORMakerItem()
        {
            if (chkPrintRelated.Checked == true)
            {
                if (rdoITEM.Checked == true)
                    return 1;
                else if (rdoMakerShohinCD.Checked == true)
                    return 2;
            }
            else return 3;

            return 3;
        }

        private L_Log_Entity Get_L_Log_Entity()
        {
            L_Log_Entity lle = new L_Log_Entity();

            lle = new L_Log_Entity
            {
                InsertOperator = this.InOperatorCD,
                PC = this.InPcID,
                Program = this.InProgramID,
                OperateMode = "",
                KeyItem = txtTargetPeriodF.Text + ","  +  txtTargetPeriodT.Text + ","+ cboSouko.AccessibilityObject.Name
            };

            return lle;
        }

        private void txtTargetPeriodF_Leave(object sender, EventArgs e)
        {
            if(!string.IsNullOrWhiteSpace(txtTargetPeriodF.Text))
            {
                txtTargetPeriodT.Text = txtTargetPeriodF.Text;
            }
        }
    }
}
